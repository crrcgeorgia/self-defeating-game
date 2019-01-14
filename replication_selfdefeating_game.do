*** Replication Data
/// The self-defeating game: How state capacity and policy choice affect political survival
/// Dustin Gilbreath & Koba Turmanidze

/// Caucasus Survey, Volume 5, 2017 - Issue 3
/// https://doi.org/10.1080/23761199.2017.1382214

*******************************************************************************
/// Graphs in the paper
*******************************************************************************

graph set window fontface "Times New Roman"

// Graph 1. Marginal effects with 95% and 90% CIs
*************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

local model1 l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.free_lag year
local model2 l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.n_n11 year

qui: logit lose `model1' if mele==1, vce(cluster country) or
qui: margins, dydx(*) post
estimates store Model_1
qui: logit lose `model2' if mele==1, vce(cluster country) or
qui: margins, dydx(*) post
estimates store Model_2

coefplot ///
(Model_1, label(Model 1) lpatt(solid)lwidth(none)lcol(ebblue)msym(D)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue))) ///
(Model_2, label(Model 2) lpatt(solid)lcol(erose)msym(O)mcol(erose)ciopts(lpatt(solid)lcol(erose))), ///
drop(_cons year) xscale() xline(0, lcolor(red) lwidth(thin) lpattern(dash)) ///
xtitle(Effects on Pr(losing elections)) levels(95 90) ///
omitted graphregion(color(white)) ///
coeflabels(_cons="Constant" L.rpe1="State capacity (lagged)" rpe1_mp="State capacity growth" rpe1_sd="State capacity volatility" ///
L.natres="Natural resources (lagged)" L.gdp_gr="GDP growth (lagged)" ///
ecrisis="Economic crisis" year="Year" ///
1.free_lag="Free" 2.free_lag="Partly free" 3.free_lag="Not free" ///
oppvote="Opposition vote share" L.polity2="Polity IV score" ///
0.n_n11="Fraud" 1.n_n11="Electoral fraud", ///
wrap(27) notick labcolor(black*.8) labsize(medsmall) labgap(2)) /// 
title("Graph 1. Did the incumbent's party lose elections?", color(dknavy*.9) tstyle(size(medium)) span) ///
subtitle("Marginal effects with 95% and 90% CIs", color(dknavy*.8) tstyle(size(medium)) span)

graph export "Graph_1.png", width(3000) replace 

 // Graph 2. Marginal effects of state capacity indicators
**********************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

// growth
qui: logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.free_lag year if mele==1, vce(cluster country) or
qui: margins, at (rpe1_mp=(-1 (.1) 1)) noatlegend vsquish post
est store Model_1

qui: logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.n_n11 year if mele==1, vce(cluster country) or
qui: margins, at (rpe1_mp=(-1 (.12) 1)) noatlegend vsquish post
est store Model_2

coefplot (Model_1, label(Model 1) lpatt(solid)lwidth(none)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue))) ///
(Model_2, label(Model 2) lpatt(solid)lcol(erose)msym(O)mcol(erose)ciopts(lpatt(solid)lcol(erose))), ///
name(a, replace) ///
title("") graphregion(color(white)) ///
at xtitle("State capacity growth (%)") lwidth(*1) connect(1) ///
xlabel(-1(.5)1) ///
xlabel(-1 "-100" -.5 "-50" 0 "0" .5 "50" 1 "100") ///
ylabel(0(.2)1) ytitle(Effects on Pr(losing elections))

// volatility
qui: logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.free_lag year if mele==1, vce(cluster country) or
qui: margins, at (rpe1_sd=(0 (.05) 1)) noatlegend vsquish post
est store Model_1

qui: logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.n_n11 year if mele==1, vce(cluster country) or
qui: margins, at (rpe1_sd=(0 (.07) 1)) noatlegend vsquish post
est store Model_2

coefplot (Model_1, label(Model 1) lpatt(solid)lwidth(none)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue))) ///
(Model_2, label(Model 2) lpatt(solid)lcol(erose)msym(O)mcol(erose)ciopts(lpatt(solid)lcol(erose))), ///
name(b, replace) ///
title("") graphregion(color(white)) ///
at xtitle("State capacity volatility") lwidth(*1) connect(1) ///
xlabel(0(.5)1) ///
ylabel(0(.2)1) ytitle(Effects on Pr(losing elections))

graph combine a b, ///
title("Graph 2. Marginal effects of state capacity indicators", ///
color(dknavy) tstyle(size(medium)) span) subtitle("95% Confidence Intervals", color(dknavy) tstyle(size(medium)) span) ///
graphregion(color(white))

graph export "Graph_2.png", width(3000) replace 

// Graph 3. marginal effects of volatility as a function of growth
******************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

qui: logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.free_lag year if mele==1, vce(cluster country) or
qui: margins, dydx(rpe1_sd) at(rpe1_mp=(-1(.1)1)) noatlegend vsquish post
est store Model_1

qui: logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.n_n11 year if mele==1, vce(cluster country) or
qui: margins, dydx(rpe1_sd) at(rpe1_mp=(-1(.12)1)) noatlegend vsquish post
est store Model_2

coefplot (Model_1, label(Model 1) lpatt(solid)lwidth(none)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue))) ///
(Model_2, label(Model 2) lpatt(solid)lcol(erose)msym(O)mcol(erose)ciopts(lpatt(solid)lcol(erose))), ///
name(a, replace) ///
title("Graph 3. State capacity volatility as a function of growth", ///
color(dknavy) tstyle(size(medium)) span) subtitle("95% Confidence Intervals", color(dknavy) tstyle(size(medium)) span) ///
graphregion(color(white)) ///
at xtitle("State capacity growth") lwidth(*1) connect(l) ///
xlabel(-1(.5)1) ///
xlabel(-1 "-100" -.5 "-50" 0 "0" .5 "50" 1 "100") ///
ylabel(0(.2)1) ytitle(Effects on Pr(losing elections)) ///
xtitle(State capacity growth (%)) note() ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash))

graph export "Graph_3.png", width(3000) replace 

// Graph 4. marginal effects of volatility as a function of regime type and quality of elections
************************************************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

gen Growth=rpe1_mp
gen Volatility=rpe1_sd

/// regime type
lab var free_lag "Regime type"
qui: logit lose l.rpe1 Growth Volatility l.natres l.gdp_gr ecrisis i.free_lag year if mele==1, vce(cluster country) or
qui: margins, dydx(Growth Volatility) over(free_lag) noatlegend vsquish post

marginsplot, name(a, replace) ///
title("Model 1") graphregion(color(white)) ///
xdim(free_lag) xlabel(1 "Free" 2 "Partly Free" 3 "Not Free") xscale(range(.75 3.25)) ///
recast(scatter) ///
ylabel(-1(.5)1) ytitle(Effects on Pr(loseing elections)) ///
plot1opts(lpatt(solid) lwidth(medium) lcolor(eltgreen) mcolor(eltgreen) msym(T) mcol(eltgreen)) ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash)) 

/// quality of elections
lab var n_n11 "Electoral fraud"
qui: logit lose l.rpe1 Growth Volatility l.natres l.gdp_gr ecrisis i.n_n11 year if mele==1, vce(cluster country) or
qui: margins, dydx(Growth Volatility) over(n_n11) noatlegend vsquish post

marginsplot, name(b, replace) ///
title("Model 2") graphregion(color(white)) ///
xdim(n_n11) xlabel(0 "No" 1 "Yes") xscale(range(.9 1.1)) ///
recast(scatter) ///
ylabel(-1(.5)1) ytitle(Effects on Pr(loseing elections)) ///
plot1opts(lpatt(solid) lwidth(medium) lcolor(eltgreen) mcolor(eltgreen) msym(T) mcol(eltgreen)) ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash)) 

graph combine a b, ///
title("Graph 4. State capacity as a function of regime type and electoral fraud", ///
color(dknavy) tstyle(size(medium)) span) subtitle("95% Confidence Intervals", color(dknavy) tstyle(size(medium)) span) ///
graphregion(color(white))

graph export "Graph_4.png", width(3000) replace 

********************************************************************************
/// Online Appendix
********************************************************************************

// Table A2. Logit Estimates of the effect of state capacity on electoral outcome (Base models)
********************************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.free_lag year if mele==1, vce(cluster country)
logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.n_n11 year if mele==1, vce(cluster country)
logit lose c.rpe1_sd##i.free_lag c.rpe1_mp##i.free_lag l.rpe1 l.natres l.gdp_gr ecrisis year if mele==1, vce(cluster country)
logit lose c.rpe1_sd##i.n_n11 c.rpe1_mp##i.n_n11 l.rpe1 l.natres l.gdp_gr ecrisis year if mele==1, vce(cluster country)

// Table A3. Logit Estimates of the effect of state capacity on electoral outcome (Base models, Random effects)
********************************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year
xtset country year

xtlogit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.free_lag year if mele==1, re
xtlogit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis i.n_n11 year if mele==1, re
xtlogit lose c.rpe1_sd##i.free_lag c.rpe1_mp##i.free_lag l.rpe1 l.natres l.gdp_gr ecrisis year if mele==1, re
xtlogit lose c.rpe1_sd##i.n_n11 c.rpe1_mp##i.n_n11 l.rpe1 l.natres l.gdp_gr ecrisis year if mele==1, re

// Table A4. Logit Estimates of the effect of state capacity on electoral outcome (Alternative models)
********************************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis oppvote year if mele==1, vce(cluster country)
logit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis polity2_lag year if mele==1, vce(cluster country)
logit lose c.rpe1_sd##c.oppvote c.rpe1_mp##c.oppvote l.rpe1 l.natres l.gdp_gr ecrisis year if mele==1, vce(cluster country)
logit lose c.rpe1_sd##c.polity2_lag c.rpe1_mp##c.polity2_lag l.rpe1 l.natres l.gdp_gr ecrisis year if mele==1, vce(cluster country)

// Table A5. Logit Estimates of the effect of state capacity on electoral outcome (Alternative models, Random effects)
********************************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year
xtset country year

xtlogit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis oppvote year if mele==1, re
xtlogit lose l.rpe1 rpe1_sd rpe1_mp l.natres l.gdp_gr ecrisis polity2_lag year if mele==1, re
xtlogit lose c.rpe1_sd##c.oppvote c.rpe1_mp##c.oppvote l.rpe1 l.natres l.gdp_gr ecrisis year if mele==1, re
xtlogit lose c.rpe1_sd##c.polity2_lag c.rpe1_mp##c.polity2_lag l.rpe1 l.natres l.gdp_gr ecrisis year if mele==1, re

// Graph 5. Marginal effects of state capacity as a function of natural resources
**********************************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

gen Growth=rpe1_mp
gen Volatility=rpe1_sd

qui: logit lose l.rpe1 Growth Volatility rpe1_mp l.natres l.gdp_gr ecrisis i.free_lag year if mele==1, vce(cluster country) or
qui: margins, dydx(Growth Volatility) at(L.natres=(0(.1)1)) noatlegend vsquish post

marginsplot, name(a, replace) recastci(rline) ciopts(color(erose*.4)) ///
title("Model 1") graphregion(color(white)) ///
xlabel(0(.5)1) ///
xlabel(0 "0" .5 "50" 1 "100") ///
ylabel(-1(.5)1) ytitle(Effects on Pr(losing elections)) ///
xtitle(Natural resources (% of GDP)) note() ///
plot1opts(lpatt(solid) lwidth(thin) lcolor(erose) mcolor(erose) msym(t) mcol(erose)) ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash))

qui: logit lose l.rpe1 Growth Volatility l.natres l.gdp_gr ecrisis i.n_n11 year if mele==1, vce(cluster country) or
qui: margins, dydx(Growth Volatility) at(L.natres=(0(.1)1)) noatlegend vsquish post

marginsplot, name(b, replace) recastci(rline) ciopts(color(erose*.4)) ///
title("Model 2") graphregion(color(white)) ///
xlabel(0(.5)1) ///
xlabel(0 "0" .5 "50" 1 "100") ///
ylabel(-1(.5)1) ytitle(Effects on Pr(losing elections)) ///
xtitle(Natural resources (% of GDP)) note() ///
plot1opts(lpatt(solid) lwidth(thin) lcolor(erose) mcolor(erose) msym(t) mcol(erose)) ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash))

graph combine a b, ///
title("Graph A1. State capacity as a function of natural resources", ///
color(dknavy) tstyle(size(medium)) span) subtitle("Marginal effects at 95% CIs", color(dknavy) tstyle(size(medium)) span) ///
graphregion(color(white))

graph export "Graph_5.png", width(3000) replace 

// Graph 6. Marginal effects of state capacity as a function of GDP growth
***************************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

gen Growth=rpe1_mp
gen Volatility=rpe1_sd

qui: logit lose l.rpe1 Growth Volatility l.natres l.gdp_gr ecrisis i.free_lag year if mele==1, vce(cluster country) or
qui: margins, dydx(Growth Volatility) at(L.gdp_gr=(-.5(.1).5)) noatlegend vsquish post

marginsplot, name(a, replace) recastci(rline) ciopts(color(erose*.4)) ///
title("Model 1") graphregion(color(white)) ///
xlabel(-.5(.5).5) ///
xlabel(-.5 "-50" 0 "0" .5 "50") ///
ylabel(-1(.5)1) ytitle(Effects on Pr(losing elections)) ///
xtitle(GDP growth (%)) note() ///
plot1opts(lpatt(solid) lwidth(solid) lcolor(erose) mcolor(erose) msym(t) mcol(erose)) ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash))

qui: logit lose l.rpe1 Growth Volatility l.natres l.gdp_gr ecrisis i.n_n11 year if mele==1, vce(cluster country) or
qui: margins, dydx(Growth Volatility) at(L.gdp_gr=(-.5(.1).5)) noatlegend vsquish post

marginsplot, name(b, replace) recastci(rline) ciopts(color(eltgreen*.4)) ///
title("Model 2") graphregion(color(white)) ///
xlabel(-.5(.5).5) ///
xlabel(-.5 "-50" 0 "0" .5 "50") ///
ylabel(-1(.5)1) ytitle(Effects on Pr(losing elections)) ///
xtitle(GDP growth (%)) note() ///
plot1opts(lpatt(solid) lwidth(thin) lcolor(erose) mcolor(erose) msym(t) mcol(erose)) ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash))

graph combine a b, ///
title("Graph A2. State capacity as a function of GDP growth", ///
color(dknavy) tstyle(size(medium)) span) subtitle("Marginal effects at 95% CIs", color(dknavy) tstyle(size(medium)) span) ///
graphregion(color(white))

graph export "Graph_6.png", width(3000) replace 

// Graph 7. Marginal effects of state capacity as a function of democracy indicators
*************************************************************************************

clear all
use "StateCapacityData_2017.dta"
sort country year

gen Growth=rpe1_mp
gen Volatility=rpe1_sd

qui: logit lose l.rpe1 Growth Volatility l.natres l.gdp_gr ecrisis oppvote year if mele==1, vce(cluster country) or
qui: margins, dydx(Growth Volatility) at(oppvote=(0(.2)1)) noatlegend vsquish post

marginsplot, name(a, replace) recastci(rline) ciopts(color(erose*.4)) ///
title("Model 5") graphregion(color(white)) ///
xlabel(0(.5)1) ///
ylabel(-1(.5)1) ytitle(Effects on Pr(losing elections)) ///
xtitle(Opposition vote share (%)) note() ///
plot1opts(lpatt(solid) lwidth(solid) lcolor(erose) mcolor(erose) msym(t) mcol(erose)) ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash))

qui: logit lose l.rpe1 Growth Volatility l.natres l.gdp_gr ecrisis polity2_lag year if mele==1, vce(cluster country) or
qui: margins, dydx(Growth Volatility) at(polity2_lag=(-10(1)10)) noatlegend vsquish post

marginsplot, name(b, replace) recastci(rline) ciopts(color(eltgreen*.4)) ///
title("Model 6") graphregion(color(white)) ///
xlabel(-10(2)10) ///
ylabel(-1(.5)1) ytitle(Effects on Pr(losing elections)) ///
xtitle(Polity IV score) note() ///
plot1opts(lpatt(solid) lwidth(thin) lcolor(erose) mcolor(erose) msym(t) mcol(erose)) ///
yline(0, lcolor(red) lwidth(thin) lpattern(dash))

graph combine a b, ///
title("Graph A3. State capacity as a function of democracy indicators", ///
color(dknavy) tstyle(size(medium)) span) subtitle("Marginal effects at 95% CIs", color(dknavy) tstyle(size(medium)) span) ///
graphregion(color(white))

graph export "Graph_7.png", width(3000) replace 
