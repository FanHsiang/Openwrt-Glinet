#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include "my_palloc.h"

#define my_free          free
#define MY_ALIGNMENT   sizeof(unsigned long)    /* platform word */
#define MY_POOL_ALIGNMENT       16
#define my_align_ptr(p, a)                                                   \
    (u_char *) (((uintptr_t) (p) + ((uintptr_t) a - 1)) & ~((uintptr_t) a - 1))
#define my_memzero(buf, n)       (void) memset(buf, 0, n)



static void *my_palloc_block(my_pool_t *pool, size_t size);
static void *my_palloc_large(my_pool_t *pool, size_t size);

/*********************************************************************
 * * 函數名稱: my_alloc
 * * 輸入參數: size---pool大小；
 * * 輸出參數: 
 * * 返 回 值: 
 * * 時 間: 2015-09-01
 * * 說明: 封裝malloc，分配失敗判斷及調試日誌 
 * * 其它: my_alloc(4096, log); 
 * *******************************************************************/
void *
my_alloc(size_t size)
{
    void  *p;

    p = malloc(size);

    return p;
}

void *
my_memalign(size_t alignment, size_t size)
{
    void  *p;

    // 與posix_memalign 的不同是其將分配好的內存塊首地址做為返回值
    p = memalign(alignment, size);

    return p;
}

/*********************************************************************
 * * 函數名稱: my_create_pool
 * * 輸入參數: size---pool大小； log---
 * * 輸出參數: 內存池結構位址
 * * 返 回 值: my_pool_t
 * * 時 間: 2015-09-01
 * * 說明: 創建size大小的內存池,考慮對齊問題
 * * 其它: my_create_pool(4096,log) 
 * *******************************************************************/
my_pool_t *
my_create_pool(size_t size)
{
    my_pool_t  *p;

    p = my_memalign(MY_POOL_ALIGNMENT, size);
    if (p == NULL) {
        return NULL;
    }

    p->d.last = (u_char *) p + sizeof(my_pool_t);
    p->d.end = (u_char *) p + size;
    p->d.next = NULL;
    p->d.failed = 0;

    size = size - sizeof(my_pool_t);
    p->max = (size < MY_MAX_ALLOC_FROM_POOL) ? size : MY_MAX_ALLOC_FROM_POOL;

    p->current = p;
    p->large = NULL;

    return p;
}

/*
 *  MY_POOL_ALIGNMENT      = 16
 *  MY_MAX_ALLOC_FROM_POOL = -1
 *  my_pagesize            = 0
 *
   +---+---+---+---+---+
   | x | x | x | x | x |
   +---+---+---+---+---+
   |   |   |   |   |   v
   |   |   |   |   v   
   |   |   |   v   
   |   |   v  pool_large_t
   |   v  
   v  pool_t
   pool_data_t
 */

/*********************************************************************
 * * 函數名稱: my_destroy_pool
 * * 輸入參數: pool---內存池位址
 * * 輸出參數: 
 * * 返 回 值:
 * * 時 間: 2015-09-01
 * * 說明: 銷毀內存池
 * * 其它: my_destroy_pool(pool) 
 * *******************************************************************/
void
my_destroy_pool(my_pool_t *pool)
{
    my_pool_t          *p, *n;
    my_pool_large_t    *l;

    // 釋放large 數據塊的內存
    for (l = pool->large; l; l = l->next) {

        if (l->alloc) {
            my_free(l->alloc);
        }
    }

    // 釋放整個pool
    for (p = pool, n = pool->d.next; /* void */; p = n, n = n->d.next) {
        my_free(p);

        if (n == NULL) {
            break;
        }
    }
}


/*********************************************************************
 * * 函數名稱: my_reset_pool
 * * 輸入參數: pool---內存池位址
 * * 輸出參數: 
 * * 返 回 值:
 * * 時 間: 2015-09-01
 * * 說明: 重置pool中的部分數據
 * * 其它: my_reset_pool(pool) 
 * *******************************************************************/
void
my_reset_pool(my_pool_t *pool)
{
    my_pool_t        *p;
    my_pool_large_t  *l;

    // 釋放large 數據塊的內存
    for (l = pool->large; l; l = l->next) {
        if (l->alloc) {
            my_free(l->alloc);
        }
    }

    // 重置指針位址,讓pool中的內存可用
    for (p = pool; p; p = p->d.next) {
        p->d.last = (u_char *) p + sizeof(my_pool_t);
        p->d.failed = 0;
    }

    // current 位址重置
    pool->current = pool;

    // large 數據塊重置
    pool->large = NULL;
}


/*********************************************************************
 * * 函數名稱: my_palloc
 * * 輸入參數: size---要求空間大小； 
 * * 輸出參數: free space 開頭地址
 * * 返 回 值: void *
 * * 時 間: 2015-09-01
 * * 說明: 從內存池pool 分配大小為size的內存塊並返回其地址,考慮對齊問題
 * * 其它: my_palloc(pool,4096) 
 * *******************************************************************/
void *
my_palloc(my_pool_t *pool, size_t size)
{
    u_char      *m;
    my_pool_t  *p;

    // 如果還未超出內存池的max值，超過了則用large
    if (size <= pool->max) {

        p = pool->current;

        do {
            m = my_align_ptr(p->d.last, MY_ALIGNMENT);

            if ((size_t) (p->d.end - m) >= size) {
                p->d.last = m + size;

                return m;
            }

            p = p->d.next;

        } while (p);

        return my_palloc_block(pool, size);
    }

    return my_palloc_large(pool, size);
}


/*********************************************************************
 * * 函數名稱: my_palloc
 * * 輸入參數: size---要求空間大小； 
 * * 輸出參數: free space 開頭地址
 * * 返 回 值: void *
 * * 時 間: 2015-09-01
 * * 說明: 從內存池pool 分配大小為size的內存塊並返回其地址,不考慮對齊問題
 * * 其它: my_pnalloc(pool,4096) 
 * *******************************************************************/
void *
my_pnalloc(my_pool_t *pool, size_t size)
{
    u_char      *m;
    my_pool_t  *p;

    // 如果還未超出內存池的max值，超過了則用large
    if (size <= pool->max) {

        p = pool->current;

        do {
            m = p->d.last;

            if ((size_t) (p->d.end - m) >= size) {
                p->d.last = m + size;

                return m;
            }

            p = p->d.next;

        } while (p);

        return my_palloc_block(pool, size);
    }

    return my_palloc_large(pool, size);
}

/*
  ----------------
  | pool_data_t  | Header. It contains the status of
  |              | of this frame
  |--------------|
  | data buffer  |
  .              .
  .              .
   ---------------
 */
/*********************************************************************
 * * 函數名稱: my_palloc_block
 * * 輸入參數: pool---內存池位址;size---要求空間大小
 * * 輸出參數: free space 開頭地址
 * * 返 回 值:
 * * 時 間: 2015-09-01
 * * 說明: 配置內存池大小的空間加入pool list,從中分配size大小內存回傳
 * * 其它: my_palloc_block(pool,4096)
 * *******************************************************************/
static void *
my_palloc_block(my_pool_t *pool, size_t size)
{
    u_char      *m;
    size_t       psize;
    my_pool_t  *p, *new;

    // pool 結構定義區和pool->d 數據區的總大小
    psize = (size_t) (pool->d.end - (u_char *) pool);

    m = my_memalign(MY_POOL_ALIGNMENT, psize);
    if (m == NULL) {
        return NULL;
    }

    new = (my_pool_t *) m;

    //初始化這個new，設定new 的d.end、d.next、d.failed
    new->d.end = m + psize;
    new->d.next = NULL;
    new->d.failed = 0;

    m += sizeof(my_pool_data_t);
    m = my_align_ptr(m, MY_ALIGNMENT);
    
    //配置size大小內存, 設定 new 的 d.last
    new->d.last = m + size;

    //遍歷到內存池鍊錶的末尾
    for (p = pool->current; p->d.next; p = p->d.next) {
        
        //為什麼4？推測是個經驗值
        if (p->d.failed++ > 4) {
            pool->current = p->d.next;
        }
    }

    p->d.next = new;

    return m;
}


/*********************************************************************
 * * 函數名稱: my_palloc_large
 * * 輸入參數: pool---內存池位址;size---要求空間大小
 * * 輸出參數: free space 開頭地址
 * * 返 回 值: void *
 * * 時 間: 2015-09-01
 * * 說明: alloc內存,配置size大小內存空間,加入large list
 * * 其它: my_palloc_block(pool,4096)
 * *******************************************************************/
static void *
my_palloc_large(my_pool_t *pool, size_t size)
{
    void              *p;
    my_uint_t         n;
    my_pool_large_t  *large;

    // 分配 size 大小的内存
    p = my_alloc(size);
    if (p == NULL) {
        return NULL;
    }

    n = 0;

    // 在pool 的large 鏈中尋找存儲區為空的節點，把新分配的內存區首地址賦給它
    for (large = pool->large; large; large = large->next) {
        
        // 找到large 鏈末尾，在其後插入之，並返回給外部使用
        if (large->alloc == NULL) {
            large->alloc = p;
            return p;
        }

        // 查看的large 節點超過3 個，不再嘗試和尋找，由下面代碼實現創建新large 節點的邏輯
        if (n++ > 3) {
            break;
        }
    }

    // 創建large 鏈的一個新節點，如果失敗則釋放剛才創建的size 大小的內存，並返回NULL
    large = my_palloc(pool, sizeof(my_pool_large_t));
    if (large == NULL) {
        my_free(p);
        return NULL;
    }

    // 一切順利，善後工作
    large->alloc = p;
    large->next = pool->large;
    pool->large = large;

    return p;
}

/*********************************************************************
 * * 函數名稱: my_pmemalign
 * * 輸入參數: pool---內存池位址;size---配置大小;alignment---對齊字節
 * * 輸出參數: free space 開頭地址
 * * 返 回 值: void *
 * * 時 間: 2015-09-01
 * * 說明: alloc內存,配置size大小內存空間,加入large list
 * * 其它: my_pmemalign(pool, 4096, 64)
 * *******************************************************************/
void *
my_pmemalign(my_pool_t *pool, size_t size, size_t alignment)
{
    void              *p;
    my_pool_large_t  *large;

    // 創建一塊size 大小的內存，內存以alignment 字節對齊
    p = my_memalign(alignment, size);
    if (p == NULL) {
        return NULL;
    }

    // 創建一個 large 節點
    large = my_palloc(pool, sizeof(my_pool_large_t));
    if (large == NULL) {
        my_free(p);
        return NULL;
    }

    large->alloc = p;
    large->next = pool->large;
    pool->large = large;

    return p;
}

/*********************************************************************
 * * 函數名稱: my_pfree
 * * 輸入參數: pool---內存池位址;p---large記憶體位址
 * * 輸出參數: MY_OK, MY_DECLINED
 * * 返 回 值: my_int_t
 * * 時 間: 2015-09-01
 * * 說明: 遍歷large list,釋放指定的large 數據塊
 * * 其它: my_pfree(pool, p);
 * *******************************************************************/
my_int_t
my_pfree(my_pool_t *pool, void *p)
{
    my_pool_large_t  *l;

    // 釋放指定的large 數據塊的內存
    for (l = pool->large; l; l = l->next) {

        //找到指定的large數據塊
        if (p == l->alloc) {
            my_free(l->alloc);
            l->alloc = NULL;

            return MY_OK;
        }
    }

    return MY_DECLINED;
}

/*********************************************************************
 * * 函數名稱: my_pcalloc
 * * 輸入參數: pool---內存池位址;size---要求空間大小
 * * 輸出參數: free space 開頭地址
 * * 返 回 值: void *
 * * 時 間: 2015-09-01
 * * 說明: 存內存持分配大小為size的內存,初始化為0並返回其地址
 * * 其它: my_pcalloc(pool, 4096)
 * *******************************************************************/
void *
my_pcalloc(my_pool_t *pool, size_t size)
{
    void *p;

    p = my_palloc(pool, size);
    if (p) {
        my_memzero(p, size);
    }

    return p;
}


