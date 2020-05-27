# Point Cloud Geometry Coder
The following Matlab code implements a lossy intra frame encoder for Point Cloud Geometry based on Dyadic Decomposition. 
It was used to get the results presented on the paper `LOSSY POINT CLOUD GEOMETRY COMPRESSION VIA DYADIC DECOMPOSITION`, whose authors are Davi R. Freitas, Eduardo Peixoto, Ricardo L. de Queiroz and Edil Medeiros, accepted for presentation on the [IEEE ICIP 2020](http://2020.ieeeicip.org) conference.

# Usage
The script `Code/startup` should configure yout Matlab path to this project.

Afterwards, there are 2 functions that can be used:
 - The function 
    `enc = encodePointCloudGeometry(inputFile, outputFile, lossy_params)` 
    compress the input data to the output file, and returns an encoder object. It takes as inputs:

    1. `inputFile` = the input PLY file with the point cloud to be encoded;
    2. `outputFile` = bineary file where to save the encoded frame;
    3. `lossy_params` = 
  
 - The function 
    `dec = decodePointCloudGeometry(inputFile, outputFile)` 
    takes two inputs, the binary input file and the output Ply file.
    It decodes the data, writing the ply file to the outputFile, and returns a decoder object.

# LICENSE
Copyright 2020 Eduardo Peixoto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Contact Person
[Eduardo Peixoto](mailto:eduardopeixoto@ieee.org)

