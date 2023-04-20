//DO-FILE FOR ASSIGNMENT 3 DA4 WINTER 2023 CEU
//DOWNLDOAD DATA
clear 
import delimited C:\Users\User\Desktop\4c0c94b1-75c7-40cc-8de8-cbb033043b57_Data.csv, varnames(1) 
sort countryname
drop in 1/5

// SAVE DATA
 save "C:\Users\User\Desktop\Data for DA4 assignment_3.dta", replace
 rename gdppercapitapppconstant2017inter GDPpc
 rename time year
 rename populationgrowthannualsppopgrow population_growth
 rename humancapitalindexhciscale01hdhci HCI
 rename cpiatransparencyaccountabilityan CPIA
 rename netofficialdevelopmentassistance aid
 
//CLEANING DATA
drop if GDPpc==".."

destring year, replace force
destring population_growth , replace force
destring GDPpc, replace force
destring HCI, replace force
destring aid, replace force
destring CPIA, replace force


tab year
drop if year==1990
drop if year==1991
drop if year==1992
drop if year==1993
drop if year==1994
drop if year==1995
drop if year==1996
drop if year==1997
drop if year==1998
drop if year==1999

tab countryname
drop if countryname=="Afghanistan"
drop if countryname=="Eritrea"
drop if countryname=="Sao Tome and Principe"
drop if countryname=="Somalia"
drop if countryname=="South Sudan"
drop if countryname=="Syrian Arab Republic"
drop if countryname=="Yemen, Rep."
drop if aid<0
gen ln_GDPpc = ln(GDPpc)
gen ln_aid = ln(aid)
egen countryid = group(countryname)

// DESCRIPTIVE STATISTICS
sum year countryid population_growth GDPpc aid CPIA HCI ln_GDPpc ln_aid
hist ln_GDPpc ,normal bin(40) bcolor(blue)
hist ln_aid ,normal bin(40) bcolor(blue)



//FIXED EFFECT REG
xtset countryid year
xtreg ln_GDPpc i.year ln_aid, fe cluster(countryid)
xtreg ln_GDPpc ln_aid population_growth CPIA HCI i.year , fe cluster(countryid)
// estimate store fe 
// we don't need it here, but it useful for compare fixed and random effects (hausman test)//

gen low_income_country=0
replace low_income_country=1 if countryname=="Burkina Faso"
replace low_income_country=1 if countryname=="Burundi"
replace low_income_country=1 if countryname=="Central African Republic"
replace low_income_country=1 if countryname=="Chad"
replace low_income_country=1 if countryname=="Congo, Dem. Rep."
replace low_income_country=1 if countryname=="Ethiopia"
replace low_income_country=1 if countryname=="Gambia, The"
replace low_income_country=1 if countryname=="Guinea"
replace low_income_country=1 if countryname=="Guinea-Bissau"
replace low_income_country=1 if countryname=="Korea, Dem. People's Rep."
replace low_income_country=1 if countryname=="Liberia"
replace low_income_country=1 if countryname=="Madagascar"
replace low_income_country=1 if countryname=="Malawi"
replace low_income_country=1 if countryname=="Mali"
replace low_income_country=1 if countryname=="Mozambique"
replace low_income_country=1 if countryname=="Niger"
replace low_income_country=1 if countryname=="Rwanda"
replace low_income_country=1 if countryname=="Sierra Leone"
replace low_income_country=1 if countryname=="Sudan"
replace low_income_country=1 if countryname=="Togo"
replace low_income_country=1 if countryname=="Uganda"
replace low_income_country=1 if countryname=="Zambia"

keep if low_income_country==0
//OR 
//keep if low_income_country==0
xtreg ln_GDPpc ln_aid population_growth CPIA HCI i.year , fe cluster(countryid)



//FINAL SAVING
save "C:\Users\User\Desktop\Data for DA4 final project_FINAL.dta", replace

//
