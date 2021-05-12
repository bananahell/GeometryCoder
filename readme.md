# Point Cloud Geometry Coder

The following Matlab code implements a lossless inter frame encoder for Point Cloud Geometry based on Dyadic Decomposition and context selection 

Detailed discussion and performance results are presented on the paper. 
If you find this code useful in your own research, please consider citing:

    @inproceedings{evaristo2021,
	    Author = {Evaristo Ramalho Eduardo Peixoto and Edil Medeiros},
	    Title = {Silhouette 4D with Context Selection: Lossless Geometry Compression of Dynamic Point Clouds(Preprint)},
	    Booktitle  = {},
	    Year = {2021}
    }

# LICENSE
Copyright 2021 Eduardo Peixoto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Usage
To execute the code, you need first to run the script `startup`, which adds the project to your Matlab Path.

Afterwards, there are 2 functions and 3 scripts that can be used:
- The function
    `enc = encodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile)`
	takes two inputs:

    1. `inputFile` = PLY file for the current frame;
    2. `predictionFile` = PLY file for the previous frame;
    3. `outputFile` = path to the binary encoded file;

	It compress the input data to the output file, and returns an encoder object.

- The function
    `dec = decodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile)`
	takes two inputs, the binary input file and the output Ply file.
	It decodes the data, writing the ply file to the outputFile, and returns a decoder object.

# Contact Person
[Eduardo Peixoto](mailto:eduardopeixoto@ieee.org)
[Evaristo Ramalho](mailto:evaristora28@gmail.com)
[Edil Medeiros](mailto:j.edil@ene.unb.br)