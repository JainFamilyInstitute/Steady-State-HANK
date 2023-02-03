%clc;
clearvars -except Time1 MonetaryShockSize figname;
close all;

% InputDir = strcat('D:\University of Washington\HANK Literature\Codes for Heterogenous Models',...
%     '\myHANKReplication\ReplicateHank-Steady State\');
InputDir = cd;
lSaveDir = strcat(InputDir,'\SteadyStateFigures'); %path to directory to save figures
mkdir(lSaveDir);

lSave = 1;
%%
SSInputDir = InputDir;
load([SSInputDir '\Steadystate_workspace_paper.mat']);
clearvars alpha

SaveDir = lSaveDir;
datagrosslabinc = 69100;
dataannoutput = 115000;

Save = lSave;
count=0;

%% INCOME DISTRIBUTION and Other Inequality Statistics
% InequalityStatistics

% yygrid = permute(repmat(ygrid, [1 40 50]),[2 3 1]);
% 
% grlabincmat = dataannoutput .*hour .* initss.wage .* yygrid ./initss.output;
% grlabinc = reshape(grlabincmat,ngpa*ngpb*ngpy,1);
% grlabincdist = reshape(gjoint.*abydelta,ngpa*ngpb*ngpy,1);
% 
% [grlabinc , tempind] = sort([grlabinc]);
% grlabincdist = grlabincdist(tempind);
% 
% grlabinccum = cumsum(grlabincdist);
% 
% % Lorenz curves for labor income
% 
% % gross labor income 
% incpopfrac = grlabinccum;
% incpopfrac = [0; incpopfrac];
% incfrac = cumsum(grlabinc.*grlabincdist);
% incfrac = incfrac ./ incfrac(size(incfrac,1));
% incfrac = [0; incfrac];
% 
% [incpopfrac_uniq,incpopfrac_uniqindex]=unique(incpopfrac);
% incfrac_uniq=incfrac(incpopfrac_uniqindex);
% 
% inc_share_top10pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.9);
% inc_share_top1pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.99);
% inc_share_top01pc = 1-interp1(incpopfrac_uniq,incfrac_uniq,0.999);
% inc_share_bot50pc = interp1(incpopfrac_uniq,incfrac_uniq,0.5);
% inc_share_bot25pc = interp1(incpopfrac_uniq,incfrac_uniq,0.25);

% productivity in model
prodpopfrac = cumsum(ydist);
prodpopfrac = [0; prodpopfrac];
prodfrac = cumsum(ygrid.*ydist);
prodfrac = prodfrac./ prodfrac(ngpy);
prodfrac = [0; prodfrac];

% original productivity = SSA male earnings
prodpopfrac = cumsum(ydist);
prodpopfrac = [0; prodpopfrac];
prodgrid = ygrid.^(1+0.85*1);
% prodgrid = ygrid.^(1+1*1);
prodfrac2 = cumsum(prodgrid.*ydist);
prodfrac2 = prodfrac2./ prodfrac2(ngpy);
prodfrac2 = [0; prodfrac2];

%% WEALTH DISTRIBUTION: liquid wealth distribution - equally spaced bins;

%clear alpha;
fprintf('Distribution of Liquid and Illiquid Wealth\n');
liqspace=1; %thousands
liqcdf = cumsum(bdelta.*gbmargallinc);
liqbinmin = floor(bgrid(1).*dataannoutput/(4*initss.output*1000));
liqbinmax = ceil(bgrid(ngpb).*dataannoutput/(4*initss.output*1000));
%liqbin = [liqbinmin:liqspace:liqbinmax]';
liqbin = (liqbinmin:liqspace:liqbinmax)';
nliqbin = size(liqbin,1);
liqbincdf = interp1(bgrid.*dataannoutput/(4*initss.output*1000),liqcdf,liqbin);
liqbincdf(1) = 0;
liqbincdf(nliqbin) = 1;
liqbinpdf = [liqbincdf(1:nliqbin)] - [0;liqbincdf(1:nliqbin-1)];

liqbintrunc = liqbin(liqbin<=250);
liqbinpdftrunc = liqbinpdf(liqbin<=250);
liqbinpdftrunc(end) = liqbinpdftrunc(end) + sum(liqbinpdf(liqbin>250));

count=count+1;
figure(count);
f   = bar(liqbintrunc, liqbinpdftrunc,'histc');
sh  = findall(gcf,'marker','*'); delete(sh);
set(f,'FaceColor','blue','EdgeColor','red','LineWidth',0.05);
xlim([-20 251]);
ylim([0 0.04]);
text(0,0.035,['$\leftarrow Pr(b=0)=' num2str(round(gbmargallinc(11).*bdelta(11),2)) '$'],'FontSize',20,'interpreter','latex','Color','b');
text(0,0.025,['$\leftarrow Pr(b \in (0,\$2,000])=' num2str(round(liqbinpdf(liqbin==0)+liqbinpdf(liqbin==1)-gbmargallinc(11).*bdelta(11),2)) '$'],'FontSize',20,'interpreter','latex','Color','r');
text(90,0.015,['$Pr(b \geq \$250,000)=' num2str(round(liqbinpdftrunc(end),2)) '\rightarrow $'],'FontSize',20,'interpreter','latex','Color','k');
grid;
xlabel('\$ Thousands','FontSize',20,'interpreter','latex');
title('Liquid wealth distribution','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6 6]);
alpha(0.7)
if Save==1
    saveas(gcf,[SaveDir '\fig_1a_' figname '.png']);
    %print('-depsc',[SaveDir '\fig_1a']);
end

%% illiquid wealth distribution - equally spaced bins;
illspace = 10; %thousands
illcdf = cumsum(adelta.*gamargallinc);
illbinmin = illspace;
illbinmax = ceil(agrid(ngpa).*dataannoutput/(4*initss.output*1000));
illbin = (illbinmin:illspace:illbinmax)';
nillbin = size(illbin,1);
illbincdf = interp1(agrid.*dataannoutput/(4*initss.output*1000),illcdf,illbin);
illbincdf(nillbin) = 1;
illbinpdf = [illbincdf(1:nillbin)] - [0;illbincdf(1:nillbin-1)];
illbin = illbin-illspace;

illbintrunc = illbin(illbin<=1000);
illbinpdftrunc = illbinpdf(illbin<=1000);
illbinpdftrunc(end) = illbinpdftrunc(end) + sum(illbinpdf(illbin>1000));

count=count+1;
figure(count);
hold on
f   = bar(illbintrunc/1000, illbinpdftrunc,'histc');
alpha(f,0.7);
sh  = findall(gcf,'marker','*'); delete(sh);
set(f,'FaceColor','blue','EdgeColor','red','LineWidth',0.2);
str = ['$\leftarrow Pr(a=0)=' num2str(round(gamargallinc(1).*adelta(1),2)) '$'];
text(0,0.09,str,'FontSize',20,'interpreter','latex','Color','b');
str = ['$\leftarrow Pr(a \in(0,\$10,000])=' num2str(round(illbinpdf(1) - gamargallinc(1).*adelta(1),2)) '$'];
text(0,0.07,str,'FontSize',20,'interpreter','latex','Color','r');
text(0.37,0.02,['$Pr(a \geq \$1,000,000)=' num2str(round(illbinpdftrunc(end),2)) '\rightarrow $'],'FontSize',20,'interpreter','latex','Color','k');

grid;
xlim([0 1.01]);
ylim([0 0.1]);
xlabel('\$ Millions','FontSize',20,'interpreter','latex');
title('Illiquid wealth distribution','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16) ;
hold off

if Save==1
    saveas(gcf,[SaveDir '\fig_1b_' figname '.png']);
    %print('-depsc',[SaveDir '\fig_1b']);
end
%% Lorenz curve illiquid wealth
% illpopfrac = cumsum(adelta.*gamargallinc);
% illpopfrac(ngpa) = 1;
% illpopfrac = [0; illpopfrac];
% illwealthfrac = cumsum(agrid.*adelta.*gamargallinc);
% illwealthfrac = illwealthfrac ./ illwealthfrac(ngpa);
% illwealthfrac= [0; illwealthfrac];
% %datalorenzill = load('lorenz_ill.txt');
% 
% % top illiquid shares
% 
% ill_share_top10pc = 1-interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.9);
% ill_share_top1pc = 1-interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.99);
% ill_share_top01pc = 1-interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.999);
% ill_share_bot50pc = interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.5);
% ill_share_bot25pc = interp1(illpopfrac(2:ngpa+1),illwealthfrac(2:ngpa+1),0.25);
% ill_gini = initss.GINIa;
% 
% %% Lorenz curve liquid wealth
% liqpopfrac = cumsum(bdelta.*gbmargallinc);
% illpopfrac(ngpb) = 1;
% liqwealthfrac = cumsum(bgrid.*bdelta.*gbmargallinc);
% liqwealthfrac = liqwealthfrac ./ liqwealthfrac(ngpb);
% %datalorenzliq = load('lorenz_liq.txt');
% 
% 
% % top liquid shares
% 
% liq_share_top10pc = 1-interp1(liqpopfrac,liqwealthfrac,0.9);
% liq_share_top1pc = 1-interp1(liqpopfrac,liqwealthfrac,0.99);
% liq_share_top01pc = 1-interp1(liqpopfrac,liqwealthfrac,0.999);
% liq_share_bot50pc = interp1(liqpopfrac,liqwealthfrac,0.5);
% liq_share_bot25pc = interp1(liqpopfrac,liqwealthfrac,0.25);
% liq_gini = initss.GINIb;
% 
% 
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

%% Plot histogram of net worth  

fprintf('Distribution of Net Worth\n');
nwspace=10; %thousands (same as illiquid)
%liqcdf = cumsum(bdelta.*gbmargallinc);
nwcdf=nwpopfrac(1:end-1);
nwbinmin = floor(nw_sorted(1).*dataannoutput/(4*initss.output*1000));
nwbinmax = ceil(nw_sorted(end).*dataannoutput/(4*initss.output*1000));
%liqbin = [liqbinmin:liqspace:liqbinmax]';
nwbin = (nwbinmin:nwspace:nwbinmax)';
nnwbin = size(nwbin,1);
nwbincdf = interp1(nw_sorted.*dataannoutput/(4*initss.output*1000),nwcdf,nwbin);
nwbincdf(1) = 0;
nwbincdf(nnwbin) = 1;
nwbinpdf = [nwbincdf(1:nnwbin)] - [0;nwbincdf(1:nnwbin-1)];

nwbintrunc = nwbin(nwbin<=800);
nwbinpdftrunc = nwbinpdf(nwbin<=800);
nwbinpdftrunc(end) = nwbinpdftrunc(end) + sum(nwbinpdf(nwbin>800));

count=count+1;
figure(count);
f   = bar(nwbintrunc/1000, nwbinpdftrunc,'histc');
alpha(f,0.7);
% sh  = findall(gcf,'marker','*'); delete(sh);
% set(f,'FaceColor','blue','EdgeColor','red','LineWidth',0.2);
% str = ['$\leftarrow Pr(a=0)=' num2str(g_nw(nw_delta==0)....
%     *nw_delta(nw_stacked==0),2) '$'];
% text(0,0.09,str,'FontSize',20,'interpreter','latex','Color','b');
% str = ['$\leftarrow Pr(a \in(0,\$10,000])=' ...
%     num2str(round(nwbinpdf(1) - g_nw(1).*nw_delta_stacked(1),2)) '$'];
% text(0,0.07,str,'FontSize',20,'interpreter','latex','Color','r');
% text(0.37,0.02,['$Pr(a \geq \$1,000,000)=' ...
%     num2str(round(nwbinpdftrunc(end),2)) '\rightarrow $'],...
%     'FontSize',20,'interpreter','latex','Color','k');

grid;
xlim([-0.018 0.801]);
ylim([0 0.4]);
xlabel('\$ Millions','FontSize',20,'interpreter','latex');
title('Net Wealth distribution','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16) ;
hold off

if Save==1
    saveas(gcf,[SaveDir '\fig_NW_Hist_' figname '.png']);
end

%% Plot histogram of leverage (=illiquid/nw) and liquid (=liquid/nw)

alev_stacked=a_stacked./(a_stacked + b_stacked);
[alev_sorted,index] = sort(alev_stacked);
alev_sorted(end)=1;
g_nw = g_nw_stacked(index);
nw_delta = nw_delta_stacked(index);

count=count+1;
figure(count);
f=histogram(alev_sorted(alev_sorted>0),20,'Normalization','probability','FaceColor',[0.8500 0.3250 0.0980]);
alpha(f,0.7);
grid;
%xlim([0 1]);
%ylim([0 0.5]);
xlabel('Bin Size=0.05','FontSize',20,'interpreter','latex');
title('Net leverage (Illiquid) distribution','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16) ;
if Save==1
    saveas(gcf,[SaveDir '\fig_NetLeverage_IlliquidAssets_Hist_' figname '.png']);
end

alev_sorted(alev_sorted<0)=0;
alev_sorted(alev_sorted>1)=1;
count=count+1;
figure(count);
f=histogram(alev_sorted,20,'Normalization','probability','FaceColor',[0.8500 0.3250 0.0980]);
alpha(f,0.7);
grid;
%xlim([0 1]);
%ylim([0 0.5]);
xlabel('Bin Size=0.05','FontSize',20,'interpreter','latex');
title('Net leverage (Illiquid) distribution','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16) ;
if Save==1
    saveas(gcf,[SaveDir '\fig_NetLeverage_IlliquidAssets_AdjustedHist_' figname '.png']);
end


alev_stacked=1-alev_stacked;
[alev_sorted,index] = sort(alev_stacked);
alev_sorted(end)=1;
g_nw = g_nw_stacked(index);
nw_delta = nw_delta_stacked(index);

count=count+1;
figure(count);
f=histogram(alev_sorted,20,'Normalization','probability','FaceColor',[0.4940 0.1840 0.5560]);
alpha(f,0.7);
grid;
%xlim([0 1]);
ylim([0 0.5]);
xlabel('Bin Size=0.05','FontSize',20,'interpreter','latex');
title('Net leverage (Liquid) distribution','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16) ;
if Save==1
    saveas(gcf,[SaveDir '\fig_NetLeverage_LiquidAssets_Hist_' figname '.png']);
end

%%
% 
% alevpopfrac = cumsum(g_nw.*nw_delta);
% alevpopfrac = [0; alevpopfrac];
% alevcdf=alevpopfrac(2:end);
% 
% % fprintf('Distribution of Leverage\n');
% 
% alevspace=0.05; %thousands (same as illiquid)
% alevbin = (0:alevspace:1)';
% nalevbin = size(alevbin,1);
% nalevbincdf=zeros(nalevbin,1);
% for i =1:nalevbin
%     y=find(alev_sorted<=alevbin(i),1,'last');
%     nalevbincdf(i)=alevcdf(y);
% end
% nalevbinpdf = nalevbincdf(1:nalevbin) - [0;nalevbincdf(1:nalevbin-1)];
% % nwbintrunc = nwbin(nwbin<=800);
% % nwbinpdftrunc = nwbinpdf(nwbin<=800);
% % nwbinpdftrunc(end) = nwbinpdftrunc(end) + sum(nwbinpdf(nwbin>800));
% % 
% count=count+1;
% figure(count);
% f   = bar(alevbin, nalevbinpdf,'histc');
% alpha(f,0.7);
% grid;
% xlim([0 1.5]);
% ylim([0 0.5]);
% xlabel('Bin Size=0.05','FontSize',20,'interpreter','latex');
% title('Net leverage distribution','FontSize',20,'interpreter','latex');
% set(gca,'FontSize',16) ;
% if Save==1
%     saveas(gcf,[SaveDir '\fig_NetLeverage_Alt_Hist_' figname '.png']);
% end
% 

%% SCALAR TABLES FOR CALIBRATION
format long;
fprintf('Calculation of Inequality Statistics\n');
fid = fopen(fullfile(SaveDir,'ScalarsForTable5.txt'),'w');

fprintf(fid,'Mean Iliquid Wealth  = %s\n'  ,num2str(initss.Ea./(4*initss.output)));
fprintf(fid,'Mean Liquid Wealth   = %s\n'  ,num2str(initss.Eb./(4*initss.output)));
fprintf(fid,'Frac $b=0$ and $a=0$ = %s\n'  ,num2str(initss.FRACb0a0));
fprintf(fid,'Frac $b=0$ and $a>0$ = %s\n'  ,num2str(initss.FRACb0aP));
fprintf(fid,'Frac $b<0$           = %s\n'  ,num2str(initss.FRACbN));



fprintf(fid,'Liquid Wealth: top 10%% share  = %s\n'  ,num2str(initss.liq_share_top10pc));
fprintf(fid,'Liquid Wealth: top 1%% share   = %s\n'  ,num2str(initss.liq_share_top1pc));
fprintf(fid,'Liquid Wealth: top 0.1%% share = %s\n'  ,num2str(initss.liq_share_top01pc));
fprintf(fid,'Liquid Wealth: bot 50%% share  = %s\n'  ,num2str(initss.liq_share_bot50pc));
fprintf(fid,'Liquid Wealth: bot 25%% share  = %s\n'  ,num2str(initss.liq_share_bot25pc));
fprintf(fid,'Liquid Wealth: gini           = %s\n'  ,num2str(initss.GINIb));

fprintf(fid,'Iliquid Wealth: top 10%% share  = %s\n'  ,num2str(initss.ill_share_top10pc));
fprintf(fid,'Iliquid Wealth: top 1%% share   = %s\n'  ,num2str(initss.ill_share_top1pc));
fprintf(fid,'Iliquid Wealth: top 0.1%% share = %s\n'  ,num2str(initss.ill_share_top01pc));
fprintf(fid,'Iliquid Wealth: bot 50%% share  = %s\n'  ,num2str(initss.ill_share_bot50pc));
fprintf(fid,'Iliquid Wealth: bot 25%% share  = %s\n'  ,num2str(initss.ill_share_bot25pc));
fprintf(fid,'Iliquid Wealth: gini           = %s\n'  ,num2str(initss.GINIa));

fprintf(fid,'Net Wealth: top 10%% share  = %s\n'  ,num2str(initss.nw_share_top10pc));
fprintf(fid,'Net Wealth: top 1%% share   = %s\n'  ,num2str(initss.nw_share_top1pc));
fprintf(fid,'Net Wealth: top 0.1%% share = %s\n'  ,num2str(initss.nw_share_top01pc));
fprintf(fid,'Net Wealth: bot 50%% share  = %s\n'  ,num2str(initss.nw_share_bot50pc));
fprintf(fid,'Net Wealth: bot 25%% share  = %s\n'  ,num2str(initss.nw_share_bot25pc));
fprintf(fid,'Net Wealth: gini           = %s\n'  ,num2str(initss.GINInw));

fprintf(fid,'Gross Labor Income: top 10%% share  = %s\n'  ,num2str(initss.inc_share_top10pc));
fprintf(fid,'Gross Labor Income: top 1%% share   = %s\n'  ,num2str(initss.inc_share_top1pc));
fprintf(fid,'Gross Labor Income: top 0.1%% share = %s\n'  ,num2str(initss.inc_share_top01pc));
fprintf(fid,'Gross Labor Income: bot 50%% share  = %s\n'  ,num2str(initss.inc_share_bot50pc));
fprintf(fid,'Gross Labor Income: bot 25%% share  = %s\n'  ,num2str(initss.inc_share_bot25pc));
fprintf(fid,'Gross Labor Income: gini           = %s\n'  ,num2str(initss.GINIinc));

fclose(fid);

%% MPC plot

rebgrid = [1 25 50 75 100 150 200:100:600 800 1000]';
for ir = 1:numel(rebgrid)
    rebamount       = (rebgrid(ir)/dataannoutput).* (initss.output*4);
    disp(['doing mpreb for amount ' num2str(rebamount)]);
   
    lmpreb1          = zeros(ngpa,ngpb,ngpy);
    lmpreb2          = zeros(ngpa,ngpb,ngpy);
    lmpreb4          = zeros(ngpa,ngpb,ngpy);
    for ia = 1:ngpa
        for iy = 1:ngpy
            lmpreb1(ia,:,iy) = interp1(bgrid',ccum1(ia,:,iy),bgrid'+rebamount,'linear','extrap');
            lmpreb1(ia,:,iy) = (lmpreb1(ia,:,iy) - ccum1(ia,:,iy))./rebamount;
            lmpreb2(ia,:,iy) = interp1(bgrid',ccum2(ia,:,iy),bgrid'+rebamount,'linear','extrap');
            lmpreb2(ia,:,iy) = (lmpreb2(ia,:,iy) - ccum2(ia,:,iy))./rebamount;
            lmpreb4(ia,:,iy) = interp1(bgrid',ccum4(ia,:,iy),bgrid'+rebamount,'linear','extrap');
            lmpreb4(ia,:,iy) = (lmpreb4(ia,:,iy) - ccum4(ia,:,iy))./rebamount;
        end
    end   

    Empreb1grid(ir)  = sum(sum(sum(lmpreb1.*gjoint.*repmat(abdelta,[1,1,ngpy]))));
    Empreb2grid(ir)  = sum(sum(sum(lmpreb2.*gjoint.*repmat(abdelta,[1,1,ngpy]))));
    Empreb4grid(ir)  = sum(sum(sum(lmpreb4.*gjoint.*repmat(abdelta,[1,1,ngpy]))));

end
Empreb1grid = Empreb1grid';
Empreb2grid = Empreb2grid';
Empreb4grid = Empreb4grid';
%%
fprintf('Plotting MPC Heterogeneity: Amount of Transfer\n');
count=count+1;
figure(count);
hold on;
plot(rebgrid,Empreb1grid,'r','LineWidth',3);
plot(rebgrid,Empreb2grid,'b','LineWidth',3);
plot(rebgrid,Empreb4grid,'k','LineWidth',3);
grid;
ylim([0 0.5]);
title('Fraction of lump sum transfer consumed','FontSize',20,'interpreter','latex');
legend('One quarter','Two quarters','One year','Location','NorthWest');
xlabel('Amount of transfer (\$)','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16) ;
text(500,0.13,['$ \uparrow $'],'FontSize',20,'interpreter','latex','Color','r');
text(200,0.07,['Quarterly MPC out of $\$500 = ' num2str(round(Empreb1grid(10)*100,0)) '\% $'],'FontSize',20,'interpreter','latex','Color','r');
alpha(0.7)
if Save==1
    saveas(gcf,[SaveDir '\fig_2a_' figname '.png']);
    %print('-depsc',[SaveDir '\fig_2a']);
end


%% DISTRIBUTION OF D/A FOR USE WHEN PLOTTING ADJUSTMENT COST FUNCTION


dovera = dep./max(initss.kappa3,repmat(agrid,1,ngpb,ngpy));
mindovera = min(min(min(dovera)));
mindoveraP = min(min(min(dovera(dep>0))));
maxdovera = max(max(max(dovera)));
maxdoveraN = max(max(max(dovera(dep<0))));

doverawidth = 0.0025;
minplotdovera = -0.05;
maxplotdovera = 0.05;
% doverahistpoints   = [minplotdovera:doverawidth:maxdoveraN 0 mindoveraP:doverawidth:maxplotdovera]';
doverahistpoints   = [minplotdovera:doverawidth:maxplotdovera]';
dovera_cumdist     = zeros(size(doverahistpoints));
for i = 1:length(doverahistpoints)-1
    dovera_cumdist(i) = sum(sum(sum(gjoint(dovera<=doverahistpoints(i)).* abydelta(dovera<=doverahistpoints(i)) )));
end
dovera_cumdist(length(doverahistpoints))=1;
doverahist         = diff([0; dovera_cumdist]);


%% ADJUSTMENT COST FUNCTION /D AS FUNCTION OF OF D/ASSETS
fprintf('Adjustment Cost Functions\n');
adjcostfn_w     = @(d,a) initss.kappa0_w.*abs(d./max(a,initss.kappa3)) + (abs((d./max(a,initss.kappa3))/initss.kappa1_w).^(1+initss.kappa2_w)) .*initss.kappa1_w./ (1+initss.kappa2_w);
adjcostfn_d     = @(d,a) initss.kappa0_d.*abs(d./max(a,initss.kappa3)) + (abs((d./max(a,initss.kappa3))/initss.kappa1_d).^(1+initss.kappa2_d)) .*initss.kappa1_d./ (1+initss.kappa2_d);
adjcostfn       = @(d,a) (d<=0).*adjcostfn_w(d,a).*max(a,initss.kappa3)+ (d>=0).*adjcostfn_d(d,a).*max(a,initss.kappa3);

xlimit = [-5 5];

count=count+1;
figure(count);
[fbar]   = bar((doverahistpoints-0.5*doverawidth).*100, doverahist,'histc');
axbar = gca;
sh  = findall(gcf,'marker','*'); delete(sh);
set(fbar,'FaceColor','blue','EdgeColor','none');
xlim([xlimit]);
alpha(0.3);
axbar.YAxisLocation ='right';
axline = axes('Position',axbar.Position,...
    'XAxisLocation','bottom','YAxisLocation','left','Color','none','XLim',xlim);
set(gca,'FontSize',16) ;


hold on;
aplotadj = initss.PERCa(6);
laplot = aplotadj;
f1 = ezplot(@(x)adjcostfn((x./100).*laplot,laplot).*100./((abs(x)./100).*laplot),xlimit,'Parent',axline);
ylim([0 40]);
grid on;
set(f1,'LineWidth',3.5,'Color','r');
plot(0,adjcostfn((1.e-10).*laplot,laplot).*100./((abs(1.e-10)).*laplot),'o','MarkerSize',16,'MarkerEdgeColor','r','LineWidth',4);

f3 = ezplot(@(x)initss.kappa0_w.*100,xlim,'Parent',axline);
set(f3,'LineWidth',1,'Color','k');

text(-4.8,7,['Linear cost: $' num2str(initss.kappa0_w.*100) '\% $ $\downarrow $ '],'FontSize',20,'interpreter','latex','Color','k');

xlabel('Quarterly Deposit/Withdrawal, \% of Stock','FontSize',20,'interpreter','latex');
ylabel('\% of Deposit/Withdrawal','FontSize',20,'interpreter','latex');
title('Adjustment Cost, \% of Deposit/Withdrawal','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16) ;
set(axbar,'FontSize',16) ;
set(axline,'FontSize',16) ;

hold off;
alpha(0.7);
if Save==1
    saveas(gcf,[SaveDir '\fig_D3b_' figname '.png']);
    %print('-depsc',[SaveDir '\fig_D3b']);
end


%% ADJUSTMENT COST FUNCTION /A AS FUNCTION OF OF D/ASSETS

%for a > kappa_3, this is not a function of a.

adjcostfn_w     = @(d,a) initss.kappa0_w.*abs(d./max(a,initss.kappa3)) + (abs((d./max(a,initss.kappa3))/initss.kappa1_w).^(1+initss.kappa2_w)) .*initss.kappa1_w./ (1+initss.kappa2_w);
adjcostfn_d     = @(d,a) initss.kappa0_d.*abs(d./max(a,initss.kappa3)) + (abs((d./max(a,initss.kappa3))/initss.kappa1_d).^(1+initss.kappa2_d)) .*initss.kappa1_d./ (1+initss.kappa2_d);
adjcostfn       = @(d,a) abs(d).*( (d<=0).*adjcostfn_w(d,a).*max(a,initss.kappa3)+ (d>=0).*adjcostfn_d(d,a).*max(a,initss.kappa3));

xlimit = [-5 5];

count=count+1;
figure(count);
[fbar]   = bar((doverahistpoints-0.5*doverawidth).*100, doverahist,'histc');
axbar = gca;
sh  = findall(gcf,'marker','*'); delete(sh);
set(fbar,'FaceColor','blue','EdgeColor','none');
xlim([xlimit]);
alpha(0.3);
axbar.YAxisLocation = 'right';
axline = axes('Position',axbar.Position,...
    'XAxisLocation','bottom','YAxisLocation','left','Color','none','XLim',xlim);
set(gca,'FontSize',16) ;

hold on;
aplotadj = initss.PERCa(6);
laplot = aplotadj;
f1 = ezplot(@(x)adjcostfn((x./100).*laplot,laplot).*100./((abs(x)./100).*laplot),xlimit);
ylim([0 0.25]);
grid on;
set(f1,'LineWidth',3.5,'Color','r');
%set(f2,'LineWidth',3.5,'Color','b');

xlabel('Quarterly Deposit/Withdrawal, \% of Stock','FontSize',20,'interpreter','latex');
ylabel('\% of Stock','FontSize',20,'interpreter','latex');
title('Adjustment Cost, \% of Stock','FontSize',20,'interpreter','latex');
set(gca,'FontSize',16) ;
set(axbar,'FontSize',16) ;
set(axline,'FontSize',16) ;

hold off;
alpha(0.7);
if Save==1
    saveas(gcf,[SaveDir '\fig_D3a_' figname '.png']);
    %print('-depsc',[SaveDir '\fig_D3a']);
end



%% JOINT DISTRIBUTION OF MPCs
fprintf('MPC Hetereogeneity: Joint Dsitribution of MPCs\n');
ipoint   = (ngpy+1)/2;
bplotmax = 20;     %in $000
bplotpoints = find(bgrid.*dataannoutput/(initss.output*4*1000)<bplotmax);
aplotmax = 400;     %in $000
aplotpoints = find(agrid.*dataannoutput/(initss.output*4*1000)<aplotmax);


%% One quarter $500 mp rebate (3D): average across income states
lavmpreb1  = squeeze(mpreb1(aplotpoints,bplotpoints,1)).*ydist(1);
for iy = 2:ngpy
    lavmpreb1 = lavmpreb1 + squeeze(mpreb1(aplotpoints,bplotpoints,iy)).*ydist(iy);    
end 

count=count+1;
figure(count);
surf(bgrid(bplotpoints).*dataannoutput/(initss.output*4*1000),agrid(aplotpoints).*dataannoutput/(initss.output*4*1000),lavmpreb1 ,'LineWidth',1);
xlabel('Liquid Wealth (\$000)','FontSize',16, 'interpreter','latex');
ylabel('Illiquid Wealth (\$000)','FontSize',16, 'interpreter','latex');
grid on;
xlim([bgrid(1).*dataannoutput/(initss.output*4*1000) bplotmax]);
ylim([agrid(1).*dataannoutput/(initss.output*4*1000) aplotmax]);
title('Quarterly MPC \$500','FontSize',20, 'interpreter','latex');
set(gca,'FontSize',14);
zlim([0 0.3]);

if Save==1
    saveas(gcf,[SaveDir '\fig_2b_' figname '.png']);
    %print('-depsc',[SaveDir '\fig_2b']);
end

fprintf('Completed Plotting Steady State Figures\n');
