function y = myOutputFunction(x,u,params)
%MYSTATEFUNCTION Summary of this function goes here
%   Detailed explanation goes here

% States x(k) = [ SoC(k)
%                 P_FC(k-1)]

% Inputs u = [ Increment of fuel cell power per step Delta_P_FC(k)
%              Power_demand P_DC(k)]

y = x;

end

