%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Calculate the Inequality measures and save them (useful for transition dynamics)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

datagrosslabinc = 69100;
dataannoutput = 115000;

%% INCOME DISTRIBUTION

yygrid = permute(repmat(ygrid, [1 40 50]),[2 3 1]);

grlabincmat = dataannoutput .*hour .* initss.wage .* yygrid./initss.output;
grlabinc = reshape(grlabincmat,ngpa*ngpb*ngpy,1);
grlabincdist = reshape(gjoint.*abydelta,ngpa*ngpb*ngpy,1);

[grlabinc , tempind] = sort(grlabinc);
grlabincdist = grlabincdist(tempind);

grlabinccum = cumsum(grlabincdist);

%% Lorenz curves for labor income

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
ill_gini = initss.GINIa;

%% Lorenz curve liquid wealth
liqpopfrac = cumsum(bdelta.*gbmargallinc);
illpopfrac(ngpb) = 1;
liqwealthfrac = cumsum(bgrid.*bdelta.*gbmargallinc);
liqwealthfrac = liqwealthfrac ./ liqwealthfrac(ngpb);
%datalorenzliq = load('lorenz_liq.txt');


% top liquid shares

liq_share_top10pc = 1-interp1(liqpopfrac,liqwealthfrac,0.9);
liq_share_top1pc = 1-interp1(liqpopfrac,liqwealthfrac,0.99);
liq_share_top01pc = 1-interp1(liqpopfrac,liqwealthfrac,0.999);
liq_share_bot50pc = interp1(liqpopfrac,liqwealthfrac,0.5);
liq_share_bot25pc = interp1(liqpopfrac,liqwealthfrac,0.25);
liq_gini = initss.GINIb;


%% Lorenz curve networth

bb_grid = ones(ngpa,1)*bgrid'; %needs to be a ngpa X ngpb vector
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
nw_gini = initss.GINInw;

%% Save the shares into INITSS for transition dynamics

% for the liquid shares
ineqitss.liq_share_top10pc=liq_share_top10pc;
ineqitss.liq_share_top1pc=liq_share_top1pc;
ineqitss.liq_share_top01pc=liq_share_top01pc;
ineqitss.liq_share_bot50pc=liq_share_bot50pc;
ineqitss.liq_share_bot25pc=liq_share_bot25pc;
ineqitss.GINIb=GINIb;

% for the illiquid shares
ineqitss.ill_share_top10pc=ill_share_top10pc;
ineqitss.ill_share_top1pc=ill_share_top1pc;
ineqitss.ill_share_top01pc=ill_share_top01pc;
ineqitss.ill_share_bot50pc=ill_share_bot50pc;
ineqitss.ill_share_bot25pc=ill_share_bot25pc;
ineqitss.GINIa=GINIa;

% for the net worth shares
ineqitss.nw_share_top10pc=nw_share_top10pc;
ineqitss.nw_share_top1pc=nw_share_top1pc;
ineqitss.nw_share_top01pc=nw_share_top01pc;
ineqitss.nw_share_bot50pc=nw_share_bot50pc;
ineqitss.nw_share_bot25pc=nw_share_bot25pc;
ineqitss.GINInw=GINInw;

% for labor income shares
ineqitss.inc_share_top10pc = inc_share_top10pc;
ineqitss.inc_share_top1pc = inc_share_top1pc;
ineqitss.inc_share_top01pc = inc_share_top01pc;
ineqitss.inc_share_bot50pc = inc_share_bot50pc;
ineqitss.inc_share_bot25pc = inc_share_bot25pc;

save('ineqitss.mat','-struct','ineqitss');


