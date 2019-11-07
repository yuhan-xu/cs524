option seed=0; set nodes /1*500/;
parameter offset(nodes); offset(nodes) = round(uniform(2,5));

alias (i,j,nodes); set arcs(nodes,nodes);
arcs(i,j) = no; arcs(i,i+1) = yes; arcs(i,i+offset(i)) = yes;

set k /1*3/;
parameter demand(nodes,k) /
  1.1 -70, 6.1 70, 3.2 -25, 500.2 25, 4.3 -20, 8.3 20, 54.1 -70, 55.1 70
  23.2 -25, 89.2 25, 10.3 -20, 89.3 20, 20.3 -10, 450.3 10 /;

parameter capacity(i,j); capacity(i,j) = uniform(75,85);

set breakpoint /1*4/;
alias(breakpoint,b);

parameters
    x(b) "value of breakpoint on x-axis for log function" /"1" 0, "2" 5, "3" 10, "4" 100/,
    f(b) "value of breakpoint on y-axis for log function";

f(b) = log(x(b)+1);

positive variables
    flow(i,j,k) "flow of kth commodity on arcs(i,j)",
    lambda(i,j,b) "bth lambda value on arcs(i,j)";
binary variable y(i,j,b) "y value used for lambda";
free variable totcost "total cost";

equations
    def_obj "objective function",
    eq_flow_lambda(i,j) "relationship between flow and lambda on each arcs",
    eq_lambda_lim(i,j) "limit of the sum of lambda on each arcs",
    eq_capacity_lim(i,j) "limit of capacity on each arcs",
    eq_demand_req(nodes,k) "demand requirement kth commodity for each node",
    eq1_lambda_y(i,j) "relationship between lambda and y",
    eq2_lambda_y(i,j,b),
    eq3_lambda_y(i,j),
    eq_y_sum(i,j) "limit of sum of y";

def_obj..
    totcost =e= sum((arcs,b), lambda(arcs,b)*f(b));

eq_flow_lambda(arcs)..
    sum(k, flow(arcs,k)) =e= sum(b, x(b)*lambda(arcs,b));

eq_lambda_lim(arcs)..
    sum(b, lambda(arcs,b)) =e= 1;

eq_capacity_lim(arcs)..
    sum(k, flow(arcs,k)) =l= capacity(arcs);

* all the flow going into the node minus all the flow coming out from the node
* equals demand of the node for kth commodity
eq_demand_req(nodes,k)..
    sum(arcs(i,nodes), flow(i,nodes,k)) - sum(arcs(nodes,j), flow(nodes,j,k)) =e= demand(nodes,k);

eq1_lambda_y(arcs)..
    lambda(arcs,"1") =l= y(arcs,"1");

eq2_lambda_y(arcs,b)$(ord(b) > 1 and ord(b) < card(b))..
    lambda(arcs,b) =l= y(arcs,b-1) + y(arcs,b);

eq3_lambda_y(arcs)..
    lambda(arcs,"4") =l= y(arcs,"3");

eq_y_sum(arcs)..
    sum(b$(ord(b) ne card(b)), y(arcs,b)) =e= 1;

lambda.lo(i,j,b) = 0;
lambda.up(i,j,b) = 1;

option optcr = 0.02;
option mip = gurobi;
model prob4 /all/;
solve prob4 using mip minimizing totcost;