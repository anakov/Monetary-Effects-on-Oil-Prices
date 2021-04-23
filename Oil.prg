new; cls;
format /ld 6,2;
output file=C:\Gauss\Gillman\NAJEF\oil.out reset;     

dataend=632;     @ dataend=516; @

load yyy[dataend,3]=C:\Gauss\Gillman\NAJEF\DataNle.txt; 

@ variables are ordered: (inflation; oil price; gold price) @
dep=1;                    @ index of dependent variable @       
reg=2;                    @ index of other regressor (lagged dependent is always a regressor) @       

ar=1;                    @ number of lags in VAR @       

bigt=dataend-ar;          @ effective sample size @

y=yyy[1+ar:dataend,dep];  @ y is the dependent variable @
z=ones(bigt,1);           @ z is the matrix of regressors (bigt,q) whose coefficients are ALLOWED to change @
x=ones(bigt,1);           @ x is the matrix of regressors (bigt,p) whose coefficients are NOT allowed to change @

j=1; do while j<=ar;            @ building regressors in matrix x @
x=x~yyy[1+ar-j:dataend-j,dep];    @ lagged dependent variable @
 x=x~yyy[1+ar-j:dataend-j,reg];   @ lags of other regressor   @
j=j+1; endo;

x=x[1:bigt,2:cols(x)];          @ removing first column, which is constant and already in z @

"";
"Equation for variable number (PI, Poil, Pgold): "  dep;
"AR: " ar; "";

                         @  x is a (bigt,p) matrix of regressors with coefficients fixed across regimes. 
                               Note: initialize x to something, say 0, even if p = 0.@
q=cols(z);               @ number of regressors z @
p=cols(x);               @ number of regressors x @
m=5;                     @ maximum number of structural changes allowed @
eps1=.1;                @ Value of the trimming (in percentage) for the construction
                               and critical values of the supF type tests (used in the
                               supF test, the Dmax, the supF(l+1|l) and the sequential
                               procedure). if these test are used, h below should be set
                               at int(eps1*bigt). But if the tests are not required, estimation
                               can be done with an arbitrary h.
                               There are five options: eps1 = .05, .10, .15, .20 or .25.
                               for each option, the maximal value of m above is: 10 for eps1 = .05;
                               8 for eps1 = .10, 5 for eps1 = .15, 3 for eps1 = .20 and 2 for eps1 = .25. @
h=int(eps1*bigt);        @ minimal length of a segment (h >= q). Note: if
                               robust=1, h should be set at a larger value.@

@ the following are options if p > 0. @
@ -------------------------------------------------------------------------------------------@
fixb=0;                  @ set to 1 if use fixed initial values for beta@
betaini=0;               @ if fixb=1, load the initial value of beta.@
maxi=20;                 @ maximum number of iterations for the nonlinear
                              procedure to obtain global minimizers.@
printd=1;                @ set to 1 if want the output from the iterations
                              to be printed.@
eps=0.0001;              @ criterion for the convergence.@
@ -------------------------------------------------------------------------------------------@

robust=0;                @set to 1 if want to allow for heterogeneity
                              and autocorrelation in the residuals, 0 otherwise.
                              The method used is Andrews(1991) automatic
                              bandwidth with AR(1) approximation and the
                              quadratic quernel. Note: DO NOT set to 1 if
                              lagged dependent variables are included as
                              regressors.@
prewhit=0;               @set to 1 if want to apply AR(1) prewhitening
                              prior to estimating the long run covariance
                              matrix@
hetdat=1;                @Option for the construction of the F-tests.
                              Set to 1 if want to allow different moment matrices of the
                              regressors accross segments. if hetdat = 0, the same
                              moment matrices are assumed for each segment and estimated
                              from the full sample. It is recommended to set hetdat=1.  if p > 0
                              set hetdat = 1.@
hetvar=1;                @Option for the construction of the F-tests.
                              Set to 1 if want to allow for the variance of the residuals
                              to be different across segments. If hetvar=0, the variance
                              of the residuals is assumed constant across segments
                              and constructed from the full sample. This option is not available
                              when robust = 1.@
hetomega=1;              @Used in the construction of the confidence
                              intervals for the break dates. if hetomega=0,
                              the long run covariance matrix of zu is assumed
                              identical accross segments (the variance of the
                              errors u if robust = 0).@
hetq=1;                  @Used in the construction of the confidence
                              intervals for the break dates. if hetq=0,
                              the moment matrix of the data is assumed
                              identical accross segments.@
doglobal=0;              @set to 1 if want to call the procedure
                              to obtain global minimizers.@
  dotest=0;              @set to 1 if want to construct the sup F,
                              UDmax and WDmax tests. doglobal must be set
                              to 1 to run this procedure.@
  dospflp1=0;            @set to 1 if want to construct the sup(l+1|l)
                              tests where under the null the l breaks are
                              obtained using global minimizers. doglobal
                              must be set to 1 to run this procedure.@
  doorder=0;             @set to 1 if want to call the procedure that
                              selects the number of breaks using information
                              criteria. doglobal must be set to 1 to run
                              this procedure.@
dosequa=1;               @set to 1 if want to estimate the breaks
                              sequentially and estimate the number of
                              breaks using the supF(l+1|l) test.@
dorepart=0;              @set to 1 if want to modify the
                              break dates obtained from the sequential
                              method using the repartition method of
                              Bai (1995), Estimating breaks one at a time.
                              This is needed for the confidence intervals
                              obtained with estim below to be valid.@
estimbic=0;              @set to 1 if want to estimate the model with
                              the number of breaks selected by BIC.@
estimlwz=0;              @set to 1 if want to estimate the model with
                              the number of breaks selected by LWZ.@
estimseq=1;              @set to 1 if want to estimate the model with
                              the number of breaks selected using the
                              sequential procedure.@
estimrep=0;              @set to 1 if want to esimate the model with
                              the breaks selected using the repartition
                              method.@
estimfix=0;              @set to 1 if want to estimate the model with
                              a prespecified number of breaks equal to fixn
                              set below.@
fixn=0;

call pbreak(bigt,y,z,q,m,h,eps1,robust,prewhit,hetomega,
hetq,doglobal,dotest,dospflp1,doorder,dosequa,dorepart,estimbic,estimlwz,
estimseq,estimrep,estimfix,x,eps,maxi,fixb,betaini,printd,hetdat,hetvar,fixn);

#include brcode.src            @set the path to where you store the file brcode.src@

end;

