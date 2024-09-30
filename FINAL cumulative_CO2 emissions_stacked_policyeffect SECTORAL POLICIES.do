*COPY of the other stacked policies for POWER SECTOR CO2 emissions but now using C02 emissions of all sectors(total) as dep variable.
* Key change (total, per capita, state gdp in line 84)
* Change from all renewable, to solar, hydro, or wind in line 38

set more 1
use  "U:\SAM Publications\Climate Policy Diffusion\co2regs.dta", clear
gen pop=stategdp/gdppc
gen co2total = co2percap*pop
gen co2pergdp=co2percap/gdppc


sort state year

drop if year<1980
drop if year>2020
drop if state=="DISTRICT OF COLUMBIA"
drop if stateabbr=="US"
drop if stateabbr=="PR"

encode stateabbr, generate(newv1)
rename stateabbr old_stateabbr
rename newv1 stateabbr


expand 8
sort state year
destring stateabbr, replace

save "U:\SAM Publications\Climate Policy Diffusion\co2regs_expanded.dta", replace 


use "U:\SAM Publications\Climate Policy Diffusion\data_all_transformed.dta", clear
drop if year<1980
sort stateabbr year

*dropping years only in using 
drop if year<1980
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


*** KEEP ONLY SECTORAL AND GHG POLICIES, FROM CATEGORY A. THESE * ARE ONES THAT SHOULD NOT MATTER FOR SOLAR, WIND, HYDRO
**    CHANGE EXPAND 23 TO EXPAND 10 (TECHNICALLY EXPAND 8, SINCE only 8 in the data)**


keep if policy_type=="climate_action_plan_21" | policy_type=="w_ghg_targets_21" | policy_type=="environment_ghg_cap_21" | policy_type=="w_gg_rr_21" | policy_type=="ghg_standards_21" | policy_type=="public_building_standards" | policy_type=="w_complete_streets_21" | policy_type=="environment_preemption_naturalgasbans"
*/

/*not in the data
| policy_type=="environment_ca_car_emissions_sta" |
policy_type=="z_gasoline_tax" | 

*/




sort state year
merge m:m state year using "U:\SAM Publications\Climate Policy Diffusion\co2regs_expanded.dta" 

drop _merge
sort state year
drop if year<1991
*drop if state==""

*** MERGE PRICE DATA

merge m:1 year using "U:\SAM Publications\Climate Policy Diffusion\coalandngprice.dta"
drop _merge
gen relprice=coalprice/ngprice
*/

sort state year

			**** REGRESSIONS ***



replace powersecemission=co2total

*NO LAGS TO POLICIES**

xtreg  powersecemission  policy  i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", replace e(all)
xtreg  powersecemission policy  gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  powersecemission policy  gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  powersecemission policy  gdppc  mininggdpshare democrat   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  powersecemission policy  gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)
xtreg  powersecemission policy  gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies0.xls", append e(all)



*POLICIES LAGGED 1 YEAR
xtreg  powersecemission  policylag1 i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", replace e(all)
xtreg  powersecemission policylag1 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  powersecemission policylag1 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  powersecemission policylag1 gdppc  mininggdpshare democrat   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  powersecemission policylag1 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)
xtreg  powersecemission policylag1 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies1.xls", append e(all)



* POLICIES LAGGED 2 YEARS
xtreg  powersecemission  policylag2 i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", replace e(all)
xtreg  powersecemission policylag2 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  powersecemission policylag2 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  powersecemission policylag2 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  powersecemission policylag2 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)
xtreg  powersecemission policylag2 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies2.xls", append e(all)


*POLICIES LAGGED 3 YEARS
xtreg  powersecemission  policylag3 i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", replace e(all)
xtreg  powersecemission policylag3 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  powersecemission policylag3 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  powersecemission policylag3 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  powersecemission policylag3 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)
xtreg  powersecemission policylag3 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies3.xls", append e(all)




*POLICY LAGGED 5
xtreg  powersecemission  policylag5 i.stateabbr i.year, robust 
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", replace e(all)
xtreg  powersecemission policylag5 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  powersecemission policylag5 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  powersecemission policylag5 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  powersecemission policylag5 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)
xtreg  powersecemission policylag5 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\SAM Publications\Climate Policy Diffusion\renewenergyallpolicies5.xls", append e(all)


