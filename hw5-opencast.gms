Set block/1*18/;
Set level1(block)/1*8/;
Set level2(block)/10*13/;
Set level3(block)/17/;
Set quartz(block)/9,14,15,16,18/;
Set uranium(block)/1,7,10,12,17,18/;

alias(block,I,J);
Set pred(I,J)/
   (1*3) . 9
   (2*4) . 10
   (3*5) . 11
   (4*6) . 12
   (5*7) . 13
   (6*8) . 14
   (9*11) . 15
   (10*12) . 16
   (11*13) . 17
   (12*14) . 18/;

parameter cost1(level1)/1 100,2 100,3 100,4 100,5 100,6 100,7 100,8 100/;
parameter cost2(level2)/10 200,11 200,12 200,13 200/;
parameter cost3(level3)/17 300/;
parameter cost4(quartz)/9 1000,14 1000,15 1000,16 1000,18 1000/;
parameter marketValue(uranium)/1 200, 7 300, 10 500, 12 200, 17 1000,18 1200/;

scalar tonnes/10000/;

binary variable extract(block);
variable totprofit "total benefit";

equations extractMatch(I,J),objfunc;

extractMatch(I,J)$pred(I,J)..
  extract(J) =l= extract(I);
    
objfunc..
  totprofit =e= sum(uranium,extract(uranium)*marketValue(uranium)*tonnes) - sum(level1,extract(level1)*cost1(level1)*tonnes) - sum(level2,extract(level2)*cost2(level2)*tonnes) - sum(level3,extract(level3)*cost3(level3)*tonnes) - sum(quartz,extract(quartz)*cost4(quartz)*tonnes);
  
model opencast/all/;

solve opencast using mip max totprofit;
   

        

