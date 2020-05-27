/*
 *
 * geomdist.c calculates the distance among two sets of voxels (points in a point cloud within a regular grid)        
 *
 * The calling syntax is:
 *
 *		gdist = geomdist(V1,V2)
 *
 *		each Vi is an Nix3 matrix with the XYZ of the points in space 
 */

#include <math.h>
#include "mex.h"

/* Input Arguments */

#define	V1	prhs[0]
#define	V2	prhs[1]

/* Output Arguments */

#define	GDIST	plhs[0]


static void geometric_distance(
		   double	d[],
		   double	v1[],
		   int		N1,
		   double	v2[],
		   int		N2
		   )
{
	int  	i, j, N11, N22;
	double	dx, dy, dz;
  
	N11 = N1 + N1;
	N22 = N2 + N2;
	for (i = 0; i < N1; i++) {
		for (j = 0; j < N2; j++) {
				dx  = v1[i]-v2[j];
				dy  = v1[i+N1]-v2[j+N2];
				dz  = v1[i+N11]-v2[j+N22];
				d[i*N2+j] = dx*dx + dy*dy + dz*dz;//d[i*N2+j] = sqrt(dx*dx + dy*dy + dz*dz);
		}
	}
	return;
}

void mexFunction(
                 int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]
		 )
{
  double	*d, *vp1, *vp2;
  int		m1, n1, m2, n2;
  
  /* Check for proper number of arguments */
  if (nrhs != 2) {
    mexErrMsgTxt("GEOMDIST requires two input arguments.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("GOEMDIST requires one output argument.");
  }
    
  /* Check input dimensions */
  // V1 is m1x3 and V2 is m2x3
  m1 = mxGetM(V1);
  n1 = mxGetN(V1);
  if (!mxIsNumeric(V1) || mxIsComplex(V1) || mxIsSparse(V1) || !mxIsDouble(V1) || (n1 != 3)) 
		mexErrMsgTxt("GEOMDIST requires V1 to be an Nx3 real matrix.");
  m2 = mxGetM(V2);
  n2 = mxGetN(V2);
  if (!mxIsNumeric(V2) || mxIsComplex(V2) || mxIsSparse(V2) || !mxIsDouble(V2) || (n2 != 3)) 
		mexErrMsgTxt("GEOMDIST requires V2 to be an Nx3 real matrix.");
  
   // Create a matrix for the return argument, should be m2 x m1   
   // I mean, GDIST(i,j) is the distance of V2(i) to V1(j) 
   GDIST = mxCreateDoubleMatrix(m2, m1, mxREAL);
    
  /* Assign pointers to the various parameters */
  d = mxGetPr(GDIST);
  vp1 = mxGetPr(V1);
  vp2 = mxGetPr(V2);
    
  /* Do the actual computations in a subroutine */
  geometric_distance(d,vp1,m1,vp2,m2);
  return;
}
