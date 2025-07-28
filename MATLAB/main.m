%% Parameters
global eta_DC_DC Ts SoC_ini P_FC_max
eta_DC_DC = 1;
Ts = 1;

%% Valori nominali di Rint e Voc
% 0.010Ohm è la resistenza della singola CELLA;
% *97 è la resistenza del singolo MODULO;
% /10 è la resistenza di tutto il PACCO
Rint = 0.010*97/10;
% 3.3V è la tensione della singola CELLA; 
% *97 è la tensione del MODULO, che coincide 
% con quella del PACCO, essendo i moduli in parallelo
Voc = 3.3*97;   


% params in ingresso al blocco non-linear MPC ha la seguente struttura:
% [R_int Voc]

%% MPC Design
nx = 3;     % numero di stati
nmv = 1;    % numero di variabili manipulate
nmd = 1;    % numero di disturbi misurati
PredictionHorizon = 10;
p = PredictionHorizon;
ControlHorizon = PredictionHorizon;

msobj = nlmpcMultistage(p,nx,MV=1,MD=2);
msobj.Ts = Ts;

%nomi alle variabili
% vedi se tenere le uscite per "ref" di MPC in simulink
msobj.States(1).Name = "SoC";
msobj.States(2).Name = "Previous_P_FC";
msobj.States(3).Name = "SoH";   %stato aggiunto da noi
msobj.MV.Name = "Delta_P_FC";
msobj.MD.Name = "P_DC";


%% Definizione del modello
msobj.Model.IsContinuousTime = false;
msobj.Model.StateFcn = "myStateFunction";
%msobj.Model.StateJacFcn = "";
msobj.Model.ParameterLength = 2;    % Rint + Voc

%% Cost function
msobj.Stages(1).CostFcn = "myCostFunctionStageFirst";
%msobj.Stages(1).CostJacFcn = "twolinkCostJacFcn";  % non possibile
%metterle perché definite a tratti (if)
for k = 2:p
    msobj.Stages(k).CostFcn = "myCostFunction";
    %msobj.Stages(k).CostJacFcn = "twolinkCostJacFcn";
end
msobj.Stages(p+1).CostFcn = "myCostFunctionStageLast";
%msobj.Stages(p+1).CostJacFcn = "twolinkCostJacFcn";

%% Constraints for manipulated variables
% Constraints parameters
P_FC_min = 0;               % (W)
P_FC_max = 30000;           % (W)
D_P_FC_min = -1000;         % (W/s)
D_P_FC_max = -D_P_FC_min;   % (W/s)


% Questi vincoli lineari sono applicati per tutto l'orizzonte?
% Hard Constraints
msobj.States(2).Min = P_FC_min;
msobj.States(2).Max = P_FC_max;
msobj.MV.Min = D_P_FC_min;
msobj.MV.Max = D_P_FC_max;

% Soft Constraints
for k = 1:p+1
    msobj.Stages(k).IneqConFcn = "myIneqConFunction";
    %msobj.Stages(k).IneqConJacFcn = "";
    msobj.Stages(k).ParameterLength = 2;    % Rint + Voc
    msobj.Stages(k).SlackVariableLength = 3;
end

%% Set Optimization Solver
msobj.Optimization.SolverOptions.Display = 'off';%iter-detailed';     % Per report a fine ottimizzazione
msobj.Optimization.SolverOptions.OptimalityTolerance = 1e-12;   % Se la misura di ottimalità del primo ordine è inferiore a OptimalityTolerance si ferma
msobj.Optimization.SolverOptions.StepTolerance = 1e-12;         % Se il solver fa un passo inferiore alla StepTolerance si ferma

%% Validazione MPC
% getSimData
simdata = getSimulationData(msobj);
simdata.StateFcnParameter = [Rint Voc]';
simdata.StageParameter = repmat([Rint Voc]', p+1, 1);
simdata.MeasuredDisturbance = 1100;

% Condizioni iniziali
P_FC_Init = 0;
D_P_FC_Init = 0;
SoC_ini = 0.7;
SoH_ini = 1;
x0 = [SoC_ini; P_FC_Init; SoH_ini];
u0 = zeros(nmv,1);

% Validate functions and data structure
validateFcns(msobj,x0,u0,simdata);

% Code Generation in MATLAB 
[mv,simdata,info] = nlmpcmove(msobj,x0,u0,simdata);

