# Real-Time Cost‑Minimization Strategy for Fuel‑Cell Hybrid Electric Vehicles via MPC

This repository contains the paper and supplementary materials for the project **“Optimal power‑splitting strategy via MPC for fuel cell hybrid electric vehicles.”** This work presents a real‑time energy management strategy (EMS) designed to minimize the total operating cost of a fuel‑cell/battery hybrid powertrain.

---

## 📖 Overview

Fuel‑Cell Hybrid Electric Vehicles (FCHEVs) offer a promising path toward sustainable transportation, but their high total cost of ownership remains a significant barrier to market adoption. This project addresses this challenge by developing an advanced EMS that optimizes the power split between the fuel cell and the battery to reduce operational expenses.

The core of this work is a Model Predictive Control (MPC) framework that uses a multi‑objective cost function to make optimal decisions in real time. The strategy aims to:

- **Minimize hydrogen consumption:** Reduce fuel costs by using the fuel cell efficiently.  
- **Minimize component degradation:** Extend the lifespan of the fuel cell and battery by avoiding damaging operating conditions.  
- **Satisfy all physical constraints:** Operate the vehicle safely within component limits.

---

## 🔬 System Model & Powertrain

The study is based on a simulated midsize sedan equipped with a hybrid powertrain consisting of:

- **Proton Exchange Membrane Fuel Cell (PEMFC):** 30 kW  
- **Lithium‑ion Battery Pack:** Handles transients and regenerative braking  
- **Electric Machine (EM):** 75 kW AC induction motor  

Detailed models for vehicle dynamics, fuel cell degradation (start‑stop cycles, load variations, transients), and battery State‑of‑Health (SoH) ensure realistic cost optimization.

---

## ⚙️ Control Strategy: Nonlinear MPC

A nonlinear Model Predictive Control framework manages the vehicle’s energy flow:

- **Objective:** At each time step, solve over a finite prediction horizon for optimal fuel‑cell power.  
- **Cost function:**  
  $$
  J = \text{Cost}_{H_2} + \text{Cost}_{FC\_degradation} + \text{Cost}_{Battery\_degradation} + \text{Penalty}_{SoC}
  $$  
- **Solver:** Dynamic Programming (DP) within each receding horizon to solve the constrained optimization.  
- **Constraints:** Respect min/max fuel‑cell power, battery current limits, and safe SoC/SoH ranges.

---

## 📊 Key Findings

The MPC strategy was validated on the US_06 highway cycle and compared to a rule‑based strategy:

| Metric                         | Rule‑Based | MPC      | Improvement |
|--------------------------------|------------|----------|-------------|
| Total Operating Cost (USD)     | 1.1242     | 1.0770   | –4.2 %      |
| Hydrogen Consumed (kg)         | 0.0841     | 0.0883   | +4.9 %      |

> **Note:** Average cost reduction of 14.2 % and fuel‑cell lifespan extension of 8.5 % across multiple tests.

**Conclusion:** The MPC strategy lowers total cost by trading a small increase in hydrogen use for a significant reduction in component degradation, extending vehicle economic life.

---

## 📜 Read the Full Report

For full system models, control design details, and simulation results, please read the full report:

➡️ [View Report.pdf](./Report.pdf)
