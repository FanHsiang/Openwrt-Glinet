#ifndef _MY_PALLOC_H_INCLUDED_
#define _MY_PALLOC_H_INCLUDED_

#include <stdint.h>
#include <sys/types.h>

/*
                     my_pool_t                             data
 |<───────────────────────────────────────────────>| |<────────────────>|
 ┌───┬─────┬─────────┬───────┬───────┬────────┬─────┬────────┬──────────┐
 │ d │ max │ current │ chain │ large │ cleanup│ log │ 已使用 │  未使用  │
 └───┴─────┴─────────┴───────┴───────┴────────┴─────┴────────┴──────────┘
   │                            │                            ^          ^
   │ ┌──────────────────────────┘                            │          │
   │ │                                                       │          │
   │ └─>┌───────┬────────┬──────────┐                        │          │
   │    │ *next │ *alloc │ 大塊內存 │                        │          │
   │    └───────┴────────┴──────────┘                        │          │
   │        │       │    ^                                   │          │
   │        V       └────┘                                   │          │
   │    ┌───────┬────────┬──────────┐                        │          │
   │    │ *next │ *alloc │ 大塊內存 │                        │          │
   │    └───────┴────────┴──────────┘                        │          │
   │                │    ^                                   │          │
   │                └────┘                                   │          │
   │                                                         │          │
   │                                                         │          │
   └──> ┌───────┬──────┬───────┬────────┐                    │          │
        │ *last │ *end │ *next │ failed │                    │          │
		└───────┴──────┴───────┴────────┘                    │          │
		    │       │      │                                 │          │
			└───────>──────>─────────────────────────────────┘          │
                    │      │                                            │
					└──────>────────────────────────────────────────────┘
					       │
   ┌───────────────────────┘
   V
 ┌───┬───────────────────────────────────────────────────────┬──────────┐
 │ d │                         已使用                        │  未使用  │
 └───┴───────────────────────────────────────────────────────┴──────────┘
   │                                                         ^          ^
   └──> ┌───────┬──────┬───────┬────────┐                    │          │
        │ *last │ *end │ *next │ failed │                    │          │
		└───────┴──────┴───────┴────────┘                    │          │
		    │       │                                        │          │
			└───────>────────────────────────────────────────┘          │
			        │                                                   │
					└───────────────────────────────────────────────────┘
*/

/*
 * MY_MAX_ALLOC_FROM_POOL should be (my_pagesize - 1), i.e. 4095 on x86.
 * On Windows NT it decreases a number of locked pages in a kernel.
 */

typedef intptr_t        my_int_t;
typedef uintptr_t       my_uint_t;

#define  MY_OK          0
#define  MY_ERROR      -1
#define  MY_AGAIN      -2
#define  MY_BUSY       -3
#define  MY_DONE       -4
#define  MY_DECLINED   -5
#define  MY_ABORT      -6

#define MY_MAX_ALLOC_FROM_POOL  4095

#define MY_DEFAULT_POOL_SIZE    (16 * 1024)

#define MY_POOL_ALIGNMENT       16
#define MY_MIN_POOL_SIZE                                                     \
    my_align((sizeof(my_pool_t) + 2 * sizeof(my_pool_large_t)),            \
              MY_POOL_ALIGNMENT)

typedef struct my_pool_s        my_pool_t;

typedef struct my_pool_large_s  my_pool_large_t;

struct my_pool_large_s {

    //指向下一塊large 內存的指針
    my_pool_large_t     *next;

    // 內存的真正地址
    void                *alloc;
};


typedef struct {

    // 當前pool 中用完的數據的結尾指針，即可用數據的開始指針
    u_char               *last;

    // 當前pool 數據庫的結尾指針
    u_char               *end;

    // 指向下一個pool 的指針
    my_pool_t           *next;

    // 當前pool 內存不足以分配的次數
    my_uint_t            failed;
} my_pool_data_t;


struct my_pool_s {

    // 包含pool 的數據區指針的結構體
    my_pool_data_t       d;

    // 當前pool 最大可分配的內存大小
    size_t                max;

    // pool 當前正在使用的pool的指針
    my_pool_t           *current;

    // pool 中指向大數據快的指針（大數據快是指size > max 的數據塊）
    my_pool_large_t     *large;

};


void *my_alloc(size_t size);
void *my_calloc(size_t size);

my_pool_t *my_create_pool(size_t size);
void my_destroy_pool(my_pool_t *pool);
void my_reset_pool(my_pool_t *pool);

void *my_palloc(my_pool_t *pool, size_t size);
void *my_pnalloc(my_pool_t *pool, size_t size);
void *my_pcalloc(my_pool_t *pool, size_t size);
void *my_pmemalign(my_pool_t *pool, size_t size, size_t alignment);
my_int_t my_pfree(my_pool_t *pool, void *p);

#endif /* _MY_PALLOC_H_INCLUDED_ */
