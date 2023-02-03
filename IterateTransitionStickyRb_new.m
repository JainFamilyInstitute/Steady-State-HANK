% INTEGER     :: it,ii,itfg
% REAL(8)     :: lldK,ldiffB,ldiffK,lminmargcost,lpvgovbc,lpvlumpincr,linitlumpincr
% REAL(8), DIMENSION(Ttransition) :: lcapital,lcapital1,lbond,lfirmdiscount,lrb,lfundbond,lworldbond,lrgov

iteratingtransition = true;

lminmargcost = 0.01;

if Display && stickytransition; fprintf('Solving for sticky price transition\n'); end

% guess capital demand and liquid return

% construct sequence of guesses of capital: assume log linear in capital (constant if a temporary transition)
lldK = log(equmFINALSS.capital/equmINITSS.capital)/Ttransition;
equmTRANS.capital = equmINITSS.capital*exp(lldK*[0 2:Ttransition]);
equmTRANS.labor = repmat(equmINITSS.labor,1,Ttransition);
equmTRANS.pi = repmat(equmINITSS.pi,1,Ttransition);

% construct sequence of guesses of Rb
if IncludeForwardGuideShock
    equmTRANS.rnom = equmINITSS.rnom + [repmat(phifg,1,itfg-1) repmat(phitaylor,1,Ttransition-itfg+1)]*equmTRANS.pi + equmTRANS.mpshock;
else
    equmTRANS.rnom = equmINITSS.rnom + phitaylor*equmTRANS.pi + equmTRANS.mpshock;
end
equmTRANS.rb = equmTRANS.rnom - equmTRANS.pi;
% equmTRANS.rborr = equmTRANS.rb+ equmTRANS.borrwedge;

%%
if iteratingtransition
    equmTRANS.rborr = equmTRANS.rb + equmTRANS.borrwedge;
end
% world bond
equmTRANS.worldbond = [equmINITSS.worldbond WorldBondFunction2(equmTRANS.rb(1:Ttransition-1),equmINITSS.worldbond,equmINITSS.rb,bondelast)];
for it = 1:Ttransition-1
    equmTRANS.worldbond(it+1) = equmTRANS.worldbond(it) + bondadjust*deltatransvec(it)*(equmTRANS.worldbond(it+1)-equmTRANS.worldbond(it));
end

% fund bond
equmTRANS.fundbond = -equmTRANS.capital.*equmTRANS.fundlev;

% solve phillips curve backwards for marginal costs
switch FirmDiscountRate
    case 1; lfirmdiscount = equmTRANS.rho;
    case 2; lfirmdiscount = equmINITSS.rb;
    case 3; lfirmdiscount = equmINITSS.ra;
    case 4; lfirmdiscount = equmTRANS.rb;
    case 5; lfirmdiscount = equmTRANS.ra;
end

% marginal costs
equmTRANS.mc = max(lminmargcost,(lfirmdiscount-diff([equmTRANS.tfp equmFINALSS.tfp])./(equmTRANS.tfp.*deltatransvec) ...
    - alpha*diff([equmTRANS.capital equmFINALSS.capital])./(equmTRANS.capital.*deltatransvec) ...
    - alpha*diff([equmTRANS.caputil equmFINALSS.caputil])./(equmTRANS.caputil.*deltatransvec) ...
    - (1-alpha)*diff([equmTRANS.labor equmFINALSS.labor])./(equmTRANS.labor.*deltatransvec) ) ...
    .* [equmTRANS.pi(2:Ttransition) equmFINALSS.pi] * theta./ equmTRANS.elast ...
    + (equmTRANS.elast-1)./equmTRANS.elast - (diff([equmTRANS.pi equmFINALSS.pi])./deltatransvec) * theta./ equmTRANS.elast);

equmTRANS.gap = equmTRANS.elast.*equmTRANS.mc ./ (equmTRANS.elast-1) - 1;
equmTRANS.tfpadj = (equmTRANS.tfp.^((1+utilelast)/utilelastalpha)) .* (equmTRANS.mc*alpha./equmINITSS.rcapital).^(alpha*utilelast/utilelastalpha);
equmTRANS.KNratio = equmTRANS.capital./equmTRANS.labor;
equmTRANS.wage = equmTRANS.mc*(1-alpha).* equmTRANS.tfpadj .* equmTRANS.KNratio.^(alpha/utilelastalpha);
equmTRANS.netwage = (1-equmTRANS.labtax).*equmTRANS.wage;
equmTRANS.caputil = ((equmTRANS.mc*alpha.*equmTRANS.tfp/equmINITSS.rcapital) .* equmTRANS.KNratio.^(alpha-1)) .^ (utilelast/utilelastalpha);
equmTRANS.output = equmTRANS.tfpadj .* equmTRANS.capital.^(alpha/utilelastalpha) .* equmTRANS.labor.^((1-alpha)*(1+utilelast)/utilelastalpha);
equmTRANS.KYratio = (equmTRANS.KNratio.^(1-alpha)) ./ (equmTRANS.tfp.*equmTRANS.caputil.^alpha);
equmTRANS.rcapital = (equmINITSS.rcapital.^utilelast * equmTRANS.mc * alpha ./ equmTRANS.KYratio) .^ (1/(1+utilelast));
equmTRANS.priceadjust = theta/2*equmTRANS.pi.^2.*equmTRANS.capital./equmTRANS.KYratio;
equmTRANS.profit = (1-equmTRANS.mc).*equmTRANS.capital./equmTRANS.KYratio - equmTRANS.priceadjust;

equmTRANS.deprec = equmINITSS.deprec + (utilelast*equmINITSS.rcapital/(1+ utilelast)) .* ((equmTRANS.rcapital/equmINITSS.rcapital).^(1+utilelast) -1);

% solve backward for investment
equmTRANS.investment = diff([equmTRANS.capital equmFINALSS.capital])./deltatransvec + equmTRANS.deprec.*equmTRANS.capital;

% dividends and illiquid return
equmTRANS.dividend = equmTRANS.profit*(1-corptax);
if DistributeProfitsInProportion; equmTRANS.dividend = profdistfrac*equmTRANS.dividend; end

if DividendFundLumpSum; equmTRANS.divrate = 0;
else; equmTRANS.divrate = equmTRANS.dividend./equmTRANS.capital; end

equmTRANS.ra = (equmTRANS.rcapital.*equmTRANS.caputil - equmTRANS.deprec + equmTRANS.divrate - equmTRANS.fundlev.*equmTRANS.rb) ./ (1-equmTRANS.fundlev);

% value of equity component of investmemt fund
if DividendFundLumpSum
    it = Ttransition;
    equmTRANS.equity(it) = (equmFINALSS.equity + equmTRANS.dividend(it)*deltatransvec(it)) / (1+deltatransvec(it)*equmTRANS.ra(it));
    for it = Ttransition-1:-1:1
        equmTRANS.equity(it) = (equmTRANS.equity(it+1) + equmTRANS.dividend(it)*deltatransvec(it)) / (1+deltatransvec(it)*equmTRANS.ra(it));
    end
    equmTRANS.illassetdrop = ((1-equmTRANS.fundlev(1))*equmTRANS.capital(1) + equmTRANS.equity(1)) / ((1-equmINITSS.fundlev)*equmINITSS.capital + equmINITSS.equity);
else
    equmTRANS.equity = 0;
    equmTRANS.illassetdrop = 1;
end

% government budget constraint,expenditures and tax rates
switch AdjGovBudgetConstraint
    case 1 % adjust spending
        equmTRANS.govbond = equmINITSS.govbond;
        equmTRANS.labtax = equmINITSS.labtax;
        equmTRANS.lumptransfer = equmINITSS.lumptransfer;

        equmTRANS.taxrev = equmTRANS.labtax*equmTRANS.wage*equmTRANS.labor - equmTRANS.lumptransfer + corptax*equmTRANS.profit;
        if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.taxrev = equmTRANS.taxrev + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

        equmTRANS.govexp = equmTRANS.taxrev + equmTRANS.rb*equmINITSS.govbond;

    case 2 % adjust lump sum taxes
        equmTRANS.govbond = equmINITSS.govbond;
        equmTRANS.govexp = equmINITSS.govexp;
        equmTRANS.labtax = equmINITSS.labtax;
        equmTRANS.taxrev = equmTRANS.govexp - equmTRANS.rb*equmINITSS.govbond;
        equmTRANS.lumptransfer = equmTRANS.labtax*equmTRANS.wage.*equmTRANS.labor + corptax*equmTRANS.profit + equmTRANS.rb*equmINITSS.govbond - equmTRANS.govexp;
        if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.lumptransfer = equmTRANS.lumptransfer + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

    case 3 % adjust debt
        if GovExpConstantFracOutput; equmTRANS.govexp = equmTRANS.output*equmINITSS.govexp/equmINITSS.output;
        else; equmTRANS.govexp = repmat(equmINITSS.govexp,1,Ttransition); end

        equmTRANS.lumptransfer = equmINITSS.lumptransfer;
        equmTRANS.taxrev = equmTRANS.labtax*equmTRANS.wage*equmTRANS.labor - equmTRANS.lumptransfer + corptax*equmTRANS.profit;
        if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.taxrev = equmTRANS.taxrev + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

        % compute required increase in lumptransfer
        lrgov = equmTRANS.rb;
        lpvgovbc = equmFINALSS.govbond;
        lpvlumpincr = 0;
        for it = Ttransition:-1:1
            lpvgovbc = (lpvgovbc + deltatransvec(it)*(equmTRANS.govexp(it) - equmTRANS.taxrev(it)))/(1+deltatransvec(it)*lrgov(it));
            if cumdeltatrans(it)<taxincrstart; lpvlumpincr = lpvlumpincr/(1+deltatransvec(it)*lrgov(it));
            else; lpvlumpincr = (lpvlumpincr + deltatransvec(it))/(1+deltatransvec(it)*(lrgov(it)+taxincrdecay)); end
        end

        linitlumpincr = (equmINITSS.govbond-lpvgovbc) / lpvlumpincr;
        equmTRANS.lumptransfer = equmINITSS.lumptransfer + linitlumpincr*exp(-taxincrdecay*(cumdeltatrans-taxincrstart));
        equmTRANS.lumptransfer(cumdeltatrans<taxincrstart) = equmINITSS.lumptransfer;

        equmTRANS.taxrev = equmTRANS.labtax*equmTRANS.wage*equmTRANS.labor - equmTRANS.lumptransfer + corptax*equmTRANS.profit;
        if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.taxrev = equmTRANS.taxrev + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

        equmTRANS.govbond(Ttransition) = equmFINALSS.govbond;
        for it = Ttransition-1:-1:2
            equmTRANS.govbond(it) = (equmTRANS.govbond(it+1) - deltatransvec(it)*(equmTRANS.taxrev(it)-equmTRANS.govexp(it))) / (1+deltatransvec(it)*lrgov(it));
        end
        equmTRANS.govbond(1) = equmINITSS.govbond;

        equmTRANS.lumptransfer = equmTRANS.lumptransfer + (equmTRANS.rb-lrgov).*equmTRANS.govbond;
        equmTRANS.taxrev = equmTRANS.labtax*equmTRANS.wage*equmTRANS.labor - equmTRANS.lumptransfer + corptax*equmTRANS.profit;
        if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.taxrev = equmTRANS.taxrev + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

    case 4 % adjust proportional tax rate
        equmTRANS.govbond = equmINITSS.govbond;
        equmTRANS.govexp = equmINITSS.govexp;
        equmTRANS.lumptransfer = equmINITSS.lumptransfer;
        equmTRANS.taxrev = equmTRANS.govexp - equmTRANS.rb*equmINITSS.govbond;

        if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.labtax  = (equmTRANS.lumptransfer - corptax*equmTRANS.profit - equmTRANS.rb*equmINITSS.govbond + equmTRANS.govexp) / (equmTRANS.wage*equmTRANS.labor + (1-profdistfrac)*equmTRANS.profit*(1-corptax));
        else; equmTRANS.labtax  = (equmTRANS.lumptransfer - corptax*equmTRANS.profit - equmTRANS.rb*equmINITSS.govbond + equmTRANS.govexp) / (equmTRANS.wage*equmTRANS.labor); end
end

% household bonds
equmTRANS.bond = -equmTRANS.worldbond - equmTRANS.govbond - equmTRANS.fundbond;

%%
ii = 1;
ldiffK = 1;
ldiffB = 1;

% load solution
trans = load('trans');
% trans = load('trans2');
equmTRANS.capital = trans.capital;
equmTRANS.labor = trans.labor;
equmTRANS.pi = trans.pi;
equmTRANS.rb = trans.rb;
clear trans
% clear trans2
% Elapsed time is 73.563902 seconds.
%   Transition iter 602:
%    K err 1.07527244720663e-10,  B err 8.46800696728577e-07
%    household bond 1.6195372438334,  target bond 1.61953724383552
% ii=1587;
%equmTRANS.ra = equmINITSS.ra;
while ii<=maxitertranssticky && max(ldiffK,ldiffB)>toltransition
    % save('trans2','-struct','equmTRANS')
    % solve for transtion
    tic;Transition;toc
    
    % computed implied equilibrium quantities
    lbond = [statsTRANS.Eb];
    lcapital = ([statsTRANS.Ea] - equmTRANS.equity)./ (1 - equmTRANS.fundlev);
    lfundbond = -lcapital.*equmTRANS.fundlev;
    lworldbond = -lbond - equmTRANS.govbond - lfundbond;
    lrb = WorldBondInverse2( diff([lworldbond equmFINALSS.worldbond])./(bondadjust*deltatransvec) + lworldbond,equmINITSS.worldbond,equmINITSS.rb,bondelast);

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
    if ii<maxitertranssticky && max(ldiffK,ldiffB)>toltransition
        equmTRANS.capital(2:Ttransition) = PartialUpdate(Ttransition-1,stepstickytransK,equmTRANS.capital(2:Ttransition),lcapital(2:Ttransition));
        equmTRANS.rb = PartialUpdate(Ttransition,stepstickytransB,equmTRANS.rb,lrb);
    else
        % run distribution stats with full
        iteratingtransition = false;
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
     
    if iteratingtransition
        equmTRANS.rborr = equmTRANS.rb + equmTRANS.borrwedge;
    end
    % world bond
    equmTRANS.worldbond = [equmINITSS.worldbond WorldBondFunction2(equmTRANS.rb(1:Ttransition-1),equmINITSS.worldbond,equmINITSS.rb,bondelast)];
    for it = 1:Ttransition-1
        equmTRANS.worldbond(it+1) = equmTRANS.worldbond(it) + bondadjust*deltatransvec(it)*(equmTRANS.worldbond(it+1)-equmTRANS.worldbond(it));
    end

    % fund bond
    equmTRANS.fundbond = -equmTRANS.capital.*equmTRANS.fundlev;

    switch FirmDiscountRate
        case 1; lfirmdiscount = equmTRANS.rho;
        case 2; lfirmdiscount = equmINITSS.rb;
        case 3; lfirmdiscount = equmINITSS.ra;
        case 4; lfirmdiscount = equmTRANS.rb;
        case 5; lfirmdiscount = equmTRANS.ra;
    end

    % marginal costs
    equmTRANS.mc = max(lminmargcost,(lfirmdiscount-diff([equmTRANS.tfp equmFINALSS.tfp])./(equmTRANS.tfp.*deltatransvec) ...
        - alpha*diff([equmTRANS.capital equmFINALSS.capital])./(equmTRANS.capital.*deltatransvec) ...
        - alpha*diff([equmTRANS.caputil equmFINALSS.caputil])./(equmTRANS.caputil.*deltatransvec) ...
        - (1-alpha)*diff([equmTRANS.labor equmFINALSS.labor])./(equmTRANS.labor.*deltatransvec) ) ...
        .* [equmTRANS.pi(2:Ttransition) equmFINALSS.pi] * theta./ equmTRANS.elast ...
        + (equmTRANS.elast-1)./equmTRANS.elast - (diff([equmTRANS.pi equmFINALSS.pi])./deltatransvec) * theta./ equmTRANS.elast);

    equmTRANS.gap = equmTRANS.elast.*equmTRANS.mc ./ (equmTRANS.elast-1) - 1;
    equmTRANS.tfpadj = (equmTRANS.tfp.^((1+utilelast)/utilelastalpha)) .* (equmTRANS.mc*alpha./equmINITSS.rcapital).^(alpha*utilelast/utilelastalpha);
    equmTRANS.KNratio = equmTRANS.capital./equmTRANS.labor;
    equmTRANS.wage = equmTRANS.mc*(1-alpha).* equmTRANS.tfpadj .* equmTRANS.KNratio.^(alpha/utilelastalpha);
    equmTRANS.netwage = (1-equmTRANS.labtax).*equmTRANS.wage;
    equmTRANS.caputil = ((equmTRANS.mc*alpha.*equmTRANS.tfp/equmINITSS.rcapital) .* equmTRANS.KNratio.^(alpha-1)) .^ (utilelast/utilelastalpha);
    equmTRANS.output = equmTRANS.tfpadj .* equmTRANS.capital.^(alpha/utilelastalpha) .* equmTRANS.labor.^((1-alpha)*(1+utilelast)/utilelastalpha);
    equmTRANS.KYratio = (equmTRANS.KNratio.^(1-alpha)) ./ (equmTRANS.tfp.*equmTRANS.caputil.^alpha);
    equmTRANS.rcapital = (equmINITSS.rcapital.^utilelast * equmTRANS.mc * alpha ./ equmTRANS.KYratio) .^ (1/(1+utilelast));
    equmTRANS.priceadjust = theta/2*equmTRANS.pi.^2.*equmTRANS.capital./equmTRANS.KYratio;
    equmTRANS.profit = (1-equmTRANS.mc).*equmTRANS.capital./equmTRANS.KYratio - equmTRANS.priceadjust;

    equmTRANS.deprec = equmINITSS.deprec + (utilelast*equmINITSS.rcapital/(1+ utilelast)) .* ((equmTRANS.rcapital/equmINITSS.rcapital).^(1+utilelast) -1);

    % solve backward for investment
    equmTRANS.investment = diff([equmTRANS.capital equmFINALSS.capital])./deltatransvec + equmTRANS.deprec.*equmTRANS.capital;

    % dividends and illiquid return
    equmTRANS.dividend = equmTRANS.profit*(1-corptax);
    if DistributeProfitsInProportion; equmTRANS.dividend = profdistfrac*equmTRANS.dividend; end

    if DividendFundLumpSum; equmTRANS.divrate = 0;
    else; equmTRANS.divrate = equmTRANS.dividend./equmTRANS.capital; end

    equmTRANS.ra = (equmTRANS.rcapital.*equmTRANS.caputil - equmTRANS.deprec + equmTRANS.divrate - equmTRANS.fundlev.*equmTRANS.rb) ./ (1-equmTRANS.fundlev);

    % value of equity component of investmemt fund
    if DividendFundLumpSum
        it = Ttransition;
        equmTRANS.equity(it) = (equmFINALSS.equity + equmTRANS.dividend(it)*deltatransvec(it)) / (1+deltatransvec(it)*equmTRANS.ra(it));
        for it = Ttransition-1:-1:1
            equmTRANS.equity(it) = (equmTRANS.equity(it+1) + equmTRANS.dividend(it)*deltatransvec(it)) / (1+deltatransvec(it)*equmTRANS.ra(it));
        end
        equmTRANS.illassetdrop = ((1-equmTRANS.fundlev(1))*equmTRANS.capital(1) + equmTRANS.equity(1)) / ((1-equmINITSS.fundlev)*equmINITSS.capital + equmINITSS.equity);
    else
        equmTRANS.equity = 0;
        equmTRANS.illassetdrop = 1;
    end

    % government budget constraint,expenditures and tax rates
    switch AdjGovBudgetConstraint
        case 1 % adjust spending
            equmTRANS.govbond = equmINITSS.govbond;
            equmTRANS.labtax = equmINITSS.labtax;
            equmTRANS.lumptransfer = equmINITSS.lumptransfer;

            equmTRANS.taxrev = equmTRANS.labtax*equmTRANS.wage*equmTRANS.labor - equmTRANS.lumptransfer + corptax*equmTRANS.profit;
            if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.taxrev = equmTRANS.taxrev + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

            equmTRANS.govexp = equmTRANS.taxrev + equmTRANS.rb*equmINITSS.govbond;

        case 2 % adjust lump sum taxes
            equmTRANS.govbond = equmINITSS.govbond;
            equmTRANS.govexp = equmINITSS.govexp;
            equmTRANS.labtax = equmINITSS.labtax;
            equmTRANS.taxrev = equmTRANS.govexp - equmTRANS.rb*equmINITSS.govbond;
            equmTRANS.lumptransfer = equmTRANS.labtax*equmTRANS.wage.*equmTRANS.labor + corptax*equmTRANS.profit + equmTRANS.rb*equmINITSS.govbond - equmTRANS.govexp;
            if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.lumptransfer = equmTRANS.lumptransfer + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

        case 3 % adjust debt
            if GovExpConstantFracOutput; equmTRANS.govexp = equmTRANS.output*equmINITSS.govexp/equmINITSS.output;
            else; equmTRANS.govexp = repmat(equmINITSS.govexp,1,Ttransition); end

            equmTRANS.lumptransfer = equmINITSS.lumptransfer;
            equmTRANS.taxrev = equmTRANS.labtax*equmTRANS.wage*equmTRANS.labor - equmTRANS.lumptransfer + corptax*equmTRANS.profit;
            if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.taxrev = equmTRANS.taxrev + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

            % compute required increase in lumptransfer
            lrgov = equmTRANS.rb;
            lpvgovbc = equmFINALSS.govbond;
            lpvlumpincr = 0;
            for it = Ttransition:-1:1
                lpvgovbc = (lpvgovbc + deltatransvec(it)*(equmTRANS.govexp(it) - equmTRANS.taxrev(it)))/(1+deltatransvec(it)*lrgov(it));
                if cumdeltatrans(it)<taxincrstart; lpvlumpincr = lpvlumpincr/(1+deltatransvec(it)*lrgov(it));
                else; lpvlumpincr = (lpvlumpincr + deltatransvec(it))/(1+deltatransvec(it)*(lrgov(it)+taxincrdecay)); end
            end

            linitlumpincr = (equmINITSS.govbond-lpvgovbc) / lpvlumpincr;
            equmTRANS.lumptransfer = equmINITSS.lumptransfer + linitlumpincr*exp(-taxincrdecay*(cumdeltatrans-taxincrstart));
            equmTRANS.lumptransfer(cumdeltatrans<taxincrstart) = equmINITSS.lumptransfer;

            equmTRANS.taxrev = equmTRANS.labtax*equmTRANS.wage*equmTRANS.labor - equmTRANS.lumptransfer + corptax*equmTRANS.profit;
            if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.taxrev = equmTRANS.taxrev + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

            equmTRANS.govbond(Ttransition) = equmFINALSS.govbond;
            for it = Ttransition-1:-1:2
                equmTRANS.govbond(it) = (equmTRANS.govbond(it+1) - deltatransvec(it)*(equmTRANS.taxrev(it)-equmTRANS.govexp(it))) / (1+deltatransvec(it)*lrgov(it));
            end
            equmTRANS.govbond(1) = equmINITSS.govbond;

            equmTRANS.lumptransfer = equmTRANS.lumptransfer + (equmTRANS.rb-lrgov).*equmTRANS.govbond;
            equmTRANS.taxrev = equmTRANS.labtax*equmTRANS.wage*equmTRANS.labor - equmTRANS.lumptransfer + corptax*equmTRANS.profit;
            if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.taxrev = equmTRANS.taxrev + equmTRANS.labtax*(1-profdistfrac)*equmTRANS.profit*(1-corptax); end

        case 4 % adjust proportional tax rate
            equmTRANS.govbond = equmINITSS.govbond;
            equmTRANS.govexp = equmINITSS.govexp;
            equmTRANS.lumptransfer = equmINITSS.lumptransfer;
            equmTRANS.taxrev = equmTRANS.govexp - equmTRANS.rb*equmINITSS.govbond;

            if DistributeProfitsInProportion && TaxHHProfitIncome; equmTRANS.labtax  = (equmTRANS.lumptransfer - corptax*equmTRANS.profit - equmTRANS.rb*equmINITSS.govbond + equmTRANS.govexp) / (equmTRANS.wage*equmTRANS.labor + (1-profdistfrac)*equmTRANS.profit*(1-corptax));
            else; equmTRANS.labtax  = (equmTRANS.lumptransfer - corptax*equmTRANS.profit - equmTRANS.rb*equmINITSS.govbond + equmTRANS.govexp) / (equmTRANS.wage*equmTRANS.labor); end
    end

    % household bonds
    equmTRANS.bond = -equmTRANS.worldbond - equmTRANS.govbond - equmTRANS.fundbond;

    ii = ii+1;
end
% save('trans2','-struct','equmTRANS')
if stickytransition
    irf.equmSTICKY = equmTRANS;
    irf.statsSTICKY = statsTRANS;
    irf.solnSTICKY = solnTRANS;
end

