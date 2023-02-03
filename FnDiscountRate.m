function FnDiscountRate(lrhoT)

rho = -log(pdf('logistic',lrhoT));

Grids
IterateBellman
StationaryDistribution
DistributionStatistics

if DividendFundLumpSum==0; capital = Ea/(1.0-fundlev); end
if DividendFundLumpSum
	if DistributeProfitsInProportion==0 
        capital = Ea/(1.0-fundlev + (1.0-mc)*(1.0-corptax)/(ra*KYratio));
  end
	if DistributeProfitsInProportion 
        capital = Ea/(1.0-fundlev + (1.0-mc)*(1.0-corptax)*profdistfrac/(ra*KYratio));
  end     
end

labor = Elabor;
equity = Ea - (1.0-fundlev)*capital;

lKNratio = capital / labor;
lKYratio = (lKNratio^(1.0-alpha)) / tfp;

if Display>=1
    fprintf('(A,I2,A,E11.4,A,E11.4) %4.6f, Rho iter %d,  rho  %4.6f,  K/N err %4.6f',...
        neqmiter,rho,lKNratio/KNratio - 1.0);
end
FnDiscountRate = lKNratio/KNratio - 1.0;


if CalibrateDiscountRate
    fid=fopen(fullfile(OutputDir,'DiscountRateCalibration.txt'),'w');
    fprintf(fid,'^^^^^^^^^^^^^^^^^^^^^*\n');
    fprintf(fid,' ITERATION : %d\n',neqmiter);
    fprintf(fid,' rho guess:  %4.6f\n',rho);
    fprintf(fid,'  target KY ratio: %4.6f\n',KYratio);
    fprintf(fid,'  implied KY ratio: %4.6f\n',lKYratio);
    fprintf(fid,'  target KN ratio: %4.6f\n',KNratio);
    fprintf(fid,'  implied KN ratio: %4.6f\n',lKNratio);
    fprintf(fid,'  relative error: %4.6f\n',FnDiscountRate);

    fclose(fid);
end

if CalibrateRhoAtInitialGuess
    fid2=fopen(fullfile(OutputDir,'DiscountRateAtInitialGuess.txt'),'w');
    fprintf(fid2,'^^^^^^^^^^^^^^^^^^^^^*\n');
    fprintf(fid2,' ITERATION : %d\n',neqmiter);
    fprintf(fid2,' rho guess:  %4.6f\n',rho);
    fprintf(fid2,'  target KY ratio: %4.6f\n',KYratio);
    fprintf(fid2,'  implied KY ratio: %4.6f\n',lKYratio);
    fprintf(fid2,'  target KN ratio: %4.6f\n',KNratio);
    fprintf(fid2,'  implied KN ratio: %4.6f\n',lKNratio);
    fprintf(fid2,'  relative error: %4.6f\n',FnDiscountRate);

    fclose(fid2);
end    

neqmiter = neqmiter+1;

%implied aggregate statistics
bond = Eb;
investment = deprec*capital;
priceadjust = 0.0;
profit = (1.0-mc)*capital/KYratio - priceadjust;
dividend = profit*(1.0-corptax);
if DistributeProfitsInProportion
    dividend = profdistfrac*dividend;
end
output = tfp*(capital^alpha)*(labor^(1.0-alpha));
fundbond = -capital*fundlev;
bondelast = bondelastrelgdp*output;
caputil 	= 1.0;
tfpadj = ((tfp^(1.0+utilelast)) * (mc*alpha/rcapital)^(alpha*utilelast))^(1.0/utilelastalpha);
taxrev = labtax*wage*labor - lumptransfer + corptax*profit;
if DistributeProfitsInProportion && TaxHHProfitIncome 
    taxrev = taxrev + labtax*(1.0-profdistfrac)*profit*(1.0-corptax);
end    

if GovBondResidualZeroWorld==0
	govbond = -ssdebttogdp*output;
	govexp = taxrev + rb*govbond ;
	worldbond = -bond-govbond-fundbond;
elseif GovBondResidualZeroWorld
	worldbond = 0.0;
	govbond = -bond-worldbond-fundbond;
	govexp = taxrev + rb*govbond;		
end

end