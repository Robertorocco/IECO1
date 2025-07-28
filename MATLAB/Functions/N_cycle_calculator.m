function N_cycle = N_cycle_calculator(P_FC_prev, P_FC_curr)
%N_CYCLE_CALCULATOR Calcola il numero di cicli di accensione delle celle a
%combustibile

sogliaMin = 3;  % (W) Soglia al di sotto della quale si considera spenta la cella

N_cycle = 0;
if P_FC_prev<sogliaMin
    if P_FC_curr>sogliaMin
        N_cycle=1;
    end
% else
%     if P_FC_curr<sogliaMin
%         N_cycle=1;
%     end
end

end

