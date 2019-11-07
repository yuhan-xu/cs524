$title hw3 hydro

* create a set of months
Set months/march,april/;

* create a set of dams
Set dams/A,B/;

positive variables resLev(months,dams),
                   water(months,dams),
                   spill(months,dams),
                   genPower(months,dams),
                   regular(months),
                   extra(months);
                   
free variable revenue "the amount of money General Eccentric receives";

* create a table stating the inflow to each dam in each month
table inflow(months,dams)
        A     B
march   200   40
april   130   15
;

parameters march1Level(dams)/"A" 1900,"B" 850/,
           conversion(dams)/"A" 400,"B" 200/,
           powerPlantCapacity(dams)/"A" 60000,"B" 35000/;
        

scalar  maxPowerUsageWithRegularPrice maximum power usage each month that pay 5 dollars per MWH /50000/
	    priceRegular price per MWH for power usage up to 50000MWH /5/
	    priceExtra price per MWH for power usage that exceeds 50000MWH /3.5/;
	  
* VARIBLE BOUNDS    
resLev.up(months,"A")=2000;
resLev.up(months,"B")=1500;
resLev.lo(months,"A")=1200;
resLev.lo(months,"B")=800;

equations powerBalance(months) "the sum of power usage below 50000 and extra usage over 50000 for each month should be the sum of total power generated for both dams in that month"
          balanceAmarch "for dam A, the total inflow should be equal to total outflow in march"
          balanceBmarch "for dam B, the total inflow should be equal to total outflow in march"
          balanceAapril "for dam A, the total inflow should be equal to total outflow in april"
          balanceBapril "for dam B, the total inflow should be equal to total outflow in april"
          maxPowerCapacity(months,dams) "max power capacity of the power plants that associate with each dam"
          balancePlant(months,dams) "power that created by water for each dam in each month should be the same as genPower of each dam in each month"
          objfunc;
          
* EQUATION (MODEL) DEFINITION  
powerBalance(months)..
  regular(months) + extra(months) =e= sum(dams,genPower(months,dams));

balanceAmarch..
  march1Level("A") + inflow("march","A") =e= resLev("march","A") + spill("march","A") + water("march","A");

balanceBmarch..
  march1Level("B") + inflow("march","B") + water("march","A") + spill("march","A") =e= resLev("march","B") + spill("march","B") + water("march","B");

balanceAapril..
  inflow("april","A") + resLev("march","A") =e= resLev("april","A") + spill("april","A")+water("april","A");

balanceBapril..
  inflow("april","B") + resLev("march","B") + water("april","A") + spill("april","A") =e= resLev("april","B") + spill("april","B") + water("april","B");

maxPowerCapacity(months,dams)..
  water(months,dams)*conversion(dams) =l= powerPlantCapacity(dams);

balancePlant(months,dams)..
  water(months,dams)*conversion(dams) =e= genPower(months,dams);

* Objective function  
objfunc..
  revenue =e= sum(months, priceRegular*regular(months))
		+ sum(months, priceExtra*extra(months)); 

* VARIBLE BOUNDS  		
regular.up(months) = maxPowerUsageWithRegularPrice;

model hydroplanning /all/;
solve hydroplanning using lp max revenue;

