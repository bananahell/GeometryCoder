# Point Cloud Geometry Coder

The following Matlab code implements a lossless inter frame encoder for Point Cloud Geometry based on Dyadic Decomposition. 

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

- Optional parameters can be set to control the codec algorithm:
   Usage: enc = encodePointCloudGeometry_Inter(inputFile, predictionFile, outputFile,'param_key',param_value, ...)

	1. `numberOfSlicesToTestSingleMode`: marks the point at which the single-mode encoding starts being considered in addition to the dyadic decomposition. 
    	
		Possible Values: [0 1 2 4 8 16 32 64 128 256 512 1024]
	
		Default: 16
	 
	2. `mode`: As explained in the paper, the codec has three modes.

		0 = S4D: This is the algorithm using the Multi-Mode decision (i.e., it considers both 3D and 4D contexts) and the proposed fast mode decision.
		
		1 = S4D-Multi-Mode: This is the algorithm using the Multi-Mode decision (i.e., it considers both 3D and 4D contexts) but it tests both contexts and decides for the best. 
		
		2 = S4D-Inter: This is the algorithm considering only 4D contexts. 
    
		Possible Values: [0 1 2]
	
		Default: 0

# Contact Person
[Eduardo Peixoto](mailto:eduardopeixoto@ieee.org)