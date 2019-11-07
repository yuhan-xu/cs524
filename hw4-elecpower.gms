Set node/1*7/;
Set subnode1(node)/1,4,7/;
Set subnode2(node)/2,5,6/;

parameter capacity(subnode1)/1 100, 4 20, 7 80/;
parameter genCosts(subnode1)/1 15, 4 13.5, 7 21/;
parameter demands(subnode2)/2 35, 5 50, 6 60/;
parameter transmissionCosts(node,node)/1.2 11, 2.1 11, 2.3 11, 2.7 11, 7.2 11, 3.2 11, 6.7 11, 7.6 11, 4.5 11, 4.3 11, 3.4 11, 5.4 11, 3.5 11, 5.3 11/;

alias(node,i,j,k);

* define dynamic set to indicate legal arcs
Set arc(node,node);
arc(i,j) = yes$(transmissionCosts(i,j) gt 0);
positive variable x(node,node),store(subnode1);
free variable totcost;

equations storeUpBound(subnode1), demandsBalance(subnode2), generate(subnode1), divergences, objfunc;
storeUpBound(subnode1)..
  store(subnode1) =l= capacity(subnode1);

demandsBalance(subnode2)..
  sum(j$arc(j,subnode2),x(j,subnode2)) - sum(k$arc(subnode2,k),x(subnode2,k)) =e= demands(subnode2);
  
generate(subnode1)..
  sum(k$arc(subnode1,k),x(subnode1,k)) - sum(j$arc(j,subnode1),x(j,subnode1)) =e= store(subnode1);
  
divergences..
  sum(j$arc(j,"3"),x(j,"3")) =e= sum(k$arc("3",k),x("3",k));
  
objfunc..
  totcost =e= sum((i,j)$arc(i,j),transmissionCosts(i,j)*x(i,j)) + sum(subnode1,genCosts(subnode1)*store(subnode1));
  
model elecpower /all/;

solve elecpower using lp min totcost;

display x.l;