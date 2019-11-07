$ondollar title hw2-advert

positive variables tv "number of minutes of TV", magazine "number of magazine pages", radio "number of minutes of radio advertising";
Set I /tv,magazine,radio/;
positive variable spend(I);
free variable z "number of audience";
parameters
  costs(I)/"tv" 20000, "magazine" 10000, "radio" 2000/
  audience(I)/"tv" 1.8, "magazine" 1, "radio" 0.25/
  weeks(I)/"tv" 1, "magazine" 3, "radio" [1/7]/;

equations firstconstr,secondconstr,thirdconstr,fourthconstr, objfunc;


firstconstr..
  sum(I,costs(I)*spend(I)) =l= 1000000;
  
secondconstr..
  spend("tv") =g= 10;
  
thirdconstr..
  sum(I,weeks(I)*spend(I)) =l= 100;
  
fourthconstr..
  spend("magazine") =g= 2;
  
spend.up("radio") = 120;
  
objfunc..
  z =e= sum(I,audience(I)*spend(I));

model advert /all/;

solve advert using lp max z;