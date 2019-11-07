set i /1*10/;
alias(i,j);

table clean(i,j)
   1  2  3  4  5  6  7  8   9  10
1     11 7  13 11 12 4  9   7  11
2  5     13 15 15 6  8  10  9   8
3  13 15    23 11 11 16 18  5   7
4  9  13 5     3  8  10 12 14   5
5  3  7  7  7     9  10 11 12  13
6  10 6  3  4  14    8  5  11  12
7  4  6  7  3  13 7     10  4   6
8  7  8  9  9  12 11 10    10   9
9  9  14 8  4  9  6  10 8      12
10 11 17 11 6  10 4  7  9  11
;

parameter dur(i) /1 40, 2 35, 3 45, 4 32, 5 50, 6 42, 7 44, 8 30, 9 33, 10 55 /;

binary variables x(i,j);
free variable obj;

equations defobj, assign1(j), assign2(i);

defobj..
  obj =e= sum((i,j), clean(i,j) * x(i,j)) + sum(i,dur(i));

assign1(j)..
  sum(i$(not sameas(i,j)), x(i,j)) =e= 1;

assign2(i)..
  sum(j$(not sameas(i,j)), x(i,j)) =e= 1;

x.fx(i,i) = 0;

set tour(i,i) ;
* Just print the tour in a simple way
option tour:0:0:1 ;

positive variables y(i) ;
equations mtz(i,j);

mtz(i,j)$(ord(i) ne 1 and ord(j) ne 1)..
  y(i) - y(j) + 1 =L= (card(i) - 1) * (1 - x(i,j)) ;

model tsp4 /defobj, assign1, assign2, mtz/;

y.lo(i) = 2; y.up(i) = card(i);
y.fx(i)$(i.ord eq 1) = 1;

option optcr = 0;

solve tsp4 using mip minimizing obj ;
display obj.l;
tour(i,j) = no;
tour(i,j)$(x.l(i,j) > 0.01) = yes ;
display tour;
display y.L;

parameters batchlength,order;
batchlength = obj.l;

set iter/1*10/;
loop(iter,
     order(iter) = smax(i,ord(i)$(y.l(i) eq ord(iter)));
);





