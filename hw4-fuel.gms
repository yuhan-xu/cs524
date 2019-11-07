option limrow=100, limcol=0;

$if not set N $set N 50
$eval NM1 %N%-1
set t times /0*%N%/;
set i /x,y,dx,dy/; alias(i,j);
set ct(t) control times /0*%NM1%/;

parameter A(i,j) /x.x 1, x.y -0.1, y.x -0.5, y.y 0.5, dx.dx 0.1, dx.dy -1.1, dy.dx 0.5, dy.y -0.5/,
          b(i) /x 1, y 1, dx 1, dy 1/,
          xdes(i) /x 2, y -1/;
          
variable x(i,t);
variable u(t);
positive variable f(ct);
variable totalFuel;

equations Recurrence(i,t),ConditionFuel1(ct),ConditionFuel2(ct),ConditionFuel3(ct),ConditionFuel4(ct),objfunc;
  
Recurrence(i,t)$ct(t)..
  x(i,t+1) =e= sum(j, A(i,j)*x(j,t)) + b(i)*u(t);
  
ConditionFuel1(ct)..
  f(ct) =g= u(ct);
  
ConditionFuel2(ct)..
  f(ct) =g= -u(ct);
  
ConditionFuel3(ct)..
  f(ct) =g= 2*u(ct) - 1;
  
ConditionFuel4(ct)..
  f(ct) =g= -2*u(ct) - 1;
  
objfunc..
  totalFuel =e= sum(ct, f(ct));
  
x.fx(i,"0") = 0;
x.fx(i,"50") = xdes(i);
  
model fuel /all/;

solve fuel using lp min totalFuel;




