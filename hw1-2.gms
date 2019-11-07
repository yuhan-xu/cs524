$ondollar title hw1-2

option limrow = 0, limcol = 0;

Set J /x1, x2, x3/;
variable x(J);
variable obj;
equations firstconstr, objfunc;

firstconstr..
  3*x("x1") =g= sum(J,x(J));

x.lo(J) = 0;
  
x.up(J) = 3;
  
objfunc..
  obj =e= 5*(x("x1") + 2*x("x2")) - 11*(x("x2")-x("x3"))
  
model prob2 /firstconstr, objfunc/

solve prob2 using lp max obj;

display x.l, x.lo, x.up, prob2.objval;