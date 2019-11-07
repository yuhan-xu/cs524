Set I/wineGlasses,beerGlasses,champagneGlasses,whiskeyGlasses/;
positive variable x(I);
Set data/moldingTime,packagingTime,glass/;
free variable revenue "total revenue";

table a(data,I)
                wineGlasses  beerGlasses  champagneGlasses  whiskeyGlasses
moldingTime     4            9            7                 10
packagingTime   1            1            3                 40
glass           3            4            2                 1;

parameter sellingPrice(I)/wineGlasses 6,beerGlasses 10,champagneGlasses 9,whiskeyGlasses 20/;
parameter maxTime(data)/moldingTime 600,packagingTime 400,glass 500/;
           
equations limitTimes(data), objfunc;

limitTimes(data)..
  sum(I,a(data,I)*x(I)) =l= maxTime(data);
  
objfunc..
  revenue =e= sum(I,sellingPrice(I)*x(I));
  
model glassco /all/;
solve glassco using lp max revenue;
display x.l;

positive variable y(data);
variable w_star;

equations limitPrice(I),dualobjective;

dualobjective..
    sum(data,maxTime(data)*y(data)) =e= w_star;
    
limitPrice(I)..
    sum(data,a(data,I)*y(data)) =g= sellingPrice(I);

model dualglassco /limitPrice, dualobjective/;

solve dualglassco using lp min w_star;