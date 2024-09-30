Overview
--------

README for “Climate Policy Diffusion across the U.S. States”. This read me will walk the reader through the codes to replicate Tables 2, 3, and 4 of the paper.

Data Availability
----------------------------

All data required for estimating the regressions are included in the following datasets:
- data_all_transformed.dta
- coalandngprice.dta
- co2regs.dta

Instructions to Replicators
---------------------------

# Table 2: Climate Policies and the Share of Renewables in Total Energy Capacity
1. For Columns 1, 4, 7, and 10: run the do file FINAL_cumulative_renewable_averagepolicyeffect ALL POLICIES.do
2. For Columnds 2, 5, 8, and 11: run the do file FINAL_cumulative_renewable_averagepolicyeffect RENEWABLE POLICIES.do
3. For Columnds 3, 6, 9, and 12: run the do file FINAL_cumulative_renewable_averagepolicyeffect SECTORAL POLICIES.do

# Table 3: Climate Policies and the Share of Renewables in Net Generation of Electric Power 
1. For Columns 1, 4, 7, and 10: run the do file FINAL_cumulative_renewable_averagepolicyeffect Net Generation ALL POLICIES.do
2. For Columnds 2, 5, 8, and 11: run the do file FINAL_cumulative_renewable_averagepolicyeffect Net Generation RENEWABLE POLICIES.do
3. For Columnds 3, 6, 9, and 12: run the do file FINAL_cumulative_renewable_averagepolicyeffect Net Generation SECTORAL POLICIES.do

# Table 4: Climate Policies and energy-related CO2 emissions 
1. For Columns 1 and 4: run the do file FINAL_cumulative_CO2_emissions_stacked_policyeffect ALL POLICIES.do
2. For Columns 2 and 5: run the do file 
3. FINAL_cumulative_CO2_emissions_stacked_policyeffect RENEWABLE POLICIES.do
4. For Columns 3 and 12: run the do file FINAL_cumulative_CO2_emissions_stacked_policyeffect SECTORAL POLICIES.do

### License for Code and Data

The code in this repository is provided only for the purpose of replicating the results for peer-review. All other uses of the code or data are strictly prohibited.
