******************************************************************
** Noé J Nava, Ph.D. Student at ACE                     **********
** Regional Economics Applications Laboratory                 ****
** noejn2@illinois.edu                               *************
******************************************************************
*
** Please, contact author for distribution
*

clear all
cd "C:\Users\nnrno\OneDrive - University of Illinois - Urbana\Drive\Projects\suez_canal_and_US_food_Security"
cap set matsize 800
cap set matsize 11000
cap set maxvar 32000

use "data\interstate_foodFlows_2017.dta"
keep if year == "2017"
drop year
rename value trade

* Regions affecting the U.S.
global foreign_list "Africa" "Canada" "Europe" "Mexico" "Rest of Americas" "Eastern Asia" "SE Asia & Oceania" "SW & Central Asia"
foreach foreign in "$foreign_list" {
	drop if orig == "`foreign'"
	drop if dest == "`foreign'"
}

* Theta = 2.468 based on "Who benefits from local agriculture? (Under review in the American Journal of Agricultural Economics) paper with William Ridley and Sandy Dall'Erba"

* beta is bilateral trade costs
gen beta = 0  /* No effect*/
gen A_hat = 1 /* No effect*/

/* Scenario 1: Souz Canal doubles trade costs */
replace beta = -2.468*log(.95)
ge_gravity_tech orig dest trade beta, theta(2.468) gen_w(infra_welfare) gen_X(trade) gen_rw(local_wages) a_hat(A_hat)

rename orig state
keep state infra_welfare
save "output/welfare.dta", replace
*end