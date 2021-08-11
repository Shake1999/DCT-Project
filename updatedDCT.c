/* DCT implementation for a one-dimensional array
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

#define N 8
// reduced precision
// constants required to calculate the output from rotators
// for C1   c1cos 0.99999413            c1sin 0.00342694
// for C3   c3cos 0.99994715            c3sin 0.01028066
// for C6   root(2)*c6cos 1.41391462    root(2)*c6sin 0.02907655
const float constants[8] = { 0, 0.9999, 0.0034, 0.9999, 0.0103, 0, 1.4139, 0.0291};

// to make it easier to return 2 values.
struct Output{
    uint8_t o1,o2;
};

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
void readJPEG(FILE *fp, uint8_t **M){
   // have to look into this
}

struct Output butterfly(register uint8_t i1, register uint8_t i2, register float c1, register float c2)
{
    struct Output o;
    o.o1 = (uint8_t)(i1+i2)*c1; // 16 bits
    o.o2 = (uint8_t)(i1-i2)*c2; // 16 bits
    
    return o;
}

/*struct Output reflector(uint8_t i1, uint8_t i2)
{
    struct Output o;
    o.o1 = (uint8_t)(i1 + i2);
    o.o2 = (uint8_t)(i1 - i2);
    
    return o;
}*/

uint16_t r (uint8_t i1, uint8_t i2){
    int a = i1 + i2;
    int b = i1 - i2;
    return (a<<8)+b;
}

struct Output rotators(register uint8_t i1, register uint8_t i2, int n)
{
    register float k1 = constants[n];
    register float k2 = constants[n+1];
    
    float o1 =  k1 * i1 + k2 * i2;
    float o2 = -k2 * i1 + k1 * i2;
    
    struct Output o;
    o.o1 = (uint8_t)o1;
    o.o2 = (uint8_t)o2;
    
    return o;
}

float scaleup (register uint8_t i)
{
    register float root2 = 1.4142;
    return (root2 * i); //changed from memory load to immediate load operation.
}

// calculates the 8-point 1D DCT
// Input : pointer to array of 8 elements.
void dct(uint8_t *x){
    struct Output o;
    
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
    uint8_t testBlock[8][8] = { {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                            {255, 255, 255, 255, 255, 255, 255, 255} };
    
    uint8_t **Matrix = createMatrix(8,8);
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
    
    
    /*check for two return value emulation*/
    uint8_t x = 9;
    uint8_t y = 6;
    uint16_t z = r(x,y);
    printf("\n\n The char : %d\n\n", z);
    uint8_t o1 = z & 0xFF;
    uint8_t o2 = z >> 8;
    printf("\n o1 = : %d\n", o1);
    printf("\n o2 = : %d\n", o2);
    
}
