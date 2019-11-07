Set groups /minority, nonminority/;
Set schools /Cooley, Whitman/;
Set districts /d1,d2,d3/;

table population(districts,groups)
    minority    nonminority
1   50          200
2   50          250
3   100         150;

parameter tot;
  tot = sum(groups,population(districts,groups));
  
display tot;