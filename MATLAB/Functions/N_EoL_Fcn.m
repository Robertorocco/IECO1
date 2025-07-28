function N_EoL = N_EoL_Fcn(current_c_rate)
%N_EOL_FCN Summary of this function goes here
%   Detailed explanation goes here

%Parameters
% Q_cell = 2; % (Ah)
% R = 8.31;   % (J/mol)
% T = 298.2;  % (Kelvin)
% z = 0.55;
% B = 1;
% %% c_rate-B_coeff relationship
% if(current_c_rate<=1)
%     B = 31.630;
% elseif (current_c_rate<=4)
%     B = 21.681;
% elseif (current_c_rate<=8)
%     B = 12.934;
% else
%     B = 15.512;
% end
% 
% %% Ea coefficient
% Ea = 31700 - 370.3*current_c_rate;
% 
% Ah_EoL = (20/(B*exp(-Ea/(R*T))))^(1/z);
% 
% N_EoL = Ah_EoL/(Q_cell*3600);

% Parametri per la coda del grafico da 10c-rate a 35c-rate
b = -1/25*log(75);
a = 10*exp(-35*b);

if current_c_rate<=10
    N_EoL = -85.1648*current_c_rate^2 + 726.648*current_c_rate + 2000;
else
    N_EoL = a*exp(b*current_c_rate);
end

end

