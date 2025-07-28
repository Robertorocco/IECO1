driving_cycle_name = 'US_06_HWY';
folder_name = strcat('Simulazioni/',driving_cycle_name,'/');

% Nostra simulazione
SimCosts10 = cell2mat(struct2cell(load(strcat(folder_name,'w_soc4/SimCosts'))));

% Loro simulazione
SimCosts_RB = cell2mat(struct2cell(load('Simulazioni/Rule_Based/SimCosts')));
SimCosts_RB.PerTime.Ji(1) = SimCosts_RB.PerTime.Ji(1) + 0.6412;

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

%Massa H2
p_H2 = 4;   % USD/kg
MH2_RB = SimCosts_RB.PerTime.C_H2/p_H2;
MH2_10 = SimCosts10.PerTime.C_H2/p_H2;

MH2_RT_TOTAL = sum(MH2_RB);
MH2_10_TOTAL = sum(MH2_10);

time = 0:369-1;

% Grafici
f2 = figure('Position', get(0, 'Screensize'));
subplot(1,2,1)
grid on
hold on
plot(time,cumsum(MH2_RB),'LineWidth',spessoreGrafici)
plot(time,cumsum(MH2_10),'LineWidth',spessoreGrafici)
hold off
ylabel('M_{H2} (kg)','FontSize',dimensioneTesto)
xlabel('Time (s)','FontSize',dimensioneTesto)
title('(a) Hydrogen Mass Consumption','FontSize',dimensioneTesto)
legend({sprintf('Rule based strategy: %.4f kg', MH2_RT_TOTAL), sprintf('Cost minimization: %.4f kg', MH2_10_TOTAL)},'Location','northwest')
box on
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',dimensioneTesto)

% Costi totali
subplot(1,2,2)
grid on
hold on
plot(time,cumsum(SimCosts_RB.PerTime.Ji),'LineWidth',spessoreGrafici)
plot(time,cumsum(SimCosts10.PerTime.Ji),'LineWidth',spessoreGrafici)
hold off
ylabel('C_{Total} (USD)','FontSize',dimensioneTesto)
xlabel('Time (s)','FontSize',dimensioneTesto)
title('(b) Vehicular Total Operating Cost','FontSize',dimensioneTesto)
legend({sprintf('Rule based strategy: $%.4f',SimCosts_RB.Total.Jtot+ 0.6412), sprintf('Cost minimization: $%.4f', SimCosts10.Total.Jtot)},'Location','northwest')
box on
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',dimensioneTesto)

%% Salva immagine
saveas(f2, 'ROSSSSSSS_Costo.png','png');