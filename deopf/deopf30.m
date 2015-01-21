clear;
clc;

   %        IEEE 30-BUS TEST SYSTEM (American Electric Power)
%        Bus Bus  Voltage Angle   ---Load---- -------Generator----- Injected
%        No  code Mag.    Degree  MW    Mvar  MW  Mvar Qmin Qmax     Mvar
 global busdata linedata  Pdt
 tic;
basemva=100;
%        Bus Bus  Voltage Angle   ---Load---- -----Generator-----Static Mvar
%        No  code Mag.    Degree  MW    Mvar  MW  Mvar Qmin Qmax Qc/-Ql
busdata=[1   1    1.06    0.0     0.0   0.0    0.0  0.0   0   0       0
         2   2    1.043   0.0   21.70  12.7   40.0  0.0 -40  50       0
         3   0    1.0     0.0     2.4   1.2    0.0  0.0   0   0       0
         4   0    1.06    0.0     7.6   1.6    0.0  0.0   0   0       0
         5   2    1.01    0.0    94.2  19.0    0.0  0.0 -40  40       0
         6   0    1.0     0.0     0.0   0.0    0.0  0.0   0   0       0
         7   0    1.0     0.0    22.8  10.9    0.0  0.0   0   0       0
         8   2    1.01    0.0    30.0  30.0    0.0  0.0 -10  60       0
         9   0    1.0     0.0     0.0   0.0    0.0  0.0   0   0       0
        10   0    1.0     0.0     5.8   2.0    0.0  0.0  -6  24      19
        11   2    1.082   0.0     0.0   0.0    0.0  0.0   0   0       0
        12   0    1.0     0       11.2  7.5    0    0     0   0       0
        13   2    1.071   0        0    0.0    0    0    -6  24       0
        14   0    1       0       6.2   1.6    0    0     0   0       0
        15   0    1       0       8.2   2.5    0    0     0   0       0
        16   0    1       0       3.5   1.8    0    0     0   0       0
        17   0    1       0       9.0   5.8    0    0     0   0       0
        18   0    1       0       3.2   0.9    0    0     0   0       0
        19   0    1       0       9.5   3.4    0    0     0   0       0
        20   0    1       0       2.2   0.7    0    0     0   0       0
        21   0    1       0      17.5  11.2    0    0     0   0       0
        22   0    1       0       0     0.0    0    0     0   0       0
        23   0    1       0       3.2   1.6    0    0     0   0       0
        24   0    1       0       8.7   6.7    0    0     0   0      4.3
        25   0    1       0       0     0.0    0    0     0   0       0
        26   0    1       0       3.5   2.3    0    0     0   0       0
        27   0    1       0       0     0.0    0    0     0   0       0
        28   0    1       0       0     0.0    0    0     0   0       0
        29   0    1       0       2.4   0.9    0    0     0   0       0
        30   0    1       0      10.6   1.9    0    0     0   0       0];

%                                        Line code
%         Bus bus   R      X     1/2 B   = 1 for lines
%         nl  nr  p.u.   p.u.   p.u.     > 1 or < 1 tr. tap at bus nl
linedata=[1   2   0.0192   0.0575   0.02640    1
          1   3   0.0452   0.1852   0.02040    1
          2   4   0.0570   0.1737   0.01840    1
          3   4   0.0132   0.0379   0.00420    1
          2   5   0.0472   0.1983   0.02090    1
          2   6   0.0581   0.1763   0.01870    1
          4   6   0.0119   0.0414   0.00450    1
          5   7   0.0460   0.1160   0.01020    1
          6   7   0.0267   0.0820   0.00850    1
          6   8   0.0120   0.0420   0.00450    1
          6   9   0.0      0.2080   0.0    0.978
          6  10   0         .5560   0      0.969
          9  11   0         .2080   0          1
          9  10   0         .1100   0          1
          4  12   0         .2560   0      0.932
         12  13   0         .1400   0          1
         12  14    .1231    .2559   0          1
         12  15    .0662    .1304   0          1
         12  16    .0945    .1987   0          1
         14  15    .2210    .1997   0          1
         16  17    .0824    .1923   0          1
         15  18    .1073    .2185   0          1
         18  19    .0639    .1292   0          1
         19  20    .0340    .0680   0          1
         10  20    .0936    .2090   0          1
         10  17    .0324    .0845   0          1
         10  21    .0348    .0749   0          1
         10  22    .0727    .1499   0          1
         21  22    .0116    .0236   0          1
         15  23    .1000    .2020   0          1
         22  24    .1150    .1790   0          1
         23  24    .1320    .2700   0          1
         24  25    .1885    .3292   0          1
         25  26    .2544    .3800   0          1
         25  27    .1093    .2087   0          1
         28  27     0       .3960   0      0.968
         27  29    .2198    .4153   0          1
         27  30    .3202    .6027   0          1
         29  30    .2399    .4533   0          1
          8  28    .0636    .2000   0.0214     1
          6  28    .0169    .0599   0.065      1];
gencost = [1 	0.00375	2	0  50 200;
		2 0.0175	1.75	0  20 80;
		5 0.0625	1	    0  15 50;
		8 0.0083	3.25	0  10 35;
		11 0.025	3	    0  10 30;
		13 0.025	3	    0  12 40];
    Pdt=283.4;
 
n=length(gencost(:,1));
% Initialization and run of differential evolution optimizer.
% A simpler version with fewer explicit parameters is in run0.m
%
% Here for Rosenbrock's function
% Change relevant entries to adapt to your personal applications
%
% The file ofunc.m must also be changed 
% to return the objective function
%

% VTR		"Value To Reach" (stop when ofunc < VTR)
		VTR = 1.e-6; 
% D		number of parameters of the objective function 
		D = n-1; 
% XVmin,XVmax   vector of lower and bounds of initial population
%    		the algorithm seems to work well only if [XVmin,XVmax] 
%    		covers the region where the global minimum is expected
%               *** note: these are no bound constraints!! ***
XVmin=gencost(2:6,5)';
XVmax=gencost(2:6,6)';

% NP            number of population members
		NP = 20; 

% itermax       maximum number of iterations (generations)
		itermax = 200; 

% F             DE-stepsize F ex [0, 2]
		F = 0.8; 

% CR            crossover probabililty constant ex [0, 1]
		CR = 0.8; 

% strategy       1 --> DE/best/1/exp           6 --> DE/best/1/bin
%                2 --> DE/rand/1/exp           7 --> DE/rand/1/bin
%                3 --> DE/rand-to-best/1/exp   8 --> DE/rand-to-best/1/bin
%                4 --> DE/best/2/exp           9 --> DE/best/2/bin
%                5 --> DE/rand/2/exp           else  DE/rand/2/bin

		strategy = 1;

% refresh       intermediate output will be produced after "refresh"
%               iterations. No intermediate output will be produced
%               if refresh is < 1
		refresh = 10; 

[x,f,nf] = devec3('opf2',VTR,D,XVmin,XVmax,gencost,NP,itermax,F,CR,strategy,refresh);
toc;
[F1 PP vv]=opf2(x,gencost)