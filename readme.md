# Point Cloud Geometry Coder
The following Matlab code implements a lossy intra frame encoder for Point Cloud Geometry based on Dyadic Decomposition. 

Detailed discussion and performance results are presented on the paper. If you find this code useful in your own research, please consider citing:

@inproceedings{peixoto2020,
    Author = {Davi R. Freitas and Eduardo Peixoto and Ricardo L. de Queiroz and Edil Medeiros},
    Title = {Lossy Point Cloud Geometry Compression Via Dyadic Decomposition (Preprint)},
    Booktitle  = {IEEE International Conference on Image Processing (ICIP 2020)},
    Year = {2020}
}

# Usage
The script `Code/startup` should configure yout Matlab path to this project.

Afterwards, there are 2 functions that can be used:
 - The function 
    `enc = encodePointCloudGeometry(inputFile, outputFile, lossy_params)` 
    compress the input data to the output file, and returns an encoder object. It takes as inputs:

    1. `inputFile` = the input PLY file with the point cloud to be encoded;
    2. `outputFile` = binary file where to save the encoded frame;
    3. `lossy_params` = step and downsampling values for lossy geometry compression.
        * `lossy_params` can be defined as:
          + `lossy_params = getLossyParams();`
          + `lossy_params.nDownsample = downsample_value;`
          + `lossy_params.step = step_value;`
        * Where downsample_value can be [1, (1/0.75), 2, 3.2] and step_value can be [1, 2, 4]
  
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

