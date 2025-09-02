To those wondering. These assests aren't used, and merely are for demonstration.
They should be removed after converting back into a png.

How to corrupt an image using Audacity:

Get a PNG and make it into a .BMP image.
Using Audacity open the bmp. Selecting U-Law encoding, little-endian byte order, and mono channel. (or use your corruption software of choice if you have one)
You can use various effects on most of the data. Keep in mind that the first few bytes are important to keep the image format. (DON'T CHANGE THE START!!!)
After you've applied you effects export the data as a raw file, and after exporting change the file type to .bmp again. (you might get a warning)
if it doesn't export correctly undo some effects, and reapply avoiding the start/end of the file.
Congrats! You've corrupted an image!
