#include <iostream>

__global__ void myKernelAdd(int *a, int *b, int n) {

    int index = threadIdx.x;
    int stride = blockDim.x;

    for(int i = index; i < n; i+= stride) {
        a[i] = a[i] + b[i];
        if (i%blockDim.x==0) {
            printf("element #%d = %d, on block %d, thread %d, blockDim x y z %d %d %d\n",
            i, a[i], blockIdx.x, threadIdx.x, blockDim.x, blockDim.y, blockDim.z);
        }
    }
}

int main() {
    int N = 512;
    int *a, *b;

    // allocate unified memory, memory accessible from CPU and GPU
    cudaMallocManaged(&a, N*sizeof(int));
    cudaMallocManaged(&b, N*sizeof(int));

    for (int i = 0; i < N ; i++) {
        a[i] = i;
        b[i] = 0;
    }

    myKernelAdd<<<1,128>>>(a, b, N);

    cudaDeviceSynchronize();
    cudaFree(a);
    cudaFree(b);

    return 0;
}