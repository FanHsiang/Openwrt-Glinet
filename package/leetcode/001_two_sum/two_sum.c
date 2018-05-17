#include <stdio.h>
#include <stdlib.h>

int* twoSum(int* nums, int numsSize, int target) {
    int *result = (int*)malloc(2*sizeof(int));
    for(int i=0;i<numsSize;i++)
    {
	for(int j=0;j<numsSize&&j!=i;j++)
	{
	    if((nums[i]+nums[j])==target)
	    {
		result[0]=i;
		result[1]=j;
		return result;
	    }
	}	
    }   
}

int main(void){
    int num[]={2,3,4}, numsSize=3,target=5;
    printf("%d and %d\n",twoSum(num,numsSize,target)[0],twoSum(num,numsSize,target)[1]);
    return 0;
}
    
