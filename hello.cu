#include <stdio.h>
#include <iostream>

__global__ void myKernel(float f) {
    if (threadIdx.x == 0) {
        printf("hello from gpu block %d, thread %d, f=%f\n", blockIdx.x, threadIdx.x, f);}
}

int main() {
    size_t printfBufferSz;
    cudaDeviceGetLimit(&printfBufferSz, cudaLimitPrintfFifoSize);
    std::cout << printfBufferSz << std::endl;
    cudaDeviceSetLimit(cudaLimitPrintfFifoSize, 10000);
    cudaDeviceGetLimit(&printfBufferSz, cudaLimitPrintfFifoSize);
    std::cout << printfBufferSz << std::endl;

    myKernel<<<5,5>>>(2.333f);
    cudaDeviceSynchronize();
    printf("hello from cpu\n");
    return 0;
}