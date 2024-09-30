* This file estimates the impact of cumulative/stacked policies on
* the share of renewable energy CAPACITY 

*  KEY:  RENEWABLE POLICIES ONLY (all policies and SECTORAL POLICIES ONLY done separately)
* KEY CHANGE MADE IN LINE 33


set more 1

use "U:\Climate Policy Diffusion\total electricity capacity by source.dta", clear

sort state year

drop if year<1980
drop if year>2020
drop if state=="DISTRICT OF COLUMBIA"
drop if stateabbr=="US"
drop if stateabbr=="PR"

encode stateabbr, generate(newv1)
rename stateabbr old_stateabbr
rename newv1 stateabbr

replace solar=0 if solar==.
replace wind=0 if wind==.
replace hydro=0 if hydro==.
replace coal=0 if coal==.
replace ngas=0 if ngas==.


*RENEWABLE DEFINITION -- THIS LINE TO BE CHANGED AS WE ESTIMATE HYDRO VS. SOLAR VS. WIND VS. ALL RENEWABLES

generate renewable2 = ((solar)/totalelectricindustry)*100

**# ESTIMATING DIFFERENCES IN LEVELS
sort state year
bysort state: gen levelchangerenew=renewable2 -renewable2[_n-1]
replace renewable2=levelchangerenew


expand 11

sort state year
destring stateabbr, replace
save "U:\Climate Policy Diffusion\total electricity capacity by source_expanded.dta", replace 

* USing Manuel's transformed --- stacked, cumulative --- data
use "U:\Climate Policy Diffusion\data_all_transformed.dta", clear

drop if year<1991
drop if year>2020
drop if state=="DISTRICT OF COLUMBIA"

encode state_policy_fe, generate(newv1)
rename state_policy_fe old_state_policy_fe
rename newv1 state_policy_fe

encode year_policy_fe, generate(newv1)
rename year_policy_fe old_year_policy_fe
rename newv1 year_policy_fe

encode stateabbr, generate(newv1)
rename stateabbr old_stateabbr
rename newv1 stateabbr

xtset stateabbr


* CREATE LAGGED POLICIES
sort stateabbr year
bysort stateabbr: gen policylag1=policy[_n-1]
bysort stateabbr: gen policylag2=policy[_n-2]
bysort stateabbr: gen policylag3=policy[_n-3] 
bysort stateabbr: gen policylag5=policy[_n-5] 
bysort stateabbr: gen policylag10=policy[_n-10] 



* KEEP ONLY RENEWABLE POLICYES AND ENERGY POLICIES FROM CATEGORY A. thESE ARE THE ONES THAT SHOULD MATTER FOR SOLAR/WIND/HYDRO
 
**          REMEMBER TO CHANGE EXPAND 23 TO EXPAND 15 (only 11 of the 15 in the data in the data so expand 11) **


keep if policy_type=="netmeter_yearadopted_21" | policy_type=="fgd_21" | policy_type=="w_mgpo_21" | policy_type=="community_solar" | policy_type=="w4_environment_state_rps_21" | policy_type=="w_Environment_Solar_TaxCredit_21" |  policy_type=="w4_gas_decoupling_21" | policy_type=="w4_electric_decoupling_21"  | policy_type=="w_ee_21"  | policy_type=="w_low_income_ee_21"   |      policy_type=="pace_21"
*/


*/


/* not in the data:
policy_type=="x_eers" 
| policy_type=="environment_publicbenefit_funds_"
policy_type=="environment_utility_deregulation"  |
policy_type=="x_RPS_targets_bindingonly" | 
*/

**** MERGING IN THE RENEWABLE DATA FROM IEA see Gregor EMAIL JAN 26
sort state year
drop if year<1991
merge m:m state year using "U:\Climate Policy Diffusion\total electricity capacity by source_expanded.dta"


drop _merge
sort state year


*** MERGE PRICE DATA

merge m:1 year using "U:\Climate Policy Diffusion\coalandngprice.dta"
drop _merge
gen relprice=coalprice/ngprice
*/

gen miningtransgdpshare = mininggdpshare + transutilgdpshare
replace miningtransgdpshare = mininggdpshare



*NO LAGS TO POLICIES**

xtreg  renewable2  policy  i.stateabbr i.year, robust 
* This file estimates the impact of cumulative/stacked policies on
* the share of renewable energy CAPACITY 

*  KEY:  RENEWABLE POLICIES ONLY (all policies and SECTORAL POLICIES ONLY done separately)


set more 1

use "U:\Climate Policy Diffusion\total electricity capacity by source.dta", clear

sort state year

drop if year<1980
drop if year>2020
drop if state=="DISTRICT OF COLUMBIA"
drop if stateabbr=="US"
drop if stateabbr=="PR"

encode stateabbr, generate(newv1)
rename stateabbr old_stateabbr
rename newv1 stateabbr

replace solar=0 if solar==.
replace wind=0 if wind==.
replace hydro=0 if hydro==.
replace coal=0 if coal==.
replace ngas=0 if ngas==.


*RENEWABLE DEFINITION -- THIS LINE TO BE CHANGED AS WE ESTIMATE HYDRO VS. SOLAR VS. WIND VS. ALL RENEWABLES

generate renewable2 = ((solar)/totalelectricindustry)*100

**# ESTIMATING DIFFERENCES IN LEVELS
sort state year
bysort state: gen levelchangerenew=renewable2 -renewable2[_n-1]
replace renewable2=levelchangerenew


expand 11

sort state year
destring stateabbr, replace
save "U:\Climate Policy Diffusion\total electricity capacity by source_expanded.dta", replace 

* USing Manuel's transformed --- stacked, cumulative --- data
use "U:\Climate Policy Diffusion\data_all_transformed.dta", clear

drop if year<1991
drop if year>2020
drop if state=="DISTRICT OF COLUMBIA"

encode state_policy_fe, generate(newv1)
rename state_policy_fe old_state_policy_fe
rename newv1 state_policy_fe

encode year_policy_fe, generate(newv1)
rename year_policy_fe old_year_policy_fe
rename newv1 year_policy_fe

encode stateabbr, generate(newv1)
rename stateabbr old_stateabbr
rename newv1 stateabbr

xtset stateabbr


* CREATE LAGGED POLICIES
sort stateabbr year
bysort stateabbr: gen policylag1=policy[_n-1]
bysort stateabbr: gen policylag2=policy[_n-2]
bysort stateabbr: gen policylag3=policy[_n-3] 
bysort stateabbr: gen policylag5=policy[_n-5] 
bysort stateabbr: gen policylag10=policy[_n-10] 



* KEEP ONLY RENEWABLE POLICYES AND ENERGY POLICIES FROM CATEGORY A. thESE ARE THE ONES THAT SHOULD MATTER FOR SOLAR/WIND/HYDRO
 
**          REMEMBER TO CHANGE EXPAND 23 TO EXPAND 15 (only 11 in the data) **


keep if policy_type=="netmeter_yearadopted_21" | policy_type=="fgd_21" | policy_type=="w_mgpo_21" | policy_type=="community_solar" | policy_type=="w4_environment_state_rps_21" | policy_type=="w_Environment_Solar_TaxCredit_21" |  policy_type=="w4_gas_decoupling_21" | policy_type=="w4_electric_decoupling_21"  | policy_type=="w_ee_21"  | policy_type=="w_low_income_ee_21"   |      policy_type=="pace_21"
*/


*/


/* not in the data:
policy_type=="x_eers" 
| policy_type=="environment_publicbenefit_funds_"
policy_type=="environment_utility_deregulation"  |
policy_type=="x_RPS_targets_bindingonly" | 
*/


*** KEEP ONLY SECTORAL AND GHG POLICIES, FROM CATEGORY A. THESE * ARE ONES THAT SHOULD NOT MATTER FOR SOLAR, WIND, HYDRO


**          REMEMBER TO CHANGE EXPAND 23 TO EXPAND 10 (only 8 in the data)**

/*
keep if policy_type=="climate_action_plan_21" | policy_type=="w_ghg_targets_21" | policy_type=="environment_ghg_cap_21" | policy_type=="w_gg_rr_21" | policy_type=="ghg_standards_21" | policy_type=="public_building_standards" | policy_type=="w_complete_streets_21" | policy_type=="environment_preemption_naturalgasbans"
*/

/*not in the data
| policy_type=="environment_ca_car_emissions_sta" |
policy_type=="z_gasoline_tax" | 

*/

**** MERGING IN THE RENEWABLE DATA FROM IEA see Gregor EMAIL JAN 26
sort state year
drop if year<1991
merge m:m state year using "U:\Climate Policy Diffusion\total electricity capacity by source_expanded.dta"


drop _merge
sort state year


*** MERGE PRICE DATA

merge m:1 year using "U:\Climate Policy Diffusion\coalandngprice.dta"
drop _merge
gen relprice=coalprice/ngprice
*/


*NO LAGS TO POLICIES**

xtreg  renewable2  policy  i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies0.xls", replace e(all)
xtreg  renewable2 policy  gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  renewable2 policy  gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  renewable2 policy  gdppc  mininggdpshare democrat   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  renewable2 policy  gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  renewable2 policy  gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)



*POLICIES LAGGED 1 YEAR
xtreg  renewable2  policylag1 i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies1.xls", replace e(all)
xtreg  renewable2 policylag1 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  renewable2 policylag1 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  renewable2 policylag1 gdppc  mininggdpshare democrat   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  renewable2 policylag1 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  renewable2 policylag1 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)



* POLICIES LAGGED 2 YEARS
xtreg  renewable2  policylag2 i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies2.xls", replace e(all)
xtreg  renewable2 policylag2 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  renewable2 policylag2 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  renewable2 policylag2 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  renewable2 policylag2 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  renewable2 policylag2 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)


*POLICIES LAGGED 3 YEARS
xtreg  renewable2  policylag3 i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies3.xls", replace e(all)
xtreg  renewable2 policylag3 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  renewable2 policylag3 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  renewable2 policylag3 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  renewable2 policylag3 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  renewable2 policylag3 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)

 


*POLICY LAGGED 5
xtreg  renewable2  policylag5 i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies5.xls", replace e(all)
xtreg  renewable2 policylag5 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  renewable2 policylag5 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  renewable2 policylag5 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  renewable2 policylag5 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  renewable2 policylag5 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)


