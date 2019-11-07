Set cities /MSN,ORD,DTW,MSP,MCO, DCA, IAH, SFO/;
Set destinations(cities) /MCO, DCA, IAH, SFO/;
Set citiesNeededPass(cities) /ORD,DTW,MSP/;
Set x /Delta, United, noff/;
Set y(citiesNeededPass) /DTW,MSP/;

alias (cities,i,j);

parameter times(cities,cities) /MSN.ORD 27, MSN.DTW 52, MSN.MSP 46, MSP.SFO 216, MSP.IAH 146, MSP.DCA 118, MSP.MCO 163, ORD.SFO 246, ORD.IAH 131, ORD.DCA 83, ORD.MCO 130, DTW.SFO 275, DTW.IAH 154, DTW.DCA 64, DTW.MCO 127/;
parameters delayTimes(citiesNeededPass);

scalar
    trips /3/;

* define a dynamic set
set arc(cities,cities);
arc(i,j) = yes$(times(i,j) gt 0);

delayTimes("ORD") = uniform(0,2.5);
delayTimes("DTW") = uniform(0,1.5);
delayTimes("MSP") = uniform(0,2);
    
*variable eachTime(citiesNeededPass,destinations) 'time from msn to each mid and then to each dest';
positive variable flow(citiesNeededPass,destinations) 'the amount of travel times of each airline';
variable totalTime 'total time of airlines';

equations timeBalance, tripLimit(destinations);
timeBalance..
  sum((citiesNeededPass,destinations),(times("MSN", citiesNeededPass)+times(citiesNeededPass, destinations)+delayTimes(citiesNeededPass)) * flow(citiesNeededPass,destinations) ) =e= totalTime;
  
tripLimit(destinations)..
  sum(citiesNeededPass, flow(citiesNeededPass,destinations)) =e= trips;

model untied /all/;

parameter soln(x), midSoln(y);

* if choose United, the total time is the following
flow.fx("DTW",destinations) = 0;
flow.fx("MSP",destinations) = 0;
solve untied using lp min totalTime;
soln("United") = totalTime.l;

* if choose Delta, the total time is the following
flow.up("DTW",destinations) = inf;
flow.up("MSP",destinations) = inf;
flow.fx("ORD",destinations) = 0;
solve untied using lp min totalTime;
soln("Delta") = totalTime.l;