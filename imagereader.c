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
    if(img == NULL) {
        printf("ERROR: Could not load the image\n");
    }
    printf("Loaded image with a width of %dpx, a height of %dpx and %d channels\n", width, height, channels);
    int numSubMat = (height/8)*(width/8);
    printf("need %d x %d 8x8 to hold this image, %d in total \n", (height/8), (width/8), numSubMat);
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
    fptr = fopen("fullimagematrix","w");
    for(y=0; y<height; y++) {
        for(x=0; x<width; x++) {
           fprintf(fptr, "%d,", original_image[y][x]);
        }
        fprintf(fptr,"\n");
    }
    fclose(fptr);


    fptr = fopen("splitmatrix","w");
    int yOffset = 0;
    int xOffset = 0;
    int xsplit;
    int ysplit;
    for(ysplit = 0; ysplit < height/8; ysplit++) {
        for(xsplit = 0; xsplit < width/8; xsplit++) {
            for(y=0; y<8; y++) {
                for(x=0; x<8; x++) {
                    fprintf(fptr, "%d,", original_image[y+yOffset][x+xOffset]);
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