sets
tube            /standard,high/,
size            /half,one,two,eight/,
wall            /thick,thin/,
p(tube,size,wall) "products",
m "mills"         /1*5/;
set i /"none", "4", "5"/;

p(tube,size,wall) = yes;

table c(tube,size,wall,m) "cost (in dollars) per 1000 pounds of p at m"
                        1    2    3    4    5
standard.half.thick    90   75   70   63   64
standard.half.thin     80   70   65   60   64
standard.one.thick    104   85   83   77   64
standard.one.thin      98   79   80   74   64
standard.two.thick    123  101  110   99   90
standard.two.thin     113   94  100   84  100
standard.eight.thick       160  156  140  160
standard.eight.thin        142  150  130  140
high.half.thick       140  110       122  110
high.half.thin        124   96       101  101
high.one.thick        160  133       138  134
high.one.thin         143  127       133  139
high.two.thick        202  150       160  150
high.two.thin         190  141       140  160
high.eight.thick           190       220  250
high.eight.thin            175       200  200;

table t(tube,size,wall,m) "time (in hours) per 1000 pounds of p at m"
                         1    2    3    4    5
standard.half.thick    0.8  0.7  0.5  0.6  0.6
standard.half.thin     0.8  0.7  0.5  0.6  0.6
standard.one.thick     0.8  0.7  0.5  0.6  0.6
standard.one.thin      0.8  0.7  0.5  0.6  0.6
standard.two.thick     0.8  0.7  0.5  0.6  0.6
standard.two.thin      0.8  0.7  0.5  0.6  0.6
standard.eight.thick        0.9  0.5  0.6  0.6
standard.eight.thin         0.9  0.5  0.6  0.6
high.half.thick        1.5  0.9       1.2  1.2
high.half.thin         1.5  0.9       1.2  1.2
high.one.thick         1.5  0.9       1.2  1.2
high.one.thin          1.5  0.9       1.2  1.2
high.two.thick         1.5  0.9       1.2  1.2
high.two.thin          1.5  0.9       1.2  1.2
high.eight.thick            1.0       1.5  1.5
high.eight.thin             1.0       1.5  1.5;

parameter d(tube,size,wall) "weekly demand in 1000 pounds for product"/
standard.half.thick  100, 
standard.half.thin   630, 
standard.one.thick   500, 
standard.one.thin    980, 
standard.two.thick   720, 
standard.two.thin    240, 
standard.eight.thick 75, 
standard.eight.thin  22,
high.half.thick      50, 
high.half.thin       22, 
high.one.thick       353, 
high.one.thin        55, 
high.two.thick       125, 
high.two.thin        35, 
high.eight.thick     100, 
high.eight.thin      10/;

parameter b(m) "mill m capacity (in hours)"
/1 800, 2 480, 3 1280, 4 960, 5 960/;

positive variable f(tube,size,wall,m);
free variable cost;

equations demands(tube,size,wall),time(m),objfunc;

demands(tube,size,wall)..
  sum(m,f(tube,size,wall,m)) =g= d(tube,size,wall);

time(m)..
  sum((tube,size,wall),t(tube,size,wall,m)*f(tube,size,wall,m)) =l= b(m);

objfunc..
  cost =e= sum((tube,size,wall,m),c(tube,size,wall,m)*f(tube,size,wall,m));
    
*f.up(tube,size,wall,m)$(c(tube,size,wall,m) = 0) = 0;
  
model tubprods /all/;

f.fx(p,'4') = 0;
f.fx(p,'5') = 0;

solve tubprods using lp min cost;

parameter soln(i);
soln("none") = cost.l;