set nationality /Brit, German, Norwegian, Dane, Swede/
    smoke /Blends, Dunhill, BlueMaster, PallMall, Prince/
    beverage/tea, beer, milk, water, coffee/
    color /yellow, red, green, white, blue/
    pet /dog, bird, cat, horse, fish/;
    
set h/1*5/;
set fishowner(nationality);

variables
col(h,color) 'color assignment'
nation(h,nationality) 'nationality assignment'
bev(h,beverage) 'beverage assignment'
cigar(h,smoke) 'cigar assignment'
pets(h,pet) 'pet assignment';
variable obj;

binary variables col,nation,bev,cigar,pets;

equations colconstr1(h)
          colconstr2(color)
          nationconstr1(h)
          nationconstr2(nationality)
          bevconstr1(h)
          bevconstr2(beverage)
          smokeconstr1(h)
          smokeconstr2(smoke)
          petconstr1(h)
          petconstr2(pet)
          hint1(h)
          hint2(h)
          hint3(h)
          hint4(h)
          hint5(h)
          hint6(h)
          hint7(h)
          hint10condi1(h)
          hint10condi2(h)
          hint10condi3(h)
          hint10condi4(h)
          hint10condi5
          hint10condi6
          hint11condi1(h)
          hint11condi2(h)
          hint11condi3(h)
          hint11condi4(h)
          hint11condi5
          hint11condi6
          hint12(h)
          hint13(h)
          hint14condi1(h)
          hint14condi2(h)
          hint14condi3(h)
          hint14condi4(h)
          hint14condi5
          hint14condi6
          hint15condi1(h)
          hint15condi2(h)
          hint15condi3(h)
          hint15condi4(h)
          hint15condi5
          hint15condi6
          objfunc;

colconstr1(h)..
  sum(color,col(h,color))=e=1;
  
colconstr2(color)..
  sum(h,col(h,color))=e=1;
  
nationconstr1(h)..
  sum(nationality,nation(h,nationality))=e=1;
  
nationconstr2(nationality)..
  sum(h,nation(h,nationality))=e=1;
  
bevconstr1(h)..
  sum(beverage,bev(h,beverage))=e=1;
  
bevconstr2(beverage)..
  sum(h,bev(h,beverage))=e=1;
  
smokeconstr1(h)..
  sum(smoke,cigar(h,smoke))=e=1;
  
smokeconstr2(smoke)..
  sum(h,cigar(h,smoke))=e=1;
  
petconstr1(h)..
  sum(pet,pets(h,pet))=e=1;
  
petconstr2(pet)..
  sum(h,pets(h,pet))=e=1;

hint1(h)..
  nation(h,'Brit') =e= col(h,'red');
  
hint2(h)..
  nation(h,'Swede') =e= pets(h,'dog');
  
hint3(h)..
  nation(h,'Dane') =e= bev(h,'tea');
  
hint4(h)$(ord(h)<card(h))..
  col(h,'green') =e= col(h+1,'white');
  
col.fx('1','white') = 0;

hint5(h)..
  col(h,'green') =e= bev(h,'coffee');
  
hint6(h)..
  cigar(h,'PallMall') =e= pets(h, 'bird');
  
hint7(h)..
  col(h,'yellow') =e= cigar(h, 'Dunhill');
  
bev.fx('3','milk') = 1;

nation.fx('1','Norwegian') = 1;

binary variable nextto1;
hint10condi1(h)$(ord(h)<card(h))..
  cigar(h,'Blends') =l= pets(h+1,'cat')+nextto1;
  
hint10condi2(h)$(ord(h)<card(h))..
  cigar(h,'Blends') =g= pets(h+1,'cat')-nextto1;
  
hint10condi3(h)$(ord(h)<card(h))..
  cigar(h+1,'Blends') =l= pets(h,'cat')+(1-nextto1);
  
hint10condi4(h)$(ord(h)<card(h))..
  cigar(h+1,'Blends') =g= pets(h,'cat')-(1-nextto1);
  
hint10condi5..
  cigar('5','Blends') =l= nextto1;
  
hint10condi6..
  pets('5','cat') =l= (1-nextto1);

* The man who keeps horses lives next to the man who smokes Dunhill.
binary variable nextto2;
hint11condi1(h)$(ord(h)<card(h))..
  cigar(h,'Dunhill') =l= pets(h+1,'horse')+nextto2;
  
hint11condi2(h)$(ord(h)<card(h))..
  cigar(h,'Dunhill') =g= pets(h+1,'horse')-nextto2;
  
hint11condi3(h)$(ord(h)<card(h))..
  cigar(h+1,'Dunhill') =l= pets(h,'horse')+(1-nextto2);
  
hint11condi4(h)$(ord(h)<card(h))..
  cigar(h+1,'Dunhill') =g= pets(h,'horse')-(1-nextto2);
  
hint11condi5..
  cigar('5','Dunhill') =l= nextto1;
  
hint11condi6..
  pets('5','horse') =l= 1-nextto1;

* The man who smokes Blue Master drinks beer.
hint12(h)..
  cigar(h,'BlueMaster') =e= bev(h,'beer');
  
* The German smokes Prince.
hint13(h)..
  nation(h,'German') =e= cigar(h, 'Prince');
  
* The Norwegian lives next to the blue house.
binary variable nextto3;
hint14condi1(h)$(ord(h)<card(h))..
  nation(h,'Norwegian') =l= col(h+1,'blue')+nextto3;
  
hint14condi2(h)$(ord(h)<card(h))..
  nation(h,'Norwegian') =g= col(h+1,'blue')-nextto3;
  
hint14condi3(h)$(ord(h)<card(h))..
  nation(h+1,'Norwegian') =l= col(h,'blue')+(1-nextto3);

hint14condi4(h)$(ord(h)<card(h))..
  nation(h+1,'Norwegian') =g= col(h,'blue')-(1-nextto3);
  
hint14condi5..
  nation('5','Norwegian') =l= nextto3;
  
hint14condi6..
  col('5','blue') =l= 1-nextto3;

* The man who smokes Blends has a neighbour who drinks water.
binary variable nextto4;

hint15condi1(h)$(ord(h)<card(h))..
  cigar(h,'Blends') =l= bev(h+1,'water')+nextto4;
  
hint15condi2(h)$(ord(h)<card(h))..
  cigar(h,'Blends') =g= bev(h+1,'water')-nextto4;
  
hint15condi3(h)$(ord(h)<card(h))..
  cigar(h+1,'Blends') =l= bev(h,'water')+(1-nextto4);
  
hint15condi4(h)$(ord(h)<card(h))..
  cigar(h+1,'Blends') =g= bev(h,'water')-(1-nextto4);
  
hint15condi5..
  cigar('5','Blends') =l= nextto4;
  
hint15condi6..
  bev('5','water') =l= 1-nextto4;

objfunc..
  obj=e=0;

model einstein /all/;
solve einstein using mip max obj;

fishowner(nationality) = yes$(sum(h$((nation.l(h,nationality) gt 0.9)and(pets.l(h,"fish") gt 0.9)),1));
display pets.l;
