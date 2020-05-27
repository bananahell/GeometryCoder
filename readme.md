# Point Cloud Geometry Coder

The following Matlab code implements an lossless inter frame encoder for Point Cloud Geometry based on Dyadic Decomposition. 

Detailed discussion and performance results are presented on the paper. 
If you find this code useful in your own research, please consider citing:

    @inproceedings{peixoto2020,
	    Author = {Eduardo Peixoto and Edil Medeiros and Evaristo Ramalho},
	    Title = {Silhouette 4D: An Inter-Frame Lossless Geometry Coder of Dynamic Voxelized Point Clouds (Preprint)},
	    Booktitle  = {IEEE International Conference on Image Processing (ICIP 2020)},
	    Year = {2020}
    }

# LICENSE
Copyright 2020 Eduardo Peixoto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Usage

To execute the code, you need first to run the script `startup`, which adds the project to your Matlab Path.

Afterwards, there are 2 functions and 3 scripts that can be used:
 - The function
    `enc = encodePointCloudGeometry(inputFile, outputFile)`
	takes two inputs, the input Ply file with the Point Cloud data to be encoded, and the output Binary file.
	It compress the input data to the output file, and returns an encoder object.

 - The function
    `dec = decodePointCloudGeometry(inputFile, outputFile)`
	takes two inputs, the binary input file and the output Ply file.
	It decodes the data, writing the ply file to the outputFile, and returns a decoder object.

 - The script `script_testEncoderDecoder` runs both the encoder and the decoder, and then it checks if the decoder
   was able to succesffuly decode the data (the compression is lossless). Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).

 - The script `scriptRunDecoder` decodes all files in the dataset provided (i.e., all sequences in the Microsoft
   Upper Bodies Dataset and the 8i Full Bodies Dataset). Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).

 - The script `scriptRunEncoder` encodes all files in the dataset. The JPEG Pleno dataset can be downloaded at:
     https://jpeg.org/plenodb/ . Note that the input of the script should be changed to reflect your system (i.e., the location of the files in your system).

# Contact Person

[Eduardo Peixoto](mailto:eduardopeixoto@ieee.org)

# Credits

[Philipp Gira](https://scholar.google.at/citations?user=ANBHN2AAAAAJ): [Point cloud tools for Matlab](https://www.geo.tuwien.ac.at/downloads/pg/pctools/pctools.html).
