$title Example: Ordering of one-dimensional sets and use of ord() and card()

* $onuellist

* define two wacko sets
set I / soccer, football /;
set K / 1*4, 25*29, me2you*me10you/;

parameter A(I), B(K);

scalar cardI, cardK;

* components of A and B set to the ord() of successive elements 
A(I) = ord(I);
B(K) = ord(K);

* show the sets
display I, K;

* check their cardinality
cardI = card(I);
cardK = card(K);
display cardI, cardK;

* check the ord()
display A, B;
