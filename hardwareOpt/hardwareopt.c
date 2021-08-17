/* DCT implementation for a one-dimensional array
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define N 8

// reduced precision
// constants required to calculate the output from rotators
#define constant0 0.9999  // kcos(n * pi/16) for k = 1 and n = 1
#define constant1 0.9965  // ksin(n * pi/16) - kcos(n * pi/16) for k = 1 and n = 1
#define constant2 1.0033  // ksin(n * pi/16) + kcos(n * pi/16) for k = 1 and n = 1

#define constant3 0.9999  // kcos(n * pi/16) for k = 1 and n = 3
#define constant4 0.9896  // ksin(n * pi/16) - kcos(n * pi/16) for k = 1 and n = 3
#define constant5 1.0102  // ksin(n * pi/16) + kcos(n * pi/16) for k = 1 and n = 3

#define constant6 1.4139  // kcos(n * pi/16) for k = root(2) and n = 6
#define constant7 1.3848  // ksin(n * pi/16) - kcos(n * pi/16) for k = root2 and n = 6
#define constant8 1.443   // ksin(n * pi/16) + kcos(n * pi/16) for k = root2 and n = 6

void transpose(uint8_t A[N][N], uint8_t B[N][N])
{
    int i, j;
    for (i = 0; i < N; i++){
        for (j = 0; j< N; j++){
            B[i][j] = A[j][i];
        }
    }
}

// k1 is kcos(n * pi/16)
// k2 is ksin(n * pi/16) - kcos(n * pi/16)
// k3 is ksin(n * pi/16) + kcos(n * pi/16)
// requires 3 multiplication and 3 additions
uint16_t rotators(register uint8_t i1, register uint8_t i2, register float k1, register float k2, register float k3)
{
    register uint8_t tmp1 = (i1 + i2) * k1;
    register uint8_t tmp2 = k2 * i2;
    register uint8_t tmp3 = k3 * i1;
    
    register uint8_t o1 = tmp2 + tmp1;
    register uint8_t o2 = tmp3 + tmp1;
    register uint16_t o = (o1<<8) + o2;
    
    return o;
}

uint8_t scaleup(register uint8_t x)
{
    return (uint8_t)(1.4142 * x);
}

// calculates the 8-point 1D DCT
// Input : array of 8 elements.
// Output : DCT transform of the 8 elements.
void dct1d(uint8_t x[N], uint8_t y[N]){
    //local parameters
    register uint16_t x07 = (x[0] << 8) + x[7];
    register uint16_t x16 = (x[1] << 8) + x[6];
    register uint16_t x25 = (x[2] << 8) + x[5];
    register uint16_t x34 = (x[3] << 8) + x[4];

    // stage 1
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (x07)
        : "r" (x07 >> 8), "r" (x07 & 0xff)
    );
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (x16)
        : "r" (x16 >> 8), "r" (x16 & 0xff)
    );
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (x25)
        : "r" (x25 >> 8), "r" (x25 & 0xff)
    );
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (x34)
        : "r" (x34 >> 8), "r" (x34 & 0xff)
    );
    
    register uint16_t tmp1;
    register uint16_t tmp2;
    register uint16_t tmp3;

    // stage 2 even part
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (tmp1)
        : "r" (x07 >> 8), "r" (x34 >> 8)
    );
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (tmp2)
        : "r" (x16 >> 8), "r" (x25 >> 8)
    );

    // stage 3 even part and memory updates
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (tmp3)
        : "r" (tmp1 >> 8), "r" (tmp2 >> 8)
    );
    y[4] = tmp3 & 0xff;
    y[0] = tmp3 >> 8;
    tmp3 = rotators(tmp2 & 0xff, tmp1 & 0xff, constant6, constant7, constant8);
    y[6] = tmp3 & 0xff;
    y[2] = tmp3 >> 8;

    // stage 2 odd part
    tmp1 = rotators(x34 & 0xff, x07 & 0xff, constant3, constant4, constant5);
    tmp2 = rotators(x25 & 0xff, x16 & 0xff, constant0, constant1, constant2);

    // stage 3 odd part
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (tmp3)
        : "r" (tmp1 >> 8), "r" (tmp2 & 0xff)
    );
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (tmp1)
        : "r" (tmp1 & 0xff), "r" (tmp2 >> 8)
    );

    // stage 4 odd part and memory updates
    __asm__ __volatile__(
        "butterfly\t%0, %1, %2\n"
        : "=r" (tmp2)
        : "r" (tmp3 >> 8), "r" (tmp1 >> 8)
    );
    
    y[7] = tmp2 & 0xff;
    y[1] = tmp2 >> 8;
    y[3] = scaleup(tmp1 & 0xff);
    y[5] = scaleup(tmp3 & 0xff);
}

// input is 8x8 input pixel data
// output is the 8x8 transformed output pixel data
// so input[0] points to the first row of 8 numbers.
void dct2d(uint8_t input[N][N], uint8_t output[N][N])
{
    uint8_t *currentRow, *nextRow;
    
    // row separation part
    // loop unrolling
    currentRow = input[0];  // prologue

    nextRow = input[1];         // these two instructions
    dct1d(currentRow, output[0]); // can run in parallel
    currentRow = nextRow;

    nextRow = input[2];
    dct1d(currentRow, output[1]);
    currentRow = nextRow;

    nextRow = input[3];
    dct1d(currentRow, output[2]);
    currentRow = nextRow;

    nextRow = input[4];
    dct1d(currentRow, output[3]);
    currentRow = nextRow;

    nextRow = input[5];
    dct1d(currentRow, output[4]);
    currentRow = nextRow;

    nextRow = input[6];
    dct1d(currentRow, output[5]);
    currentRow = nextRow;

    nextRow = input[7];
    dct1d(currentRow, output[6]);
    currentRow = nextRow;

    dct1d(currentRow, output[7]);

    // Matrix Transpose
    uint8_t transposedoutput[N][N];
    transpose(output, transposedoutput);

    // column separation part.
    // loop unrolling
    currentRow = transposedoutput[0];

    nextRow = transposedoutput[1];         // these two instructions
    dct1d(currentRow, output[0]); // can run in parallel
    currentRow = nextRow;

    nextRow = transposedoutput[2];
    dct1d(currentRow, output[1]);
    currentRow = nextRow;

    nextRow = transposedoutput[3];
    dct1d(currentRow, output[2]);
    currentRow = nextRow;

    nextRow = transposedoutput[4];
    dct1d(currentRow, output[3]);
    currentRow = nextRow;

    nextRow = transposedoutput[5];
    dct1d(currentRow, output[4]);
    currentRow = nextRow;

    nextRow = transposedoutput[6];
    dct1d(currentRow, output[5]);
    currentRow = nextRow;

    nextRow = transposedoutput[7];
    dct1d(currentRow, output[6]);
    currentRow = nextRow;

    dct1d(currentRow, output[7]);
}

// prints the provided matrix
void printMatrix(uint8_t x[N][N]){
    printf("\n");
    int i;
    int j;
    for (i=0; i<N; i++){
        for (j=0; j<N;j++){
            printf("%d  ", x[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, char *argv[])
{
    // Reading the JPEG file
    int width, height, channels;
    // defined to write to an unsigned char, but uint8_t is the same effectivly
    uint8_t *img = stbi_load("TestImages/min_test_image.png", &width, &height, &channels, 0);
    if(img == NULL) {
        printf("ERROR: Could not load the image\n");
    }
    printf("Loaded image with a width of %dpx, a height of %dpx and %d channels\n", width, height, channels);
    int size = strlen((char*) img);
    printf("String is  %d chars long\n", size);
    // create the array to work off
    uint8_t original_image[height][width];
    // write values to this 2D array, which is what we'll work off of.
    int x;
    int y;
    int index = 0;
    for(y=0; y<height; y++) {
        for(x=0; x<width; x++) {
            original_image[y][x] = *(img + index);
            index++;
        }
    }

    printf("\nheight : %d\n", height);
    printf("width : %d\n", width);

    int yOffset = 0;
    int xOffset = 0;
    int xsplit;
    int ysplit;
    uint8_t blockInput[N][N], blockOutput[N][N];

    for(ysplit = 0; ysplit < height/8; ysplit++) {
        for(xsplit = 0; xsplit < width/8; xsplit++) {
            for(y=0; y<8; y++) {
                for(x=0; x<8; x++) {
                    blockInput[y][x] = original_image[y+yOffset][x+xOffset];
                }
            }
            printf("Before :\n");
            printMatrix(blockInput);
            dct2d(blockInput, blockOutput);
            printf("After :\n");
            printMatrix(blockOutput);
            xOffset= xOffset+8;
        }
        xOffset = 0;
        yOffset = yOffset+8;
    }
}
