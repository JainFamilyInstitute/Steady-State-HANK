clearvars -except Time1 figname; clc;
count=0;
% InputDir=strcat('D:\University of Washington\HANK Literature\Codes for Heterogenous Models',...
%     '\myHANKReplication\ReplicateHank-Steady State\');
InputDir=strcat(cd,'\');
%%
lSaveDir = strcat(InputDir,'TransitionFigures'); %path to directory to save figures
mkdir(lSaveDir);
lSave = 1;

%% LOAD WORKSPACES
SSInputDir = InputDir;
load([SSInputDir 'Steadystate_workspace_paper.mat']);
clearvars alpha
NOFS = load([InputDir 'IRF_Monetary_NOFS_workspace.mat']);
PE3 = load([InputDir 'IRF_Monetary_PE3_workspace.mat']);
PE4 = load([InputDir 'IRF_Monetary_PE4_workspace.mat']);
PE5 = load([InputDir 'IRF_Monetary_PE5_workspace.mat']);
PE6 = load([InputDir 'IRF_Monetary_PE6_workspace.mat']);
PE7 = load([InputDir 'IRF_Monetary_PE7_workspace.mat']);
PE9 = load([InputDir 'IRF_Monetary_PE9_workspace.mat']);

%%
SaveDir = lSaveDir;

datagrosslabinc = 69100;
dataannoutput = 115000;
tstep       = load([InputDir 'deltatransvec.txt']);

tlim = [0 20];
% tlim = [0 40];
% tlim = [0 50];
tlimFG = [0 16];
ShockType = 'Monetary';
tpoints = NOFS.tpoints-tstep(1);

Save = lSave;
% MonetaryShockSize =0.0025;
if MonetaryShockSize == 0.0025
   locfigname = ['NegativeMPS_lags' num2str(tlim(2)) '.png'];
else
   locfigname = ['PositiveMPS_lags' num2str(tlim(2)) '.png']; 
end    

%% 




%% monetary shock, liquid return and inflation
fprintf('Impulse Responses to a Monetary Policy Shock\n');

count=count+1;
figure(count);
hold on;
plot(tpoints,400.*NOFS.sticky.mpshock, 'r','LineWidth',1.5);
plot(tpoints,400.*(NOFS.sticky.rb-initss.rb), 'b--','LineWidth',1.5);
plot(tpoints,400.*(NOFS.sticky.ra-initss.ra), 'g-','LineWidth',1.5);
plot(tpoints,400.*NOFS.sticky.pi, 'k-.','LineWidth',1.5);
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Taylor rule innovation: $\epsilon$' ...
    'Liquid return: $r^b$' 'Illiquid Return: $r^a$' 'Inflation: $\pi$'},'Location','Best','Interpreter','latex');
xlim(tlim);
%ylim([-1.5 1.5]);
hold off;
ylabel('Deviation (pp annual)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
if Save==1
    saveas(gcf,[SaveDir '\fig_3b_' figname locfigname]);
    %print('-depsc',[SaveDir '\fig_3a']);
end

%% Liquidity change (=b/a) IRF

NOFS.sticky.atot = NOFS.sticky.Ea;
NOFS.initss.atot = NOFS.initss.Ea;
NOFS.sticky.btot = NOFS.sticky.Eb;
NOFS.initss.btot = NOFS.initss.Eb;
a=NOFS.sticky.atot/NOFS.initss.atot;
b=NOFS.sticky.btot/NOFS.initss.btot;

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*log(b/a), 'b--','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
%ylim([-1.5 1.5]);
hold off;
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
if MonetaryShockSize==0.0025
   t=title('Aggregate Liquidity: negative MP shock');
else
  t=title('Aggregate Liquidity:  positive MP shock');
end
t.FontSize=14;
set(gca,'FontSize',14);
if Save==1
    saveas(gcf,[SaveDir '\Aggregate_Portfolio_Liquidity_' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_3b']);
end

%% Illiquid asset premium 

count=count+1;
figure(count);
hold on;
plot(tpoints,400.*((NOFS.sticky.ra-initss.ra)-(NOFS.sticky.rb-initss.rb)), 'b--','LineWidth',1.5);
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
%ylim([-1.5 1.5]);
hold off;
ylabel('Deviation (pp annual)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
if MonetaryShockSize==0.0025
   t=title('Equity Premium: negative MP shock');
else
  t=title('Equity Premium:  positive MP shock');
end
t.FontSize=14;
set(gca,'FontSize',14);
if Save==1
    saveas(gcf,[SaveDir '\Illiquid asset premium_' figname locfigname]);
end


%% output, total consumption, total investment
NOFS.initss.Ctot = NOFS.initss.Ec;
NOFS.sticky.Ctot = NOFS.sticky.Ec;
NOFS.sticky.Itot = NOFS.sticky.investment;
NOFS.initss.Itot = NOFS.initss.investment;
NOFS.sticky.htot = NOFS.sticky.Ehours;
NOFS.initss.htot = NOFS.initss.Ehours;
NOFS.sticky.dtot = NOFS.sticky.Ed;
NOFS.initss.dtot = NOFS.initss.Ed;
NOFS.sticky.atot = NOFS.sticky.Ea;
NOFS.initss.atot = NOFS.initss.Ea;
NOFS.sticky.btot = NOFS.sticky.Eb;
NOFS.initss.btot = NOFS.initss.Eb;
NOFS.sticky.ktot = NOFS.sticky.output.*NOFS.sticky.KYratio;
NOFS.initss.ktot = NOFS.initss.output*NOFS.initss.KYratio;


count=count+1;
figure(count);
hold on;
plot(tpoints,100.*log(NOFS.sticky.output./NOFS.initss.output), 'k-.','LineWidth',1.5),grid;
plot(tpoints,100.*log(NOFS.sticky.Ctot./NOFS.initss.Ctot), 'b--','LineWidth',1.5),grid;
plot(tpoints,100.*log(NOFS.sticky.Itot./NOFS.initss.Itot), 'r','LineWidth',1.5),grid;
plot(tpoints,100.*log(NOFS.sticky.htot./NOFS.initss.htot), 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*log(NOFS.sticky.dtot./NOFS.initss.dtot), 'g-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Output' 'Consumption' 'Investment'  'Labor' 'Deposits'},'Location','Best','Interpreter','latex');
xlim(tlim);
% ylim([-1.5 0.5]);
hold off;
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
if Save==1
    saveas(gcf,[SaveDir '\fig_3b_' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_3b']);
end

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*log(NOFS.sticky.ktot./NOFS.initss.ktot), 'r-','LineWidth',1.5),grid;
plot(tpoints,100.*log(NOFS.sticky.atot./NOFS.initss.atot), 'g-','LineWidth',1.5),grid;
plot(tpoints,100.*log(NOFS.sticky.btot./NOFS.initss.btot), 'b--','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Capital' 'Liquid Assets' 'Illqiuid Assets'},'Location','Best','Interpreter','latex');
xlim(tlim);
% xlim([0 200]);
% ylim([-1.5 0.5]);
hold off;
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
if Save==1
    saveas(gcf,[SaveDir '\fig_3b_AssetsDeviation_' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_3b']);
end

%% Plot transition for GINI

a = log(NOFS.sticky.GINInw./NOFS.initss.GINInw);
b = log(NOFS.sticky.GINIinc./NOFS.initss.GINIinc);
c = log(NOFS.sticky.GINIc./NOFS.initss.GINIc);
d = log(NOFS.sticky.GINIa./NOFS.initss.GINIa);
e = log(NOFS.sticky.GINIb./NOFS.initss.GINIb);
f = log(NOFS.sticky.GINIlabinc./NOFS.initss.GINIlabinc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*a, 'r--','LineWidth',1.5),grid;
plot(tpoints,100.*b, 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*d, 'm:','LineWidth',1.5),grid;
plot(tpoints,100.*e, 'g-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'Color', [0.8500 0.3250 0.0980] ,'LineStyle','-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Wealth' 'Income' 'Consumption' 'Illiquid' 'Liquid' 'Lab. inc.'},'Location','Best','Interpreter','latex');
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('GINI Coefficients: negative MP shock');
else
  t=title('GINI Coefficients:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Gini_Coefficients_' figname locfigname]);
end

%% Plot GINIS separately 

% Consumption
count=count+1;
figure(count);
hold on;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Consumption GINI: negative MP shock');
else
  t=title('Consumption GINI:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Consumption_Gini_' figname locfigname]);
end

% Income
count=count+1;
figure(count);
hold on;
plot(tpoints,100.*b, 'c-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Income GINI: negative MP shock');
else
  t=title('Income GINI:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Income_Gini_' figname locfigname]);
end

% Wealth
count=count+1;
figure(count);
hold on;
plot(tpoints,100.*a, 'Color', [0.8500 0.3250 0.0980] ,'LineStyle','-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Wealth GINI: negative MP shock');
else
  t=title('Wealth GINI:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Wealth_Gini_' figname locfigname]);
end

% Earnings
count=count+1;
figure(count);
hold on;
plot(tpoints,100.*f, 'Color', [0.4940 0.1840 0.5560] ,'LineStyle','-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Earnings GINI: negative MP shock');
else
  t=title('Earnings GINI:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Earnings_Gini_' figname locfigname]);
end

% Illiquid
count=count+1;
figure(count);
hold on;
plot(tpoints,100.*d, 'Color', [0.6350 0.0780 0.1840] ,'LineStyle','-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Illiquid Wealth GINI: negative MP shock');
else
  t=title('Illiquid Wealth GINI:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Illiquid_Gini_' figname locfigname]);
end

% Liquid
count=count+1;
figure(count);
hold on;
plot(tpoints,100.*e, 'Color', [0.9290 0.6940 0.1250] ,'LineStyle','-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Liquid Wealth Wealth GINI: negative MP shock');
else
  t=title('Liquid Wealth Wealth GINI:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Liquid_Gini_' figname locfigname]);
end
%% Plot transition for 90-10 shares (log deviations) 

% % for income
% a = 1-NOFS.sticky.totinc_share_top10pc;
% b = 1-NOFS.initss.totinc_share_top10pc;
% c = log(a./b);
% 
% d = log(NOFS.sticky.totinc_share_bot10pc./NOFS.initss.totinc_share_bot10pc);
% 
% count=count+1;
% figure(count);
% hold on;
% %plot(tpoints,100.*(d./c), 'c-','LineWidth',1.5),grid;
% plot(tpoints,100.*(d-c), 'c-','LineWidth',1.5),grid;
% plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
% grid on;
% xlim(tlim);
% % xlim([0 40]);
% if MonetaryShockSize==0.0025
%    t=title('Income 90-10 shares: negative MP shock');
% else
%   t=title('Income 90-10 shares:  positive MP shock');
% end
% ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
% xlabel('Quarters', 'interpreter','latex','FontSize',14);
% set(gca,'FontSize',14);
% t.FontSize=14;
% if Save==1
%     saveas(gcf,[SaveDir '\Transition_Income_90-10_shares_' figname locfigname]);
% end
% 
% % for consumption
% a = 1-NOFS.sticky.con_share_top10pc;
% b = 1-NOFS.initss.con_share_top10pc;
% 
% c = log(a./b);
% 
% d = log(NOFS.sticky.con_share_bot10pc./NOFS.initss.con_share_bot10pc);
% 
% count=count+1;
% figure(count);
% hold on;
% plot(tpoints,100.*(d-c), 'b-','LineWidth',1.5),grid;
% plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
% grid on;
% xlim(tlim);
% % xlim([0 40]);
% if MonetaryShockSize==0.0025
%    t=title('Consumption 90-10 shares: negative MP shock');
% else
%   t=title('Consumption 90-10 shares:  positive MP shock');
% end
% ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
% xlabel('Quarters', 'interpreter','latex','FontSize',14);
% set(gca,'FontSize',14);
% t.FontSize=14;
% if Save==1
%     saveas(gcf,[SaveDir '\Transition_Consumption_90-10_shares_' figname locfigname]);
% end
% 
% % for labor income which is earnings here
% a = 1-NOFS.sticky.inc_share_top10pc;
% b = 1-NOFS.initss.inc_share_top10pc;
% c = log(a./b);
% 
% d = log(NOFS.sticky.inc_share_bot10pc./NOFS.initss.inc_share_bot10pc);
% 
% count=count+1;
% figure(count);
% hold on;
% plot(tpoints,100.*(d-c), 'Color', [0.4940 0.1840 0.5560] ,'LineStyle','-','LineWidth',1.5),grid;
% plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
% grid on;
% xlim(tlim);
% % xlim([0 40]);
% if MonetaryShockSize==0.0025
%    t=title('Earnings 90-10 shares: negative MP shock');
% else
%   t=title('Earnings 90-10 shares:  positive MP shock');
% end
% ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
% xlabel('Quarters', 'interpreter','latex','FontSize',14);
% set(gca,'FontSize',14);
% t.FontSize=14;
% if Save==1
%     saveas(gcf,[SaveDir '\Transition_Earnings_90-10_shares_' figname locfigname]);
% end
% 

% for wealth
a = 1-NOFS.sticky.nw_share_top10pc;
b = 1-NOFS.initss.nw_share_top10pc;
c = log(a./b);

d = log(NOFS.sticky.nw_share_bot10pc./NOFS.initss.nw_share_bot10pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*(c-d), 'c-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Wealth 90-10 shares: negative MP shock');
else
  t=title('Wealth 90-10 shares:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Wealth_90-10_shares_' figname locfigname]);
end

%% Plot transition for 90-10 percentiles (log deviations) 

% for income
a = NOFS.sticky.totinc_p90pc;
b = NOFS.initss.totinc_p90pc;
c = log(a./b);

d = log(NOFS.sticky.totinc_p10pc./NOFS.initss.totinc_p10pc);

count=count+1;
figure(count);
hold on;
%plot(tpoints,100.*(d./c), 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*(c-d), 'c-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Income 90-10 perc: negative MP shock');
else
  t=title('Income 90-10 perc:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Income_90-10_percdiff_' figname locfigname]);
end

% for consumption
a = NOFS.sticky.con_p90pc;
b = NOFS.initss.con_p90pc;

c = log(a./b);

d = log(NOFS.sticky.con_p10pc./NOFS.initss.con_p10pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*(c-d), 'b-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Consumption 90-10 perc: negative MP shock');
else
  t=title('Consumption 90-10 perc:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Consumption_90-10_percdiff_' figname locfigname]);
end

% for labor income which is earnings here
a = NOFS.sticky.inc_p90pc;
b = NOFS.initss.inc_p90pc;
c = log(a./b);

d = log(NOFS.sticky.inc_p10pc./NOFS.initss.inc_p10pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*(c-d), 'Color', [0.4940 0.1840 0.5560] ,'LineStyle','-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Earnings 90-10 perc: negative MP shock');
else
  t=title('Earnings 90-10 perc:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Earnings_90-10_percdiff_' figname locfigname]);
end


% for wealth
a = 1-NOFS.sticky.nw_share_top10pc;
b = 1-NOFS.initss.nw_share_top10pc;
c = log(a./b);

d = log(NOFS.sticky.nw_share_bot10pc./NOFS.initss.nw_share_bot10pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*(c-d), 'c-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Wealth 90-10 shares: negative MP shock');
else
  t=title('Wealth 90-10 shares:  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Wealth_90-10_shares_' figname locfigname]);
end



%% Plot P10-P50 (blue) and P90-P50 (red) income, consumption, labor income percentile diffs and wealth shares separately

% % for income
% a = log(NOFS.sticky.totinc_share_bot10pc./NOFS.initss.totinc_share_bot10pc);
% b = log(NOFS.sticky.totinc_share_bot50pc./NOFS.initss.totinc_share_bot50pc);
% c = a-b;
% 
% d = 1-NOFS.sticky.totinc_share_top10pc;
% e = 1-NOFS.initss.totinc_share_top10pc;
% f = log(d./e)-b;
% 
% count=count+1;
% figure(count);
% hold on;
% plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
% plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
% plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
% grid on;
% legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
% ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
% xlabel('Quarters', 'interpreter','latex','FontSize',14);
% xlim(tlim);
% % xlim([0 40]);
% if MonetaryShockSize==0.0025
%    t=title('Income shares: negative MP shock');
% else
%   t=title('Income shares:  positive MP shock');
% end
% set(gca,'FontSize',14);
% t.FontSize=14;
% if Save==1
%     saveas(gcf,[SaveDir '\Transition_Dist_Impact_Income_shares_' figname locfigname]);
% end
% 
% 
% % for consumption
% a = log(NOFS.sticky.con_share_bot10pc./NOFS.initss.con_share_bot10pc);
% b = log(NOFS.sticky.con_share_bot50pc./NOFS.initss.con_share_bot50pc);
% c = a-b;
% 
% d = 1-NOFS.sticky.con_share_top10pc;
% e = 1-NOFS.initss.con_share_top10pc;
% f = log(d./e)-b;
% 
% count=count+1;
% figure(count);
% hold on;
% plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
% plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
% plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
% grid on;
% legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
% ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
% xlabel('Quarters', 'interpreter','latex','FontSize',14);
% xlim(tlim);
% % xlim([0 40]);
% if MonetaryShockSize==0.0025
%    t=title('Consumption shares: negative MP shock');
% else
%   t=title('Consumption shares:  positive MP shock');
% end
% set(gca,'FontSize',14);
% t.FontSize=14;
% if Save==1
%     saveas(gcf,[SaveDir '\Transition_Dist_Impact_Consumption_shares_' figname locfigname]);
% end
% 
% % for labor income
% a = log(NOFS.sticky.inc_share_bot10pc./NOFS.initss.inc_share_bot10pc);
% b = log(NOFS.sticky.inc_share_bot50pc./NOFS.initss.inc_share_bot50pc);
% c = a-b;
% 
% d = 1-NOFS.sticky.inc_share_top10pc;
% e = 1-NOFS.initss.inc_share_top10pc;
% f = log(d./e)-b;
% 
% count=count+1;
% figure(count);
% hold on;
% plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
% plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
% plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
% grid on;
% legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
% ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
% xlabel('Quarters', 'interpreter','latex','FontSize',14);
% xlim(tlim);
% % xlim([0 40]);
% if MonetaryShockSize==0.0025
%    t=title('Earnings shares: negative MP shock');
% else
%   t=title('Earnings shares:  positive MP shock');
% end
% set(gca,'FontSize',14);
% t.FontSize=14;
% if Save==1
%     saveas(gcf,[SaveDir '\Transition_Dist_Impact_Earnings_shares_' figname locfigname]);
% end

% for income
a = log(NOFS.sticky.totinc_p10pc./NOFS.initss.totinc_p10pc);
b = log(NOFS.sticky.totinc_p50pc./NOFS.initss.totinc_p50pc);
c = a-b;

d = NOFS.sticky.totinc_p90pc;
e = NOFS.initss.totinc_p90pc;
f = log(d./e)-b;

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Income perc: negative MP shock');
else
  t=title('Income perc:  positive MP shock');
end
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Dist_Impact_Income_percdiff_' figname locfigname]);
end


% for consumption
a = log(NOFS.sticky.con_p10pc./NOFS.initss.con_p10pc);
b = log(NOFS.sticky.con_p50pc./NOFS.initss.con_p50pc);
c = a-b;

d = NOFS.sticky.con_p90pc;
e = NOFS.initss.con_p90pc;
f = log(d./e)-b;

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Consumption perc: negative MP shock');
else
  t=title('Consumption perc:  positive MP shock');
end
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Dist_Impact_Consumption_percdiff_' figname locfigname]);
end

% for labor income
a = log(NOFS.sticky.inc_p10pc./NOFS.initss.inc_p10pc);
b = log(NOFS.sticky.inc_p50pc./NOFS.initss.inc_p50pc);
c = a-b;

d = NOFS.sticky.inc_p90pc;
e = NOFS.initss.inc_p90pc;
f = log(d./e)-b;

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Earnings perc: negative MP shock');
else
  t=title('Earnings perc:  positive MP shock');
end
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Dist_Impact_Earnings_percdiff_' figname locfigname]);
end

% for net wealth shares
a = log(NOFS.sticky.nw_share_bot10pc./NOFS.initss.nw_share_bot10pc);
b = log(NOFS.sticky.nw_share_bot50pc./NOFS.initss.nw_share_bot50pc);
c = a-b;

d = 1-NOFS.sticky.nw_share_top10pc;
e = 1-NOFS.initss.nw_share_top10pc;
f = log(d./e)-b;

% a = NOFS.sticky.nw_share_bot10pc./NOFS.initss.nw_share_bot10pc;
% b = NOFS.sticky.nw_share_bot50pc./NOFS.initss.nw_share_bot50pc;
% c = a-b;
% 
% d = 1-NOFS.sticky.nw_share_top10pc;
% e = 1-NOFS.initss.nw_share_top10pc;
% f = d./e-b;

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Wealth shares: negative MP shock');
else
  t=title('Wealth shares:  positive MP shock');
end
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Dist_Impact_Wealth_shares_' figname locfigname]);
end

% for liquid wealth shares
a = log(NOFS.sticky.liq_share_bot10pc./NOFS.initss.liq_share_bot10pc);
b = log(NOFS.sticky.liq_share_bot50pc./NOFS.initss.liq_share_bot50pc);
c = a-b;

d = 1-NOFS.sticky.liq_share_top10pc;
e = 1-NOFS.initss.liq_share_top10pc;
f = log(d./e)-b;

% a = NOFS.sticky.nw_share_bot10pc./NOFS.initss.nw_share_bot10pc;
% b = NOFS.sticky.nw_share_bot50pc./NOFS.initss.nw_share_bot50pc;
% c = a-b;
% 
% d = 1-NOFS.sticky.nw_share_top10pc;
% e = 1-NOFS.initss.nw_share_top10pc;
% f = d./e-b;

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Liquid Wealth shares: negative MP shock');
else
  t=title('Liquid Wealth shares:  positive MP shock');
end
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Dist_Impact_Liquid_Wealth_shares_' figname locfigname]);
end

% for illiquid wealth shares
% a = log(NOFS.sticky.ill_share_bot10pc./NOFS.initss.ill_share_bot10pc);
a = 0;
b = log(NOFS.sticky.ill_share_bot50pc./NOFS.initss.ill_share_bot50pc);
c = a-b;

d = 1-NOFS.sticky.ill_share_top10pc;
e = 1-NOFS.initss.ill_share_top10pc;
f = log(d./e)-b;

% a = 0;
% b = NOFS.sticky.ill_share_bot50pc./NOFS.initss.ill_share_bot50pc;
% c = a-b;

% d = 1-NOFS.sticky.ill_share_top10pc;
% e = 1-NOFS.initss.ill_share_top10pc;
% f = d./e-b;

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'r-','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'P10-P50' 'P90-P50'},'Location','Best','Interpreter','latex');
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
xlim(tlim);
% xlim([0 40]);
if MonetaryShockSize==0.0025
   t=title('Illiquid Wealth shares: negative MP shock');
else
  t=title('Illiquid Wealth shares:  positive MP shock');
end
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Dist_Impact_Illiquid_Wealth_shares_' figname locfigname]);
end

%% Plot transition for Wealth Shares: Illiquid

t_ill_share_mid5090pc = 1-NOFS.sticky.ill_share_bot50pc-NOFS.sticky.ill_share_top10pc;
ss_ill_share_mid5090pc = 1-NOFS.initss.ill_share_bot50pc-NOFS.initss.ill_share_top10pc;

a = log(NOFS.sticky.ill_share_top10pc./NOFS.initss.ill_share_top10pc);
b = log(NOFS.sticky.ill_share_top1pc./NOFS.initss.ill_share_top1pc);
c = log(NOFS.sticky.ill_share_top01pc./NOFS.initss.ill_share_top01pc);
d = log(NOFS.sticky.ill_share_bot50pc./NOFS.initss.ill_share_bot50pc);
e = log(NOFS.sticky.ill_share_bot25pc./NOFS.initss.ill_share_bot25pc);
f = log(t_ill_share_mid5090pc./ss_ill_share_mid5090pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*a, 'r--','LineWidth',1.5),grid;
plot(tpoints,100.*b, 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*d, 'm:','LineWidth',1.5),grid;
plot(tpoints,100.*e, 'g-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'b--','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend1=legend({'Top 10' 'Top 1' 'Top 0.1' 'Bottom50' 'Bottom25' '50-90Perc'},'Location','Southeast','Interpreter','latex');
if tlim(2)==20
    set(legend1,...
    'Position',[0.381577179432808 0.454345229580289 0.220655164943907 0.303476200149173],...
    'Interpreter','latex');
end
xlim(tlim);
if MonetaryShockSize == 0.0025
   t=title('Illiquid Wealth Shares  negative MP shock');
else
  t=title('Illiquid Wealth Shares  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Illiquid_Wealth_Shares_' figname locfigname]);
end

%% Plot transition for Wealth Shares: Liquid

t_liq_share_mid5090pc = 1-NOFS.sticky.liq_share_bot50pc-NOFS.sticky.liq_share_top10pc;
ss_liq_share_mid5090pc = 1-NOFS.initss.liq_share_bot50pc-NOFS.initss.liq_share_top10pc;

a = log(NOFS.sticky.liq_share_top10pc./NOFS.initss.liq_share_top10pc);
b = log(NOFS.sticky.liq_share_top1pc./NOFS.initss.liq_share_top1pc);
c = log(NOFS.sticky.liq_share_top01pc./NOFS.initss.liq_share_top01pc);
d = log(NOFS.sticky.liq_share_bot50pc./NOFS.initss.liq_share_bot50pc);
e = log(NOFS.sticky.liq_share_bot25pc./NOFS.initss.liq_share_bot25pc);
f = log(t_liq_share_mid5090pc./ss_liq_share_mid5090pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*a, 'r--','LineWidth',1.5),grid;
plot(tpoints,100.*b, 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*d, 'm:','LineWidth',1.5),grid;
plot(tpoints,100.*e, 'g-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'b--','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Top 10' 'Top 1' 'Top 0.1' 'Bottom50' 'Bottom25' '50-90Perc'},'Location','Best','Interpreter','latex');
xlim(tlim);
if MonetaryShockSize == 0.0025
   t=title('Liquid Wealth Shares  negative MP shock');
else
  t=title('Liquid Wealth Shares  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Liquid_Wealth_Shares_' figname locfigname]);
end

%% Plot transition for Wealth Shares: Net Wealth

t_nw_share_mid5090pc = 1-NOFS.sticky.nw_share_bot50pc-NOFS.sticky.nw_share_top10pc;
ss_nw_share_mid5090pc = 1-NOFS.initss.nw_share_bot50pc-NOFS.initss.nw_share_top10pc;

a = log(NOFS.sticky.nw_share_top10pc./NOFS.initss.nw_share_top10pc);
b = log(NOFS.sticky.nw_share_top1pc./NOFS.initss.nw_share_top1pc);
c = log(NOFS.sticky.nw_share_top01pc./NOFS.initss.nw_share_top01pc);
d = log(NOFS.sticky.nw_share_bot50pc./NOFS.initss.nw_share_bot50pc);
e = log(NOFS.sticky.nw_share_bot25pc./NOFS.initss.nw_share_bot25pc);
f = log(t_nw_share_mid5090pc./ss_nw_share_mid5090pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*a, 'r--','LineWidth',1.5),grid;
plot(tpoints,100.*b, 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*d, 'm:','LineWidth',1.5),grid;
plot(tpoints,100.*e, 'g-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'b--','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend1=legend({'Top 10' 'Top 1' 'Top 0.1' 'Bottom50' 'Bottom25' '50-90Perc'},'Location','Southeast','Interpreter','latex');
if tlim(2)==20
    set(legend1,...
    'Position',[0.204791465147094 0.330535705770765 0.220655164943907 0.303476200149172],...
    'Interpreter','latex');
end
xlim(tlim);
if MonetaryShockSize == 0.0025
   t=title('Net Wealth Shares  negative MP shock');
else
  t=title('Net Wealth Shares  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Net_Wealth_Shares_' figname locfigname]);
end

%% Plot transition for Wealth Shares: Gross Labor Income

t_inc_share_mid5090pc = 1-NOFS.sticky.inc_share_bot50pc-NOFS.sticky.inc_share_top10pc;
ss_inc_share_mid5090pc = 1-NOFS.initss.inc_share_bot50pc-NOFS.initss.inc_share_top10pc;

a = log(NOFS.sticky.inc_share_top10pc./NOFS.initss.inc_share_top10pc);
b = log(NOFS.sticky.inc_share_top1pc./NOFS.initss.inc_share_top1pc);
c = log(NOFS.sticky.inc_share_top01pc./NOFS.initss.inc_share_top01pc);
d = log(NOFS.sticky.inc_share_bot50pc./NOFS.initss.inc_share_bot50pc);
e = log(NOFS.sticky.inc_share_bot25pc./NOFS.initss.inc_share_bot25pc);
f = log(t_inc_share_mid5090pc./ss_inc_share_mid5090pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*a, 'r--','LineWidth',1.5),grid;
plot(tpoints,100.*b, 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*d, 'm:','LineWidth',1.5),grid;
plot(tpoints,100.*e, 'g-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'b--','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Top 10' 'Top 1' 'Top 0.1' 'Bottom50' 'Bottom25' '50-90Perc'},'Location','Best','Interpreter','latex');
xlim(tlim);
if MonetaryShockSize == 0.0025
  t=title('Labor Income Shares  negative MP shock');
else
  t=title('Labor Income Shares  positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Gross_Labor_Income_Shares_' figname locfigname]);
end

%% Plot transition for Wealth Shares: Gross Total Income

t_totinc_share_mid5090pc = 1-NOFS.sticky.totinc_share_bot50pc-NOFS.sticky.totinc_share_top10pc;
ss_totinc_share_mid5090pc = 1-NOFS.initss.totinc_share_bot50pc-NOFS.initss.totinc_share_top10pc;

a = log(NOFS.sticky.totinc_share_top10pc./NOFS.initss.totinc_share_top10pc);
b = log(NOFS.sticky.totinc_share_top1pc./NOFS.initss.totinc_share_top1pc);
c = log(NOFS.sticky.totinc_share_top01pc./NOFS.initss.totinc_share_top01pc);
d = log(NOFS.sticky.totinc_share_bot50pc./NOFS.initss.totinc_share_bot50pc);
e = log(NOFS.sticky.totinc_share_bot25pc./NOFS.initss.totinc_share_bot25pc);
f = log(t_totinc_share_mid5090pc./ss_totinc_share_mid5090pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*a, 'r--','LineWidth',1.5),grid;
plot(tpoints,100.*b, 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*d, 'm:','LineWidth',1.5),grid;
plot(tpoints,100.*e, 'g-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'b--','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Top 10' 'Top 1' 'Top 0.1' 'Bottom50' 'Bottom25' '50-90Perc'},'Location','Best','Interpreter','latex');
xlim(tlim);
if MonetaryShockSize == 0.0025
  t=title('Total Income Shares negative MP shock');
else
  t=title('Total Income Shares positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Gross_Total_Income_Shares_' figname locfigname]);
end

%% Plot transition for Consumption shares

t_con_share_mid5090pc = 1-NOFS.sticky.con_share_bot50pc-NOFS.sticky.con_share_top10pc;
ss_con_share_mid5090pc = 1-NOFS.initss.con_share_bot50pc-NOFS.initss.con_share_top10pc;

a = log(NOFS.sticky.con_share_top10pc./NOFS.initss.con_share_top10pc);
b = log(NOFS.sticky.con_share_top1pc./NOFS.initss.con_share_top1pc);
c = log(NOFS.sticky.con_share_top01pc./NOFS.initss.con_share_top01pc);
d = log(NOFS.sticky.con_share_bot50pc./NOFS.initss.con_share_bot50pc);
e = log(NOFS.sticky.con_share_bot25pc./NOFS.initss.con_share_bot25pc);
f = log(t_con_share_mid5090pc./ss_con_share_mid5090pc);

count=count+1;
figure(count);
hold on;
plot(tpoints,100.*a, 'r--','LineWidth',1.5),grid;
plot(tpoints,100.*b, 'c-','LineWidth',1.5),grid;
plot(tpoints,100.*c, 'b-','LineWidth',1.5),grid;
plot(tpoints,100.*d, 'm:','LineWidth',1.5),grid;
plot(tpoints,100.*e, 'g-','LineWidth',1.5),grid;
plot(tpoints,100.*f, 'b--','LineWidth',1.5),grid;
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Top 10' 'Top 1' 'Top 0.1' 'Bottom50' 'Bottom25' '50-90Perc'},'Location','Best','Interpreter','latex');
xlim(tlim);
if MonetaryShockSize == 0.0025
  t=title('Consumption Shares negative MP shock');
else
  t=title('Consumption Shares positive MP shock');
end
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\Transition_Consumption_Shares_' figname locfigname]);
end

%% w, ra, rb, tau, equity deviations from steady state
fprintf('Direct and Indirect Effects of Monetary Policy in HANK: Prices and Consumption\n');

count=count+1;
figure(count);
hold on;
plot(tpoints,400.*(NOFS.sticky.rb-initss.rb), 'r--','LineWidth',1.5);
plot(tpoints,100.*log(NOFS.sticky.wage./NOFS.initss.wage), 'c-','LineWidth',1.5);
plot(tpoints,100.*log(NOFS.sticky.lumptransfer./NOFS.initss.lumptransfer), 'b-.','LineWidth',1.5);
plot(tpoints,400.*(NOFS.sticky.ra-initss.ra), 'm:','LineWidth',1.5);
plot(tpoints,100.*log(NOFS.sticky.equity./NOFS.initss.equity), 'g-','LineWidth',1.5);
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Liquid return: $r^b$ (pp annual)' 'Real wage: $w$ ($\%$)' 'Lump sum transfer: $T$ ($\%$)'  'Iliquid return: $r^a$ (pp annual)'  'Share price: $q$ ($\%$)'},'Location','Best','Interpreter','latex');
xlim(tlim);
% ylim([-1.5 0.5]);
hold off;
ylabel('Deviation', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\fig_4a_' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_4a']);
end


count=count+1;
figure(count);
hold on;
plot(tpoints,100.*log(NOFS.sticky.wage./NOFS.initss.wage), 'c-','LineWidth',1.5);
plot(tpoints,100.*log(NOFS.sticky.lumptransfer./NOFS.initss.lumptransfer), 'b-.','LineWidth',1.5);
plot(tpoints,100.*log(NOFS.sticky.equity./NOFS.initss.equity), 'g-','LineWidth',1.5);
plot(tpoints,zeros(size(tpoints)),'k-','LineWidth',1);
grid on;
legend({'Real wage: $w$ ' 'Lump sum transfer: $T$ '  'Share price: $q$'},'Location','Best','Interpreter','latex');
xlim(tlim);
% ylim([-1.5 0.5]);
hold off;
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
t.FontSize=14;
if Save==1
    saveas(gcf,[SaveDir '\fig_4a_OtherPrices_' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_4a']);
end

%% consumption decomposition: paper
count=count+1;
figure(count);
plot(tpoints,100.*log(NOFS.sticky.Ec./NOFS.initss.Ec), 'k',...
        tpoints,100.*log((PE4.sticky.Ec)./PE4.initss.Ec), 'r--',...        
        tpoints,100.*log(PE3.sticky.Ec./PE3.initss.Ec), 'c-',...
        tpoints,100.*log((PE7.sticky.Ec)./PE7.initss.Ec), 'b-.',...        
        tpoints,100.*log((PE5.sticky.Ec+PE6.sticky.Ec-NOFS.initss.Ec)./PE5.initss.Ec), 'm:',...
        tpoints,100.*zeros(size(tpoints)),'k:','LineWidth',1.5),grid;
leg=legend('Total Response','Direct: $r^b$','Indirect: $w$','Indirect: $T$','Indirect: $r^a \  \& \ q$','Location','NorthEast');
set(leg,'Interpreter','Latex');
set(leg,...
    'Location','best',...
    'Interpreter','latex');
xlim(tlim);
%ylim([-0.1 0.5]);
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
if MonetaryShockSize == 0.0025
  t=title('Aggregate Consumption Breakdown negative MP shock');
else
  t=title('Aggregate Consumption Breakdown positive MP shock');
end
t.FontSize=10;
if Save==1
    saveas(gcf,[SaveDir '\fig_4b_consumption' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_4b']);
end

%% aggregate deposit decomposition: paper

count=count+1;
figure(count);
plot(tpoints,100.*log(NOFS.sticky.Ed./NOFS.initss.Ed), 'k',...
        tpoints,100.*log((PE4.sticky.Ed)./PE4.initss.Ed), 'r--',...        
        tpoints,100.*log(PE3.sticky.Ed./PE3.initss.Ed), 'c-',...
        tpoints,100.*log((PE7.sticky.Ed)./PE7.initss.Ed), 'b-.',...        
        tpoints,100.*log((PE5.sticky.Ed+PE6.sticky.Ed-NOFS.initss.Ed)./PE5.initss.Ed), 'm:',...
        tpoints,100.*zeros(size(tpoints)),'k:','LineWidth',1.5),grid;
leg=legend('Total Response','Direct: $r^b$','Indirect: $w$','Indirect: $T$','Indirect: $r^a \  \& \ q$','Location','NorthEast');
set(leg,'Interpreter','Latex');
set(leg,...
    'Location','best',...
    'Interpreter','latex');
xlim(tlim);
%ylim([-0.1 0.5]);
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
if MonetaryShockSize == 0.0025
  t=title('Aggregate Deposit Breakdown negative MP shock');
else
  t=title('Aggregate Deposit Breakdown positive MP shock');
end
t.FontSize=10;
if Save==1
    saveas(gcf,[SaveDir '\fig_4b_deposits' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_4b']);
end


%% aggregate illiquid asset decomposition: paper

count=count+1;
figure(count);
plot(tpoints,100.*log(NOFS.sticky.Ea./NOFS.initss.Ea), 'k',...
        tpoints,100.*log((PE4.sticky.Ea)./PE4.initss.Ea), 'r--',...        
        tpoints,100.*log(PE3.sticky.Ea./PE3.initss.Ea), 'c-',...
        tpoints,100.*log((PE7.sticky.Ea)./PE7.initss.Ea), 'b-.',...        
        tpoints,100.*log((PE5.sticky.Ea+PE6.sticky.Ea-NOFS.initss.Ea)./PE5.initss.Ea), 'm:',...
        tpoints,100.*zeros(size(tpoints)),'k:','LineWidth',1.5),grid;
leg=legend('Total Response','Direct: $r^b$','Indirect: $w$','Indirect: $T$','Indirect: $r^a \  \& \ q$','Location','NorthEast');
set(leg,'Interpreter','Latex');
set(leg,...
    'Location','best',...
    'Interpreter','latex');
xlim(tlim);
%ylim([-0.1 0.5]);
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
if MonetaryShockSize == 0.0025
  t=title('Aggregate Illiquid Asset  Breakdown negative MP shock');
else
  t=title('Aggregate Illiquid Asset positive MP shock');
end
t.FontSize=10;
if Save==1
    saveas(gcf,[SaveDir '\fig_4b_illiquid' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_4b']);
end

%% aggregate liquid asset decomposition: paper

count=count+1;
figure(count);
plot(tpoints,100.*log(NOFS.sticky.Eb./NOFS.initss.Eb), 'k',...
        tpoints,100.*log((PE4.sticky.Eb)./PE4.initss.Eb), 'r--',...        
        tpoints,100.*log(PE3.sticky.Eb./PE3.initss.Eb), 'c-',...
        tpoints,100.*log((PE7.sticky.Eb)./PE7.initss.Eb), 'b-.',...        
        tpoints,100.*log((PE5.sticky.Eb+PE6.sticky.Eb-NOFS.initss.Eb)./PE5.initss.Eb), 'm:',...
        tpoints,100.*zeros(size(tpoints)),'k:','LineWidth',1.5),grid;
leg=legend('Total Response','Direct: $r^b$','Indirect: $w$','Indirect: $T$','Indirect: $r^a \  \& \ q$','Location','NorthEast');
set(leg,'Interpreter','Latex');
set(leg,...
    'Location','best',...
    'Interpreter','latex');
xlim(tlim);
%ylim([-0.1 0.5]);
ylabel('Deviation (\%)', 'interpreter','latex','FontSize',14);
xlabel('Quarters', 'interpreter','latex','FontSize',14);
set(gca,'FontSize',14);
if MonetaryShockSize == 0.0025
  t=title('Aggregate Liquid Asset  Breakdown negative MP shock');
else
  t=title('Aggregate Liquid Asset positive MP shock');
end
t.FontSize=10;
if Save==1
    saveas(gcf,[SaveDir '\fig_4b_liquid' figname locfigname]);
    %print('-depsc',[SaveDir  '\fig_4b']);
end


 
%%
ConDecompDist

%%
% InputDir='D:\University of Washington\HANK Literature\Codes for Heterogenous Models\myHANKReplication\ReplicateHank-Steady State\IRF_Monetary';
% gjoint_T1 = zeros(ngpa,ngpb,ngpy);
% for iy = 1:ngpy
%     gjoint_T1(:,:,iy) = load([InputDir '\NOFS\STICKY\gjoint_T1_y' int2str(iy) '.txt']);
% end











