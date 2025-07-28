function Ji = myCostFunctionStageFirst(i,x,u,e,params)
%MYCOSTFUNCTION Summary of this function goes here
%   Detailed explanation goes here

global Ts SoC_ini P_FC_max w_SoC p_H2 p_stack p_BAT

% State and Input get
SoC = x(1);
P_FC_prev = x(2);
SoH = x(3);
Delta_P_FC = u(1);

P_FC_curr = P_FC_prev + Ts*Delta_P_FC;

%% C_H2: Hydrogen consumption cost
LHV_H2 = 120000; % J/g

P_H2 = P_FC_to_P_H2(P_FC_curr);
C_H2 = p_H2*Ts*P_H2/1000/LHV_H2;   %fattore 1000 di conversione massa da Kg in g

%% C_FC: Fuel Cell degradation cost
alpha_on_off = 13.79;   % (uV/cycle)
alpha_high = 10;        % (uV/h)
alpha_low = 8.66;       % (uV/h)
alpha_shift = 0.0441;   % (uV/DeltakW)
N_FC = 300;             % no of cells
U_EoL_FC = 60000;       % (uV)

N_cycle = N_cycle_calculator(P_FC_prev,P_FC_curr);
[T_high, T_low] = timeOfHighLowLoadings(P_FC_curr,P_FC_max,Ts);
% DEBUG
% N_cycle = 0;
% T_high = 0;
% T_low = 0;

C_cycle = alpha_on_off*N_cycle/U_EoL_FC*p_stack;
C_high = alpha_high*T_high/3600/U_EoL_FC*p_stack;
C_low = alpha_low*T_low/3600/U_EoL_FC*p_stack;
C_shift = alpha_shift*abs(Delta_P_FC)*Ts/1000/N_FC/U_EoL_FC*p_stack;

C_FC = C_cycle + C_high + C_low + C_shift;

%% C_BAT: Battery degradation cost (AT FIRST STAGE)
C_BAT = SoH*p_BAT;

%% L_SoC: Battery over-charge/over-discharge penalty
L_SoC = w_SoC*(SoC-SoC_ini)^2;

%% Constraint violations penalty
l = sum(e+e.^2);

%% Total cost function
Ji = C_H2 + C_FC + C_BAT + L_SoC + l;

end

