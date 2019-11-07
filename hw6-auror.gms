set district/1*8/;
alias(district,i,j);

table time(district,district)
  1  2  3  4  5  6  7  8
1    3  4  6  8  9  8  10
2 3     5  4  8  6  12 9
3 4  5     2  2  3  5  7
4 6  4  3     3  2  5  4
5 8  8  2  3     2  2  4
6 9  6  3  2  2     3  2
7 8  12 5  5  2  3     2
8 10 9  7  4  4  2  2;

binary variable auror(district);
binary variable seeAuror(district) "can see auror in that specific district";
variable numPeople "number of people who live within two seconds of an auror";

parameter population(district)/1 40, 2 30, 3 35, 4 20, 5 15, 6 50, 7 45, 8 60/;
parameter people(*);
parameter tobuild(*,district);

scalar N;

equations objfunc,firstconstr,secondconstr;

objfunc..
  numPeople =e= sum(district,seeAuror(district)*population(district));

firstconstr..
  sum(district,auror(district)) =e= N;
  
secondconstr(i)..
  sum(j$(time(i,j)le 2),auror(j)) =g= seeAuror(i);
  
model aurorProblem/all/;

N=1;
solve aurorProblem using mip maximizing numPeople;
people('1') = numPeople.l;
tobuild('1',district) = auror.l(district);

N=2;
solve aurorProblem using mip maximizing numPeople;
people('2') = numPeople.l;
tobuild('2',district) = auror.l(district);

N=3;
solve aurorProblem using mip maximizing numPeople;
people('3') = numPeople.l;
tobuild('3',district) = auror.l(district);

N=4;
solve aurorProblem using mip maximizing numPeople;
people('4') = numPeople.l;
tobuild('4',district) = auror.l(district);





