$title Min-Cost Network Flow (Williams, p.82) (modified)
* introduced upper bound on some arcs

option limrow=0, limcol=0, solprint=off;

set node /0*7/;
parameter supply(node) /0 10, 1 15, 5 -9, 6 -10, 7 -6/;
parameter cost(node,node) /
      0.2   5,    1.3   4,
      2.3   2,    2.4   6,
      2.5   5,    3.4   1,
      3.7   2,    4.2   4,
      4.5   6,    4.6   3,
      7.6   4 /;
parameter capacity(node,node);

alias (node,i,j,k);

* define a dynamic set that indicates the "legal" arcs
set arc(node,node);
arc(i,j) = yes$(cost(i,j) > 0);

* assign capacities
capacity(arc) = uniform(10,15)
*capacity('3','4') = 5; capacity('4','6') = 5;

positive variable f(node,node);
variable totalcost;

equations balance(node), objective;

balance(i)..
  sum(arc(i,k), f(arc)) - sum(arc(j,i), f(arc)) =e= supply(i);

objective..
  totalcost =e= sum(arc, cost(arc)*f(arc));

* apply capacity constraints
f.up(arc) = capacity(arc);

model mcf /balance, objective/;
mcf.optfile = 1;

solve mcf using lp minimizing totalcost;

option f:0:0:2; display f.l;

set iter /iter1*iter10/;
parameter result(iter,*);
option seed = 101;
loop(iter,
  capacity(arc) = uniform(3,15);
  capacity('1','3') = 15 ;
  capacity('0','2') = 10 ;
  f.up(arc) = capacity(arc);
  solve mcf using lp minimizing totalcost;
  result(iter,'modelstat') = mcf.modelstat;
  if (mcf.modelstat eq 1,
    result(iter,'obj') = totalcost.l;
  );
);
display result;

$onecho > cplex.opt
lpmethod 3
netfind 1
preind 0
names no
$offecho
