#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"


// have to look into this
int main(void) {
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
