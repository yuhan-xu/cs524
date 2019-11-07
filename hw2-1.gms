positive variables wheat,corn;
free variable pi;

equations
  landLimit "we have 45 acres of land max"
  workerLimit "there are only 100 workers available"
  fertilizerLimit "there are only 120 tons of fertilizer available"
  objfunc;

* EQUATION (MODEL) DEFINITION
landLimit..
  wheat + corn =l= 45;
  
workerLimit..
  3*wheat + 2*corn =l= 100;
  
fertilizerLimit..
  2*wheat + 4*corn =l= 120;
  
* Objective function  
objfunc..
  pi =e= 200*wheat + 300*corn;
  
model crop_planning /all/;

solve crop_planning using lp max pi;

display wheat.l,corn.l,pi.l;