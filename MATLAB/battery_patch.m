%Dividiamo per 3 per approssimare le batterie di ADVISOR con quelle del
%nostro modello
ess_max_ah_cap = ess_max_ah_cap/3;
ess_r_dis = ess_r_dis/3;
ess_r_chg = ess_r_chg/3;
ess_voc =ess_voc/3;
ess_min_volts=ess_min_volts/3;
ess_max_volts = ess_max_volts/3;
ess_module_mass = ess_module_mass/3;

ess_module_num = 97; %97 batterie in serie per un modulo
ess_cap_scale = 10; %10 moduli in parallelo
