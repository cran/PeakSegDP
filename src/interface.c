/* -*- compile-command: "R CMD INSTALL .." -*- */
 
#include <R.h>
#include <R_ext/Rdynload.h>
#include <math.h>
#include "cDPA.h"

void cDPA_interface
(int *data_vec, int *weight_vec, 
 int *n_data, int *max_segments, 
 double *cost_mat, int *end_mat, double *mean_mat
 ){
  cDPA(data_vec, weight_vec,
       *n_data, *max_segments,
       cost_mat, end_mat, mean_mat);
}

R_CMethodDef cMethods[] = {
  {"cDPA_interface",
   (DL_FUNC) &cDPA_interface, 7
   //,{INTSXP, REALSXP, REALSXP, INTSXP}
  },
  {NULL, NULL, 0}
};

void R_init_PeakSegDP(DllInfo *info) {
  R_registerRoutines(info, cMethods, NULL, NULL, NULL);
  //R_useDynamicSymbols call says the DLL is not to be searched for
  //entry points specified by character strings so .C etc calls will
  //only find registered symbols.
  R_useDynamicSymbols(info, FALSE);
}
    
