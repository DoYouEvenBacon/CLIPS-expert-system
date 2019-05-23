;Alan J. Tan
;atan574
;322945602

;atan574Rules.clp
;A CLIPS program that sees if you are hungry and decides where/what to eat based on location, time and money.

;Load this file in CLIPS (load "locationOfThisFile/atan574Rules.clp")
;Then run using (run)
;Reset using (reset) followed by (run) when the program ends/reaches a leaf and you wish to run the program again.


;Decision Tree layout
;Key: decision nodes: <>, action nodes: []	
;													 <checkHungry>, 
;											_______________|_____________
;											|							|
;									1 <checkAtHome>,				0 [notHungry]
;						____________________|________________________
;						|											|
;				1 <checkFoodInFridge>, 						0 <checkFarFromHome>
;			____________|________					        ________|_________________________________
;			|					|							|                                        |
;	1 [eatLeftovers], 0 <checkForNoodles>		1 [goHome (point to <foodInFridge>)], 0 <checkHaveFormOfPayment>
;							____|______________											_____________|______________________																	 |
;							|				  |											|								   |
;			------>	1 [makeNoodles], 0 [goToSupermarket]						1 <checkWantFastFood>, 0 [goHome (point to <foodInFridge>)]
;			|								  |									   ___________|_________
;			|								  |									   |                   |
;			|							<meatOnSpecial>						1 [goToFastFood], 0 [goToRestaurant]
;			|						__________|_________
;			|						|				   |
; 			|				1 [buyAndCookMeat], 0 [buyNoodles]
;			|__________________________________________|



;Rules

(defrule checkHungry =>
	(printout t "Are you hungry? 1=yes 0=no" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert(isHungry yes))
		else (assert(isHungry no))
	)
)

(defrule notHungry (isHungry no) =>
	(printout t "You aren't hungry. No need to get food yet." crlf)
)

(defrule checkAtHome (isHungry yes) =>
	(printout t "Are you at home? 1=yes 0=no" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert(atHome yes))
		else (assert(atHome no))
	)
)

(defrule checkFarFromHome (atHome no) =>
	(printout t "Are you within 30 minutes of home? 1=yes 0=no" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert(closeToHome yes)) (assert(atHome yes))
		(printout t "Go Home, you are close to Home." crlf)
		else (assert(closeToHome no))
	)
)

(defrule checkHaveFormOfPayment (closeToHome no) =>
	(printout t "Do you have cash or cards on you? 1=yes 0=no" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert(havePayment yes))
		else (assert(havePayment no)) (assert(atHome yes))
		(printout t "Go Home; you don't have any money on you." crlf)
	)
)

(defrule checkWantFastFood (havePayment yes) =>
	(printout t "Do you want Fast Food? 1=yes 0=no" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert(wantFastFood yes))
		else (assert(wantFastFood no))
	)
)

(defrule goToFastFood (wantFastFood yes) =>
	(printout t "Go to a Fast Food place." crlf)
)

(defrule goToRestaurant (wantFastFood no) =>
	(printout t "Go to a restaurant." crlf)
)

(defrule checkFoodInFridge (atHome yes) =>
	(printout t "Are there leftovers in the fridge? 1=yes 0=no" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert(existsLeftovers yes))
		else (assert(existsLeftovers no))
	)
)

(defrule eatLeftovers (existsLeftovers yes) =>
	(printout t "Heat up and eat the leftovers." crlf)
)

(defrule checkForNoodles (existsLeftovers no) =>
	(printout t "Are there instant noodles in the pantry? 1=yes 0=no" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert(existsNoodles yes))
		else (assert(existsNoodles no))
	)
)

(defrule goToSupermarket (existsNoodles no) =>
	(printout t "Go to the supermarket." crlf)
	(assert(atSupermarket yes))
)

(defrule meatOnSpecial (atSupermarket yes) =>
	(printout t "Are there any meats that are on special? 1=yes 0=no" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert(cheapMeat yes))
		else (assert(cheapMeat no))
	)	
)

(defrule buyAndCookMeat (cheapMeat yes) =>
	(printout t "Buy some cheap meat and cook it at home." crlf)
)

(defrule buyNoodles (cheapMeat no) =>
	(printout t "Meat is not on special; buy some instant noodles." crlf)
	(assert(existsNoodles yes))
)

(defrule makeNoodles (existsNoodles yes) =>
	(printout t "Boil some water and instant noodles in a pot." crlf)
)