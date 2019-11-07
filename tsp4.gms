$title Traveling Salesman Problem - Four (TSP4,SEQ=180)
$eolcom //
$Ontext
 This is the fourth problem in a series of traveling salesman
 problems. Here we revisit TSP1 and generate smarter cuts.
 The first relaxation is the same as in TSP1.


Kalvelagen, E, Model Building with GAMS. forthcoming

de Wetering, A V, private communication.

$Offtext

$include br17.inc
*
* For this algorithm we can try a larger subset of 12 cities.

set i(ii) / i1*i12 /;

*  options. Make sure MIP solver finds global optima.
option optcr=0;


model assign /objective, rowsum, colsum/;

solve assign using mip minimizing z;

* find and display tours
*
set t tours  /t1*t17/; abort$(card(t) < card(i)) "Set t is possibly too small"
     sets tour(i,j,t)  subtours
          visited(i)   flag whether a city is already visited;
Singleton Sets
          from(i)      contains always one element: the from city
          next(j)      contains always one element: the to city
          tt(t)        contains always one element: the current subtour;
   scalar goon         go on flag used to control loop;
alias(i,ix);

* initialize
from(i)$(ord(i)=1) = yes;    // turn first element on
tt(t)$(ord(t)=1)   = yes;    // turn first element on

* subtour elimination by adding cuts
*

set cc /c1*c1000/; alias(cc,ccc); // we allow up to 1000 cuts

set curcut(cc)  current cut always one element
    allcuts(cc) total cuts;

parameters cutcoeff(cc, i, j)
           rhs(cc)
           nosubtours  number of subtours;

equations cut(cc) dynamic cuts;

cut(allcuts).. sum((i,j), cutcoeff(allcuts,i,j)*x(i,j)) =l= rhs(allcuts);

model tspcut /objective, rowsum, colsum, cut/;

curcut(cc)$(ord(cc)=1) = yes;
scalar ok;
goon = 1;

loop(ccc$goon,
* initialize
   from(i)$(ord(i)=1) = yes;    // turn first element on
   tt(t)$(ord(t)=1)   = yes;    // turn first element on
   tour(i,j,t)=no;
   visited(i)=no;
   loop(i,
      next(j)$(x.l(from,j)>0.5) = yes;    // check x.l(from,j)=1 would be dangerous
      tour(from,next,tt) = yes;           // store in table
      visited(from) = yes;                // mark city 'from' as visited
      from(j) = next(j);
      if (sum(visited(next),1)>0,         // if already visited...
         tt(t) = tt(t-1);
         loop(ix$(not visited(ix)),       // find starting point of new subtour
            from(ix) = yes;
          )
      )
    );
    display tour;
    nosubtours = sum(t, max(0,smax(tour(i,j,t),1)));
    display nosubtours;
   if (nosubtours=1,
          goon = 0;           // done: no subtours
       else                   // else: introduce cut
          loop(t$(ord(t) <= nosubtours),
            rhs(curcut)=-1;
            loop(tour(i,j,t),
             cutcoeff(curcut, i, j)$(x.l(i,j) > 0.5) = 1;
* not needed due to nature of assignment constraints
*             cutcoeff(curcut, i, j)$(x.l(i,j) < 0.5) = -1;
             rhs(curcut) = rhs(curcut) + 1;
            );
             allcuts(curcut) = yes;   // include this cut in set
             curcut(cc) = curcut(cc-1);
          );
          solve tspcut using mip minimizing z;
          tspcut.solprint=%solprint.Quiet%;tspcut.limrow=0;tspcut.limcol=0;
   )
);

display x.l;
abort$(goon = 1) "Too many cuts needed"
