Set r /ironalloy1,ironalloy2,ironalloy3,copper1,copper2,aluminum1,aluminum2/;
Set K /C, Cu, Mn/;

* Read in a table with rows that are raw materials and columns are grades of each chemical
table data(r,K)
               C    Cu   Mn 
ironalloy1     2.5  0    1.3
ironalloy2     3    0    0.8
ironalloy3     0    0.3  0
copper1        0    90   0
copper2        0    96   4
aluminum1      0    0.4  1.2
aluminum2      0    0.6  0;

positive variables x(r);
free variable costs "the cost of producing steels";

parameters
  avail(r) /"ironalloy1" 400, "ironalloy2" 300, "ironalloy3" 600, "copper1" 500, "copper2" 200, "aluminum1" 300, "aluminum2" 250/
  cost(r) /"ironalloy1" 200, "ironalloy2" 250, "ironalloy3" 150, "copper1" 220, "copper2" 240, "aluminum1" 200, "aluminum2" 165/
  mingrade(K)/"C" 2, "Cu" 0.4, "Mn" 1.2/
  maxgrade(K)/"C" 3, "Cu" 0.6, "Mn" 1.65/;

equations 
  mingradeEqn(K)  "the minimum grade in percentage for each element in set K should be greater than the corresponding value in the parameter mingrade(K) I constructed"
  maxgradeEqn(K)  "the maximum grade in percentage for each element in set K should be smaller than the corresponding value in the parameter maxgrade(K) I constructed"
  maxTonsOfSteel  "we want the total number of raw materials to make steel equals to the order that is 500 tons of steel"
  objfunc;

* EQUATION (MODEL) DEFINITION
mingradeEqn(K)..
  (sum(r,data(r,K)*x(r)))/500 =g= mingrade(K);
  
maxgradeEqn(K)..
  (sum(r,data(r,K)*x(r)))/500 =l= maxgrade(K);
  
maxTonsOfSteel..
  sum(r,x(r)) =e= 500;

* VARIBLE BOUNDS    
x.up(r) = avail(r);

* Objective function
objfunc..
  costs =e= sum(r,cost(r)*x(r));
  
model alloyblending /all/;

solve alloyblending using lp min costs;