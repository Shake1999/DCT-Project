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
const float constants[8] = { 0, 0.9999, 0.0034, 0.9999, 0.0103, 0, 1.4139, 0.0291};

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

/*struct Output reflector(uint8_t i1, uint8_t i2)
{
    struct Output o;
    o.o1 = (uint8_t)(i1 + i2);
    o.o2 = (uint8_t)(i1 - i2);
    
    return o;
}*/

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
    
    register uint16_t o;
    //local parameters
    uint8_t x0 = x[0];
    uint8_t x1 = x[1];
    uint8_t x2 = x[2];
    uint8_t x3 = x[3];
    uint8_t x4 = x[4];
    uint8_t x5 = x[5];
    uint8_t x6 = x[6];
    uint8_t x7 = x[7];
    
    // stage 1
    o = butterfly(x0, x7, 1.0, 0.9058); // cos(0*pi/16) and cos(7*pi/16)
    x7 = o & 0xff;
    x0 = o >> 8;
    o = butterfly(x1, x6, 0.998, 0.9305); // cos(pi/16) and cos(6*pi/16)
    x6 = o & 0xff;
    x1 = o >> 8;
    o = butterfly(x2, x5, 0.9922, 0.9516); // cos(2*pi/16) and cos(5*pi/16)
    x5 = o & 0xff;
    x2 = o >> 8;
    o = butterfly(x3, x4, 0.9825, 0.9689); // cos(3*pi/16) and cos(4*pi/16)
    x4 = o & 0xff;
    x3 = o >> 8;
    
    // stage 2
    o = butterfly(x0, x3, 1, 0.9825);
    x3 = o & 0xff;
    x0 = o >> 8;
    o = butterfly(x1, x2, 0.998, 0.9922);
    x2 = o & 0xff;
    x1 = o >> 8;
    o = rotators(x4, x7, 3);
    x7 = o & 0xff;
    x4 = o >> 8;
    o = rotators(x5, x6, 1);
    x6 = o & 0xff;
    x5 = o >> 8;
    
    // stage 3
    o = butterfly(x0, x1, 1, 0.998);
    x1 = o & 0xff;
    x0 = o >> 8;
    o = rotators(x2, x3, 6);
    x3 = o & 0xff;
    x2 = o >> 8;
    o = butterfly(x4, x6, 0.9689, 0.9305);
    x6 = o & 0xff;
    x4 = o >> 8;
    o = butterfly(x7, x5, 0.9058, 0.9516);
    x5 = o & 0xff;
    x7 = o >> 8;
    
    // stage 4
    o = butterfly(x7, x4, 0.9058, 0.9689);
    x4 = o & 0xff;
    x7 = o >> 8;
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
                             {254, 254, 254, 254, 254, 254, 255, 255} };
    
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
