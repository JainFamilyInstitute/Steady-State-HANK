clearvars; clc; close all;

TransTableOutDir=strcat('\\udrive.uw.edu\udrive\rdatta2\Downloads\ReplicateHank-Steady State',...
                '\TransitionFigures\Tables7_And_8\');
mkdir(TransTableOutDir);   

%% Set Baseline Parameters 
SetParameters
%%
global tab_7and_8;
% for tab_7and_8 = 10:-1:1
tab_7and_8 = 10;   
    % clearvars -except TransTableOutDir transtable_fname; 
    % set overall parameters (which is baseline case)
    % SetParameters
    
    switch tab_7and_8 
    
    case 10
    % not working 
    frisch = 0.5; 
    rho = 0.0133348071;
    transtable_fname='Table7_col_6.txt';    
 
    case 9
    phitaylor = 2;
    transtable_fname='Table7_col_5.txt';
        
    case 8
    theta = 50;    
    transtable_fname='Table7_col_4.txt';
        
    case 7
    profdistfrac = 0.1;    
    transtable_fname='Table7_col_3.txt';
    
    case 6
    profdistfrac = 1;  
    transtable_fname='Table7_col_2.txt';
    
    case 5   
    % baseline    
    transtable_fname='Table7_col_1.txt';
    
    case 4
    AdjGovBudgetConstraint = 3;
    transtable_fname='Table8_col_4.txt';
  
    case 3
    AdjGovBudgetConstraint = 4;
    transtable_fname='Table8_col_3.txt';
    
    case 2
    AdjGovBudgetConstraint = 1;
    transtable_fname='Table8_col_2.txt';
    
    case 1
    AdjGovBudgetConstraint = 2; % also the  baseline
    transtable_fname='Table8_col_1.txt';
  
    end

%%
Procedures
InitialSteadyState
SaveSteadyStateOutput
FinalSteadyState
 
%%   
fprintf('Started Transition Dynamics:\n');
if DoImpulseResponses; ImpulseResponses; end
%%
clearvars -except TransTableOutDir transtable_fname;

MakeSteadyStateWorkspace
MakeTransitionWorkspaces

%% Save Tables 7 and 8
clc;
clearvars -except TransTableOutDir transtable_fname;
close all;

% calculate Table and save under relvant filename
Decomposition
fprintf('Completed Table for case %d\n',tab_7_and_8);
%end






