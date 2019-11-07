set J(*) ¡¯barrier site¡¯,
    P / keep, remove /;
alias (J,K);

set D(J,K) ¡¯downstream barriers from j (not including j)¡¯,
    ROOT(J) ¡¯root nodes of forest¡¯;

parameter
    pi(J,P) ¡¯increase in probability of passage due to P¡¯,
    v(J) ¡¯net habitat between J and its upstream neighbors¡¯,
    c(J,P) ¡¯cost of project P at J¡¯,
    b ¡¯available budget¡¯,
    pbar(J) ¡¯current probability of passage at J¡¯;

$gdxin data.gdx
*$gdxin datasmall.gdx
$load J,D,ROOT
$load pi,v,c,b,pbar
$gdxin

binary variables x(J,P);
positive variables z(J), y(J,P);
free variable habitatAvail;

equations
    def_obj "equation of objective function",
    eq_budget_lim "limit of available budget",
    eq_z_root(J) "equation of z(j) for root nodes",
    eq_z_nodes(J,K) "equation of z(j) for nodes further upstream",
    eq1_y(J,P) "equation 1 of trick for y",
    eq2_y(J,K,P) "equation 2 of trick for y",
    eq3_y(J,K,P) "equation 3 of trick for y",
    eq_single_proj(J) "only a kind of project can be chosen for each node J";

def_obj..
    habitatAvail =e= sum(J, v(J)*z(J));

eq_budget_lim..
    sum((J,P), x(J,P) * C(J,P)) =l= b;

eq_z_root(ROOT)..
    z(ROOT) =e= pbar(ROOT) + sum(P,pi(ROOT,P)*x(ROOT,P));

eq_z_nodes(D(J,K))..
    z(J) =e= pbar(J)*z(K) + sum(P,pi(J,P)*y(J,P));

eq1_y(J,P)$(not ROOT(J))..
    y(J,P) =l= x(J,P);

eq2_y(D(J,K),P)..
    y(J,P) =l= z(K);

eq3_y(D(J,K),P)..
    y(J,P) =g= z(K) - (1 - x(J,P));

eq_single_proj(J)..
    sum(P, x(J,P)) =e= 1;

option optcr=0;
model prob3 /all/;
solve prob3 using mip maximizing habitatAvail;
display habitatAvail.l;