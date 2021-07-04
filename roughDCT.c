/* DCT implementation for a one-dimensional array
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define root2 1.41421356
// constants required to calculate the output from rotators
// for C1   c1cos 0.99999413            c1sin 0.00342694
// for C3   c3cos 0.99994715            c3sin 0.01028066
// for C6   root(2)*c6cos 1.41391462    root(2)*c6sin 0.02907655
#define constants [ null, 0.99999413, 0.00342694, 0.99994715, 0.01028066, null, 1.41391462591, 0.02907655611]

// to make it easier to return 2 values.
struct Output{
    float o1,o2;
};

// initialize and allocate memory to a matrix of shape (row * col).
float **callocMatrix(int row, int col){
    float **M = calloc(row, sizeof(float));
    float *p = calloc(row*col, sizeof(float));
    for (int i=0; i<row;i++){
        M[i] = &p[i*col];
    }
    return M;
}

// free the pointers.
void freeMatrix(float **M){
    for (int i=0; i<8; i++){
        free(M[i]);
    }
    free(M);
}

// read the jpeg file
void readJPEG(FILE *fp, float **M, int N, int M){
   // have to look into this
}

double butterfly(float i1, float i2, float c1, float c2)
{
    float o1 = (i1+i2)*c1; // 16 bits
    float o2 = (i1-i2)*c2; // 16 bits

    Output o;
    o.o1 = o1;
    o.o2 = o2;
    
    return o;
}

double reflector(float i1, float i2)
{
    float o1 = i1 + i2;
    float o2 = i1 - i2;
    
    Output o;
    o.o1 = o1;
    o.o2 = o2;
    
    return o;
}

double rotators(int i1, int i2, int n)
{
    float k1 = constants[n];
    float k2 = constants[n+1];
    
    float o1 = k1*((float)i1) + k2*((float)i2);
    float o2 = -k2*((float)i1) + k1*((float)i2);
    
    Output o;
    o.o1 = o1;
    o.o2 = o2;
    
    return o;
}

float scaleup (int i)
{
    return root2 * i;
}

// calculates the 8-point 1D DCT
void dct(float *row){
    Output o;
    
    //local parameters
    float x0 = &row[0];
    float x1 = &row[1];
    float x2 = &row[2];
    float x3 = &row[3];
    float x4 = &row[4];
    float x5 = &row[5];
    float x6 = &row[6];
    float x7 = &row[7];
    
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
    &row[0] = x0;
    &row[1] = x1;
    &row[2] = x2;
    &row[3] = x3;
    &row[4] = x4;
    &row[5] = x5;
    &row[6] = x6;
    &row[7] = x7;
}


int main(int argc, char *argv[])
{
    float testBlockA[8][8] = { {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                             {255, 255, 255, 255, 255, 255, 255, 255},
                            {255, 255, 255, 255, 255, 255, 255, 255} };
    float **Matrix = callocMatrix(8,8);
    for (int i=0; i<8; i++){
        for (int j=0; j<8; j++){
            Matrix[i][j] = testBlockA[i][j];
        }
    }
    
    // row separation
    for (int i=0; i<8; i++){
        dct(&Matrix[i]);
    }
    // column separation
    for (int j=0; j<8; j++){
        float *column = calloc(8, sizeof(float));
        for (int i=0; i<8; i++){
            column[i] = Matrix[i][j];
        }
        dct(&column);
        for (int i=0; i<8; i++){
            &Matrix[i][j] = column[i];
        }
        free(column);
    }
    //print result. Needs to be done.
    // free the memory.
    freeMatrix(Matrix)
}
