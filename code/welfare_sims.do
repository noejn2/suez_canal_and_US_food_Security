******************************************************************
** Noé J Nava, Ph.D. Student at ACE                     **********
** Regional Economics Applications Laboratory                 ****
** noejn2@illinois.edu                               *************
******************************************************************
*
** Please, contact author for distribution
*

clear all
cd "C:\Users\noejn2\OneDrive - University of Illinois - Urbana\Drive\Projects\suez_canal_and_US_food_Security"
cap set matsize 800
cap set matsize 11000
cap set maxvar 32000

use "data\interstate_foodFlows_2017.dta"
keep if year == "2017"
drop year
rename value trade

* Non-US regions
global cntry_list "Africa" "Canada" "Europe" "Eastern Asia" "Mexico" "Rest of Americas" "SE Asia & Oceania" "SW & Central Asia"

foreach cntry in "$cntry_list" {
	drop if orig == "`cntry'"
	drop if dest == "`cntry'"
}

* Theta = 2.468 based on "Who benefits from local agriculture? (Under review in the American Journal of Agricultural Economics) paper with William Ridley and Sandy Dall'Erba"

* beta is bilateral trade costs
gen beta = 0  /* No effect*/
gen A_hat = 1 /* No effect*/

replace trade = 1 if orig == dest & trade == 0

/* Scenario: California, Nevada, Utah, Arizona, New Mexico */
global drgth_list "Arizona" "California" "Nevada" "New Mexico" "Utah"
foreach cntry in "$drgth_list" {
	replace A_hat = .5 if orig == "`cntry'"
}
ge_gravity_tech orig dest trade beta, theta(2.468) gen_w(welfare) gen_X(trade) gen_rw(local_wages) a_hat(A_hat)

/* Creating U.S. dataset */
keep if orig == dest
rename orig state
* Assuming half intermediate inputs
replace welfare = welfare^(1/.5)

save "output/welfare.dta", replace
*end