/* -*- compile-command: "R CMD INSTALL .." -*- */

#include <R.h>
#include <R_ext/Rdynload.h>
#include <math.h>
#include "clusterPeaks.h"
#include "binSum.h"

void clusterPeaks_interface
(int *peakStart, int *peakEnd,
 int *cluster,
 int *peaks) {
  int status;
  status = clusterPeaks(peakStart, peakEnd, 
			cluster,
			*peaks);
  if(status == ERROR_PEAKSTART_DECREASING){
    error("peakStart decreasing");
  }
  if(status != 0){
    error("unrecognized error code");
  }
}

void binSum_interface(
  int *profile_chromStart,
  int *profile_chromEnd,
  int *profile_coverage,
  int *n_profiles,
  int *bin_total,
  int *bin_size,
  int *n_bins,
  int *bin_chromStart){
  int status;
  status = binSum(profile_chromStart, 
		  profile_chromEnd,
		  profile_coverage,
		  *n_profiles,
		  bin_total,
		  *bin_size,
		  *n_bins,
		  *bin_chromStart, 0);
  if(status == ERROR_CHROMSTART_NOT_LESS_THAN_CHROMEND){
    error("chromStart not less than chromEnd");
  }
  if(status == ERROR_CHROMSTART_CHROMEND_MISMATCH){
    error("chromStart[i] != chromEnd[i-1]");
  }
  if(status != 0){
    error("error code %d", status);
  }
}

// Memory efficient and with constraint Poisson dynamic programing
// The constraint is \mu1 < \mu2 > \mu3 < \mu4 >....
// For the Poisson we don't need to consider the factorial part
// For the Poisson in the stand DP version we only to consider 
// the \sum x_i ln(lambda) [at the max likelihood \sum_i \hat{\lambda_i} = \sum x_i

double PoissonLoss(double xw, double w){
  // compute cost and mean for next step.
  if(xw != 0){
    return xw * (1 - log(xw) + log(w)); 
  } else {
    return 0;
  }
}

void cDPA
(int *sequence, int *weights, 
 int *lgSeq, int *nStep, 
 double *cost_mat, int *end_mat, double *mean_mat
  ){
  int n_data = *lgSeq;
  int max_segments = *nStep;
  for(int i=0; i<n_data*max_segments; i++){ 
    cost_mat[i] = INFINITY;
    mean_mat[i] = INFINITY;
  }
  /* 	STRT INITIALISATION 	   */
  double SommeSeq=0.0, SommeWei=0.0;
  for(int i=0; i<n_data; i++){
    SommeSeq += weights[i]*sequence[i];
    SommeWei += weights[i];
    cost_mat[i] = PoissonLoss(SommeSeq, SommeWei);
    mean_mat[i] = SommeSeq/SommeWei;
    end_mat[i] = 0;
  }
  /* 	END INITIALISATION 	   */

  /* 	CONSIDER ALL SEG 	   */
  for(int seg_i=1; seg_i<max_segments; seg_i++){
    for(int seg_start=seg_i; seg_start<n_data; seg_start++){
      // compute cost of models with a break before seg_start.
      SommeSeq = 0.0;
      SommeWei = 0.0;
      int prev_i = (seg_i-1)*n_data + seg_start-1;
      double prev_mean = mean_mat[prev_i];
      double prev_cost = cost_mat[prev_i];
      for(int seg_end=seg_start; seg_end<n_data; seg_end++){
	SommeSeq += weights[seg_end]*sequence[seg_end];
	SommeWei += weights[seg_end];
	double seg_mean = SommeSeq/SommeWei;
	int mean_feasible;
	if(seg_i % 2){
	  //odd-numbered segment. 3, 5, ...
	  mean_feasible = prev_mean < seg_mean;
	}else{
	  //even-numbered segment. 2, 4, ...
	  mean_feasible = prev_mean > seg_mean;
	}
	if(mean_feasible){ 
	  double seg_cost = PoissonLoss(SommeSeq, SommeWei);
	  /* printf("segs=%d, start=%d, end=%d\n", seg_i, seg_start, seg_end); */
	  /* printf("prev mean=%f cost=%f\n", prev_mean, prev_cost); */
	  /* printf("this mean=%f cost=%f\n", seg_mean, seg_cost); */
	  int this_i = n_data*seg_i + seg_end;
	  double best_cost_so_far = cost_mat[this_i];
	  double candidate_cost = seg_cost + prev_cost;
	  //printf("best=%f, candidate=%f\n", best_cost_so_far, candidate_cost);
	  if(candidate_cost < best_cost_so_far){
	    cost_mat[this_i] = candidate_cost;
	    mean_mat[this_i] = seg_mean;
	    end_mat[this_i] = seg_start;
	  }
	}
      }//seg_end
    }//seg_start
  }//seg_i
}


R_CMethodDef cMethods[] = {
  {"clusterPeaks_interface",
   (DL_FUNC) &clusterPeaks_interface, 4
   //,{REALSXP, REALSXP, INTSXP, INTSXP, REALSXP}
  },
  {"binSum_interface",
   (DL_FUNC) &binSum_interface, 9
   //,{REALSXP, REALSXP, INTSXP, INTSXP, REALSXP}
  },
  {"cDPA",
   (DL_FUNC) &cDPA, 7
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
    
