function cineq = myIneqConFunction(i,x,u,e,params)
%MYINEQCONFUNCTION Summary of this function goes here
%   Detailed explanation goes here

global eta_DC_DC Ts

% Parametri
I_bat_min = 10*(-35);   % (A)
I_bat_max = 10*(70);    % (A)
SoC_min = 0.58;      % di default 0.58
SoC_max = 0.82;
SoH_min = 0;
SoH_max = 1;

% Calcoli
P_bat = u(2) - (x(2) + Ts*u(1))*eta_DC_DC;  
I_bat = I_batFcn(P_bat,params);

% Vincoli
cineq = [I_bat_min - I_bat - e(1);    ...     % Lower bound for I_bat
         I_bat - I_bat_max - e(1);    ...     % Upper bound for I_bat
         SoC_min - x(1)    - e(2);    ...     % Lower bound for SoC
         x(1) - SoC_max    - e(2);    ...     % Upper bound for SoC
         SoH_min - x(3)    - e(3);    ...     % Lower bound for SoH
         x(3) - SoH_max    - e(3)];           % Upper bound for SoH

end

