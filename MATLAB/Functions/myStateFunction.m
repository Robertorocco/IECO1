function x_next = myStateFunction(x,u,params)
%MYSTATEFUNCTION Summary of this function goes here
%   Detailed explanation goes here

% States x(k) = [ SoC(k)
%                 P_FC(k-1) (W)
%                 SoH(k)]
%
% Inputs u = [ Increment of fuel cell power per step Delta_P_FC(k)
%              Power_demand P_DC(k) (Delta_kW/Delta_s)]

global eta_DC_DC Ts

x_next = zeros(3,1);

%% Parametetri
eta_bat = 0.95;     % (adimensional)
Q_bat = 23;         % (Ah)
Q_cell = 2;         % (Ah)
c_rate = 2;         % (Corrente corrispondente a C_rate 1)

%% Grandezze utili
P_bat = u(2) - (x(2) + Ts*u(1))*eta_DC_DC;
I_bat = I_batFcn(P_bat, params);            % corrente di tutto il pacco batterie
i_cell = I_bat/10;                          % 10 moduli in parallelo
current_c_rate = abs(i_cell) / c_rate;      % il current_c_rate è riferito alla cella (non al pacco di batterie)
N_EoL = N_EoL_Fcn(current_c_rate);

%DEBUG
% if N_EoL<0
%     N_EoL
%     current_c_rate
% end

%% Evoluzione dello stato
x_next(1) = x(1) - eta_bat*Ts/(Q_bat*3600)*I_bat;
x_next(2) = x(2) + Ts*u(1);
x_next(3) = x(3) - abs(i_cell)*Ts/(2*N_EoL*Q_cell*3600);

end