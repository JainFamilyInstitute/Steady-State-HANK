% vectorize everything
lnw = agrid+bgrid;
ladjcost = adjcostfn(d,agrid);
lwage = ygrid*wage;
llabor = h.*ygrid;
lgrosslabinc = llabor*wage;
lnetlabinc = llabor*netwage + lumptransfer;

if DistributeProfitsInProportion
    lgrossprofinc = (1-profdistfrac)*profit*ygrid/meanlabeff;
else
    lgrossprofinc = 0;
end
if TaxHHProfitIncome
    lnetprofinc = (1-labtax)*lgrossprofinc;
else
    lnetprofinc = lgrossprofinc;
end

bdrift = (rborr*(bgrid<=0)+rb*(bgrid>0)+PerfectAnnuityMarkets*deathrate).*bgrid;
lgrossinc = lgrosslabinc + lgrossprofinc + bdrift + ...
    (ra+PerfectAnnuityMarkets*deathrate)*agrid;

% marginal distributions
gamarg = sum(gmat.*bdelta,2);
gbmarg = sum(gmat.*adelta,1);
lmargdist = gmat.*abdelta;

gamargallinc    = sum(squeeze(gamarg),2);
gbmargallinc    = sum(squeeze(gbmarg),2);
% gmat is gjoint
gjointallinc    = sum(gmat,3);

% ab joint distribution
gabmarg = sum(gmat,3).*abdelta;

% ab cumulative distribution
gabcum = cumsum(cumsum(gabmarg),2);

% liquid wealth marginal dist
lbmargdist = sum(gbmarg,3).*bdelta;
lbmargcum = cumsum(lbmargdist);

% illiquid wealth marginal dist
lamargdist = sum(gamarg,3).*adelta;
lamargcum = cumsum(lamargdist);

% other marginal dist
if ~iteratingtransition && ~calibrating
    % networth grid and marginal dist
    [lnwgrid,ordernw] = sort(lnw(:));
    lnwdelta = diff2(lnwgrid);
    lnwmargdist = gabmarg(ordernw);
    lnwmargcum = cumsum(lnwmargdist);
    [ia,ib] = ind2sub([ngpa,ngpb],ordernw);
    iab = lnwmargdist <= 1e-12;
    lnw_a = agrid(ia); lnw_a(iab) = 0;
    lnw_b = bgrid(ib)'; lnw_b(iab) = 0;
    lnw_c = sum(c.*lmargdist,3)./gabmarg;
    lnw_c = lnw_c(ordernw); lnw_c(iab) = 0;
    lnw_h = sum(h.*lmargdist,3)./gabmarg;
    lnw_h = lnw_h(ordernw); lnw_h(iab) = 0;
    lnw_inc = sum(lgrossinc.*lmargdist,3)./gabmarg;
    lnw_inc = lnw_inc(ordernw); lnw_inc(iab) = 0;

    % consumption
    [lcgrid,orderc] = sort(c(:));
    lcdelta = diff2(lcgrid);
    lcmargdist = lmargdist(orderc);
    lcmargcum = cumsum(lcmargdist);

    % gross total income
    [lincgrid,orderinc] = sort(lgrossinc(:));
    lincdelta = diff2(lincgrid);
    lincmargdist = lmargdist(orderinc);
    lincmargcum = cumsum(lincmargdist);
    [ia,ib,~] = ind2sub([ngpa,ngpb,ngpy],orderinc);
    [iab,~] = ind2sub([nab,ngpy],orderinc);
    linc_a = agrid(ia);
    linc_b = bgrid(ib)';
    linc_c = c(orderinc);
    linc_h = h(orderinc);
    linc_nw = lnw(iab);

    % gross labor income
    [llabincgrid,orderinc] = sort(lgrosslabinc(:));
    llabincdelta = diff2(llabincgrid);
    llabincmargdist = lmargdist(orderinc);
    llabincmargcum = cumsum(llabincmargdist);
    [ia,ib,~] = ind2sub([ngpa,ngpb,ngpy],orderinc);
    [iab,~] = ind2sub([nab,ngpy],orderinc);
    llabinc_a = agrid(ia);
    llabinc_b = bgrid(ib)';
    llabinc_c = c(orderinc);
    llabinc_h = h(orderinc);
    llabinc_nw = lnw(iab);
    
    % means
    Enw = sum(lnwgrid.*lnwmargdist);
    Einc = sum(lincgrid.*lincmargdist);
    Elabinc = sum(llabincgrid.*llabincmargdist);
else
    Enw = NaN;
    Einc = NaN;
    Elabinc = NaN;
end

%% Store Aggregate Portfolio Liquidity at t==1 for all percentiles 
% by the time it converges, stores the responses for t=1

if DoImpulseResponses
 if FlagTransNOFS && ~iteratingtransition && it==1
   disp('Here')
%    x=agrid.*lmargdist;
%    y=bgrid.*lmargdist;
   x=(agrid.*lmargdist-statsINITSS.Ea)/statsINITSS.Ea;
   y=(bgrid.*lmargdist-statsINITSS.Eb)/statsINITSS.Eb;
   x=x(:);y=y(:);
   [z,zindex]=sort(x+y);
   x_sorted=x(zindex);
   y_sorted=y(zindex);
   net_liqratio = y_sorted./x_sorted-1;
%    net_liqratio = y_sorted./x_sorted;
   [nobs,~]=size(net_liqratio);
   seq=nobs/100*(1:1:99);
%    netliqratio_req=net_liqratio([seq end]);
   netliqratio_req=net_liqratio(seq);
   net_liqratio = net_liqratio(~isnan(net_liqratio) & ~isinf(net_liqratio));
   figure(1)
   val=50:99;
   plot(val,netliqratio_req(val))
   ylabel('Deviation (\%)', 'interpreter','latex','FontSize',10);
   xlabel('Net Wealth Percentile', 'interpreter','latex','FontSize',10);
   if MonetaryShockSize==0.0025
      t=title('Portfolio Liquidity: negative MP shock');
   else
      t=title('Portfolio Liquidity:  positive MP shock');
   end
   t.FontSize=10;
   set(gca,'FontSize',10);
   saveas(gcf,'Portfolio_Liquidity_byNetWealthPercentiles.png'); 
%    plot(1:100,netliqratio_req)
%    net_liqratio = sort(net_liqratio(~isnan(net_liqratio) & ~isinf(net_liqratio)));
%    find(net_liqratio<=0,1,'last')
%    dbstop %in DistributionStatistics % at 123
  end
end  
    
%% means
Ehours = sum(sum(sum(h.*lmargdist)));
Elabor = sum(sum(sum(llabor.*lmargdist)));
Ewage = sum(sum(sum(lwage.*lmargdist)));
Enetlabinc = sum(sum(sum(lnetlabinc.*lmargdist)));
Egrosslabinc = sum(sum(sum(lgrosslabinc.*lmargdist)));
Enetprofinc = sum(sum(sum(lnetprofinc.*lmargdist)));
Egrossprofinc = sum(sum(sum(lgrossprofinc.*lmargdist)));
Ea = sum(sum(sum(agrid.*lmargdist)));
Eb = sum(sum(sum(bgrid.*lmargdist)));
Ec = sum(sum(sum(c.*lmargdist)));
Ed = sum(sum(sum(d.*lmargdist)));
Eadjcost = sum(sum(sum(ladjcost.*lmargdist)));
EbP = sum(sum(sum(bgrid(bgrid>0).*lmargdist(:,bgrid>0,:))));
EbN = sum(sum(sum(bgrid(bgrid<0).*lmargdist(:,bgrid<0,:))));

% frac at exactly zero
FRACa0 = lamargdist(1);
if Borrowing; FRACb0 = lbmargdist(ngpbNEG+1); else; FRACb0 = lbmargdist(1); end
FRACnw0 = sum(lnwmargdist(abs(lnwgrid)<1e-8));
FRACb0a0 = sum(sum(sum(lmargdist(abs(agrid)<1e-8,abs(bgrid)<1e-8,:))));
FRACb0aP = sum(sum(sum(lmargdist(agrid>1e-8,abs(bgrid)<1e-8,:))));

% frac zero or close but greater than zero
FRACb0close = interp1(bgrid,lbmargcum,defnbclose*Egrosslabinc);
if Borrowing; FRACb0close = FRACb0close - lbmargcum(ngpbNEG); end
FRACa0close = interp1(agrid,lamargcum,defnaclose*Egrosslabinc);
if ~iteratingtransition && ~calibrating
    FRACnw0close = interp1(lnwgrid,lnwmargcum,(defnbclose+defnaclose)*Egrosslabinc);
    if Borrowing; FRACnw0close = FRACnw0close - interp1(lnwgrid,lnwmargcum,-1e-8); end
end
if ~iteratingtransition % since we don't store gabcum
    FRACb0a0close = interp2(agrid,bgrid,gabcum',defnaclose*Egrosslabinc,defnbclose*Egrosslabinc);
    if Borrowing; FRACb0a0close = FRACb0a0close - interp1(agrid,gabcum(:,ngpbNEG),defnaclose*Egrosslabinc); end
end

FRACbN = sum(sum(sum(lmargdist(:,bgrid<-1e-12,:))));
c_b = c.*lmargdist;
Ec_bN = sum(sum(sum(c_b(:,bgrid<-1e-8,:))))/FRACbN;
Ec_b0close = sum(sum(sum(c_b(:,bgrid>-1e-8 & bgrid<defnbclose*Egrosslabinc,:))))/FRACb0close;
Ec_b0far = sum(sum(sum(c_b(:,bgrid>=defnbclose*Egrosslabinc,:))))/(1-FRACb0close-FRACbN);

% percentiles: use cumulative marginal distributions
lpvec = [1 2 5 10 25 50 75 90 95 98 99]/100;
if ~iteratingtransition && (~calibrating || MatchMedianLiq) && (ngpy>1 || deathrate>0)
    % liquid wealth
    iab = diff(lbmargcum) > 0;
    PERCb = interp1(lbmargcum(iab),bgrid(iab),lpvec);
    PERCb(lpvec<=lbmargcum(1)) = bgrid(1);
end
if ~iteratingtransition && (~calibrating || MatchMedianIll || MatchP75Ill) && (ngpy>1 || deathrate>0)
    % illiquid wealth
    iab = diff(lamargcum) > 0;
    PERCa = interp1(lamargcum(iab),agrid(iab),lpvec);
    PERCa(lpvec<=lamargcum(1)) = agrid(1);
end
    
if ~iteratingtransition && ~calibrating && (ngpy>1 || deathrate>0)
    % net worth
    iab = diff(lnwmargcum) > 0;
    PERCnw = interp1(lnwmargcum(iab),lnwgrid(iab),lpvec);
    PERCnw(lpvec<=lnwmargcum(1)) = lnwgrid(1);
    % consumption
    [~,iab] = unique(lcmargcum); %%  check timing unique vs diff > 0
    PERCc = interp1(lcmargcum(iab),lcgrid(iab),lpvec);
    PERCc(lpvec<=lcmargcum(1)) = lcgrid(1);
    % gross income
    iab = diff(lincmargcum) > 0;
    PERCinc = interp1(lincmargcum(iab),lincgrid(iab),lpvec);
    PERCinc(lpvec<=lincmargcum(1)) = lincgrid(1);

    % gini coefficient
    if Ea>0; GINIa = sum(lamargcum.*(1-lamargcum).*adelta) / Ea; else; GINIa = 0; end
    GINIb = sum(lbmargcum.*(1-lbmargcum).*bdelta) / Eb;
    GINInw = sum(lnwmargcum.*(1-lnwmargcum).*lnwdelta) / Enw;
    GINIc = sum(lcmargcum.*(1-lcmargcum).*lcdelta) / Ec;
    GINIinc = sum(lincmargcum.*(1-lincmargcum).*lincdelta) / Einc;
    GINIlabinc = sum(llabincmargcum.*(1-llabincmargcum).*llabincdelta) / Elabinc;

    % in transition use groupings based on steady sate
    
    % statistics conditional on quartile of net worth distributions    
    lnwmargdist = lnwmargdist./lnwdelta;
    [Ea_nwQ,Eb_nwQ,Ec_nwQ,Einc_nwQ] = ConditionalExpectation(nab,lnwgrid,lnwmargdist,lnwdelta,PERCnw(5:7),lnw_a,lnw_b,lnw_c,lnwgrid);
    
    % statistics conditional on quartile of total gross income distributions
    lincmargdist = lincmargdist./lincdelta;
    [Ea_incQ,Eb_incQ,Ec_incQ,Einc_incQ] = ConditionalExpectation(naby,lincgrid,lincmargdist,lincdelta,PERCinc(5:7),linc_a,linc_b,linc_c,lincgrid);
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Calculate the Inequality measures and save them (useful for transition dynamics)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inc_share_top10pc=0;inc_share_top1pc=0;inc_share_top01pc=0;
inc_share_bot50pc=0;inc_share_bot25pc=0;inc_share_bot10pc=0;
%% 
if ~initialSS 
    datagrosslabinc = 69100;
    dataannoutput = 115000;
    hour=h;
    
    yygrid = permute(repmat(squeeze(ygrid), [1 40 50]),[2 3 1]);
    
    grlabincmat = dataannoutput .*hour .*wage .* yygrid./output;
    grlabinc = reshape(grlabincmat,ngpa*ngpb*ngpy,1);
    abydelta    = repmat(abdelta,[1,1,ngpy]);
    grlabincdist = reshape(gmat.*abydelta,ngpa*ngpb*ngpy,1);
    
    
    [grlabinc , tempind] = sort(grlabinc);
    grlabincdist = grlabincdist(tempind);

    grlabinccum = cumsum(grlabincdist);

    % gross labor income 
    incpopfrac = grlabinccum;
    incpopfrac = [0; incpopfrac];
    incfrac = cumsum(grlabinc.*grlabincdist);
    incfrac = incfrac ./ incfrac(size(incfrac,1));
    incfrac = [0; incfrac];

    [incpopfrac_uniq,incpopfrac_uniqindex]=unique(incpopfrac);
    incfrac_uniq=incfrac(incpopfrac_uniqindex);

    inc_share_top10pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.9);
    inc_share_top1pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.99);
    inc_share_top01pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.999);
    inc_share_bot50pc = interp1(incpopfrac_uniq,incfrac_uniq,0.5);
    inc_share_bot25pc = interp1(incpopfrac_uniq,incfrac_uniq,0.25);
    inc_share_bot10pc = interp1(incpopfrac_uniq,incfrac_uniq,0.1);
    
    inc_p90pc = prctile(grlabinc(:),90);
    inc_p50pc = prctile(grlabinc(:),50);
    inc_p10pc = prctile(grlabinc(:),10);
end    

%% for transition dynamics

if DoImpulseResponses 
    datagrosslabinc = 69100;
    dataannoutput = 115000;
    hour=h;
    
    yygrid = permute(repmat(squeeze(ygrid), [1 40 50]),[2 3 1]);
    
    grlabincmat = dataannoutput .*hour .* equmTRANS.wage(1).* yygrid./equmTRANS.output(1);
    grlabinc = reshape(grlabincmat,ngpa*ngpb*ngpy,1);
    abydelta    = repmat(abdelta,[1,1,ngpy]);
    grlabincdist = reshape(gmat.*abydelta,ngpa*ngpb*ngpy,1);
    
    
    [grlabinc , tempind] = sort(grlabinc);
    grlabincdist = grlabincdist(tempind);

    grlabinccum = cumsum(grlabincdist);

    % gross labor income 
    incpopfrac = grlabinccum;
    incpopfrac = [0; incpopfrac];
    incfrac = cumsum(grlabinc.*grlabincdist);
    incfrac = incfrac ./ incfrac(size(incfrac,1));
    incfrac = [0; incfrac];

    [incpopfrac_uniq,incpopfrac_uniqindex]=unique(incpopfrac);
    incfrac_uniq=incfrac(incpopfrac_uniqindex);

    inc_share_top10pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.9);
    inc_share_top1pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.99);
    inc_share_top01pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.999);
    inc_share_bot50pc = interp1(incpopfrac_uniq,incfrac_uniq,0.5);
    inc_share_bot25pc = interp1(incpopfrac_uniq,incfrac_uniq,0.25);
    inc_share_bot10pc = interp1(incpopfrac_uniq,incfrac_uniq,0.1);
   
    inc_p90pc = prctile(grlabinc(:),90);
    inc_p50pc = prctile(grlabinc(:),50);
    inc_p10pc = prctile(grlabinc(:),10);
end

%% Lorenz curve gross total income 
grlabinc = reshape(lgrossinc,ngpa*ngpb*ngpy,1);
abydelta    = repmat(abdelta,[1,1,ngpy]);
grlabincdist = reshape(gmat.*abydelta,ngpa*ngpb*ngpy,1);

[grlabinc , tempind] = sort(grlabinc);
grlabincdist = grlabincdist(tempind);

grlabinccum = cumsum(grlabincdist);


incpopfrac = grlabinccum;
incpopfrac = [0; incpopfrac];
incfrac = cumsum(grlabinc.*grlabincdist);
incfrac = incfrac ./ incfrac(size(incfrac,1));
incfrac = [0; incfrac];

[incpopfrac_uniq,incpopfrac_uniqindex]=unique(incpopfrac);
incfrac_uniq=incfrac(incpopfrac_uniqindex);

totinc_share_top10pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.9);
totinc_share_top1pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.99);
totinc_share_top01pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.999);
totinc_share_bot50pc = interp1(incpopfrac_uniq,incfrac_uniq,0.5);
totinc_share_bot25pc = interp1(incpopfrac_uniq,incfrac_uniq,0.25);
totinc_share_bot10pc = interp1(incpopfrac_uniq,incfrac_uniq,0.1);

totinc_p90pc = prctile(lgrossinc(:),90);
totinc_p50pc = prctile(lgrossinc(:),50);
totinc_p10pc = prctile(lgrossinc(:),10);

%% Lorenz curve for consumption 

conpopfrac = cumsum(lcgrid.*lcmargdist);
%conpopfrac(ngpa) = 1;
conpopfrac = [0; conpopfrac];
conwealthfrac = cumsum(lcgrid.*lcdelta.*lcmargdist);
conwealthfrac = conwealthfrac ./ conwealthfrac(ngpa);
conwealthfrac= [0; conwealthfrac];

[conpopfrac_uniq,conpopfrac_uniqindex]=unique(conpopfrac);
confrac_uniq=incfrac(conpopfrac_uniqindex);

con_share_top10pc = 1-interp1(conpopfrac_uniq,confrac_uniq,0.9);
con_share_top1pc = 1-interp1(conpopfrac_uniq,confrac_uniq,0.99);
con_share_top01pc = 1-interp1(conpopfrac_uniq,confrac_uniq,0.999);
con_share_bot50pc = interp1(conpopfrac_uniq,confrac_uniq,0.5);
con_share_bot25pc = interp1(conpopfrac_uniq,confrac_uniq,0.25);
con_share_bot10pc = interp1(conpopfrac_uniq,confrac_uniq,0.1);

con_p90pc = prctile(c(:),90);
con_p50pc = prctile(c(:),50);
con_p10pc = prctile(c(:),10);

%% Lorenz curve illiquid wealth
illpopfrac = cumsum(adelta.*gamargallinc);
illpopfrac(ngpa) = 1;
illpopfrac = [0; illpopfrac];
illwealthfrac = cumsum(agrid.*adelta.*gamargallinc);
illwealthfrac = illwealthfrac ./ illwealthfrac(ngpa);
illwealthfrac= [0; illwealthfrac];
%datalorenzill = load('lorenz_ill.txt');

% top illiquid shares
ill_share_top10pc = 1-interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.9);
ill_share_top1pc = 1-interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.99);
ill_share_top01pc = 1-interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.999);
ill_share_bot50pc = interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.5);
ill_share_bot25pc = interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.25);
ill_share_bot10pc = interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.1);

ill_p90pc = prctile(agrid(:),90);
ill_p50pc = prctile(agrid(:),50);
ill_p10pc = prctile(agrid(:),10);

%% Lorenz curve liquid wealth
liqpopfrac = cumsum(bdelta'.*gbmargallinc);
illpopfrac(ngpb) = 1;
liqwealthfrac = cumsum(bgrid'.*bdelta'.*gbmargallinc);
liqwealthfrac = liqwealthfrac ./ liqwealthfrac(ngpb);
%datalorenzliq = load('lorenz_liq.txt');

% top liquid shares
liq_share_top10pc = 1-interp1(liqpopfrac,liqwealthfrac,0.9);
liq_share_top1pc = 1-interp1(liqpopfrac,liqwealthfrac,0.99);
liq_share_top01pc = 1-interp1(liqpopfrac,liqwealthfrac,0.999);
liq_share_bot50pc = interp1(liqpopfrac,liqwealthfrac,0.5);
liq_share_bot25pc = interp1(liqpopfrac,liqwealthfrac,0.25);
liq_share_bot10pc = interp1(liqpopfrac,liqwealthfrac,0.1);

liq_p90pc = prctile(bgrid(:),90);
liq_p50pc = prctile(bgrid(:),50);
liq_p10pc = prctile(bgrid(:),10);

%% Lorenz curve networth

bb_grid = ones(ngpa,1)*bgrid; %needs to be a ngpa X ngpb vector
aa_grid = agrid*ones(1,ngpb);
b_stacked = reshape(bb_grid,ngpa*ngpb,1);
a_stacked = reshape(aa_grid,ngpa*ngpb,1);
nw_stacked = a_stacked + b_stacked;
nw_delta_stacked = reshape(abdelta,ngpa*ngpb,1);
g_nw_stacked = reshape(gjointallinc,ngpa*ngpb,1);

[nw_sorted,index] = sort(nw_stacked);
g_nw = g_nw_stacked(index);
nw_delta = nw_delta_stacked(index);

nwpopfrac = cumsum(g_nw.*nw_delta);
nwpopfrac = [0; nwpopfrac];
nwwealthfrac = cumsum(nw_sorted.*g_nw.*nw_delta);
nwwealthfrac = nwwealthfrac./nwwealthfrac(end);
nwwealthfrac = [0; nwwealthfrac];

%datalorenznw = load('lorenz_nw.txt');

[nwpopfrac_uniq,nwpopfrac_uniqindex]=unique(nwpopfrac);
nwwealthfrac_uniq=nwwealthfrac(nwpopfrac_uniqindex);

% top net worth shares
nw_share_top10pc = 1-interp1(nwpopfrac_uniq,nwwealthfrac_uniq,0.9);
nw_share_top1pc = 1-interp1(nwpopfrac_uniq,nwwealthfrac_uniq,0.99);
nw_share_top01pc = 1-interp1(nwpopfrac_uniq,nwwealthfrac_uniq,0.999);
nw_share_bot50pc = interp1(nwpopfrac_uniq,nwwealthfrac_uniq,0.5);
nw_share_bot25pc = interp1(nwpopfrac_uniq,nwwealthfrac_uniq,0.25);
nw_share_bot10pc = interp1(nwpopfrac_uniq,nwwealthfrac_uniq,0.1);

nw_p90pc = prctile(nw_stacked(:),90);
nw_p50pc = prctile(nw_stacked(:),50);
nw_p10pc = prctile(nw_stacked(:),10);

