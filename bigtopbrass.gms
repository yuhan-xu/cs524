$ondollar
$title Big Top Brass (LP)

$offsymxref offsymlist offuelxref offuellist offupper
option limrow = 0, limcol = 0;
option solprint=off;

*$include bigtopbrass-1.dat
$include bigtopbrass-2.dat

* VARIABLE AND EQUATION DECLARATIONS
free variable profit "total profit";

positive variables
x(I)     "number trophies" ;

equations
profit_eq         "profit definition"
resource_con(R)   "resource limit" ;

* EQUATION (MODEL) DEFINITION
profit_eq..
  profit =E= sum(I,c(I)*x(I));

resource_con(R)..
  sum(I, a(R,I)*x(I)) =L= b(R);

* VARIBLE BOUNDS
x.up(I) = u(I);

model btb /all/;

$onecho > cplex.opt
lpmethod 1
$offecho

solve btb using lp maximizing profit;

display x.l;
