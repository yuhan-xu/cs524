set activity /
        A "Find Site",
        B "Find Engineers",
        C "Hire Opening Act",
        D "Set Radio and TV Ads",
        E "Set Up Ticket Agents",
        F "Prepare Electronics",
        G "Print Advertising",
        H "Set up Transportation",
        I "Rehearsals",
        J "Last-Minute Details"
/;

alias (activity,ai,aj);

set pred(ai,aj) "ai preceeds aj" /
        A. (B,C,E) 
        B . F
        C . (D,G,H)
        (F,H) . I
        I . J
/;

parameter duration(activity) "in days" /
        A       3,      B       2
        C       6,      D       2
        E       3,      F       3
        G       5,      H       1
        I       1.5,    J       2
/;

variables projDur;
positive variable t(ai) "time activity starts";

equations incidence(ai,aj), endTime(ai);

incidence(ai,aj)$pred(ai,aj)..
    t(aj) =g= t(ai) + duration(ai);

endTime(ai)..
    projDur =g= t(ai) + duration(ai);

model rockc /all/;

* option limrow = 0, limcol = 1000;
solve rockc using lp minimizing projDur;

set critical(activity) "critical activities";

critical(activity) = yes$(smax(aj$pred(aj,activity),incidence.m(aj,activity)) ge 1
            or smax(aj$pred(activity,aj),incidence.m(activity,aj)) ge 1);


* First method
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

* Second method
Set firstdone(activity),next(activity);
eeTime(activity) = -inf;

firstdone(aj)= yes$(sum(ai$pred(ai,aj),1) eq 0);
eeTime(firstdone) = 0;

set iters /iter1*iter100/;

loop(iters$(card(firstdone) gt 0),
  next(ai) = yes$sum(pred(firstdone,ai),1);
  eeTime(next) = smax(pred(aj,next), eeTime(aj)+duration(aj));
  firstdone(activity) = next(activity);
);

Set lastdone(activity), prev(activity);

leTime(activity) = inf;

lastdone(ai) = yes$(sum(aj$pred(ai,aj),1) eq 0);
leTime(lastdone) = projDur.l - duration(lastdone);

loop(iters$(card(lastdone) gt 0),
  prev(ai) = yes$sum(pred(ai,lastdone),1);
  leTime(prev) = smin(pred(prev,aj), leTime(aj)-duration(prev));
  lastdone(activity) = prev(activity);
);

critical(activity) = yes$(eeTime(activity) ge leTime(activity));

