function I_bat = I_batFcn(P_bat, params)
%I_BATFCN Determina la corrente che scorre nell'intero pacco batterie

%Parameters
R_bat = params(1);      % (Ohm)
Uoc = params(2);        % (volt)

I_bat = (Uoc - sqrt(Uoc^2 - 4*R_bat*P_bat))/(2*R_bat);

end