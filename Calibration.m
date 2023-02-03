calibrating = true;

if CalibrateRhoAtInitialGuess
    if Display >= 1; fprintf('Calibrating rho at initial steady state\n'); end
    converged = false;
	neqmiter = 1;
	fopen(fullfile(OutputDir,'DiscountRateAtInitialGuess.txt'),'w');
    lrhoL = icdf('Logistic',exp([-0.02 8]));
	lrhoU = icdf('Logistic',exp([-0.01 8]));
    rho = fzero(@FnDiscountRate,lrhoL,lrhoU,optimset('TolX',1e-8));
    converged = true; 
    
end

%set up parameters
nparam = 0;
if (EstimateKappa0 == 1);nparam = nparam+1; end
if (EstimateKappa1 == 1);nparam = nparam+1;end
if (EstimateKappa2 == 1);nparam = nparam+1;end
if (EstimateKappa3 == 1);nparam = nparam+1;end
if (EstimateKappa4 == 1);nparam = nparam+1;end
if (EstimateRho == 1);nparam = nparam+1;end
if (EstimateBorrWedge == 1);nparam = nparam+1;end
if (EstimateGamma == 1);nparam = nparam+1;end


%set up moments
nmoments = 0;
if MatchMeanIll == 1;nmoments = nmoments+1;end
if MatchKYratio == 1;nmoments = nmoments+1;end
if MatchMedianIll == 1;nmoments = nmoments+1; end
if MatchP75Ill == 1;nmoments = nmoments+1;end
if MatchFracIll0 == 1;nmoments = nmoments+1;end
if MatchMeanLiq == 1;nmoments = nmoments+1;end
if MatchMedianLiq == 1;nmoments = nmoments+1;end
if MatchFracLiq0 == 1;nmoments = nmoments+1;end
if MatchFracLiqNeg == 1;nmoments = nmoments+1;end
if MatchFracIll0Liq0 == 1;nmoments = nmoments+1;end

diagweight = 1.0;
% make guess: with bound constraints, scale is set in one go below, 
%based on bounds. the initial starting points are the midpoints of the bounds
ip = 0;

if EstimateKappa0
    ip=ip+1;
	paramguess(ip) = icdf('Logistic',kappa0_w);
	paramub(ip) = 0.10; %0.95
	paramscale(ip) = 1.0/(icdf('Logistic',paramub(ip))-paramguess(ip));
end
if EstimateKappa1
    ip=ip+1;
	paramguess(ip) = log(kappa1_w);
	paramub(ip) = 3.0;
	paramscale(ip) = 1.0/(log(paramub(ip))-paramguess(ip));
end
if EstimateKappa2
    ip=ip+1;
	paramguess(ip) = log(kappa2_w-kappa2min);
	paramub(ip) = 4.0;
	paramscale(ip) = 1.0/(log(paramub(ip)-kappa2min)-paramguess(ip));
end
if EstimateKappa3
    ip=ip+1;
	paramguess(ip) = log(kappa3);
	paramub(ip) = 10.0;
	paramscale(ip) = 1.0/(log(paramub(ip))-paramguess(ip));
end
if EstimateKappa4
    ip=ip+1;
	paramguess(ip) = log(kappa4_w);
	paramub(ip) = 0.5;
	paramscale(ip) = 1.0/(log(paramub(ip))-paramguess(ip));
end
if EstimateRho 
    ip=ip+1;
	paramguess(ip) = icdf('Logistic',exp(-rho));
	paramub(ip) = 0.02;
	paramscale(ip) = 1.0/(icdf('Logistic',exp(-paramub(ip)))-paramguess(ip));
end
if EstimateBorrWedge 
    ip=ip+1;
	paramguess(ip) = icdf('Logistic',borrwedge/borrwedgemax);
	paramub(ip) = 0.95*borrwedgemax;
	paramscale(ip) = 1.0/(icdf('Logistic',paramub(ip)/borrwedgemax)-paramguess(ip));

end
if EstimateGamma 
    ip=ip+1;
	paramguess(ip) = log(gam);
	paramub(ip) = 3.0;
	paramscale(ip) = 1.0/(log(paramub(ip))-paramguess(ip));
end

writematrix(paramguess,strcat(OutputDir,'paramguess.txt'),'Delimiter',' ');
writematrix(paramlb,strcat(OutputDir,'paramlb.txt'),'Delimiter',' ');
writematrix(paramub,strcat(OutputDir,'paramub.txt'),'Delimiter',' ');

x = paramguess*paramscale;
npt = 2*nparam+1;
lrhobeg = 1.0;
lrhoend = 1.0e-5;
maxfun = 500*(nparam+1) ;
iprint = 3;

%do DFLS/DFBOLS minimization: objective function in dfovec.f90
%NB: DFBOLS automatically makes points the midpoints of the bounds
%DFLS uses the actual guesses with no bounds
fopen(fullfile(OutputDir,'iterations.txt'),'w');
j=1;
while j < ndfls
	if CalibrateRhoAtInitialGuess
        if Display >= 1; fprintf('Calibrating rho at initial steady state\n'); end
        converged = false;
        neqmiter = 1;
        fopen(fullfile(OutputDir,'DiscountRateAtInitialGuess.txt'),'w');
        lrhoL = icdf('Logistic',exp([-0.02 8]));
        lrhoU = icdf('Logistic',exp([-0.01 8]));
        rho = fzero(@FnDiscountRate,lrhoL,lrhoU,optimset('TolX',1e-8));
        converged = true;    
  end
	
	fprintf('********************************** \n');
	fprintf('DFLS MINIMIZATION ATTEMPT %d\n', j);
	CALL NEWUOA_H(nparam,npt,x,lrhobeg,lrhoend,iprint,maxfun,w,nmoments)
	fprintf('********************************** \n');
end

paramout = x(1:nparam)/paramscale;

%extract parameters at solution
ip = 0;
if EstimateKappa0
    ip=ip+1;
	kappa0_w = pdf('logistic',paramout(ip));
	fprintf('kappa0_w sol: %2.5g\n',kappa0_w);
end

if EstimateKappa1
    ip=ip+1;
    kappa1_w = exp(paramout(ip));
	fprintf(' kappa1_w sol: %2.5g\n',kappa1_w);
end

if EstimateKappa2
    ip=ip+1;
    kappa2_w = kappa2min + exp(paramout(ip));
	fprintf(' kappa2_w sol: %2.5g\n',kappa2_w);
end

if EstimateKappa3
    ip=ip+1;
    kappa3 = exp(paramout(ip));
	fprintf(' kappa3 sol: %2.5g\n',kappa3);
end

if EstimateKappa4
    ip=ip+1;
    kappa4_w = exp(paramout(ip));
	fprintf(' kappa4_w sol: %2.5g\n',kappa4_w);
end

if EstimateRho
    ip=ip+1;
	rho = -log(pdf('logistic',paramout(ip)));
	fprintf(' rho sol: %2.5g\n',rho);
end

if EstimateBorrWedge
    ip=ip+1;
	borrwedge = borrwedgemax*logistic(paramout(ip));	
	fprintf(' borrwedge sol: %2.5g\n',borrwedge);
end

if EstimateGamma
    ip=ip+1;
    gam = exp(paramout(ip));
	fprintf(' gam sol: %2.5g\n',gam);
end

if PinKappa1ByKappa02
	kappa1_w = ((1.0-kappa0_w)*(1.0+kappa2_w))^(-1.0/kappa2_w);
end	

kappa0_d = kappa0_w;
kappa1_d = kappa1_w;
kappa2_d = kappa2_w;
kappa4_d = kappa4_w;


calibrating = false;

%implied aggregate statistics: note that lump transfer is based on output=1.5, not actual output
bond = Eb;
investment = deprec*capital;
priceadjust = 0.0;
profit = (1.0-mc)*capital/KYratio - priceadjust;
if ~DistributeProfitsInProportion; dividend = profit*(1.0-corptax); end
if DistributeProfitsInProportion; dividend = profdistfrac*profit*(1.0-corptax); end
output = tfp*(capital^alpha)*(labor^(1.0-alpha));
fundbond = -capital*fundlev;
bondelast = bondelastrelgdp*output;
caputil 	= 1.0;
tfpadj = ((tfp^(1.0+utilelast)) * (mc*alpha/rcapital)^(alpha*utilelast))^(1.0/utilelastalpha);
taxrev = labtax*wage*labor - lumptransfer + corptax*profit;
if DistributeProfitsInProportion && TaxHHProfitIncome 
    taxrev = taxrev + labtax*(1.0-profdistfrac)*profit*(1.0-corptax);
end
    
if ~GovBondResidualZeroWorld
	govbond = -ssdebttogdp*output;
	govexp = taxrev + rb*govbond;
	worldbond = -bond-govbond-fundbond;
elseif GovBondResidualZeroWorld
	worldbond = 0.0;
	govbond = -bond-worldbond-fundbond;
	govexp = taxrev + rb*govbond;	
end








