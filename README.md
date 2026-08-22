# Pavement_Reliability_Project
# Project Title: Reliability-Based Flexible Pavement Design Life Prediction Using Monte Carlo Simulation in R

## Abstract

This project presents a reliability-oriented analysis of a two-lane, two-way flexible pavement using **IRC:37-2018** as the principal Indian pavement-design basis and Monte Carlo simulation as the uncertainty-analysis framework. The work was developed without IITPAVE and therefore does not claim to reproduce the full IRC mechanistic strain-analysis workflow. Instead, the project combines an IRC-based deterministic design input set with probabilistic simulation of selected uncertain parameters and evaluates the resulting distribution of cumulative traffic demand in million standard axles (MSA).

The baseline pavement/design inputs used in the final analysis were a subgrade CBR of **10.71%**, design traffic of **3086 CVPD**, design traffic of **95 MSA**, a **20-year** design period, traffic growth of **5%**, VDF of **3.9**, LDF of **0.50**, bituminous resilient modulus of **3000 MPa**, and granular resilient modulus of **98.6 MPa**. The probabilistic model treated four parameters as uncertain: CBR, traffic growth rate, bituminous resilient modulus and granular resilient modulus.

For 10,000 Monte Carlo simulations, the reported mean simulated MSA was **76.29 MSA**, median **76.28 MSA**, standard deviation **1.07 MSA**, 5th percentile **74.54 MSA**, and 95th percentile **78.04 MSA**. The implemented threshold calculation reported **100% reliability** and **0% probability of failure** against the 95-MSA design threshold. Sensitivity analysis ranked traffic growth rate as the dominant simulated parameter.

> **Important interpretation note:** the reported reliability is the reliability of the implemented Monte Carlo traffic-demand threshold model. 

---

## 1. Introduction

Flexible pavement design is affected by uncertainty in traffic, subgrade strength and material properties. A conventional deterministic design uses selected mean or design values, whereas a reliability-based approach explicitly represents the variability of important inputs.

IRC:37-2018 defines flexible pavement design around traffic, subgrade strength and pavement composition. The guideline expresses design traffic as cumulative standard axle repetitions and identifies commercial traffic, growth rate, design period, axle-load/VDF information and lateral distribution as important traffic inputs. It also recommends a 20-year structural design period for National Highways, State Highways and Urban Roads. A minimum annual commercial-vehicle growth rate of 5% is recommended when reliable growth information is unavailable or the estimated growth is below 5%.

The present project follows this IRC framework for the baseline design while using Monte Carlo simulation to investigate the effect of uncertainty in selected input parameters.

The reliability concept is motivated by the work of Maji and Das, who treated pavement design parameters as random variables and evaluated pavement reliability using simulation and analytical approaches. Their work defines reliability as the complement of failure probability and uses the difference between allowable and applied standard-axle repetitions as a safety-margin concept.

The 2011 study by Thyagarajan et al. further demonstrated the usefulness of simulation-based reliability analysis for flexible pavements and compared Monte Carlo simulation with Latin hypercube and Rosenblueth point-estimate approaches.

---

## 2. Objectives

The main objectives of the project are:

1. To establish a baseline flexible-pavement design input set using IRC:37-2018.
2. To use the user's processed CBR and traffic analyses as the baseline inputs.
3. To represent selected pavement-design parameters as uncertain random variables.
4. To generate Monte Carlo samples for the uncertain parameters.
5. To calculate the resulting distribution of cumulative traffic demand in MSA.
6. To estimate reliability and probability of failure relative to the selected design MSA.
7. To perform sensitivity analysis to identify the parameters that most influence the simulated MSA.
8. To provide figures, summary statistics and CSV outputs suitable for further research and reproducibility.

---

## 3. Methodology

### 3.1 Overall workflow

The project follows this sequence:

1. Raw CBR Data
2. CBR Cleaning
3. Design CBR
4. IRC-Based Baseline Subgrade Modulus
5. Raw Traffic Data
6. Traffic Cleaning
7. Design CVPD
8. Design MSA
9. IRC Pavement/Material Baseline
10. Uncertainty Definition
11. Monte Carlo Simulation
12. MSA Distribution
13. Reliability Analysis
14. Sensitivity Analysis
15. Figures and Results

The probabilistic part is based on the principle that Monte Carlo simulation generates random realizations of uncertain input variables and uses those realizations to obtain the output distribution.

### 3.2 IRC-based baseline design

The baseline values used in the final analysis were:

| Parameter | Baseline value | Unit |
|---|---:|---|
| CBR | 10.71 | % |
| Design CVPD | 3086 | CVPD |
| Design MSA | 95 | MSA |
| Design period | 20 | years |
| Traffic growth | 5.00 | %/year |
| Bituminous MR | 3000 | MPa |
| Granular MR | 98.6 | MPa |
| VDF | 3.9 | dimensionless |
| LDF | 0.50 | dimensionless |
| Subgrade MR | 80.27 | MPa |
| GSB + WMM thickness | 480 | mm |
| Granular Poisson's ratio | 0.35 | dimensionless |

The selected pavement system contains bituminous layers over granular material and subgrade. The material-property sheet used in the project identifies a combined bituminous system and a combined WMM + GSB granular system.

IRC:37-2018 describes a flexible pavement as having sub-base, base and bituminous functional layers above the subgrade. The guideline also permits the same resilient/elastic properties to be used for sublayers belonging to the same functional layer when linear-elastic layered analysis is performed.

### 3.3 CBR and subgrade

The project uses the processed design CBR of 10.71%.

IRC:37-2018 states that pavement thickness is based on 4-day soaked CBR at the appropriate placement condition and that design CBR is selected using percentile procedures. For high-volume roads such as National Highways, State Highways and Urban Roads, the guideline specifies the 90th-percentile subgrade CBR approach.

The baseline subgrade resilient modulus used in the project is:

**M_R = 80.27 MPa**

This value was obtained from the IRC-based CBR-to-resilient-modulus relationship used in the preceding design analysis.

### 3.4 Traffic and design MSA

The project uses:

- Initial/design CVPD = 3086
- Growth rate = 5%
- Design period = 20 years
- VDF = 3.9
- LDF = 0.50

IRC:37-2018 defines design traffic using the cumulative number of standard axles and identifies initial commercial traffic, growth rate, design period, VDF/axle-load information and lateral distribution as the relevant inputs.

The general traffic relationship implemented in the project is of the form:

N_DES = 365 × A × D × F × [(1+r)^n − 1]/r

where:

- A = initial commercial vehicles per day
- D = lateral distribution factor
- F = vehicle damage factor
- r = annual traffic growth rate in decimal form
- n = design period in years

### 3.5 Uncertain parameters

Four parameters were treated as uncertain in the Monte Carlo model.

| Parameter | Distribution | Baseline | SD | COV | Unit |
|---|---|---:|---:|---:|---|
| CBR | Log-normal | 10.71 | 1.5113 | 0.1731 | % |
| Traffic growth | Normal | 5.00 | 0.1212 | 0.0242 | % |
| Bituminous MR | Log-normal | 3000 | 750 | 0.25 | MPa |
| Granular MR | Log-normal | 98.6 | 32.045 | 0.325 | MPa |

The distribution selection is based on the supplied reliability literature rather than assigning a normal distribution indiscriminately to every variable.

Maji and Das report literature evidence for log-normal and normal distributions of layer moduli, including bituminous, granular and subgrade materials. Their literature table reports, for example, log-normal distributions for several modulus datasets and normal distributions in some other datasets. The paper also notes that layer thicknesses generally follow a normal distribution and that Poisson's ratio can reasonably be treated as constant for many pavement analyses.

For this project, the above four distributions were retained as the project's adopted probabilistic assumptions.

### 3.6 Monte Carlo simulation

A total of:

**10,000 simulations**

were performed.

For each simulation:

1. A random CBR value was generated from the selected log-normal distribution.
2. A random traffic-growth value was generated from the selected normal distribution.
3. A random bituminous resilient modulus was generated from the selected log-normal distribution.
4. A random granular resilient modulus was generated from the selected log-normal distribution.
5. The simulated traffic demand was calculated.
6. The resulting MSA was stored.
7. Reliability/failure status was evaluated against the selected 95-MSA design threshold.
8. The simulation output was retained for sensitivity analysis.

The use of Monte Carlo simulation is consistent with the supplied pavement-reliability literature, where simulation is used to propagate input uncertainty into the output distribution.

### 3.7 Reliability definition used in the project

The reliability calculation follows the threshold interpretation implemented in the R analysis:

**Reliability = P(MSA_simulated ≤ Design MSA)**

and

**Probability of failure = P(MSA_simulated > Design MSA)**

This is a traffic-demand threshold reliability measure.

It should not be interpreted as the probability that IRC fatigue-cracking or rutting criteria are satisfied, because the present project does not execute the full layered elastic strain calculation or IRC distress transfer functions through IITPAVE.

### 3.8 Sensitivity analysis

Spearman rank correlation was used to evaluate the monotonic relationship between each uncertain parameter and simulated MSA.

The absolute Spearman correlation was then used to rank parameter influence.

---

## 4. Results

### 4.1 Monte Carlo results

The final simulation produced the following results:

| Result | Value |
|---|---:|
| Number of simulations | 10,000 |
| Baseline CBR | 10.71 % |
| Mean simulated CBR | 10.716 % |
| SD simulated CBR | 1.522 % |
| Baseline traffic growth | 5.00 % |
| Mean simulated growth | 5.002 % |
| SD simulated growth | 0.1219 % |
| Baseline bituminous MR | 3000 MPa |
| Mean simulated bituminous MR | 3002.45 MPa |
| SD simulated bituminous MR | 750.11 MPa |
| Baseline granular MR | 98.6 MPa |
| Mean simulated granular MR | 98.51 MPa |
| SD simulated granular MR | 31.86 MPa |
| Mean simulated subgrade MR | 80.12 MPa |
| Baseline design MSA | 95 MSA |
| Mean simulated MSA | 76.29 MSA |
| Median simulated MSA | 76.28 MSA |
| SD simulated MSA | 1.07 MSA |
| 5th percentile MSA | 74.54 MSA |
| 95th percentile MSA | 78.04 MSA |
| Reliability | 100 % |
| Probability of failure | 0 % |

### 4.2 Sensitivity results

The Spearman sensitivity ranking obtained from the simulation was:

| Rank | Parameter | Spearman correlation | Absolute correlation |
|---:|---|---:|---:|
| 1 | Traffic Growth Rate | 1.0000 | 1.0000 |
| 2 | Granular MR | 0.0168 | 0.0168 |
| 3 | Bituminous MR | -0.0073 | 0.0073 |
| 4 | CBR | 0.0070 | 0.0070 |

The simulation therefore identifies **traffic growth rate** as overwhelmingly the dominant driver of the simulated MSA output in the current model.

### 4.3 Figures generated

The R analysis generates figures for the principal probabilistic outputs, including:

- CBR distribution
- Traffic-growth distribution
- Bituminous resilient-modulus distribution
- Granular resilient-modulus distribution
- Simulated MSA distribution
- MSA cumulative distribution/reliability view
- Sensitivity ranking

The figures are intended to document both the input uncertainty and the resulting output uncertainty.

---

## 5. Discussion

The Monte Carlo results show that the four selected uncertain inputs reproduce distributions centered close to their adopted baseline values. The simulated CBR, traffic growth and resilient-modulus means remain close to their specified baselines, indicating that the random-generation procedure is behaving as intended.

The simulated MSA distribution is comparatively narrow, with a mean of approximately 76.29 MSA and a 95th percentile of approximately 78.04 MSA. Under the implemented 95-MSA threshold criterion, all simulated traffic-demand values remain below the design threshold, producing 100% calculated reliability and 0% calculated failure probability.

The sensitivity analysis provides an important finding: traffic growth dominates the MSA response. This is physically reasonable because cumulative traffic is strongly dependent on the compound growth term over the design period. Small changes in annual growth accumulate over 20 years.

The relatively small correlations of CBR, bituminous MR and granular MR with MSA are also expected within the present model because MSA is primarily a traffic-demand quantity. These material variables would become much more influential if the model explicitly calculated pavement response, fatigue cracking, rutting, strain or allowable load repetitions using a mechanistic pavement-response model.

### 5.1 Important consistency check

The reported baseline design MSA in the project is **95 MSA**.

However, using the listed traffic values directly in the IRC-style cumulative traffic equation:

- A = 3086 CVPD
- D = 0.50
- F = 3.9
- r = 0.05
- n = 20 years

gives approximately:

**72.63 MSA**

Therefore, the **95-MSA value should be verified against the source calculation from the earlier traffic-design stage** before treating it as the final IRC-derived design traffic. This does not invalidate the Monte Carlo code, but it is an important project-quality check.

### 5.2 Interpretation of reliability

The calculated 100% reliability should not be presented as proof that the pavement has 100% structural reliability under IRC:37-2018.

The present R model does not calculate:

- tensile strain at the critical bituminous-layer location,
- vertical compressive strain at the subgrade,
- bottom-up fatigue cracking,
- rutting,
- top-down cracking,
- cumulative fatigue damage, or
- mechanistic distress transfer functions.

Those analyses require a pavement-response model. IRC:37-2018 explicitly describes structural design in terms of traffic-induced fatigue cracking and subgrade rutting and includes IITPAVE for linear-elastic layered pavement analysis.

Accordingly, the present project should be described as a **Monte Carlo uncertainty and reliability framework based on the selected traffic-demand/design threshold**, rather than as a complete mechanistic-empirical distress reliability analysis.

---

## 6. Conclusion

This project demonstrates a reproducible Monte Carlo framework for investigating uncertainty in flexible-pavement design inputs.

The major conclusions are:

1. The project uses IRC:37-2018 for the baseline pavement-design framework.
2. The adopted baseline CBR is 10.71%.
3. The adopted design traffic is 3086 CVPD and the project currently uses 95 MSA as its design threshold.
4. Four parameters are treated probabilistically: CBR, traffic growth, bituminous MR and granular MR.
5. The adopted distributions are log-normal for CBR, bituminous MR and granular MR, and normal for traffic growth.
6. 10,000 Monte Carlo simulations were performed.
7. The mean simulated MSA is 76.29 MSA.
8. The 5th and 95th percentile simulated MSA values are 74.54 and 78.04 MSA, respectively.
9. Traffic growth rate is the dominant sensitivity parameter in the current model.
10. The implemented threshold calculation gives 100% reliability and 0% probability of failure.
11. The reliability result is model-specific and should not be interpreted as full IRC structural reliability without mechanistic distress calculations.
12. The reported 95-MSA baseline should be checked because the listed traffic inputs produce approximately 72.63 MSA when inserted directly into the cumulative traffic equation.

---

## 7. Limitations

The principal limitations are:

- Traffic and CBR datasets are synthetic/processed project datasets rather than measured site-specific field datasets.
- Only four primary parameters are probabilistically varied in the final Monte Carlo model.
- VDF and LDF are held at their selected baseline values in the current simulation.
- Pavement-layer thicknesses are not probabilistically varied.
- Poisson's ratio is treated as deterministic.
- No climate uncertainty is included.
- No mechanistic strain calculation is performed.
- No IITPAVE calculation is performed.
- No direct fatigue-cracking or rutting prediction is performed.
- The current reliability result is therefore a threshold reliability of simulated traffic demand, not a complete distress-based pavement reliability value.

---

## 8. Future Scope

The next stage of development can extend the model by:

1. Introducing uncertainty in VDF and LDF.
2. Introducing layer-thickness variability.
3. Introducing Poisson's-ratio variability where justified.
4. Incorporating climate and moisture variability.
5. Adding mechanistic strain calculations using an independent layered-elastic R implementation.
6. Implementing IRC fatigue-cracking and subgrade-rutting transfer functions.
7. Defining separate fatigue and rutting limit states.
8. Computing system reliability from multiple distress modes.
9. Comparing Monte Carlo with Latin hypercube sampling.
10. Calibrating distributions using measured field/laboratory data.
11. Automating pavement-thickness optimization for a target reliability.
12. Adding uncertainty in the design MSA itself rather than treating it only as a fixed threshold.

---


## 10. References

1. **Indian Roads Congress (IRC). (2018).** *IRC:37-2018: Guidelines for the Design of Flexible Pavements*, Fourth Revision. Indian Roads Congress, New Delhi.

2. **Maji, A., & Das, A. (2008).** Reliability considerations of bituminous pavement design by mechanistic–empirical approach. *International Journal of Pavement Engineering*, 9(1), 19–31. DOI: 10.1080/10298430600997240.

3. **Thyagarajan, S., Muhunthan, B., Sivaneswaran, N., & Petros, K. (2011).** Efficient Simulation Techniques for Reliability Analysis of Flexible Pavements Using the Mechanistic-Empirical Pavement Design Guide. *Journal of Transportation Engineering*, 137(11), 796–804.

### Supporting reliability literature cited by the supplied papers

4. **Timm, D. H., Newcomb, D. E., & Galambos, T. V. (2000).** Incorporation of reliability into mechanistic-empirical pavement design. *Transportation Research Record*, 1730, 73–80.

5. **Khazanovich, L., Wojtkiewicz, S. F., & Velasquez, R. (2008).** MEPDG-RED: A framework for reliability analysis with the mechanistic-empirical pavement design procedure. *Transportation Research Board 87th Annual Meeting*.

6. **Federal Highway Administration (FHWA). (2001).** *Assessment of Selected LTPP Material Data Tables and Development of Representative Test Tables*. FHWA-RD-02-001, U.S. Department of Transportation.

