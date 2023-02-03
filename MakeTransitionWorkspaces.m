%%
% clearvars -except Time1; close all; clc;

IRF={'Monetary'};
options.IRF=IRF;
STIM={'NOFS','PE1','PE2','PE3','PE4','PE5','PE6','PE7','PE8',...
                        'PE9','PE10','PE11','PE12','PE13','PE14','PE15'};
options.STIM=STIM;
PRICES={'sticky'};                    
options.OnlyWorkspace           = 1;  %for the PE experiments does not make figures
options.ipoint                  = 17; %17;
options.Quartiles               = 'Y';
% options.Save                    = 1;
options.LoadDistributions       = 1;
options.datagrosslabinc         = 69100;
options.dataannoutput           = 115000;

ShockType       = options.IRF;                          
StimulusType    = options.STIM;                         

options.prices = PRICES;
% BASEDIR='D:\University of Washington\HANK Literature\Codes for Heterogenous Models\myHANKReplication\ReplicateHank-Steady State';
% BASEDIR=cd;
options.BASEDIR=cd;
%%
    for i = 1:numel(IRF)
        for j = 1:numel(STIM)
            irfdir  = [options.BASEDIR,'\','IRF_',IRF{i},'\',STIM{j}];

            if (exist(irfdir,'dir')==7)
                disp(['Computing - ' IRF{i} '\' STIM{j}]);
    
                options.IRF                     = IRF{i};
                options.STIM                    = STIM{j};

                % Set options for types of price transitions
                for k = 1:numel(options.prices)
                    Z = (exist([irfdir,'\',upper(options.prices{k})],'dir')==7);
                    eval(sprintf('options.%s = Z;',options.prices{k}));
                end

                % Compute transition figures
                TransitionFigures_fun(options); 
                fprintf('Completed Workspace Construction for %s\n',STIM{j}); 
            end
        end
    end
    
    
    
    