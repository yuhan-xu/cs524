$title hw3 blending

* create a set of crude oils 1-3
Set I /crude1,crude2,crude3/;

* create a set of gasoline, gas1-gas3
Set J /gas1,gas2,gas3/;

positive variables x(I,J);
  
free variable profit "daily profit";
  
parameters
  octane(I)/"crude1" 12,"crude2" 6,"crude3" 8/,
  sulfur(I)/"crude1" 0.5,"crude2" 2,"crude3" 3/,
  revenue(J)/"gas1" 70,"gas2" 60,"gas3" 50/,
  cost(I)/"crude1" 45,"crude2" 35,"crude3" 25/,
  demand(J)/"gas1" 3000,"gas2" 200,"gas3" 1000/;

* create a scalar crudeOilLimit indicating that Sunco can purchase up to 5000 barrels of each type of crude oil
scalar crudeOilLimit,transformCost;
       crudeOilLimit = 5000;
       transformCost = 4;


equations lowerBoundOfGas(J)   "the lower bound of each type of gases that need to be produced which is the demand of that type of gas"
          upperBoundOfCrude(I) "the upper bound of each crude oil"
          gasolineLimit        "the company can produce up to 14000 barrels of gasoline totally"
          octaneGas1           "overall octane level of gas1"
          octaneGas2           "overall octane level of gas2"
          octaneGas3           "overall octane level of gas3"
          sulfurGas1           "overall sulfur level of gas1"
          sulfurGas2           "overall sulfur level of gas2"
          sulfurGas3           "overall sulfur level of gas3"
          objfunc;
        
* EQUATION (MODEL) DEFINITION  
lowerBoundOfGas(J)..
  sum(I,x(I,J)) =g= demand(J);
  
upperBoundOfCrude(I)..
  sum(J,x(I,J)) =l= crudeOilLimit;

gasolineLimit..
  sum(I,sum(J,x(I,J))) =l= 14000;
  
octaneGas1..
  sum(I,octane(I)*x(I,"gas1")) =g= 10*sum(I,x(I,"gas1"));
  
octaneGas2..
  sum(I,octane(I)*x(I,"gas2")) =g= 8*sum(I,x(I,"gas2"));
  
octaneGas3..
  sum(I,octane(I)*x(I,"gas3")) =g= 6*sum(I,x(I,"gas3"));
  
sulfurGas1..
  sum(I,sulfur(I)*x(I,"gas1")) =l= 1*sum(I,x(I,"gas1"));

sulfurGas2..
  sum(I,sulfur(I)*x(I,"gas2")) =l= 2*sum(I,x(I,"gas2"));

sulfurGas3..
  sum(I,sulfur(I)*x(I,"gas3")) =l= 1*sum(I,x(I,"gas3"));

* Objective function    
objfunc..
  profit =e= sum(J,sum(I,x(I,J)*revenue(J))) - (sum(J,sum(I,x(I,J)*cost(I)))) - (transformCost*sum(J,sum(I,x(I,J))));

model blending /all/;

solve blending using lp max profit;
