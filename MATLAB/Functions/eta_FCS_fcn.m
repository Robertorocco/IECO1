function eta_FCS = eta_FCS_fcn(P_FC)
%ETA_FCS_FCN Summary of this function goes here
%   Detailed explanation goes here

% Da FC_ANL50H2_patch.m
fc_pwr_map=[0 2 5	7.5	10	20	30	40	50]*1000/5*3; % kW (net) including parasitic losses
fc_eff_map=[10 33 49.2	53.3	55.9	59.6	59.1	56.2	50.8]/100; % efficiency indexed by fc_pwr

if P_FC==fc_pwr_map(1)
    eta_FCS = fc_eff_map(1);
else
    for i=2:length(fc_eff_map)
        if(P_FC<=fc_pwr_map(i))
            eta_FCS = fc_eff_map(i);
            break
        end
    end
end

end

