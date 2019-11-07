$ondollar title hw1-3

option limrow = 0, limcol = 0;

Set I /p1, p2/;
variable make(I);
variable Profit;
equations firstconstr, secondconstr, thirdconstr, objfunc;

firstconstr..
  5*make("p1") + 10*make("p2") =l= 40;
  
secondconstr..
  9*make("p1") + 2*make("p2") =l= 40;
  
thirdconstr..
  7*make("p1") + 5*make("p2") =l= 40;
  
objfunc..
  Profit =e= 108*make("p1") + 84*make("p2") - 5*10*make("p1") - 5*8*make("p2")
  
model productmix /firstconstr, secondconstr, thirdconstr, objfunc/

solve productmix using lp max Profit;

display Profit.l, make.l;