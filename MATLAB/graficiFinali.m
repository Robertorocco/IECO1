P_DC_REQD = cell2mat(struct2cell(load(strcat(folder_name,driving_cycle_name,'_P_dc_req'))));
cyc_mph = cell2mat(struct2cell(load(strcat(folder_name,driving_cycle_name,'_cyc_mph'))));

% Usiamo i comandi struct2cell e poi cell2mat perché quando load ha un
% output, il dato viene convertito in una struttura
SoC1 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc1/SoC'))));
SoH1 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc1/SoH'))));
P_FC1 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc1/P_FC'))));
SimCosts1 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc1/SimCosts'))));
Delta_P_FC1 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc1/Delta_P_FC'))));
P_DC_pred1 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc1/P_DC_pred'))));

SoC4 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc4/SoC'))));
SoH4 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc4/SoH'))));
P_FC4 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc4/P_FC'))));
SimCosts4 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc4/SimCosts'))));
Delta_P_FC4 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc4/Delta_P_FC'))));
P_DC_pred4 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc4/P_DC_pred'))));

SoC10 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc10/SoC'))));
SoH10 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc10/SoH'))));
P_FC10 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc10/P_FC'))));
SimCosts10 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc10/SimCosts'))));
Delta_P_FC10 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc10/Delta_P_FC'))));
P_DC_pred10 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc10/P_DC_pred'))));

time = 0:length(cyc_mph)-1;
T = time(end)+1;

%% Colori matlab
matlabBlue = "#0072BD";
matlabOrange = "#D95319";
matlabYellow = "#EDB120";
matlabViolet = "#7E2F8E";
matlabGreen = "#77AC30";
matlabLightBlue = "#4DBEEE";
matlabBloodRed = "#A2142F";

spessoreGrafici = 1.5;  % 0.5 default
dimensioneTesto = 13;   % 11 default

%% GRAFICO DRIVING CYCLE
f = figure('Position', get(0, 'Screensize'));

% Velocità e P_DC
subplot(4,1,1)
grid on
yyaxis left
plot(time,cyc_mph*1.609344,'LineWidth',spessoreGrafici)
ylabel('Velocity (km/h)','FontSize',dimensioneTesto)
% ylim([0 50])
yyaxis right
plot(time,P_DC_REQD/1000,'LineWidth',spessoreGrafici)
ylabel('P_{dc} (kW)','FontSize',dimensioneTesto)
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',dimensioneTesto)

% P_FC
subplot(4,1,2)
grid on
hold on
p1 = plot(time,P_FC1/1000,'color',matlabBlue,'LineWidth',spessoreGrafici);
p2 = plot(time,P_FC4/1000,'color',matlabOrange,'LineWidth',spessoreGrafici);
p3 = plot(time,P_FC10/1000,'color',matlabYellow,'LineWidth',spessoreGrafici);
ylabel('P_{FC} (kW)','FontSize',dimensioneTesto)
ylim([0 30])
plot(time,0.2*P_FC_max/1000*ones(1,T),'--','Color','black')
plot(time,0.8*P_FC_max/1000*ones(1,T),'--','Color','black')
hold off
legend([p1,p2,p3],{'Wsoc=1', 'Wsoc=4', 'Wsoc=10'})  % Per non far apparire nella legend i tratteggi neri
text(30,27,'Fuel cell high loading boundary: 24kW');
text(90,4,'Fuel cell low loading boundary: 6kW');
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',dimensioneTesto)

% SoC
subplot(4,1,3)
grid on
hold on
plot(time,SoC1,'LineWidth',spessoreGrafici)
plot(time,SoC4,'LineWidth',spessoreGrafici)
plot(time,SoC10,'LineWidth',spessoreGrafici)
hold off
ylabel('SoC','FontSize',dimensioneTesto)
% ylim([0.67 0.71])
legend({'Wsoc=1', 'Wsoc=4', 'Wsoc=10'},'Location','southwest')
box on
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',dimensioneTesto)

% SoH
subplot(4,1,4)
grid on
hold on
plot(time,SoH1,'LineWidth',spessoreGrafici)
plot(time,SoH4,'LineWidth',spessoreGrafici)
plot(time,SoH10,'LineWidth',spessoreGrafici)
hold off
ylabel('SoH','FontSize',dimensioneTesto)
xlabel('Time (s)','FontSize',dimensioneTesto)
% ylim([0.9999 1])
legend({'Wsoc=1', 'Wsoc=4', 'Wsoc=10'})
box on
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',dimensioneTesto)

%% Salva immagine
saveas(f, strcat(folder_name,driving_cycle_name,'_general','.png'),'png');

%% GRAFICO COSTI E CONSUMO IDROGENO
f2 = figure('Position', get(0, 'Screensize'));

%Massa H2
p_H2 = 4;   % USD/kg
MH2_1 = SimCosts1.PerTime.C_H2/p_H2;
MH2_4 = SimCosts4.PerTime.C_H2/p_H2;
MH2_10 = SimCosts10.PerTime.C_H2/p_H2;

subplot(1,2,1)
grid on
hold on
plot(time,cumsum(MH2_1),'LineWidth',spessoreGrafici)
plot(time,cumsum(MH2_4),'LineWidth',spessoreGrafici)
plot(time,cumsum(MH2_10),'LineWidth',spessoreGrafici)
hold off
ylabel('M_{H2} (kg)','FontSize',dimensioneTesto)
xlabel('Time (s)','FontSize',dimensioneTesto)
title('(a) Hydrogen Mass Consumption','FontSize',dimensioneTesto)
legend({'Wsoc=1', 'Wsoc=4', 'Wsoc=10'},'Location','northwest')
box on
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',dimensioneTesto)

% Costi totali
subplot(1,2,2)
grid on
hold on
plot(time,cumsum(SimCosts1.PerTime.Ji),'LineWidth',spessoreGrafici)
plot(time,cumsum(SimCosts4.PerTime.Ji),'LineWidth',spessoreGrafici)
plot(time,cumsum(SimCosts10.PerTime.Ji),'LineWidth',spessoreGrafici)
hold off
ylabel('C_{Total} (USD)','FontSize',dimensioneTesto)
xlabel('Time (s)','FontSize',dimensioneTesto)
title('(b) Vehicular Total Operating Cost','FontSize',dimensioneTesto)
legend({'Wsoc=1', 'Wsoc=4', 'Wsoc=10'},'Location','northwest')
box on
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',dimensioneTesto)

%% Salva immagine
saveas(f2, strcat(folder_name,driving_cycle_name,'_Costs','.png'),'png');