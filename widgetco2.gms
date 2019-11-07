$title Practical Management Science (Example 4.4, pg 168)
$ontext
Widgetco is about to introduce a new product.  One unit of this
product is produced by assembling subassembly 1 and subassembly 2.
Before production begins on either subassembly, raw materials must be
purchased and workers must be trained. Before the subassemblies can be
assembled into the final product, the finished subassembly 2 must be
inspected.  The GAMS code that sets up this data is given below.

This example changes the data so there is non-unique critical path
$offtext

option limcol = 20, limrow = 20;

set activity /
    A "Train Workers",
    B "Purchase Raw Materials",
    C "Make Subassembly 1",
    D "Make Subassembly 2",
    E "Inspect Subassembly 2",
    F "Assemble Subassemblies" /;

alias (activity, I,J);

set pred(I,J) "I preceeds J" /
    (A,B) . C,
    (A,B) . D,
    D . E,
    (C,E) . F /;

parameter duration(I) /
    A   6
    B   9
    C   17
    D   7
    E   10
    F   12 /;

variables projDur;
positive variable t(I) "time activity starts";

equations incidence(I,J), endTime(I);

incidence(I,J)$pred(I,J)..
    t(J) =g= t(I) + duration(I);

endTime(I)..
    projDur =g= t(I) + duration(I);

model cpm /incidence,endTime/;

* option limrow = 0, limcol = 1000;
solve cpm using lp minimizing projDur;

* $exit

set critical(activity) "critical activities";

critical(activity) = yes$(smax(J$pred(J,activity),incidence.m(J,activity)) ge 1
            or smax(J$pred(activity,J),incidence.m(activity,J)) ge 1);




* Now let's set up the dual
positive variables
    lambda(I,J) "Dual var for incidence (critical arc)"
    pi(I)
;

free variable dual_obj;

equations
    projDur_dual_eq "Dual equation for projDur"
    teq(I)  "Equations for primal t vars"
    dual_obj_def
;

dual_obj_def..
    dual_obj =E= sum((I,J)$pred(I,J), lambda(I,J) * duration(I))
        + sum(I,duration(I)*pi(I));

projDur_dual_eq..
    sum(I, pi(I)) =E= 1;

teq(I)..
    -pi(I) - sum(J$pred(I,J), lambda(I,J)) + sum(J$pred(J,I), lambda(J,I)) =L= 0;


model dual_cpm /teq, projDur_dual_eq, dual_obj_def/;

solve dual_cpm using lp maximizing dual_obj;




display critical;
display incidence.m;

* now try to find early and late event times

parameter
    eeTime(activity) "early event time",
    leTime(activity) "late event time";

projDur.fx = projDur.l;

variables objective;
equations timeopt;

timeopt..
    objective =e= sum(activity,t(activity));

model eventtimes /timeopt,incidence,endTime/;

solve eventtimes using lp maximizing objective;
leTime(activity) = t.l(activity);
solve eventtimes using lp minimizing objective;
eeTime(activity) = t.l(activity);

critical(activity) = yes$(eeTime(activity) ge leTime(activity));

display eeTime,leTime,critical;

$exit

* now do this only solving the single LP

set firstdone(activity), next(activity);

eeTime(activity) = -inf;

firstdone(J) = yes$(sum(I$pred(I,J),1) eq 0);
eeTime(firstdone) = 0;

set iters /iter1*iter100/;

loop(iters$(card(firstdone) gt 0),
  next(I) = yes$sum(pred(firstdone,I),1);
  eeTime(next) = smax(pred(J,next), eeTime(J)+duration(J));
  firstdone(activity) = next(activity);
);

set lastdone(activity), prev(activity);

leTime(activity) = inf;

lastdone(I) = yes$(sum(J$pred(I,J),1) eq 0);
leTime(lastdone) = projDur.l-duration(lastdone);

loop(iters$(card(lastdone) gt 0),
  prev(I) = yes$sum(pred(I,lastdone),1);
  leTime(prev) = smin(pred(prev,J), leTime(J)-duration(prev));
  lastdone(activity) = prev(activity);
);

critical(activity) = yes$(eeTime(activity) ge leTime(activity));

display eeTime,leTime,critical;
