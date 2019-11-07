set people /1*20/,
    month /feb,mar,apr,may,jun,jul,aug,sep/;
    
alias (people,p1,p2);
alias (month,m1,m2);
    
set arc(p1,m1,p2,m2);
parameter demand(month) /feb 3,mar 4,apr 6,may 7,jun 4,jul 6,aug 2,sep 3/,
          supply(p1,m1) /3.feb 1, 3.sep -1/,
          cost(p1,m1,p2,m2);

scalar redeployCharge /160/, addCharge /100/, surplusCharge /200/, shortageCharge /200/;

arc(p1,m1,p2,m2)$((ord(m2)-ord(m1)=1)) = yes;
arc(p1,m1,p2,m2)$(ord(m1)=1 and not ord(p1)=3) = no;
arc(p1,m1,p2,m2)$(ord(m2)=card(m2) and not ord(p2)=3) = no;

arc(p1,m1,p2,m2)$((ord(m2)-ord(m1)=1) and abs(ord(p2)-ord(p1))>3) = no;
arc(p1,m1,p2,m2)$((ord(m2)-ord(m1)=1) and ord(p1)-ord(p2) > ord(p1)/3) = no;
arc(p1,m1,p2,m2)$((ord(m2)-ord(m1)=1) and demand(m1)-ord(p1) > demand(m1)/4) = no;

cost(p1,m1,p2,m2) = 9999;
cost(p1,m1,p2,m2)$arc(p1, m1, p2, m2) = addCharge*(ord(p2)-ord(p1))$(ord(p2)-ord(p1)>0) +redeployCharge*(ord(p1)-ord(p2))$(ord(p1)-ord(p2)>0)+ surplusCharge*(demand(m2)-ord(p2))$(demand(m2)-ord(p2)>0)+shortageCharge*(ord(p2)-demand(m2))$(demand(m2)-ord(p2)<0);

variable totalCost;
positive variable flow(p1,m1,p2,m2);

equations demandBalance(p1,m1),objfunc;

demandBalance(p1,m1)..
    sum((p2,m2),flow(p1,m1,p2,m2)) - sum((p2,m2),flow(p2,m2,p1,m1)) =e= supply(p1,m1);
   
objfunc..
    totalCost =e= sum((p1,m1,p2,m2), flow(p1,m1,p2,m2) * cost(p1,m1,p2,m2));

model personnel /all/;

solve personnel minimizing totalCost using lp;