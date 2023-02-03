if Display; fprintf('Saving output to disk\n'); end

%% Grids

% OutputDir=strcat('D:\University of Washington\HANK Literature\Codes for Heterogenous Models',...
%     '\myHANKReplication\ReplicateHank-Steady State\');
OutputDir=strcat(cd,'\');
% save([OutputDir,'Steadystate_workspace'],'ngpa','agrid','ngpb','bgrid','ngpy','ygrid',...
%      'ydist','adelta','bdelta');
% Grids
writematrix(agrid,strcat(OutputDir,'agrid.txt'),'Delimiter','tab');
writematrix(bgrid,strcat(OutputDir,'bgrid.txt'),'Delimiter','tab');
writematrix(ygrid,strcat(OutputDir,'ygrid.txt'),'Delimiter','tab');
writematrix(adelta,strcat(OutputDir,'adelta.txt'),'Delimiter','tab');
writematrix(bdelta,strcat(OutputDir,'bdelta.txt'),'Delimiter','tab');

% initial steady state summary stats
fid = fopen(fullfile(OutputDir,'InitialSteadyStateParameters.txt'),'w');
fprintf(fid,'gam %.15g\n',gam);
fprintf(fid,'rho %.15g\n',rho);
fprintf(fid,'deathrate %.15g\n',deathrate);
fprintf(fid,'kappa0_w %.15g\n',kappa0_w);
fprintf(fid,'kappa1_w %.15g\n',kappa1_w);
fprintf(fid,'kappa2_w %.15g\n',kappa2_w);
fprintf(fid,'kappa3 %.15g\n',kappa3);
fprintf(fid,'kappa4_w %.15g\n',kappa4_w);
fprintf(fid,'kappa0_d %.15g\n',kappa0_d);
fprintf(fid,'kappa1_d %.15g\n',kappa1_d);
fprintf(fid,'kappa2_d %.15g\n',kappa2_d);
fprintf(fid,'kappa4_d %.15g\n',kappa4_d);
fprintf(fid,'corptax %.15g\n',corptax);

fprintf(fid,'ra %.15g\n',equmINITSS.ra);
fprintf(fid,'rb %.15g\n',equmINITSS.rb);
fprintf(fid,'rborr %.15g\n',equmINITSS.rborr);
fprintf(fid,'rcapital %.15g\n',equmINITSS.rcapital);
fprintf(fid,'wage %.15g\n',equmINITSS.wage);
fprintf(fid,'netwage %.15g\n',equmINITSS.netwage);
fprintf(fid,'bond %.15g\n',equmINITSS.bond);
fprintf(fid,'capital %.15g\n',equmINITSS.capital);
fprintf(fid,'equity %.15g\n',equmINITSS.equity);
fprintf(fid,'labor %.15g\n',equmINITSS.labor);
fprintf(fid,'output %.15g\n',equmINITSS.output);
fprintf(fid,'investment %.15g\n',equmINITSS.investment);
fprintf(fid,'govexp %.15g\n',equmINITSS.govexp);
fprintf(fid,'lumptransfer %.15g\n',equmINITSS.lumptransfer);
fprintf(fid,'labtax %.15g\n',equmINITSS.labtax);
fprintf(fid,'taxrev %.15g\n',equmINITSS.taxrev);
fprintf(fid,'govbond %.15g\n',equmINITSS.govbond);
fprintf(fid,'worldbond %.15g\n',equmINITSS.worldbond);
fprintf(fid,'fundbond %.15g\n',equmINITSS.fundbond);
fprintf(fid,'KYratio %.15g\n',equmINITSS.KYratio);
fprintf(fid,'KNratio %.15g\n',equmINITSS.KNratio);
fprintf(fid,'mc %.15g\n',equmINITSS.mc);
fprintf(fid,'rb %.15g\n',equmINITSS.rb);
fprintf(fid,'tfp %.15g\n',equmINITSS.tfp);
fprintf(fid,'pi %.15g\n',equmINITSS.pi);
fprintf(fid,'rnom %.15g\n',equmINITSS.rnom);
fprintf(fid,'priceadjust %.15g\n',equmINITSS.priceadjust);
fprintf(fid,'profit %.15g\n',equmINITSS.profit);
fprintf(fid,'dividend %.15g\n',equmINITSS.dividend);
fprintf(fid,'divrate %.15g\n',equmINITSS.divrate);

fprintf(fid,'borrwedge %.15g\n',equmINITSS.borrwedge);
fprintf(fid,'rho %.15g\n',equmINITSS.rho);
fprintf(fid,'fundlev %.15g\n',equmINITSS.fundlev);
fprintf(fid,'deprec %.15g\n',deprec);
	
fprintf(fid,'Ea %.15g\n',statsINITSS.Ea);
fprintf(fid,'Eb %.15g\n',statsINITSS.Eb);
fprintf(fid,'Ec %.15g\n',statsINITSS.Ec);
fprintf(fid,'Ehours %.15g\n',statsINITSS.Ehours);
fprintf(fid,'Elabor %.15g\n',statsINITSS.Elabor);
fprintf(fid,'Ed %.15g\n',statsINITSS.Ed);
fprintf(fid,'Ewage %.15g\n',statsINITSS.Ewage);
fprintf(fid,'Enetlabinc %.15g\n',statsINITSS.Enetlabinc);
fprintf(fid,'Egrosslabinc %.15g\n',statsINITSS.Egrosslabinc);
fprintf(fid,'Enetprofinc %.15g\n',statsINITSS.Enetprofinc);
fprintf(fid,'Egrossprofinc %.15g\n',statsINITSS.Egrossprofinc);
fprintf(fid,'Einc %.15g\n',statsINITSS.Einc);
fprintf(fid,'Enw %.15g\n',statsINITSS.Enw);
fprintf(fid,'FRACa0 %.15g\n',statsINITSS.FRACa0);
fprintf(fid,'FRACb0 %.15g\n',statsINITSS.FRACb0);
fprintf(fid,'FRACb0a0 %.15g\n',statsINITSS.FRACb0a0);
fprintf(fid,'FRACnw0 %.15g\n',statsINITSS.FRACnw0);
fprintf(fid,'FRACb0aP %.15g\n',statsINITSS.FRACb0aP);
fprintf(fid,'FRACa0close %.15g\n',statsINITSS.FRACa0close);
fprintf(fid,'FRACb0close %.15g\n',statsINITSS.FRACb0close);
fprintf(fid,'FRACb0a0close %.15g\n',statsINITSS.FRACb0a0close);
fprintf(fid,'FRACnw0close %.15g\n',statsINITSS.FRACnw0close);
fprintf(fid,'FRACbN %.15g\n',statsINITSS.FRACbN);
fprintf(fid,'EbN %.15g\n',statsINITSS.EbN);
fprintf(fid,'EbP %.15g\n',statsINITSS.EbP);
fprintf(fid,'Eadjcost %.15g\n',statsINITSS.Eadjcost);

fprintf(fid,'GINIa %.15g\n',statsINITSS.GINIa);
fprintf(fid,'GINIb %.15g\n',statsINITSS.GINIb);
fprintf(fid,'GINInw %.15g\n',statsINITSS.GINInw);
fprintf(fid,'GINIc %.15g\n',statsINITSS.GINIc);
fprintf(fid,'GINIinc %.15g\n',statsINITSS.GINIinc);
fprintf(fid,'GINIlabinc %.15g\n',statsINITSS.GINIlabinc);

fprintf(fid,'ill_share_top10pc %.15g\n',statsINITSS.ill_share_top10pc);
fprintf(fid,'ill_share_top1pc %.15g\n',statsINITSS.ill_share_top1pc);
fprintf(fid,'ill_share_top01pc %.15g\n',statsINITSS.ill_share_top01pc);
fprintf(fid,'ill_share_bot50pc %.15g\n',statsINITSS.ill_share_bot50pc);
fprintf(fid,'ill_share_bot25pc %.15g\n',statsINITSS.ill_share_bot25pc);
fprintf(fid,'ill_share_bot10pc %.15g\n',statsINITSS.ill_share_bot10pc);
fprintf(fid,'ill_p10pc %.15g\n',statsINITSS.ill_p10pc);
fprintf(fid,'ill_p50pc %.15g\n',statsINITSS.ill_p50pc);
fprintf(fid,'ill_p90pc %.15g\n',statsINITSS.ill_p90pc);

fprintf(fid,'liq_share_top10pc %.15g\n',statsINITSS.liq_share_top10pc);
fprintf(fid,'liq_share_top1pc %.15g\n',statsINITSS.liq_share_top1pc);
fprintf(fid,'liq_share_top01pc %.15g\n',statsINITSS.liq_share_top01pc);
fprintf(fid,'liq_share_bot50pc %.15g\n',statsINITSS.liq_share_bot50pc);
fprintf(fid,'liq_share_bot25pc %.15g\n',statsINITSS.liq_share_bot25pc);
fprintf(fid,'liq_share_bot10pc %.15g\n',statsINITSS.liq_share_bot10pc);
fprintf(fid,'liq_p10pc %.15g\n',statsINITSS.liq_p10pc);
fprintf(fid,'liq_p50pc %.15g\n',statsINITSS.liq_p50pc);
fprintf(fid,'liq_p90pc %.15g\n',statsINITSS.liq_p90pc);

fprintf(fid,'nw_share_top10pc %.15g\n',statsINITSS.nw_share_top10pc);
fprintf(fid,'nw_share_top1pc %.15g\n',statsINITSS.nw_share_top1pc);
fprintf(fid,'nw_share_top01pc %.15g\n',statsINITSS.nw_share_top01pc);
fprintf(fid,'nw_share_bot50pc %.15g\n',statsINITSS.nw_share_bot50pc);
fprintf(fid,'nw_share_bot25pc %.15g\n',statsINITSS.nw_share_bot25pc);
fprintf(fid,'nw_share_bot10pc %.15g\n',statsINITSS.nw_share_bot10pc);
fprintf(fid,'nw_p10pc %.15g\n',statsINITSS.nw_p10pc);
fprintf(fid,'nw_p50pc %.15g\n',statsINITSS.nw_p50pc);
fprintf(fid,'nw_p90pc %.15g\n',statsINITSS.nw_p90pc);

fprintf(fid,'inc_share_top10pc %.15g\n',statsINITSS.inc_share_top10pc);
fprintf(fid,'inc_share_top1pc %.15g\n',statsINITSS.inc_share_top1pc);
fprintf(fid,'inc_share_top01pc %.15g\n',statsINITSS.inc_share_top01pc);
fprintf(fid,'inc_share_bot50pc %.15g\n',statsINITSS.inc_share_bot50pc);
fprintf(fid,'inc_share_bot25pc %.15g\n',statsINITSS.inc_share_bot25pc);
fprintf(fid,'inc_share_bot10pc %.15g\n',statsINITSS.inc_share_bot10pc);
fprintf(fid,'inc_p10pc %.15g\n',statsINITSS.inc_p10pc);
fprintf(fid,'inc_p50pc %.15g\n',statsINITSS.inc_p50pc);
fprintf(fid,'inc_p90pc %.15g\n',statsINITSS.inc_p90pc);

fprintf(fid,'totinc_share_top10pc %.15g\n',statsINITSS.totinc_share_top10pc);
fprintf(fid,'totinc_share_top1pc %.15g\n',statsINITSS.totinc_share_top1pc);
fprintf(fid,'totinc_share_top01pc %.15g\n',statsINITSS.totinc_share_top01pc);
fprintf(fid,'totinc_share_bot50pc %.15g\n',statsINITSS.totinc_share_bot50pc);
fprintf(fid,'totinc_share_bot25pc %.15g\n',statsINITSS.totinc_share_bot25pc);
fprintf(fid,'totinc_share_bot10pc %.15g\n',statsINITSS.totinc_share_bot10pc);
fprintf(fid,'totinc_p10pc %.15g\n',statsINITSS.totinc_p10pc);
fprintf(fid,'totinc_p50pc %.15g\n',statsINITSS.totinc_p50pc);
fprintf(fid,'totinc_p90pc %.15g\n',statsINITSS.totinc_p90pc);

fprintf(fid,'con_share_top10pc %.15g\n',statsINITSS.con_share_top10pc);
fprintf(fid,'con_share_top1pc %.15g\n',statsINITSS.con_share_top1pc);
fprintf(fid,'con_share_top01pc %.15g\n',statsINITSS.con_share_top01pc);
fprintf(fid,'con_share_bot50pc %.15g\n',statsINITSS.con_share_bot50pc);
fprintf(fid,'con_share_bot25pc %.15g\n',statsINITSS.con_share_bot25pc);
fprintf(fid,'con_share_bot10pc %.15g\n',statsINITSS.con_share_bot10pc);
fprintf(fid,'con_p10pc %.15g\n',statsINITSS.con_p10pc);
fprintf(fid,'con_p50pc %.15g\n',statsINITSS.con_p50pc);
fprintf(fid,'con_p90pc %.15g\n',statsINITSS.con_p90pc);

fprintf(fid,'Ec_bN %.15g\n',statsINITSS.Ec_bN);
fprintf(fid,'Ec_b0close %.15g\n',statsINITSS.Ec_b0close);
fprintf(fid,'Ec_b0far %.15g\n',statsINITSS.Ec_b0far);	
fclose(fid);

% OutputDir=strcat('D:\University of Washington\HANK Literature\Codes for Heterogenous Models',...
%     '\myHANKReplication\ReplicateHank-Steady State\INITSS\');
OutputDir=strcat(cd,'\INITSS\');
mkdir(OutputDir);

%initial steady state distributions and policy functions
writematrix(PERCa,strcat(OutputDir,'PERCa.txt'),'Delimiter',' ');
writematrix(PERCb,strcat(OutputDir,'PERCb.txt'),'Delimiter',' ');
writematrix(PERCnw,strcat(OutputDir,'PERCnw.txt'),'Delimiter',' ');
writematrix(PERCc,strcat(OutputDir,'PERCc.txt'),'Delimiter',' ');
writematrix(PERCinc,strcat(OutputDir,'PERCinc.txt'),'Delimiter',' ');

writematrix(Ea_nwQ,strcat(OutputDir,'Ea_nwQ.txt'),'Delimiter',' ');
writematrix(Eb_nwQ,strcat(OutputDir,'Eb_nwQ.txt'),'Delimiter',' ');
writematrix(Ec_nwQ,strcat(OutputDir,'Ec_nwQ.txt'),'Delimiter',' ');
writematrix(Einc_nwQ,strcat(OutputDir,'Einc_nwQ.txt'),'Delimiter',' ');

writematrix(Ea_incQ,strcat(OutputDir,'Ea_incQ.txt'),'Delimiter',' ');
writematrix(Eb_incQ,strcat(OutputDir,'Eb_incQ.txt'),'Delimiter',' ');
writematrix(Ec_incQ,strcat(OutputDir,'Ec_incQ.txt'),'Delimiter',' ');
writematrix(Einc_incQ,strcat(OutputDir,'Einc_incQ.txt'),'Delimiter',' ');

for iy=1:ngpy
    writematrix(V(:,:,iy),strcat(OutputDir,'V_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(d(:,:,iy),strcat(OutputDir,'dep_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(c(:,:,iy),strcat(OutputDir,'con_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(s(:,:,iy),strcat(OutputDir,'sav_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(h(:,:,iy),strcat(OutputDir,'hour_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(bdot(:,:,iy),strcat(OutputDir,'bdot_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(gmat(:,:,iy),strcat(OutputDir,'gjoint_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(B(:,:,iy),strcat(OutputDir,'B_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    
    writematrix(ccum1(:,:,iy),strcat(OutputDir,'ccum1_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(ccum2(:,:,iy),strcat(OutputDir,'ccum2_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(ccum4(:,:,iy),strcat(OutputDir,'ccum4_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(dcum1(:,:,iy),strcat(OutputDir,'dcum1_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(dcum2(:,:,iy),strcat(OutputDir,'dcum2_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(dcum4(:,:,iy),strcat(OutputDir,'dcum4_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    
    if ComputeDiscountedMPC
       writematrix(solnINITSS.mpc(:,:,iy),strcat(OutputDir,'mpc_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
       writematrix(solnINITSS.subeff1ass(:,:,iy),strcat(OutputDir,'subeff1ass_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
       writematrix(solnINITSS.subeff2ass(:,:,iy),strcat(OutputDir,'subeff2ass_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
       writematrix(solnINITSS.wealtheff1ass(:,:,iy),strcat(OutputDir,'wealtheff1ass_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
       writematrix(solnINITSS.wealtheff2ass(:,:,iy),strcat(OutputDir,'wealtheff2ass_INITSS_y',num2str(iy),'.txt'),'Delimiter',' ');
    end
       
end  

writematrix(squeeze(solnINITSS.gamarg),strcat(OutputDir,'gamarg_INITSS.txt'),'Delimiter',' ');
writematrix(squeeze(solnINITSS.gbmarg),strcat(OutputDir,'gbmarg_INITSS.txt'),'Delimiter',' ');
writematrix(solnINITSS.gabmarg,strcat(OutputDir,'gabmarg_INITSS.txt'),'Delimiter',' ');
writematrix(solnINITSS.gabcum,strcat(OutputDir,'gabcum_INITSS.txt'),'Delimiter',' ');

% OutputDir=strcat('D:\University of Washington\HANK Literature\Codes for Heterogenous Models',...
%     '\myHANKReplication\ReplicateHank-Steady State\');

OutputDir=strcat(cd,'\');
% initial steady state distributions and policy functions
save([OutputDir,'solnINITSS'],'-struct','solnINITSS')
save([OutputDir,'cumINITSS'],'-struct','cumINITSS')
save([OutputDir,'equmINITSS'],'-struct','equmINITSS')
save([OutputDir,'statsINITSS'],'-struct','statsINITSS')

fprintf('Completed Saving output to disk\n'); 
