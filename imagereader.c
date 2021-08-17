#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

#define STB_IMAGE_IMPLEMENTATION

#include "stb_image.h"
int main(int argc, char *argv[]){
    FILE *fptr;
    int width, height, channels;
    // defined to write to an unsigned char, but uint8_t is the same effectivly
    uint8_t *img = stbi_load("TestImages/min_test_image.png", &width, &height, &channels, 0);
    int size = strlen((char*) img);
    // create the array to work off
    uint8_t original_image[height][width];
    // write values to this 2D array, which is what we'll work off of.
    int x;
    int y;
    int index = 0;
    for(y=0; y<height; y++) {
        for(x=0; x<width; x+=2) {
            original_image[y][x] = *(img + index);
            original_image[y][x+1] = *(img + index+1);
            index+=2;
        }
    }
    /*
    fptr = fopen("fullimagematrix","w");
    for(y=0; y<height; y++) {
        for(x=0; x<width-1; x+=2) {
           fprintf(fptr, "%d,", original_image[y][x]);
           fprintf(fptr, "%d,", original_image[y][x+1]);
        }
        fprintf(fptr,"\n");
    }
    fclose(fptr);
    */
   
    fptr = fopen("splitmatrix","w");
    int yOffset = 0;
    int xOffset = 0;
    int xsplit;
    int ysplit;
    for(ysplit = 0; ysplit < height/8; ysplit++) {
        for(xsplit = 0; xsplit < width/8; xsplit++) {
            for(y=0; y<8; y++) {
                for(x=0; x<7; x+=2) {
                    fprintf(fptr, "%d,%d,", original_image[y+yOffset][x+xOffset],original_image[y+yOffset][x+xOffset+1]);
                }
                fprintf(fptr,"\n");
            }
            xOffset= xOffset+8;
            fprintf(fptr,"\n\n");
        }
        xOffset = 0; 
        yOffset = yOffset+8;
    }

    fclose(fptr);
}