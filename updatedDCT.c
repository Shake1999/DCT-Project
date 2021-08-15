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
#define constant0 0.9999
#define constant1 0.0034
#define constant2 0.9999
#define constant3 0.0103
#define constant4 1.4139
#define constant5 0.0291

// initialize and allocate memory to a matrix of shape (row * col).
uint8_t **createMatrix(int row, int col){
    uint8_t **M = (uint8_t **)malloc(row * sizeof(uint8_t *));
    int i;
    for (i=0; i<row; i++){
        M[i] = (uint8_t *)malloc(col * sizeof(uint8_t));
    }
    return M;
}

// free the pointers. // loop initialization and conditions changed.
void freeMatrix(uint8_t **M){
    int i;
    for (i=N-1; i >= 0; i--){
        free(M[i]);
    }
    free(M);
}

// read the jpeg file
void readJPEG(uint8_t **M){
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

inline uint16_t butterfly(register uint8_t i1, register uint8_t i2, register float c1, register float c2)
{
    register uint8_t o1 = (i1 + i2) * c1;
    register uint8_t o2 = (i1 - i2) * c2;
    register uint16_t o  = (o1<<8) + o2;

    return o;
}

inline uint16_t rotators(register uint8_t i1, register uint8_t i2, register float k1, register float k2)
{
    register uint8_t o1 =  k1 * i1 + k2 * i2;
    register uint8_t o2 = -k2 * i1 + k1 * i2;
    register uint16_t o = (o1<<8) + o2;
    return o;
}

inline uint8_t scaleup(register uint8_t x)
{
        return (uint8_t)(1.4142 * x);
}

// calculates the 8-point 1D DCT
// Input : pointer to array of 8 elements.
void dct(uint8_t *x){
    //local parameters
    register uint16_t x07 = x[0] << 8 + x[7];
    register uint16_t x16 = x[1] << 8 + x[6];
    register uint16_t x25 = x[2] << 8 + x[5];
    register uint16_t x34 = x[3] << 8 + x[4];

    // stage 1
    x07 = butterfly(x07 >> 8, x07 & 0xff, 1.0, 1.0);
    x16 = butterfly(x16 >> 8, x16 & 0xff, 1.0, 1.0);
    x25 = butterfly(x25 >> 8, x25 & 0xff, 1.0, 1.0);
    x34 = butterfly(x34 >> 8, x34 & 0xff, 1.0, 1.0);

    register uint16_t tmp1;
    register uint16_t tmp2;
    register uint16_t tmp3;

    // stage 2 even part
    tmp1 = butterfly(x07 >> 8, x34 >> 8, 1.0, 1.0);
    tmp2 = butterfly(x16 >> 8, x25 >> 8, 1.0, 1.0);

    // stage 3 even part and memory updates
    tmp3 = butterfly(tmp1 >> 8, tmp2 >> 8, 1.0, 1.0);
    x[4] = tmp3 & 0xff;
    x[0] = tmp3 >> 8;
    tmp3 = rotators(tmp2 & 0xff, tmp1 & 0xff, constant4, constant5);
    x[6] = tmp3 & 0xff;
    x[2] = tmp3 >> 8;

    // stage 2 odd part
    tmp1 = rotators(x34 & 0xff, x07 & 0xff, constant2, constant3);
    tmp2 = rotators(x25 & 0xff, x16 & 0xff, constant0, constant1);

    // stage 3 odd part
    tmp3 = butterfly(tmp1 >> 8, tmp2 & 0xff, 1.0, 1.0);
    tmp1 = butterfly(tmp1 & 0xff, tmp2 >> 8, 1.0, 1.0);

    // stage 4 odd part and memory updates
    tmp2 = butterfly(tmp3 >> 8, tmp1 >> 8, 1.0, 1.0);
    x[7] = tmp2 & 0xff;
    x[1] = tmp2 >> 8;
    x[3] = scaleup(tmp1 & 0xff);
    x[5] = scaleup(tmp3 & 0xff);
}

void printMatrix(uint8_t **x){
    int i;
    int j;
    for (i=0; i<8; i++){
        for (j=0; j<8;j++){
            printf("%d  ", x[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, char *argv[])
{
    int i;
    int j;
    uint8_t testBlock[8][8] = { {254, 254, 254, 254, 254, 254, 254, 254},
                             {254, 254, 254, 254, 254, 254, 254, 254},
                             {254, 254, 254, 254, 254, 254, 254, 254},
                             {254, 254, 254, 254, 254, 254, 254, 254},
                             {254, 254, 254, 254, 254, 254, 254, 254},
                             {254, 254, 254, 254, 254, 254, 254, 254},
                             {254, 254, 254, 254, 254, 254, 254, 254},
                             {254, 254, 254, 254, 254, 254, 254, 254} };
    
    uint8_t **Matrix = createMatrix(8,8);
    readJPEG(Matrix);
    /*
    for (i=0; i<8; i++){
        for (j=0; j<8; j++){
            Matrix[i][j] = testBlock[i][j];
        }
    }*/
    
    printMatrix(Matrix);
    printf("\n\n After DCT Calculation \n\n");
    
    // row separation
    for (i=0; i<8; i++){
        dct(Matrix[i]);
    }
    
    // column separation
    for (j=0; j<8; j++){
        uint8_t *column = (uint8_t *)malloc(64);
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
