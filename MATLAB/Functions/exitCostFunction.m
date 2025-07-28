function [SimCosts] = exitCostFunction(SoC,P_FC_state,SoH,Delta_P_FC)
%MYCOSTFUNCTION Summary of this function goes here
%   Detailed explanation goes here

%% OSS: nell'esempio giapponese, gli slack non appaiono al costo primo stage, e lo stato e ingresso non appaiono all'ultimo stage

global Ts P_FC_max p_H2 p_BAT p_stack

Driving_period = length(P_FC_state)-1;
P_FC = [P_FC_state; P_FC_state(Driving_period+1)];

%% C_H2: Hydrogen consumption cost
LHV_H2 = 120000; % J/g

P_H2 = P_FC_to_P_H2(P_FC_state);
C_H2 = p_H2/1000*Ts*P_H2/LHV_H2;   %fattore 1000 di conversione massa da Kg in g

%% C_FC: Fuel Cell degradation cost
alpha_on_off = 13.79;   % (uV/cycle)
alpha_high = 10;        % (uV/h)
alpha_low = 8.66;       % (uV/h)
alpha_shift = 0.0441;   % (uV/DeltakW)
N_FC = 300;             % no of cells
U_EoL_FC = 60000;       % (uV)

N_cycle = zeros(Driving_period+1,1);
T_high = zeros(Driving_period+1,1);
T_low = zeros(Driving_period+1,1);
for i=1:Driving_period+1
    P_FC_prev = P_FC(i);
    P_FC_curr = P_FC(i+1);
    N_cycle(i) = N_cycle_calculator(P_FC_prev,P_FC_curr);
    [T_high(i), T_low(i)] = timeOfHighLowLoadings(P_FC_prev,P_FC_max,Ts);
end
%DEBUG
% N_cycle = 0;
% T_high = 0;
% T_low = 0;

C_cycle = alpha_on_off*N_cycle/U_EoL_FC*p_stack;
C_high = alpha_high*T_high/3600/U_EoL_FC*p_stack;
C_low = alpha_low*T_low/3600/U_EoL_FC*p_stack;
C_shift = alpha_shift*abs(Delta_P_FC)*Ts/1000/N_FC/U_EoL_FC*p_stack;

C_FC = C_cycle + C_high + C_low + C_shift;

%% C_BAT: Battery degradation cost (AT FIRST STAGE)
C_BAT = (SoH(1:Driving_period+1)-[SoH(2:Driving_period+1); SoH(Driving_period+1)])*p_BAT;

%% C_ELEC: Battery over-charge/over-discharge penalty
E_BAT = 7400; % Wh
eta_FCS = zeros(Driving_period+1,1);
for i=1:Driving_period+1
    eta_FCS(i) = eta_FCS_fcn(P_FC(i));
end
DeltaSoC = SoC(1:Driving_period+1)-[SoC(2:Driving_period+1); SoC(Driving_period+1)];
C_ELEC = DeltaSoC./eta_FCS*p_H2*E_BAT*3600/(1000*LHV_H2);   % C_ELEC può essere negativo, indicando un aumento della massa di H2


%% Total cost function
Ji = C_H2 + C_FC + C_BAT + C_ELEC; % Costo ad ogni istante
C_H2_sum = sum(C_H2);
C_FC_sum = sum(C_FC);
C_BAT_sum = sum(C_BAT);
C_ELEC_sum = sum(C_ELEC);
Jtot = sum(Ji);

SimCosts.PerTime.C_H2 = C_H2;
SimCosts.PerTime.C_cycle = C_cycle;
SimCosts.PerTime.C_high = C_high;
SimCosts.PerTime.C_low = C_low;
SimCosts.PerTime.C_shift = C_shift;
SimCosts.PerTime.C_FC = C_FC;
SimCosts.PerTime.C_BAT = C_BAT;
SimCosts.PerTime.C_ELEC = C_ELEC;
SimCosts.PerTime.Ji = Ji;
SimCosts.Total.C_H2 = C_H2_sum;
SimCosts.Total.C_cycle = sum(C_cycle);
SimCosts.Total.C_high = sum(C_high);
SimCosts.Total.C_low = sum(C_low);
SimCosts.Total.C_shift = sum(C_shift);
SimCosts.Total.C_FC = C_FC_sum;
SimCosts.Total.C_BAT = C_BAT_sum;
SimCosts.Total.C_ELEC = C_ELEC_sum;
SimCosts.Total.Jtot = Jtot;
SimCosts.N_cycle = sum(N_cycle);
end

