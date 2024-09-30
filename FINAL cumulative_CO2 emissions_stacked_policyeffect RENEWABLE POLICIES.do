*COPY of the other stacked policies for POWER SECTOR CO2 emissions but now using C02 emissions of all sectors(total) as dep variable.
* Key change (total, per capita, state gdp in line 84)
* Change from all renewable, to solar, hydro, or wind in line 38

set more 1
use  "U:\Climate Policy Diffusionco2regs.dta", clear
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


expand 11
sort state year
destring stateabbr, replace

save "U:\Climate Policy Diffusionco2regs_expanded.dta", replace 


use "U:\Climate Policy Diffusiondata_all_transformed.dta", clear
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


* KEEP ONLY RENEWABLE POLICYES AND ENERGY POLICIES FROM CATEGORY A. thESE ARE THE ONES THAT SHOULD MATTER FOR SOLAR/WIND/HYDRO
 
**          REMEMBER TO CHANGE EXPAND 23 TO EXPAND 15 (only 11 of the 15 in the data in the data so expand 11) **


keep if policy_type=="netmeter_yearadopted_21" | policy_type=="fgd_21" | policy_type=="w_mgpo_21" | policy_type=="community_solar" | policy_type=="w4_environment_state_rps_21" | policy_type=="w_Environment_Solar_TaxCredit_21" |  policy_type=="w4_gas_decoupling_21" | policy_type=="w4_electric_decoupling_21"  | policy_type=="w_ee_21"  | policy_type=="w_low_income_ee_21"   |      policy_type=="pace_21"
*/


/* not in the data:
policy_type=="x_eers" 
| policy_type=="environment_publicbenefit_funds_"
policy_type=="environment_utility_deregulation"  |
policy_type=="x_RPS_targets_bindingonly" | 
*/



sort state year
merge m:m state year using "U:\Climate Policy Diffusionco2regs_expanded.dta" 

drop _merge
sort state year
drop if year<1991
*drop if state==""

*** MERGE PRICE DATA

merge m:1 year using "U:\Climate Policy Diffusioncoalandngprice.dta"
drop _merge
gen relprice=coalprice/ngprice
*/

sort state year

			**** REGRESSIONS ***



replace powersecemission=co2pergdp

*NO LAGS TO POLICIES**

xtreg  powersecemission  policy  i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies0.xls", replace e(all)
xtreg  powersecemission policy  gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies0.xls", append e(all)
xtreg  powersecemission policy  gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies0.xls", append e(all)
xtreg  powersecemission policy  gdppc  mininggdpshare democrat   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies0.xls", append e(all)
xtreg  powersecemission policy  gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies0.xls", append e(all)
xtreg  powersecemission policy  gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies0.xls", append e(all)



*POLICIES LAGGED 1 YEAR
xtreg  powersecemission  policylag1 i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies1.xls", replace e(all)
xtreg  powersecemission policylag1 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies1.xls", append e(all)
xtreg  powersecemission policylag1 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies1.xls", append e(all)
xtreg  powersecemission policylag1 gdppc  mininggdpshare democrat   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies1.xls", append e(all)
xtreg  powersecemission policylag1 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies1.xls", append e(all)
xtreg  powersecemission policylag1 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies1.xls", append e(all)



* POLICIES LAGGED 2 YEARS
xtreg  powersecemission  policylag2 i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies2.xls", replace e(all)
xtreg  powersecemission policylag2 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies2.xls", append e(all)
xtreg  powersecemission policylag2 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies2.xls", append e(all)
xtreg  powersecemission policylag2 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies2.xls", append e(all)
xtreg  powersecemission policylag2 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies2.xls", append e(all)
xtreg  powersecemission policylag2 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies2.xls", append e(all)


*POLICIES LAGGED 3 YEARS
xtreg  powersecemission  policylag3 i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies3.xls", replace e(all)
xtreg  powersecemission policylag3 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies3.xls", append e(all)
xtreg  powersecemission policylag3 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies3.xls", append e(all)
xtreg  powersecemission policylag3 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies3.xls", append e(all)
xtreg  powersecemission policylag3 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies3.xls", append e(all)
xtreg  powersecemission policylag3 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies3.xls", append e(all)




*POLICY LAGGED 5
xtreg  powersecemission  policylag5 i.stateabbr i.year, robust 
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies5.xls", replace e(all)
xtreg  powersecemission policylag5 gdppc    i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies5.xls", append e(all)
xtreg  powersecemission policylag5 gdppc  mininggdpshare   i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies5.xls", append e(all)
xtreg  powersecemission policylag5 gdppc  mininggdpshare    democrat     i.stateabbr i.year, robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies5.xls", append e(all)
xtreg  powersecemission policylag5 gdppc  mininggdpshare    democrat  i.year i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies5.xls", append e(all)
xtreg  powersecemission policylag5 gdppc  mininggdpshare    democrat  i.year_policy_fe  i.state_policy_fe , robust
outreg2 using "U:\Climate Policy Diffusionrenewenergyallpolicies5.xls", append e(all)


