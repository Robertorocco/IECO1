%% Questo script è chiamato alla fine della simulazione del modello ADVISOR
% Reshape variables
SoH = SoH(1,:)';
P_DC_pred = reshape(mdPrediction,[10,length(cyc_mph(:,2))])';
% mpc_ctrl_seq = reshape(mpc_ctrl_seq,[10,length(cyc_mph(:,2))])';

% Calcola costi per time e totali
SimCosts = exitCostFunction(SoC, P_FC_state, SoH, Delta_P_FC);

% Salva valori
w_soc_foldername = strcat(folder_name,sprintf('w_soc%d/',w_SoC));
% Se tenti di salvare in una cartella che non esiste dà errore
if ~exist(w_soc_foldername, 'dir')
       mkdir(w_soc_foldername)
end
save(strcat(w_soc_foldername,'SoC'),'SoC')
save(strcat(w_soc_foldername,'SoH'),'SoH')
save(strcat(w_soc_foldername,'P_FC'),'fc_pwr_out_a')
save(strcat(w_soc_foldername,'SimCosts'),'SimCosts')
save(strcat(w_soc_foldername,'Delta_P_FC'),'Delta_P_FC')
save(strcat(w_soc_foldername,'P_DC_pred'),'P_DC_pred')


% Velocity and P_DC (in kW) plot
figure
plot(cyc_mph(:,2))
hold on
plot(pb_pwr_out_r/1000)
hold off

% SoC plot
figure
plot(SoC)
title('SoC')

% SoH plot
figure
plot(SoH)
title('SoH')

%P_FC (in kW) plot 
figure
plot(fc_pwr_out_a/1000)
ylim([0 30])
title('P_{FC}')

% Delta_P_FC plot
figure
plot(Delta_P_FC)
title('Delta P_{FC}')

% H2 cumulative mass plot
p_H2 = 4;   % USD/kg
MH2 = SimCosts.PerTime.C_H2/p_H2;
figure
plot(cumsum(MH2))
title('Cumsum MH2')

% Total cumulative cost plot
figure
plot(cumsum(SimCosts.PerTime.Ji))
title('Cumsum costs')

% Plot ctrl_seq
% figure
% for i=1:length(cyc_mph(:,2))
%     plot(i:i+10,mpc_x_seq((i-1)*11+1:(i-1)*11+1+10,2))
%     hold on
%     pause(0.1)
% end
% figure
% for i=1:length(cyc_mph(:,2))
%     SoC_seq(i) = mpc_x_seq((i-1)*11+1);
% end


% Plot predizione
% figure
% for i=1:length(cyc_mph(:,2))
%     plot(i:i+9,P_DC_pred(i,:))
%     hold on
%     pause(0.2)
% end