function P_H2 = P_FC_to_P_H2(P_FC)
%P_FC_TO_P_H2 Summary of this function goes here


P_FC = P_FC/1000;

% Quadratic equation parameters (il fit è fatto in kW)
a0 = 2393.12/1000;
a1 = 1.15;
a2 = 2.38/100;

P_H2 = a2*P_FC.^2 + a1*P_FC + a0;   % NOTA CHE LA FUEL CELL FUNZIONA ANCHE QUANDO NON SI USA POTENZA IN USCITA

P_H2 = P_H2*1000;
end