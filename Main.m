%%
clearvars; clc; close all;
%%
Time1=tic;
SetParameters
MonetaryShockSize = 0.0025;

%% choose case to run 

tab_7and_8 = 5;  % 5 is baseline case

    
switch tab_7and_8 

case 10
frisch = 0.5; 
rho = 0.0133348071;

case 9
phitaylor = 2;

case 8
theta = 50;    

case 7
profdistfrac = 0.11;    

case 6
profdistfrac = 1;  

case 5   
% baseline    

case 4
% not working
AdjGovBudgetConstraint = 3;

case 3
% not working
AdjGovBudgetConstraint = 4;

case 2
AdjGovBudgetConstraint = 1;

case 1
% AdjGovBudgetConstraint = 2; % also the  baseline

end


%%
% distcomp.feature('LocalUseMpiexec',false);parpool('local',ngpy);
Procedures
%%
%if CalibrateCostFunction; Calibration; end
%%
InitialSteadyState
%%
SaveSteadyStateOutput
%%
% FinalSteadyState

if OneAssetNoCapital
    cd(OutputDir2)
end

save('Final_SS_entire.mat');

%% Making Workspace Steady State 
% Steady State
clearvars;   

load('Final_SS_entire.mat');
MakeSteadyStateWorkspace

%% Transition Dynamics 
clc;clearvars; close all;
load('Final_SS_entire.mat');

% Time2=tic;

DoImpulseResponses=true;
initialSS=true;

fprintf('Started Transition Dynamics:\n');

if tab_7and_8 ==5 || tab_7and_8 ==1 
    if MonetaryShockSize == -0.0025
        transol='trans_positivemps';
    elseif MonetaryShockSize == 0.0025  
        transol='trans_negativemps_updated2';
    end
else    
    if  profdistfrac==0.11
        transol='trans_tab7c3';
    elseif  profdistfrac==1
        transol='trans_tab7c2';    
    elseif  theta==50
        transol='trans_tab7c4'; 
    elseif  phitaylor==2
        transol='trans_tab7c5';     
    elseif frisch == 0.5 && rho == 0.0133348071
        transol='trans_tab7c6'; 
    elseif AdjGovBudgetConstraint == 1
        transol='trans_tab8c2';     
    end

    if MonetaryShockSize == 0.0025
        transol=strcat(transol,'_negativemps');
    elseif MonetaryShockSize == -0.0025  
        transol=strcat(transol,'_positivemps');
    end 

end

if DoImpulseResponses; ImpulseResponses; end

%% Making Transition Dynamics Workspaces

% clearvars;

MakeTransitionWorkspaces
 
%% Plotting Figures
% Steady State
clc
close all;
% load('Final_SS_entire.mat');
figname='baseline_';
if  profdistfrac==0.11
    figname='tab7c3_';
elseif  profdistfrac==1
    figname='tab7c2_';    
elseif  theta==50
    figname='tab7c4_'; 
elseif  phitaylor==2
    figname='tab7c5_';     
elseif frisch == 0.5 && rho == 0.0133348071
    figname='tab7c6_'; 
elseif AdjGovBudgetConstraint == 1
    figname='tab8c2_';     
end

fprintf('Plotting Steady State Figures\n');
PlotSteadyStateFigures

%%
% Transition
clc
close all;
fprintf('Plotting Transition Figures\n');
figname='baseline_';
PlotTransitionFigures
fprintf('Total time required is: %s\n',duration([0, 0, toc(Time1)]));

%%

if tab_7and_8 ~=5 
    TransTableOutDir=strcat(cd,'\TransitionFigures\Tables7_And_8\');
    mkdir(TransTableOutDir);
    
    switch tab_7and_8 

    case 10
    transtable_fname='Table7_col_6';

    case 9
    transtable_fname='Table7_col_5';

    case 8
    transtable_fname='Table7_col_4';
    
    case 7   
    transtable_fname='Table7_col_3';
    
    case 6 
    transtable_fname='Table7_col_2';
    
    case 4
    % not working
    transtable_fname='Table8_col_4';

    case 3
    transtable_fname='Table8_col_3';

    case 2
    % not working
    transtable_fname='Table8_col_2';

    end
    if MonetaryShockSize == 0.0025
        transtable_fname=strcat(transtable_fname,'_negativemps.txt');
    elseif MonetaryShockSize == -0.0025  
        transtable_fname=strcat(transtable_fname,'_positivemps.txt');
    end    
    Decomposition
end
