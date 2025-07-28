function [T_high,T_low] = timeOfHighLowLoadings(P_FC_curr,P_FC_max,Ts)
%TIMEOFHIGHLOWLOADINGS Summary of this function goes here
%   Detailed explanation goes here

% Parameters
T_low = 0;
T_high = 0;
if(P_FC_curr<=0.2*P_FC_max)
    T_low = T_low + 1;
elseif(P_FC_curr>=0.8*P_FC_max)
    T_high = T_high + 1;
end
T_high = T_high*Ts;
T_low = T_low*Ts;

end

