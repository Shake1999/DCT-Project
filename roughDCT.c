/* DCT implementation for a one-dimensional array
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define root2 1.41421356
// constants required to calculate the output from rotators
// for C1   c1cos 0.99999413            c1sin 0.00342694
// for C3   c3cos 0.99994715            c3sin 0.01028066
// for C6   root(2)*c6cos 1.41391462    root(2)*c6sin 0.02907655
const float constants[8] = { 0, 0.99999413, 0.00342694, 0.99994715, 0.01028066, 0, 1.41391462591, 0.02907655611};

// to make it easier to return 2 values.
struct Output{
    float o1,o2;
};

// initialize and allocate memory to a matrix of shape (row * col).
float **createMatrix(int row, int col){
    float **M = (float **)malloc(row * sizeof(float *));
    int i;
    for (i=0; i<row; i++){
        M[i] = (float *)malloc(col * sizeof(float));
    }
    return M;
}

// free the pointers.
void freeMatrix(float **M){
    int i;
    for (i=0; i<8; i++){
        free(M[i]);
    }
    free(M);
}

// read the image file, currently loads in from given file, and stores as 2d array
void readJPEG(FILE *fp, float **M){

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
}

struct Output butterfly(float i1, float i2, float c1, float c2)
{
    float o1 = (i1+i2)*c1; // 16 bits
    float o2 = (i1-i2)*c2; // 16 bits

    struct Output o;
    o.o1 = o1;
    o.o2 = o2;
    
    return o;
}

struct Output reflector(float i1, float i2)
{
    float o1 = i1 + i2;
    float o2 = i1 - i2;
    
    struct Output o;
    o.o1 = o1;
    o.o2 = o2;
    
    return o;
}

struct Output rotators(float i1, float i2, int n)
{
    float k1 = constants[n];
    float k2 = constants[n+1];
    
    float o1 = k1*((float)i1) + k2*((float)i2);
    float o2 = -k2*((float)i1) + k1*((float)i2);
    
    struct Output o;
    o.o1 = o1;
    o.o2 = o2;
    
    return o;
}

float scaleup (float i)
{
    return root2 * i;
}

// calculates the 8-point 1D DCT
// Input : pointer to array of 8 elements.
void dct(float *x){
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
    o = reflector(x0, x7);
    x0 = o.o1;
    x7 = o.o2;
    o = reflector(x1, x6);
    x1 = o.o1;
    x6 = o.o2;
    o = reflector(x2, x5);
    x2 = o.o1;
    x5 = o.o2;
    o = reflector(x3, x4);
    x3 = o.o1;
    x4 = o.o2;
    
    // stage 2
    o = reflector(x0, x3);
    x0 = o.o1;
    x3 = o.o2;
    o = reflector(x1, x2);
    x1 = o.o1;
    x2 = o.o2;
    o = rotators(x4, x7, 3);
    x4 = o.o1;
    x7 = o.o2;
    o = rotators(x5, x6, 1);
    x5 = o.o1;
    x6 = o.o2;
    
    // stage 3
    o = reflector(x0, x1);
    x0 = o.o1;
    x1 = o.o2;
    o = rotators(x2, x3, 6);
    x2 = o.o1;
    x3 = o.o2;
    o = reflector(x4, x6);
    x4 = o.o1;
    x6 = o.o2;
    o = reflector(x7, x5);
    x7 = o.o1;
    x5 = o.o2;
    
    // stage 4
    o = reflector(x7, x4);
    x7 = o.o1;
    x4 = o.o2;
    x5 = scaleup(x5);
    x6 = scaleup(x6);
    
    //updating the memory
    x[0] = x0;
    x[1] = x1;
    x[2] = x2;
    x[3] = x3;
    x[4] = x4;
    x[5] = x5;
    x[6] = x6;
    x[7] = x7;
}

void printMatrix(float **x){
    int i;
    int j;
    for (i=0; i<8; i++){
        for (j=0; j<8;j++){
            printf("%.3f  ", x[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, char *argv[])
{
    int i;
    int j;
    float testBlock[8][8] = { {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                            {255, 255, 255, 255, 255, 255, 255, 255} };
    
    float **Matrix = createMatrix(8,8);
    for (i=0; i<8; i++){
        for (j=0; j<8; j++){
            Matrix[i][j] = testBlock[i][j];
        }
    }
    
    printMatrix(Matrix);
    printf("\n\n After DCT Calculation \n\n");
    
    // row separation
    for (i=0; i<8; i++){
        dct(Matrix[i]);
    }
    
    // column separation
    for (j=0; j<8; j++){
        float *column = (float *)malloc(8 * sizeof(float));
        for (i=0; i<8; i++){
            column[i] = Matrix[i][j];
        }
        dct(column);
        for (i=0; i<8; i++){
            Matrix[i][j] = column[i];
        }
        free(column);
    }
    
    //print result. Needs to be done.
    printMatrix(Matrix);
    
    // free the memory.
    freeMatrix(Matrix);
}
