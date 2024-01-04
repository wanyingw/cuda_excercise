#include <iostream>

__global__ void myKernelAdd(int *a, int *b, int n) {

    for(int i = 0; i < n; i++) {
        a[i] = a[i] + b[i];
        printf("element #%d = %d, on block %d, thread %d\n", i, a[i], blockIdx.x, threadIdx.x);
    }
}

int main() {
    int N = 64;
    int *a, *b;

    // allocate unified memory, memory accessible from CPU and GPU
    cudaMallocManaged(&a, N*sizeof(int));
    cudaMallocManaged(&b, N*sizeof(int));

    for (int i = 0; i < N ; i++) {
        a[i] = i;
        b[i] = 0;
    }

    myKernelAdd<<<1,32>>>(a, b, N);

    cudaDeviceSynchronize();
    cudaFree(a);
    cudaFree(b);

    return 0;
}