% INTEGER     :: it,ii,itfg
% REAL(8)     :: lldK,ldiffB,ldiffK,lminmargcost,lpvgovbc,lpvlumpincr,linitlumpincr
% REAL(8), DIMENSION(Ttransition) :: lcapital,lcapital1,lbond,lfirmdiscount,lrb,lfundbond,lworldbond,lrgov
% global tab_7and_8;
iteratingtransition = true;

lminmargcost = 0.01;

if Display && stickytransition; fprintf('Solving for sticky price transition\n'); end

% guess capital demand and liquid return

% capital related stuff is zero
equmTRANS.fundbond = 0.0;
equmTRANS.caputil = 1.0;
equmTRANS.tfpadj = equmTRANS.tfp;
equmTRANS.deprec = deprec;
equmTRANS.investment = 0.0;
equmTRANS.KNratio = 0.0;
equmTRANS.KYratio = 0.0;
equmTRANS.rcapital = 0.0;
equmTRANS.dividend = 0.0;
equmTRANS.divrate = 0.0;
equmTRANS.ra = 0.0;
equmTRANS.equity = 0.0;
equmTRANS.illassetdrop = 1.0;	

equmTRANS.pi = equmINITSS.pi;

% construct sequence of guesses of Rb
if IncludeForwardGuideShock
    equmTRANS.rnom = equmINITSS.rnom + [repmat(phifg,1,itfg-1) repmat(phitaylor,1,Ttransition-itfg+1)]*equmTRANS.pi + equmTRANS.mpshock;
else
    equmTRANS.rnom = equmINITSS.rnom + phitaylor*equmTRANS.pi + equmTRANS.mpshock;
end
equmTRANS.rb = equmTRANS.rnom - equmTRANS.pi;
% equmTRANS.rborr = equmTRANS.rb+ equmTRANS.borrwedge;

ii = 1;
ldiffK = 1;
ldiffB = 1;

%%% load solution
% trans = load('trans_oneasset');
% equmTRANS.capital = trans.capital;
% equmTRANS.labor = trans.labor;
% equmTRANS.pi = trans.pi;
% equmTRANS.rb = trans.rb;
% clear trans_oneasset

equmTRANS.ra = equmINITSS.ra;

% reduce time taken. See if results are more or less accurate.
% toltransition = 10^-6;
% maxitertranssticky = 2500;

Time1=tic;
while ii<=maxitertranssticky && ldiffB>toltransition
    % save('trans2','-struct','equmTRANS')
    % solve for transtion
    tic;TransitionOneAsset;toc
    
    % computed implied equilibrium quantities
    lbond = [statsTRANS.Eb];
    %lcapital = ([statsTRANS.Ea] - equmTRANS.equity)./ (1 - equmTRANS.fundlev);
    if ConvergenceRelToOutput
        %ldiffK = max(abs(lcapital-equmTRANS.capital)/equmINITSS.output);
        ldiffB = max(abs(lbond-equmTRANS.bond)/equmINITSS.output);
    else
        %ldiffK = max(abs(lcapital/equmTRANS.capital - 1));
        ldiffB = max(abs(lbond/equmTRANS.bond - 1));
    end
    if Display
        fprintf('  Transition iter %d:\n',ii)
        fprintf('   B err %.15g\n',ldiffB)
        fprintf('   household bond %.15g,  target bond %.15g\n',lbond(2),equmTRANS.bond(2))
    end
    
    % update capital and interest rate
    % Partial Update is from Procedures
    if ii<maxitertranssticky && max(ldiffK,ldiffB)>toltransition
        
        lfundbond = 0;
        lworldbond = -lbond - equmTRANS.govbond - lfundbond;
        lrb = WorldBondInverse2( diff([lworldbond equmFINALSS.worldbond])./(bondadjust*deltatransvec) + lworldbond,equmINITSS.worldbond,equmINITSS.rb,bondelast);

        % equmTRANS.capital(2:Ttransition) = PartialUpdate(Ttransition-1,stepstickytransK,equmTRANS.capital(2:Ttransition),lcapital(2:Ttransition));
        equmTRANS.rb = PartialUpdate(Ttransition,stepstickytransB,equmTRANS.rb,lrb);
    else
        % run distribution stats with full
        iteratingtransition = false;
        tic;TransitionOneAsset;toc
        %equmTRANS.capital = lcapital;
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
%save the output
clc
save(trans_oneasset,'-struct','equmTRANS');
fprintf('Calculating transition solution takes %s\n',duration([0, 0, toc(Time1)]));

if stickytransition
    irf.equmSTICKY = equmTRANS;
    irf.statsSTICKY = statsTRANS;
    irf.solnSTICKY = solnTRANS;
end

