set I /1*5/;
alias(I, J);

binary variable x(I, J) "number of clicks for each cell";
integer variable d(I, J);

free variable turns "turns needed to turn out all the lights";

equations objfunc,firstconstr(I, J);

objfunc..
    turns =e= sum((I, J), x(I, J));

firstconstr(I, J)..
    x(I, J-1) + x(I, J+1) + x(I-1, J) + x(I+1, J) + x(I, J) =e= 2*d(I, J) + 1;

model threelights /all/;
solve threelights using mip minimizing turns;


integer variable y(I, J) "number of clicks for each cell";

equations
    objfunc1,
    highconst(I, J),
    mediumconst(I, J),
    lowconst(I, J);

objfunc1..
    turns =e= sum((I, J), y(I, J));

highconst(I, J)..
    y(I, J-1) + y(I, J+1) + y(I-1, J) + y(I, J) + y(I+1, J) =e= 4*d(I, J) + 1;

mediumconst(I, J)..
    y(I, J-1) + y(I, J+1) + y(I-1, J) + y(I, J) + y(I+1, J) =e= 4*d(I, J) + 2;

lowconst(I, J)..
    y(I, J-1) + y(I, J+1) + y(I-1, J) + y(I, J) + y(I+1, J) =e= 4*d(I, J) + 3;

option optcr=0;
set threeWay /high, medium, low/;
parameter totclicks(threeWay);

model threelights2high /objfunc1, highconst/;
solve threelights2high using mip minimizing turns;
totclicks("high") = turns.l;

model threelights2medium /objfunc1, mediumconst/;
solve threelights2medium using mip minimizing turns;
totclicks("medium") = turns.l;

model threelights2low /objfunc1, lowconst/;
solve threelights2low using mip minimizing turns;
totclicks("low") = turns.l;

display totclicks;
