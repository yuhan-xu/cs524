$title Traveling Salesman Problem - Five (TSP5,SEQ=345)
$Ontext

This is the fifth problem in a series of traveling salesman
problems. Here we use a compact formulation that ensures no subtours
due to Miller, Tucker and Zemlin.

Moreover, we use a dynamic subtour elimination using even stronger
cuts than in the previous models. Also the GAMS programming is more
compact than in the previous examples.


Miller, C E, Tucker, A W, and Zemlin, R A, Integer Programming
Formulation of Traveling Salesman Problems. J. ACM 7, 4 (1960),
326-329.

$Offtext

$include br17.inc
set i(ii) / i1*i17 /;

* Build compact TSP model
Positive variables
     p(ii)          position in tour;

Equations
     defMTZ(ii,jj) 'Miller, Tucker and Zemlin subtour elimination';

defMTZ(i,j)..  p(i) - p(j) =l= card(j)-card(j)*x(i,j) - 1 + card(j)$(ord(j)=1);

model MTZ /all/;

p.fx(j)$(ord(j)=1) = 0; p.up(j) = card(j)-1;
option optcr=0, reslim=30;
solve MTZ min z using mip;

* Dynamic subtour elimination
Set  ste           possible subtour elimination cuts / c1*c1000 /
     a(ste)        active cuts
     tour(ii,jj)   possible subtour
     n(jj)         nodes visited by subtour
Parameter
     continue      indicator to continue to eliminate subtours /1/
     cc(ste,ii,jj) cut coefficients
     rhs(ste)      right hand side of cut;
Equation
     defste(ste)   Subtour elimination cut;

defste(a).. sum((i,j), cc(a,i,j)*x(i,j)) =l= rhs(a);

model DSE / rowsum, colsum, objective, defste /;

a(ste)=no; cc(a,i,j)=0; rhs(a)=0;
option limrow=0, limcol=0, solprint=silent, solvelink=5;
loop(ste$continue,
  if (continue=1,
     solve DSE min z using mip;
     abort$(DSE.modelstat <> %modelstat.Optimal%) 'problems with MIP solver';
     x.l(i,j) = round(x.l(i,j));
     continue=2);
* Check for subtours
  tour(i,j)=no; n(j)=no;
  loop((i,j)$(card(n)=0 and x.l(i,j)), n(i)=yes);
* Found all subtours, resolve with new cuts
  if (card(n)=0, 
     continue=1;
  else
* Construct a single subtour and remove it by setting x.l=0 for its edges 
     while(sum((n,j), x.l(n,j)),
        loop((i,j)$(n(i) and x.l(i,j)),
           tour(i,j) = yes; x.l(i,j) = 0; n(j)=yes));
     if (card(n)<card(j),
        a(ste)   = 1;
        rhs(ste) = card(n)-1;
        cc(ste,i,j)$(n(i) and n(j)) = 1;
     else
        continue=0)));

if (continue=0,
   display 'Optimal tour found', tour;
else
   abort 'Out of subtour cuts, enlarge set ste');
