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
// for C1   c1cos 0.99999413            c1sin 0.00342694
// for C3   c3cos 0.99994715            c3sin 0.01028066
// for C6   root(2)*c6cos 1.41391462    root(2)*c6sin 0.02907655
const float constants[8] = { 0, 0.99999413, 0.00342694, 0.99994715, 0.01028066, 0, 1.41391462591, 0.02907655611};

void transpose(uint8_t A[N][N], uint8_t B[N][N])
{
    int i, j;
    for (i = 0; i < N; i++){
        for (j = 0; j< N; j++){
            B[i][j] = A[j][i];
        }
    }
}

// to make it easier to return 2 values.
struct Output{
    unsigned char o1,o2;
};

uint16_t butterfly(float i1, float i2)
{
    float o1 = (i1+i2); // 16 bits
    float o2 = (i1-i2); // 16 bits

    struct Output o;
    o.o1 = o1;
    o.o2 = o2;

    return o;
}

// k1 is kcos(n * pi/16)
// k2 is ksin(n * pi/16) - kcos(n * pi/16)
// k3 is ksin(n * pi/16) + kcos(n * pi/16)
// requires 3 multiplication and 3 additions
struct Output rotators(float i1, float i2, int n)
{
    register float k1 = constants[n];
    register float k2 = constants[n+1];

    float o1 =  k1 * i1 + k2 * i2;
    float o2 = -k2 * i1 + k1 * i2;

    struct Output o;
    o.o1 = o1;
    o.o2 = o2;

    return o;
}

float scaleup (float i)
{
    float root2 = 1.4142;
    return (root2 * i); //changed from memory load to immediate load operation.
}

// calculates the 8-point 1D DCT
// Input : array of 8 elements.
// Output : DCT transform of the 8 elements.
void dct1d(uint8_t x[N], uint8_t y[N]){
    struct Output o;

    //local parameters
    float x0 = x[0];
    float x1 = x[1];
    float x2 = x[2];
    float x3 = x[3];
    float x4 = x[4];
    float x5 = x[5];
    float x6 = x[6];
    float x7 = x[7];

    // stage 1
    o = butterfly(x0, x7, 1.0, 0.9058); // cos(0*pi/16) and cos(7*pi/16)
    x0 = o.o1;
    x7 = o.o2;
    o = butterfly(x1, x6, 0.998, 0.9305); // cos(pi/16) and cos(6*pi/16)
    x1 = o.o1;
    x6 = o.o2;
    o = butterfly(x2, x5, 0.9922, 0.9516); // cos(2*pi/16) and cos(5*pi/16)
    x2 = o.o1;
    x5 = o.o2;
    o = butterfly(x3, x4, 0.9825, 0.9689); // cos(3*pi/16) and cos(4*pi/16)
    x3 = o.o1;
    x4 = o.o2;

    // stage 2
    o = butterfly(x0, x3, 1, 0.9825);
    x0 = o.o1;
    x3 = o.o2;
    o = butterfly(x1, x2, 0.998, 0.9922);
    x1 = o.o1;
    x2 = o.o2;
    o = rotators(x4, x7, 3);
    x4 = o.o1;
    x7 = o.o2;
    o = rotators(x5, x6, 1);
    x5 = o.o1;
    x6 = o.o2;

    // stage 3
    o = butterfly(x0, x1, 1, 0.998);
    x0 = o.o1;
    x1 = o.o2;
    o = rotators(x2, x3, 6);
    x2 = o.o1;
    x3 = o.o2;
    o = butterfly(x4, x6, 0.9689, 0.9305);
    x4 = o.o1;
    x6 = o.o2;
    o = butterfly(x7, x5, 0.9058, 0.9516);
    x7 = o.o1;
    x5 = o.o2;

    // stage 4
    o = butterfly(x7, x4, 0.9058, 0.9689);
    x7 = o.o1;
    x4 = o.o2;
    x5 = scaleup(x5);
    x6 = scaleup(x6);

    //updating the memory
    y[0] = x0;
    y[1] = x1;
    y[2] = x2;
    y[3] = x3;
    y[4] = x4;
    y[5] = x5;
    y[6] = x6;
    y[7] = x7;
}

// input is 8x8 input pixel data
// output is the 8x8 transformed output pixel data
// so input[0] points to the first row of 8 numbers.
void dct2d(uint8_t input[N][N], uint8_t output[N][N])
{
    // row separation part
    int i;
    for (i=0; i <N; i++){
        dct1d(input[i], output[i]);
    }
    // Matrix Transpose
    uint8_t transposedoutput[N][N];
    transpose(output, transposedoutput);

    // column separation part.
    for (i=0; i<N; i++){
        dct1d(transposedoutput[i], output[i]);
    }
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
