$title Sailco: Winston and Albright, p.200

$ontext 

Sailco manufactures sailboats. During the next 4 months the company must
meet the following demands for their sailboats:

Month 1: 40
Month 2: 60
Month 3: 75
Month 4: 25

At the beginning of Month 1, Sailco has 10 boats in inventory. Each month
it must determine how many boats to produce. During any month, Sailco can
produce up to 40 boats with regular labor and an unlimited number of boats
with overtime labor. Boats produced with regular labor cost $400 each to
produce, while boats produced with overtime labor cost $450 each. It costs
$20 to hold a boat in inventory from one month to the next. Find the
production and inventory schedule that minimizes the cost of meeting the
next 4 months' demands on time.

Model as a network:

* One node per month, with given demand at each month.

* Inflow to each month node from a "regular labor" node, with capacity 40
* and cost 400

* Inflow to each month node from a "overtime labor" node, with unlimited
* capacity and cost 450

* month-to-month arcs representing inventory, with cost 20

* balance constraints applied only at month nodes.


$offtext

option limrow=100, limcol=0;

set months /month1 * month4/;

parameter demand(months) /month1 40, month2 60, month3 75, month4 25/;
parameter supply(months) 'External inventory supply' / month1 10 /;

scalar  maxRegularLabor maximum boats produced by regular labor per month /40/
	costRegular cost to build a boat with regular labor /400/
	costOvertime cost to build a boat with overtime labor /450/
	costInv cost to store a boat for one month /20/;

variables
	flowRegular(months)  boats produced by regular labor
	flowInventory(months)   inventory passed to next month
	flowOvertime(months)     boats produced by overtime labor
	cost                           total cost;

positive variable
  flowRegular, flowInventory, flowOvertime;

equations
  balance(months)  balance constraints at month nodes
  objective;

* demand = inventory flow in and out, plus labor flows in
* maybe better to think outflow = inflow (move flowInventory(months) to lhs)
balance(months)..
  demand(months) =e= supply(months) + flowInventory(months-1)
			   - flowInventory(months)
			   + flowRegular(months)
			   + flowOvertime(months);

* cost = inventory costs for first 3 months, plus regular and overtime
* labor costs
objective..
  cost =e= sum(months$(ord(months) < card(months)),
	                   costInv*flowInventory(months))
	        + sum(months, costRegular*flowRegular(months))
		+ sum(months, costOvertime*flowOvertime(months));

model sailco / balance,objective/;

* capacity constraint on regular labor arcs
flowRegular.up(months) = maxRegularLabor;

solve sailco using lp min cost;

display flowInventory.l,  flowRegular.l, flowOvertime.l;

$onecho > cplex.opt
lpmethod 3
netfind 1
preind 0
names no
$offecho
