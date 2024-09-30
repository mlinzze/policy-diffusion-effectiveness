*Replaces dep variable of emissions with solar + wind (or solar + wind+ hydro in share of all fuels' kilowatt) with NET GENERATION, SECTORAL POLICIES ONLY
* KEY CHANGE In ROW 32

set more 1

use "U:\SAM Publications\Climate Policy Diffusion\Net_generation_for_all_sectors.dta", clear
sort state year

drop if year<1980
drop if year>2020
drop if state=="DC"
drop if stateabbr=="US"
drop if stateabbr=="PR"

encode stateabbr, generate(newv1)
rename stateabbr old_stateabbr
rename newv1 stateabbr

sort state year

replace solar=0 if solar==.
replace solar=0 if solar==.
replace wind=0 if wind==.
replace hydro=0 if hydro==.
replace coal=0 if coal==.
replace ngas=0 if ngas==.


*RENEWABLE DEFINITION -- THIS LINE TO BE CHANGED AS WE ESTIMATE HYDRO VS. SOLAR VS. WIND VS. ALL RENEWABLES

gen renewable2 = ((solar+hydro+wind)/total)*100

**# ESTIMATING DIFFERENCES IN LEVELS
sort state year
bysort state: gen levelchangerenew=renewable2 -renewable2[_n-1]
replace renewable2=levelchangerenew



expand 8

sort state year
destring stateabbr, replace

save "U:\SAM Publications\Climate Policy Diffusion\Net_generation_for_all_sectors_expanded.dta", replace

* Using Manuel data 
use "U:\SAM Publications\Climate Policy Diffusion\data_all_transformed.dta", clear

drop if year<1991
drop if year>2020
drop if state=="DISTRICT OF COLUMBIA"
drop if state=="DC"
drop if stateabbr=="US"
drop if stateabbr=="PR"

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


*** KEEP ONLY SECTORAL AND GHG POLICIES, FROM CATEGORY A. THESE * ARE ONES THAT SHOULD NOT MATTER FOR SOLAR, WIND, HYDRO
**    CHANGE EXPAND 23 TO EXPAND 10 (TECHNICALLY EXPAND 8, SINCE only 8 in the data)**


keep if policy_type=="climate_action_plan_21" | policy_type=="w_ghg_targets_21" | policy_type=="environment_ghg_cap_21" | policy_type=="w_gg_rr_21" | policy_type=="ghg_standards_21" | policy_type=="public_building_standards" | policy_type=="w_complete_streets_21" | policy_type=="environment_preemption_naturalgasbans"
*/

/*not in the data
| policy_type=="environment_ca_car_emissions_sta" |
policy_type=="z_gasoline_tax" | 

*/



**** MERGING IN THE RENEWABLE DATA FROM IEA GREGOR  EMAIL FRI JAN 26
sort state year
merge m:m state year using "U:\SAM Publications\Climate Policy Diffusion\Net_generation_for_all_sectors_expanded.dta"

drop _merge
sort state year


*** MERGE PRICE DATA

merge m:1 year using "U:\SAM Publications\Climate Policy Diffusion\coalandngprice.dta"
drop _merge
gen relprice=coalprice/ngprice
*/

/*
				* REGRESSIONS: Net generation on policies *


*NO LAGS TO POLICIES**
xtreg  renewable2  policy  i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", replace e(all)
xtreg  renewable2 policy  gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  renewable2 policy  gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  renewable2 policy  gdppc  mininggdpshare democrat   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  renewable2 policy  gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  renewable2 policy  gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)




*POLICIES LAGGED 1 YEAR
xtreg  renewable2  policylag1 i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", replace e(all)
xtreg  renewable2 policylag1 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  renewable2 policylag1 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  renewable2 policylag1 gdppc  mininggdpshare democrat   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  renewable2 policylag1 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  renewable2 policylag1 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)



* POLICIES LAGGED 2 YEARS
xtreg  renewable2  policylag2 i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", replace e(all)
xtreg  renewable2 policylag2 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  renewable2 policylag2 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  renewable2 policylag2 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  renewable2 policylag2 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  renewable2 policylag2 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
*/

*POLICIES LAGGED 3 YEARS
xtreg  renewable2  policylag3 i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", replace e(all)
xtreg  renewable2 policylag3 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  renewable2 policylag3 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  renewable2 policylag3 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  renewable2 policylag3 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  renewable2 policylag3 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)


/*

*POLICY LAGGED 5
xtreg  renewable2  policylag5 i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", replace e(all)
xtreg  renewable2 policylag5 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  renewable2 policylag5 gdppc  mininggdpshare   i.stateabbr i.year, robust
ou/*treg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  renewable2 policylag5 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  renewable2 policylag5 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  renewable2 policylag5 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)


