$title Random Shortest Path Example: Multiple Instances (short2.gms)

option limrow=0, limcol=0, solprint=off;

maxexecerror = 100 ;

set iter/iter1*iter100/;

scalar
       density/.01/
       successful/0/
       averageLength/0/
       proportionOfSuccess;

set
    nodes /1*1000/;

alias (nodes,i,j,k);

set arcs(i,j);
parameter distance(i,j), supply(nodes);

variables f(i,j), shortestPathLength;
positive variable f;

* fix source and destination nodes
supply('1') = 1;
supply('1000') = -1;

equations balance(i), objective;

balance(i)..
    sum(arcs(i,k), f(arcs)) - sum(arcs(j,i), f(arcs)) =e= supply(i);
objective..
    shortestPathLength =e= sum(arcs, distance(arcs)*f(arcs));

model short/balance, objective/;

option seed=25671;
loop(iter,
    arcs(i,j) = yes$(uniform(0,1) < density);
    arcs(i,i) = no;
    distance(arcs) = uniform(1,10);
    solve short using lp minimizing shortestPathLength;
    if(short.modelstat < 2,
       successful = successful+1;
       averageLength = averageLength + shortestPathLength.l;
    );
);

averageLength = (averageLength / successful)$(successful > 0);
proportionOfSuccess = successful / card(iter);

option averageLength:8;
display "Arc Density ", density;
display "Proportion of Successful Paths: ", proportionOfSuccess;
display "Average length of Successful Paths: ", averageLength;




