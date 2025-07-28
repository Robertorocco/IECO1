close all
global w_SoC p_H2 p_stack p_BAT

%% Selezione Driving Cycle
driving_cycle_name = 'US_06_HWY';
folder_name = strcat('Simulazioni/',driving_cycle_name,'/');
P_DC_REQ_filename = strcat(folder_name,driving_cycle_name,'_P_dc_req.mat');
load(P_DC_REQ_filename)

%% Selezione dei costi nella f. ob.
% C_H2                      
p_H2 = 4;                   % USD/kg normalmente 4
% C_FC         
gamma_stack = 93;           % (USD/kW)
p_stack = 30*gamma_stack;   %normalmente 30*gamma_stack
% C_BAT
gamma_BAT = 178.41;         % (USD/kWh)
p_BAT = 7.4*gamma_BAT*1;      % normalmente 7.4*gamma_BAT
% L_SoC
w_SoC = 10;

