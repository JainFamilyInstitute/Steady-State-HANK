% INTEGER     :: it,ii,itfg
% REAL(8)     :: lldK,ldiffB,ldiffK,lminmargcost,lpvgovbc,lpvlumpincr,linitlumpincr
% REAL(8), DIMENSION(Ttransition) :: lcapital,lcapital1,lbond,lfirmdiscount,lrb,lfundbond,lworldbond,lrgov
% global tab_7and_8;
iteratingtransition = true;

lminmargcost = 0.01;

if Display && stickytransition; fprintf('Solving for sticky price transition\n'); end

% guess capital demand and liquid return

% construct sequence of guesses of capital: assume log linear in capital (constant if a temporary transition)
lldK = log(equmINITSS.capital/equmINITSS.capital)/Ttransition;
equmTRANS.capital = equmINITSS.capital*exp(lldK*[0 2:Ttransition]);
equmTRANS.labor = repmat(equmINITSS.labor,1,Ttransition);
equmTRANS.pi = repmat(equmINITSS.pi,1,Ttransition);

% construct sequence of guesses of Rb
if IncludeForwardGuideShock
%     itfg = MINLOC(cumdeltatrans, 1, MASK = cumdeltatrans>=ForwardGuideShockQtrs)
    itfg=find(cumdeltatrans>=ForwardGuideShockQtrs,1);
    equmTRANS.rnom = equmINITSS.rnom + [repmat(phifg,1,itfg-1) repmat(phitaylor,1,Ttransition-itfg+1)]*equmTRANS.pi' + equmTRANS.mpshock;
else
    equmTRANS.rnom = equmINITSS.rnom + phitaylor*equmTRANS.pi + equmTRANS.mpshock;
end
equmTRANS.rb = equmTRANS.rnom - equmTRANS.pi;
% equmTRANS.rborr = equmTRANS.rb+ equmTRANS.borrwedge;

ii = 1;
ldiffK = 1;
ldiffB = 1;

%%% load solution

trans = load(transol);
equmTRANS.capital = trans.capital;
equmTRANS.labor = trans.labor;
equmTRANS.pi = trans.pi;
equmTRANS.rb = trans.rb;
clear transol

% if MonetaryShockSize == -0.0025
%     trans = load('trans');
%     equmTRANS.capital = trans.capital;
%     equmTRANS.labor = trans.labor;
%     equmTRANS.pi = trans.pi;
%     equmTRANS.rb = trans.rb;
%     clear trans
% 
% else
%     %trans = load('transol_negativemps');
%     trans = load('transol_negativemps_updated');
%     equmTRANS.capital = trans.capital;
%     equmTRANS.labor = trans.labor;
%     equmTRANS.pi = trans.pi;
%     equmTRANS.rb = trans.rb;
%     %clear transol_negativemps
%     clear transol_negativemps_updated
% 
% end
% Elapsed time is 73.563902 seconds.
%   Transition iter 602:
%    K err 1.07527244720663e-10,  B err 8.46800696728577e-07
%    household bond 1.6195372438334,  target bond 1.61953724383552
% ii=1587;

equmTRANS.ra = equmINITSS.ra;

% reduce time taken. See if results are more or less accurate.
% toltransition = 5*10^-6;
% maxitertranssticky = 500;
Time1=tic;
while ii<=maxitertranssticky && max(ldiffK,ldiffB)>toltransition
    %save('trans2','-struct','equmTRANS')
    
    % solve for transtion
    tic;Transition;toc
    
    % computed implied equilibrium quantities
    lbond = [statsTRANS.Eb];
    lcapital = ([statsTRANS.Ea] - equmTRANS.equity)./ (1 - equmTRANS.fundlev);
    lfundbond = -lcapital.*equmTRANS.fundlev;
    lworldbond = -lbond - equmTRANS.govbond - lfundbond;
    lrb = WorldBondInverse2( diff([lworldbond equmINITSS.worldbond])./(bondadjust*deltatransvec) + lworldbond,equmINITSS.worldbond,equmINITSS.rb,bondelast);

    if ConvergenceRelToOutput
        ldiffK = max(abs(lcapital-equmTRANS.capital)/equmINITSS.output);
        ldiffB = max(abs(lbond-equmTRANS.bond)/equmINITSS.output);
    else
        ldiffK = max(abs(lcapital/equmTRANS.capital - 1));
        ldiffB = max(abs(lbond/equmTRANS.bond - 1));
    end
    if Display
        fprintf('  Transition iter %d:\n',ii)
        fprintf('   K err %.15g,  B err %.15g\n',ldiffK,ldiffB)
        fprintf('   household bond %.15g,  target bond %.15g\n',lbond(2),equmTRANS.bond(2))
    end
    
    % update capital and interest rate
    % Partial Update is from Procedures
    if ii<maxitertranssticky && max(ldiffK,ldiffB)>toltransition
        equmTRANS.capital(2:Ttransition) = PartialUpdate(Ttransition-1,stepstickytransK,equmTRANS.capital(2:Ttransition),lcapital(2:Ttransition));
        equmTRANS.rb = PartialUpdate(Ttransition,stepstickytransB,equmTRANS.rb,lrb);
    else
        % run distribution stats with full
        iteratingtransition = false;
        
        % %%% have to specify else will save the entire workspace
        if MonetaryShockSize == 0.0025
            if tab_7and_8 ==6    
               save('trans_tab7c2_negativemps.mat','-struct','equmTRANS');  
            elseif tab_7and_8 ==7
               save('trans_tab7c3_negativemps_updated.mat','-struct','equmTRANS');
            elseif tab_7and_8 ==10
               save('trans_tab7c6_negativemps_updated.mat','-struct','equmTRANS');
            elseif tab_7and_8 ==2 
               save('trans_tab8c2_negativemps_updated.mat','-struct','equmTRANS'); 
            end
        end
        % fprintf('Calculating transition solution takes %s\n',duration([0, 0, toc(Time1)]));

%         save('trans_negativemps_updated3.mat','-struct','equmTRANS');
        tic;Transition;toc
        equmTRANS.capital = lcapital;
        equmTRANS.bond = lbond;
        equmTRANS.rb = lrb;
        
    end
    % inflation
    if IncludeForwardGuideShock
        equmTRANS.pi = (equmTRANS.rb - equmINITSS.rnom - equmTRANS.mpshock) / ([repmat(phifg,1,itfg-1) repmat(phitaylor,1,Ttransition-itfg+1)]-1); % taylor rule
    else
        equmTRANS.pi = (equmTRANS.rb - equmINITSS.rnom - equmTRANS.mpshock) / (phitaylor-1); % taylor rule
    end        
    % nominal interest rates
    equmTRANS.rnom = equmTRANS.rb + equmTRANS.pi; % fisher equn
    % labor
    equmTRANS.labor = [statsTRANS.Elabor];

   
    ii = ii+1;
         
end
if stickytransition
    irf.equmSTICKY = equmTRANS;
    irf.statsSTICKY = statsTRANS;
    irf.solnSTICKY = solnTRANS;
end

