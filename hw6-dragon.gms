set Legs/1-2,2-3,3-4,4-5/;
set transportations/train,portkey,thestral/;

table cost(transportations,Legs)
          1-2  2-3  3-4  4-5
train     30   25   40   60
portkey   25   40   45   50
thestral  40   20   50   45;

table switch(transportations,transportations)
          train  portkey  thestral
train     0      5        12
portkey   8      0        10
thestral  15     10       0;

alias (transportations,tran1,tran2);

scalar numDragon/20/;
binary variable x(Legs, transportations), change(tran1,tran2,Legs);
variable totalCost;

equations objfunc,limit(Legs),change_eq,eq1,eq2;

objfunc..
    totalCost =e= sum((Legs,transportations),x(Legs,transportations)*numDragon*cost(transportations, Legs)) + sum((tran1,tran2,Legs), numDragon*change(tran1,tran2,Legs)*switch(tran1, tran2) );
 
limit(Legs)..   
    1 =e= sum(transportations, x(Legs,transportations));
    
change_eq(Legs)..
    sum((tran1,tran2), change(tran1,tran2,Legs) ) =e= 1;
    
eq1(tran2, Legs)..
    sum(tran1, change(tran1,tran2,Legs)) =g= x(Legs,tran2);
    
eq2(Legs,tran1)$(ord(Legs)<4)..
    sum(tran2, change(tran1,tran2,Legs + 1)) =g= x(Legs,tran1);
    

model dragon /all/;

solve dragon using mip minimizing totalCost;

display totalCost.l;



