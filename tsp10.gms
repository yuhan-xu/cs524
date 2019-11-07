$title  TSP example

* This is for the 11 city example
set city /  Atlanta,Chicago,Denver,Houston,LosAngeles,Madison,Miami,NewYork,SanFrancisco,Seattle,WashingtonDC /;
alias(city,i,j,k);

table      dist(i,j)      "distances"
            Atlanta Chicago   Denver Houston LosAngeles Madison Miami NewYork SanFrancisco Seattle WashingtonDC
Atlanta      0       587     1212    701       1936       700    604     748      2139       2182     543
Chicago      587      0      920     940       1745       122   1188     713      1858       1737     597
Denver       1212     920     0      879        831       839   1726    1631       949       1021    1494
Houston      701     940     879      0        1372       978    968    1420      1645       1891    1220
LosAngeles   1936    1745    831     1374        0        1670  2339    2451       347        959    2300
Madison      700     122     839      978      1670        0    1303     808       1764      1618     706
Miami        604    1188    1726     968       2339       1303    0      1092      2594       2734    923
NewYork      748     713    1631     1420      2451        808  1092     0        2571       2408    205
SanFrancisco 2139   1858    949     1645       347        1764  2594    2571        0         678    2442
Seattle      2182    1737   1021    1891       959        1618  2734    2408       678         0     2329
WashingtonDC  543    597    1494    1220      2300         706   923      205      2442        2329    0 ;

$ontext
set city /A*E/;
alias(city,i,j);

table  dist(i,j)      "distances"
   A   B     C     D     E
A  0  6.1   4.0   17.0  16.8
B  0   0    7.6   13.5  11.3
C  0   0     0    22.0  17.3
D  0   0     0      0   12.1
E  0   0     0     0       0 ;


dist(i,j)$(ord(i)>ord(j)) = dist(j,i);
display dist;
$offtext


binary variables x(i,j);
free variable obj;

equations defobj, assign1(j), assign2(i);

defobj..
obj =e= sum((i,j), dist(i,j) * x(i,j));

assign1(j)..
sum(i$(not sameas(i,j)), x(i,j)) =e= 1;

assign2(i)..
sum(j$(not sameas(i,j)), x(i,j)) =e= 1;

x.fx(i,i) = 0;

set tour(i,i) ;
* Just print the tour in a simple way
option tour:0:0:1 ;

model tsp /defobj, assign1, assign2/;
solve tsp using mip min obj;
display obj.l;
tour(i,j)$(x.l(i,j) > 0.01) = yes ;
display tour;

* $exit

equations simpleloop(i,j);

simpleloop(i,j)$(not sameas(i,j))..
  x(i,j) + x(j,i) =L= 1;

tour(i,j) = no ;
model tsp2 /defobj, assign1, assign2, simpleloop /;
solve tsp2 using mip minimizing obj ;
display obj.l;
tour(i,j)$(x.l(i,j) > 0.01) = yes ;
display tour;

* $exit

equations triangle(i,j,k);

triangle(i,j,k)..
  x(i,j) + x(i,k) + x(j,k) + x(j,i) + x(k,i) + x(k,j) =L= 2 ;

tour(i,j) = no ;
model tsp3 /defobj, assign1, assign2, simpleloop, triangle /;
solve tsp3 using mip minimizing obj ;
display obj.l;
tour(i,j)$(x.l(i,j) > 0.01) = yes ;
display tour;

* $exit

positive variables u(i) ;
equations mtz(i,j);

* See Pataki Teaching IP paper in SIAM
mtz(i,j)$(ord(i) ne 1 and ord(j) ne 1)..
  u(i) - u(j) + 1 =L= (card(i) - 1) * (1 - x(i,j)) ;

model tsp4 /defobj, assign1, assign2, mtz/;

u.lo(i) = 2; u.up(i) = card(i);
u.fx(i)$(i.ord eq 1) = 1;

option optcr = 0;

solve tsp4 using mip minimizing obj ;
display obj.l;
tour(i,j) = no;
tour(i,j)$(x.l(i,j) > 0.01) = yes ;
display tour;
display u.L;
