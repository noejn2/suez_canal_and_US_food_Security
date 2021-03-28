******************************************************************
** Noé J Nava, Ph.D. Student at ACE                     **********
** Regional Economics Applications Laboratory                 ****
** noejn2@illinois.edu                               *************
******************************************************************
*
** Please, contact author for distribution
*

clear all
cd "[add working directory location]\suez_canal_and_US_food_Security"
cap set matsize 800
cap set matsize 11000
cap set maxvar 32000

use "data\interstate_foodFlows_2017.dta"
keep if year == "2017"
drop year
rename value trade

* Regions affecting the U.S.
global cntry_list "Eastern Asia" "SE Asia & Oceania" "SW & Central Asia"

* Theta = 2.468 based on "Who benefits from local agriculture? (Under review in the American Journal of Agricultural Economics) paper with William Ridley and Sandy Dall'Erba"

* beta is bilateral trade costs
gen beta = 0  /* No effect*/
gen A_hat = 1 /* No effect*/

replace trade = 1 if orig == dest & trade == 0

/* Scenario 1: Souz Canal doubles trade costs */
foreach cntry in "$cntry_list" {
	replace beta = -2.468*log(2) if orig == "`cntry'" & orig != dest
}
ge_gravity_tech orig dest trade beta, theta(2.468) gen_w(w_twofold) gen_X(trade) gen_rw(local_wages) a_hat(A_hat)

/* Scenario 2: Souz Canal trade costs are three-fold */
foreach cntry in "$cntry_list" {
	replace beta = -2.468*log(3) if orig == "`cntry'" & orig != dest
}
ge_gravity_tech orig dest trade beta, theta(2.468) gen_w(w_threefold) gen_X(trade) gen_rw(local_wages) a_hat(A_hat)

/* Scenario 3: Souz Canal trade costs are five-fold */
foreach cntry in "$cntry_list" {
	replace beta = -2.468*log(5) if orig == "`cntry'" & orig != dest
}
ge_gravity_tech orig dest trade beta, theta(2.468) gen_w(w_fivefold) gen_X(trade) gen_rw(local_wages) a_hat(A_hat)

/* Creating U.S. dataset */
keep if orig == dest
foreach cntry in "Africa" "Europe" "Mexico" "Rest of Americas" "Eastern Asia" "SE Asia & Oceania" "SW & Central Asia" "Canada" "Washington DC" {
	drop if orig == "`cntry'"
}
rename orig state
keep state w_twofold w_threefold w_fivefold
save "output/welfare.dta", replace
*end