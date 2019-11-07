$ondollar title hw1-1

option limrow = 0, limcol = 0;

positive variables x1, x2, x3;
variable obj;

equations firstconstr, secondconstr, thirdconstr, objfunc;

firstconstr..
  x1 - 4*x2 + x3 =l= 15;
  
secondconstr..
  9*x1 + 6*x3 =e= 12;
  
thirdconstr..
  9*x2 - 5*x1 =g= 3;
  
objfunc..
  obj =e= 3*x1 + 2*x2 - 33*x3

model warmup /firstconstr, secondconstr, thirdconstr, objfunc/

solve warmup using lp min obj;

parameter x1val, x2val, x3val, objval;
objval = obj.l ;
x1val = x1.l ;
x2val = x2.l ;
x3val = x3.l ;

display objval, x1val, x2val, x3val;