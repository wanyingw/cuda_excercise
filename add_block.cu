#include <iostream>

__global__ void myKernelAdd(int *a, int *b, int n) {

    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;

    for(int i = index; i < n; i+= stride) {
        a[i] = a[i] + b[i];
        if (threadIdx.x==0) {
            printf("element #%d = %d, on block %d, thread %d, blockDim x y z %d %d %d\n",
            i, a[i], blockIdx.x, threadIdx.x, blockDim.x, blockDim.y, blockDim.z);
        }
    }
}

int main() {
    int N = 1024;
    int *a = nullptr;
    int *b = nullptr;
    int numThreads = 256; // number of threads per block
    int numBlocks = (N + numThreads - 1) / numThreads;

    // allocate unified memory, memory accessible from CPU and GPU
    cudaMallocManaged(&a, N*sizeof(int));
    cudaMallocManaged(&b, N*sizeof(int));

    for (int i = 0; i < N ; i++) {
        a[i] = i;
        b[i] = 0;
    }

    myKernelAdd<<<numBlocks, numThreads>>>(a, b, N);

    cudaDeviceSynchronize();
    cudaFree(a);
    cudaFree(b);

    return 0;
}