import PIL
from PIL import Image
import requests
from io import BytesIO
from PIL import ImageFilter
from PIL import ImageEnhance
import numpy as np
import os

#take all the pixels and resize it to 96 by 64 and then get the verilog code for the image that will be displayed

def binarize(image_to_transform, threshold, name):
    # now, lets convert that image to a single greyscale image using convert()
    output_image=image_to_transform.convert("L")
    # the threshold value is usually provided as a number between 0 and 255, which
    # is the number of bits in a byte.
    # the algorithm for the binarization is pretty simple, go through every pixel in the
    # image and, if it's greater than the threshold, turn it all the way up (255), and
    # if it's lower than the threshold, turn it all the way down (0).
    # so lets write this in code. First, we need to iterate over all of the pixels in the
    # image we want to work with
    mystring = f"assign {name} = ("
    firstopen = True
    for y in range(output_image.height):
        opened = False
        numopens = 0
        for x in range(output_image.width):
            # for the given pixel at w,h, lets check its value against the threshold
            if output_image.getpixel((x,y)) > threshold: #note that the first parameter is actually a tuple object
                output_image.putpixel( (x,y), 0 )
                if opened == True:      
                    mystring += f" && x < {x})"
                    opened = False
            else:
                if opened == False:
                    if numopens == 0:
                        if firstopen == False:
                            mystring += "|| \n"
                            
                        firstopen = False
                        mystring += f"((y == {y}) && ((x >= {x}"
                    else:  
                        mystring += f"|| (x >= {x}"
                    opened = True
                    numopens += 1
                output_image.putpixel( (x,y), 255 )
        if opened == True:
            mystring += ")))"
        elif numopens > 0:
            mystring += "))"
    mystring += ");\n\n"
    f.write(mystring)           
    #now we just return the new image
    return output_image


for filename in os.listdir(f"pictures/"):
    if filename.endswith(".png"): 
        img = Image.open(f"pictures/{filename}")
        img = img.resize((96,64))
        f = open(f"verilogallcode/imagecode.v", "a")
        binarize(img,100,os.path.splitext(filename)[0]).save(f"createdpictures/{os.path.splitext(filename)[0]}new.png")
        continue
    else:
        continue
        
# img = Image.open("pictures\A3.png")



# f.write(string)


 

# binarize(img, 100).save("simplenew.png")