$ondollar title hw1-4

option limrow = 0, limcol = 0;

positive variables x1"light beer", x2"dark beer";
Set K /x1, x2/;
variable quant(K);
variable Profit;
equations firstconstr, secondconstr, thirdconstr, objfunc;

firstconstr..
  2*quant("x1") + 3*quant("x2") =l= 90;
  
secondconstr..
  3*quant("x1") + quant("x2") =l= 40;
  
thirdconstr..
  2*quant("x1") + [5/3]*quant("x2") =l= 80;
  
objfunc..
  Profit =e= 2*quant("x1") + quant("x2");
  
model softsuds /all/

solve softsuds using lp max Profit;

display Profit.l, quant.l;