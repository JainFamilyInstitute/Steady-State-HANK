function SaveIRF_in_reqd_format(irfpriceexp,OutputFileIRF,Ttransition,ngpy)

OutputDir=strcat(OutputFileIRF,'/STICKY/');
mkdir(OutputDir);

% from the eqmSTICKY

writematrix(irfpriceexp.equmSTICKY.ra',strcat(OutputDir,'ra.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.rcapital',strcat(OutputDir,'rcapital.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.wage',strcat(OutputDir,'wage.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.netwage',strcat(OutputDir,'netwage.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.KYratio',strcat(OutputDir,'KYratio.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.KNratio',strcat(OutputDir,'KNratio.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.mc',strcat(OutputDir,'mc.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.rb',strcat(OutputDir,'rb.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.rborr',strcat(OutputDir,'rborr.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.tfp*ones(200,1),strcat(OutputDir,'tfp.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.pi',strcat(OutputDir,'pi.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.rnom',strcat(OutputDir,'rnom.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.gap',strcat(OutputDir,'gap.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.capital',strcat(OutputDir,'capital.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.bond',strcat(OutputDir,'bond.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.labor',strcat(OutputDir,'labor.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.output',strcat(OutputDir,'output.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.investment',strcat(OutputDir,'investment.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.taxrev',strcat(OutputDir,'taxrev.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.govexp*ones(200,1),strcat(OutputDir,'govexp.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.govbond*ones(200,1),strcat(OutputDir,'govbond.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.worldbond',strcat(OutputDir,'worldbond.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.borrwedge*ones(200,1),strcat(OutputDir,'borrwedge.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.rho',strcat(OutputDir,'rho.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.mpshock',strcat(OutputDir,'mpshock.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.prefshock',strcat(OutputDir,'prefshock.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.elast*ones(200,1),strcat(OutputDir,'elast.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.fundlev*ones(200,1),strcat(OutputDir,'fundlev.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.gam',strcat(OutputDir,'gam.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.fundbond',strcat(OutputDir,'fundbond.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.priceadjust',strcat(OutputDir,'priceadjust.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.profit',strcat(OutputDir,'profit.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.dividend',strcat(OutputDir,'dividend.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.divrate*ones(200,1),strcat(OutputDir,'divrate.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.lumptransfer',strcat(OutputDir,'lumptransfer.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.equity',strcat(OutputDir,'equity.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.caputil',strcat(OutputDir,'caputil.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.deprec',strcat(OutputDir,'deprec.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.tfpadj',strcat(OutputDir,'tfpadj.txt'),'Delimiter','tab');
writematrix(irfpriceexp.equmSTICKY.illassetdrop*ones(200,1),strcat(OutputDir,'illassetdrop.txt'),'Delimiter','tab');

% from the statsSTICKY

Arr_Ea=zeros(Ttransition,1);
Arr_Eb=zeros(Ttransition,1);
Arr_Ec=zeros(Ttransition,1);
Arr_Elabor=zeros(Ttransition,1);
Arr_Ed=zeros(Ttransition,1);
Arr_Ewage=zeros(Ttransition,1);
Arr_Enetlabinc=zeros(Ttransition,1);
Arr_Egrosslabinc=zeros(Ttransition,1);
Arr_Einc=zeros(Ttransition,1);
Arr_Ehours=zeros(Ttransition,1);
Arr_Enw=zeros(Ttransition,1);

Arr_FRACa0=zeros(Ttransition,1);
Arr_FRACa0close=zeros(Ttransition,1);
Arr_FRACb0=zeros(Ttransition,1);
Arr_FRACb0close=zeros(Ttransition,1);
Arr_FRACb0a0=zeros(Ttransition,1);
Arr_FRACb0aP=zeros(Ttransition,1);
Arr_FRACbN=zeros(Ttransition,1);
Arr_FRACnw0=zeros(Ttransition,1);
Arr_FRACnw0close=zeros(Ttransition,1);

Arr_EbN=zeros(Ttransition,1);
Arr_EbP=zeros(Ttransition,1);
Arr_Eadjcost=zeros(Ttransition,1);

Arr_ill_share_top10pc=zeros(Ttransition,1);
Arr_ill_share_top1pc=zeros(Ttransition,1);
Arr_ill_share_top01pc=zeros(Ttransition,1);
Arr_ill_share_bot50pc=zeros(Ttransition,1);
Arr_ill_share_bot25pc=zeros(Ttransition,1);
Arr_ill_share_bot10pc=zeros(Ttransition,1);
Arr_ill_p10pc=zeros(Ttransition,1);
Arr_ill_p50pc=zeros(Ttransition,1);
Arr_ill_p90pc=zeros(Ttransition,1);

Arr_liq_share_top10pc=zeros(Ttransition,1);
Arr_liq_share_top1pc=zeros(Ttransition,1);
Arr_liq_share_top01pc=zeros(Ttransition,1);
Arr_liq_share_bot50pc=zeros(Ttransition,1);
Arr_liq_share_bot25pc=zeros(Ttransition,1);
Arr_liq_share_bot10pc=zeros(Ttransition,1);
Arr_liq_p10pc=zeros(Ttransition,1);
Arr_liq_p50pc=zeros(Ttransition,1);
Arr_liq_p90pc=zeros(Ttransition,1);

Arr_nw_share_top10pc=zeros(Ttransition,1);
Arr_nw_share_top1pc=zeros(Ttransition,1);
Arr_nw_share_top01pc=zeros(Ttransition,1);
Arr_nw_share_bot50pc=zeros(Ttransition,1);
Arr_nw_share_bot25pc=zeros(Ttransition,1);
Arr_nw_share_bot10pc=zeros(Ttransition,1);
Arr_nw_p10pc=zeros(Ttransition,1);
Arr_nw_p50pc=zeros(Ttransition,1);
Arr_nw_p90pc=zeros(Ttransition,1);

Arr_inc_share_top10pc=zeros(Ttransition,1);
Arr_inc_share_top1pc=zeros(Ttransition,1);
Arr_inc_share_top01pc=zeros(Ttransition,1);
Arr_inc_share_bot50pc=zeros(Ttransition,1);
Arr_inc_share_bot25pc=zeros(Ttransition,1);
Arr_inc_share_bot10pc=zeros(Ttransition,1);
Arr_inc_p10pc=zeros(Ttransition,1);
Arr_inc_p50pc=zeros(Ttransition,1);
Arr_inc_p90pc=zeros(Ttransition,1);

Arr_totinc_share_top10pc=zeros(Ttransition,1);
Arr_totinc_share_top1pc=zeros(Ttransition,1);
Arr_totinc_share_top01pc=zeros(Ttransition,1);
Arr_totinc_share_bot50pc=zeros(Ttransition,1);
Arr_totinc_share_bot25pc=zeros(Ttransition,1);
Arr_totinc_share_bot10pc=zeros(Ttransition,1);
Arr_totinc_p10pc=zeros(Ttransition,1);
Arr_totinc_p50pc=zeros(Ttransition,1);
Arr_totinc_p90pc=zeros(Ttransition,1);

Arr_con_share_top10pc=zeros(Ttransition,1);
Arr_con_share_top1pc=zeros(Ttransition,1);
Arr_con_share_top01pc=zeros(Ttransition,1);
Arr_con_share_bot50pc=zeros(Ttransition,1);
Arr_con_share_bot25pc=zeros(Ttransition,1);
Arr_con_share_bot10pc=zeros(Ttransition,1);
Arr_con_p10pc=zeros(Ttransition,1);
Arr_con_p50pc=zeros(Ttransition,1);
Arr_con_p90pc=zeros(Ttransition,1);

Arr_GINIa=zeros(Ttransition,1);
Arr_GINIb=zeros(Ttransition,1);
Arr_GINInw=zeros(Ttransition,1);
Arr_GINIc=zeros(Ttransition,1);
Arr_GINIinc=zeros(Ttransition,1);
Arr_GINIlabinc=zeros(Ttransition,1);

Arr_Ec_bN=zeros(Ttransition,1);
Arr_Ec_b0close=zeros(Ttransition,1);
Arr_Ec_b0far=zeros(Ttransition,1);

Arr_PERCa=zeros(Ttransition,11);
Arr_PERCb=zeros(Ttransition,11);
Arr_PERCnw=zeros(Ttransition,11);
Arr_PERCc=zeros(Ttransition,11);
Arr_PERCinc=zeros(Ttransition,11);

Arr_Ea_nwQ=zeros(Ttransition,4);
Arr_Eb_nwQ=zeros(Ttransition,4);
Arr_Ec_nwQ=zeros(Ttransition,4);
Arr_Einc_nwQ=zeros(Ttransition,4);
Arr_Ea_incQ=zeros(Ttransition,4);
Arr_Eb_incQ=zeros(Ttransition,4);
Arr_Ec_incQ=zeros(Ttransition,4);
Arr_Einc_incQ=zeros(Ttransition,4);
 

for is=1:Ttransition
    Arr_Ea(is)=irfpriceexp.statsSTICKY(is).Ea;
    Arr_Eb(is)=irfpriceexp.statsSTICKY(is).Eb;
    Arr_Ec(is)=irfpriceexp.statsSTICKY(is).Ec;
    Arr_Elabor(is)=irfpriceexp.statsSTICKY(is).Elabor;
    Arr_Ed(is)=irfpriceexp.statsSTICKY(is).Ed;
    Arr_Ewage(is)=irfpriceexp.statsSTICKY(is).Ewage;
    Arr_Enetlabinc(is)=irfpriceexp.statsSTICKY(is).Enetlabinc;
    Arr_Egrosslabinc(is)=irfpriceexp.statsSTICKY(is).Egrosslabinc;
    Arr_Einc(is)=irfpriceexp.statsSTICKY(is).Einc;
    Arr_Ehours(is)=irfpriceexp.statsSTICKY(is).Ehours;
    Arr_Enw(is)=irfpriceexp.statsSTICKY(is).Enw;

    Arr_FRACa0(is)=irfpriceexp.statsSTICKY(is).FRACa0;
    Arr_FRACa0close(is)=irfpriceexp.statsSTICKY(is).FRACa0close;
    Arr_FRACb0(is)=irfpriceexp.statsSTICKY(is).FRACb0;
    Arr_FRACb0close(is)=irfpriceexp.statsSTICKY(is).FRACb0close;
    Arr_FRACb0a0(is)=irfpriceexp.statsSTICKY(is).FRACb0a0;
    Arr_FRACb0aP(is)=irfpriceexp.statsSTICKY(is).FRACb0aP;
    Arr_FRACbN(is)=irfpriceexp.statsSTICKY(is).FRACbN;
    Arr_FRACnw0(is)=irfpriceexp.statsSTICKY(is).FRACnw0;
    Arr_FRACnw0close(is)=irfpriceexp.statsSTICKY(is).FRACnw0close;

    Arr_EbN(is)=irfpriceexp.statsSTICKY(is).EbN;
    Arr_EbP(is)=irfpriceexp.statsSTICKY(is).EbP;
    Arr_Eadjcost(is)=irfpriceexp.statsSTICKY(is).Eadjcost;

    Arr_GINIa(is)=irfpriceexp.statsSTICKY(is).GINIa;
    Arr_GINIb(is)=irfpriceexp.statsSTICKY(is).GINIb;
    Arr_GINInw(is)=irfpriceexp.statsSTICKY(is).GINInw;
    Arr_GINIc(is)=irfpriceexp.statsSTICKY(is).GINIc;
    Arr_GINIinc(is)=irfpriceexp.statsSTICKY(is).GINIinc;
    Arr_GINIlabinc(is)=irfpriceexp.statsSTICKY(is).GINIlabinc;
    
    Arr_ill_share_top10pc(is)=irfpriceexp.statsSTICKY(is).ill_share_top10pc;
    Arr_ill_share_top1pc(is)=irfpriceexp.statsSTICKY(is).ill_share_top1pc;
    Arr_ill_share_top01pc(is)=irfpriceexp.statsSTICKY(is).ill_share_top01pc;
    Arr_ill_share_bot50pc(is)=irfpriceexp.statsSTICKY(is).ill_share_bot50pc;
    Arr_ill_share_bot25pc(is)=irfpriceexp.statsSTICKY(is).ill_share_bot25pc;
    Arr_ill_share_bot10pc(is)=irfpriceexp.statsSTICKY(is).ill_share_bot10pc;
    Arr_ill_p10pc(is)=irfpriceexp.statsSTICKY(is).ill_p10pc;
    Arr_ill_p50pc(is)=irfpriceexp.statsSTICKY(is).ill_p50pc;
    Arr_ill_p90pc(is)=irfpriceexp.statsSTICKY(is).ill_p90pc;
    
    Arr_liq_share_top10pc(is)=irfpriceexp.statsSTICKY(is).liq_share_top10pc;
    Arr_liq_share_top1pc(is)=irfpriceexp.statsSTICKY(is).liq_share_top1pc;
    Arr_liq_share_top01pc(is)=irfpriceexp.statsSTICKY(is).liq_share_top01pc;
    Arr_liq_share_bot50pc(is)=irfpriceexp.statsSTICKY(is).liq_share_bot50pc;
    Arr_liq_share_bot25pc(is)=irfpriceexp.statsSTICKY(is).liq_share_bot25pc;
    Arr_liq_share_bot10pc(is)=irfpriceexp.statsSTICKY(is).liq_share_bot10pc;
    Arr_liq_p10pc(is)=irfpriceexp.statsSTICKY(is).liq_p10pc;
    Arr_liq_p50pc(is)=irfpriceexp.statsSTICKY(is).liq_p50pc;
    Arr_liq_p90pc(is)=irfpriceexp.statsSTICKY(is).liq_p90pc;
    
    Arr_nw_share_top10pc(is)=irfpriceexp.statsSTICKY(is).nw_share_top10pc;
    Arr_nw_share_top1pc(is)=irfpriceexp.statsSTICKY(is).nw_share_top1pc;
    Arr_nw_share_top01pc(is)=irfpriceexp.statsSTICKY(is).nw_share_top01pc;
    Arr_nw_share_bot50pc(is)=irfpriceexp.statsSTICKY(is).nw_share_bot50pc;
    Arr_nw_share_bot25pc(is)=irfpriceexp.statsSTICKY(is).nw_share_bot25pc;
    Arr_nw_share_bot10pc(is)=irfpriceexp.statsSTICKY(is).nw_share_bot10pc;
    Arr_nw_p10pc(is)=irfpriceexp.statsSTICKY(is).nw_p10pc;
    Arr_nw_p50pc(is)=irfpriceexp.statsSTICKY(is).nw_p50pc;
    Arr_nw_p90pc(is)=irfpriceexp.statsSTICKY(is).nw_p90pc;
    
    Arr_inc_share_top10pc(is)=irfpriceexp.statsSTICKY(is).inc_share_top10pc;
    Arr_inc_share_top1pc(is)=irfpriceexp.statsSTICKY(is).inc_share_top1pc;
    Arr_inc_share_top01pc(is)=irfpriceexp.statsSTICKY(is).inc_share_top01pc;
    Arr_inc_share_bot50pc(is)=irfpriceexp.statsSTICKY(is).inc_share_bot50pc;
    Arr_inc_share_bot25pc(is)=irfpriceexp.statsSTICKY(is).inc_share_bot25pc;
    Arr_inc_share_bot10pc(is)=irfpriceexp.statsSTICKY(is).inc_share_bot10pc;
    Arr_inc_p10pc(is)=irfpriceexp.statsSTICKY(is).inc_p10pc;
    Arr_inc_p50pc(is)=irfpriceexp.statsSTICKY(is).inc_p50pc;
    Arr_inc_p90pc(is)=irfpriceexp.statsSTICKY(is).inc_p90pc;
    
    Arr_con_share_top10pc(is)=irfpriceexp.statsSTICKY(is).con_share_top10pc;
    Arr_con_share_top1pc(is)=irfpriceexp.statsSTICKY(is).con_share_top1pc;
    Arr_con_share_top01pc(is)=irfpriceexp.statsSTICKY(is).con_share_top01pc;
    Arr_con_share_bot50pc(is)=irfpriceexp.statsSTICKY(is).con_share_bot50pc;
    Arr_con_share_bot25pc(is)=irfpriceexp.statsSTICKY(is).con_share_bot25pc;
    Arr_con_share_bot10pc(is)=irfpriceexp.statsSTICKY(is).con_share_bot10pc;
    Arr_con_p10pc(is)=irfpriceexp.statsSTICKY(is).con_p10pc;
    Arr_con_p50pc(is)=irfpriceexp.statsSTICKY(is).con_p50pc;
    Arr_con_p90pc(is)=irfpriceexp.statsSTICKY(is).con_p90pc;
    
    Arr_totinc_share_top10pc(is)=irfpriceexp.statsSTICKY(is).totinc_share_top10pc;
    Arr_totinc_share_top1pc(is)=irfpriceexp.statsSTICKY(is).totinc_share_top1pc;
    Arr_totinc_share_top01pc(is)=irfpriceexp.statsSTICKY(is).totinc_share_top01pc;
    Arr_totinc_share_bot50pc(is)=irfpriceexp.statsSTICKY(is).totinc_share_bot50pc;
    Arr_totinc_share_bot25pc(is)=irfpriceexp.statsSTICKY(is).totinc_share_bot25pc;
    Arr_totinc_share_bot10pc(is)=irfpriceexp.statsSTICKY(is).totinc_share_bot10pc;
    Arr_totinc_p10pc(is)=irfpriceexp.statsSTICKY(is).totinc_p10pc;
    Arr_totinc_p50pc(is)=irfpriceexp.statsSTICKY(is).totinc_p50pc;
    Arr_totinc_p90pc(is)=irfpriceexp.statsSTICKY(is).totinc_p90pc;
    
    Arr_Ec_bN(is)=irfpriceexp.statsSTICKY(is).Ec_bN;
    Arr_Ec_b0close(is)=irfpriceexp.statsSTICKY(is).Ec_b0close;
    Arr_Ec_b0far(is)=irfpriceexp.statsSTICKY(is).Ec_b0far;

    Arr_PERCa(is,:)=irfpriceexp.statsSTICKY(is).PERCa;
    Arr_PERCb(is,:)=irfpriceexp.statsSTICKY(is).PERCb;
    Arr_PERCnw(is,:)=irfpriceexp.statsSTICKY(is).PERCnw;
    Arr_PERCc(is,:)=irfpriceexp.statsSTICKY(is).PERCc;
    Arr_PERCinc(is,:)=irfpriceexp.statsSTICKY(is).PERCinc;

    Arr_Ea_nwQ(is,:)=irfpriceexp.statsSTICKY(is).Ea_nwQ;
    Arr_Eb_nwQ(is,:)=irfpriceexp.statsSTICKY(is).Eb_nwQ;
    Arr_Ec_nwQ(is,:)=irfpriceexp.statsSTICKY(is).Ec_nwQ;
    Arr_Einc_nwQ(is,:)=irfpriceexp.statsSTICKY(is).Einc_nwQ;
    Arr_Ea_incQ(is,:)=irfpriceexp.statsSTICKY(is).Ea_incQ;
    Arr_Eb_incQ(is,:)=irfpriceexp.statsSTICKY(is).Eb_incQ;
    Arr_Ec_incQ(is,:)=irfpriceexp.statsSTICKY(is).Ec_incQ;
    Arr_Einc_incQ(is,:)=irfpriceexp.statsSTICKY(is).Einc_incQ;

end

writematrix(Arr_Ea,strcat(OutputDir,'Ea.txt'),'Delimiter','tab');
writematrix(Arr_Eb,strcat(OutputDir,'Eb.txt'),'Delimiter','tab');
writematrix(Arr_Ec,strcat(OutputDir,'Ec.txt'),'Delimiter','tab');
writematrix(Arr_Elabor,strcat(OutputDir,'Elabor.txt'),'Delimiter','tab');
writematrix(Arr_Ed,strcat(OutputDir,'Ed.txt'),'Delimiter','tab');
writematrix(Arr_Ewage,strcat(OutputDir,'Ewage.txt'),'Delimiter','tab');
writematrix(Arr_Enetlabinc,strcat(OutputDir,'Enetlabinc.txt'),'Delimiter','tab');
writematrix(Arr_Egrosslabinc,strcat(OutputDir,'Egrosslabinc.txt'),'Delimiter','tab');
writematrix(Arr_Einc,strcat(OutputDir,'Einc.txt'),'Delimiter','tab');
writematrix(Arr_Ehours,strcat(OutputDir,'Ehours.txt'),'Delimiter','tab');
writematrix(Arr_Enw,strcat(OutputDir,'Enw.txt'),'Delimiter','tab');

writematrix(Arr_FRACa0,strcat(OutputDir,'FRACa0.txt'),'Delimiter','tab');
writematrix(Arr_FRACa0close,strcat(OutputDir,'FRACa0close.txt'),'Delimiter','tab');
writematrix(Arr_FRACb0,strcat(OutputDir,'FRACb0.txt'),'Delimiter','tab');
writematrix(Arr_FRACb0close,strcat(OutputDir,'FRACb0close.txt'),'Delimiter','tab');
writematrix(Arr_FRACb0a0,strcat(OutputDir,'FRACb0a0.txt'),'Delimiter','tab');
writematrix(Arr_FRACb0aP,strcat(OutputDir,'FRACb0aP.txt'),'Delimiter','tab');
writematrix(Arr_FRACbN,strcat(OutputDir,'FRACbN.txt'),'Delimiter','tab');
writematrix(Arr_FRACnw0,strcat(OutputDir,'FRACnw0.txt'),'Delimiter','tab');
writematrix(Arr_FRACnw0close,strcat(OutputDir,'FRACnw0close.txt'),'Delimiter','tab');

writematrix(Arr_EbN,strcat(OutputDir,'EbN.txt'),'Delimiter','tab');
writematrix(Arr_EbP,strcat(OutputDir,'EbP.txt'),'Delimiter','tab');
writematrix(Arr_Eadjcost,strcat(OutputDir,'Eadjcost.txt'),'Delimiter','tab');

writematrix(Arr_GINIa,strcat(OutputDir,'GINIa.txt'),'Delimiter','tab');
writematrix(Arr_GINIb,strcat(OutputDir,'GINIb.txt'),'Delimiter','tab');
writematrix(Arr_GINInw,strcat(OutputDir,'GINInw.txt'),'Delimiter','tab');
writematrix(Arr_GINIc,strcat(OutputDir,'GINIc.txt'),'Delimiter','tab');
writematrix(Arr_GINIinc,strcat(OutputDir,'GINIinc.txt'),'Delimiter','tab');
writematrix(Arr_GINIlabinc,strcat(OutputDir,'GINIlabinc.txt'),'Delimiter','tab');

writematrix(Arr_ill_share_top10pc,strcat(OutputDir,'ill_share_top10pc.txt'),'Delimiter','tab');
writematrix(Arr_ill_share_top1pc,strcat(OutputDir,'ill_share_top1pc.txt'),'Delimiter','tab');
writematrix(Arr_ill_share_top01pc,strcat(OutputDir,'ill_share_top01pc.txt'),'Delimiter','tab');
writematrix(Arr_ill_share_bot50pc,strcat(OutputDir,'ill_share_bot50pc.txt'),'Delimiter','tab');
writematrix(Arr_ill_share_bot25pc,strcat(OutputDir,'ill_share_bot25pc.txt'),'Delimiter','tab');
writematrix(Arr_ill_share_bot10pc,strcat(OutputDir,'ill_share_bot10pc.txt'),'Delimiter','tab');
writematrix(Arr_ill_p10pc,strcat(OutputDir,'ill_p10pc.txt'),'Delimiter','tab');
writematrix(Arr_ill_p50pc,strcat(OutputDir,'ill_p50pc.txt'),'Delimiter','tab');
writematrix(Arr_ill_p90pc,strcat(OutputDir,'ill_p90pc.txt'),'Delimiter','tab');

writematrix(Arr_liq_share_top10pc,strcat(OutputDir,'liq_share_top10pc.txt'),'Delimiter','tab');
writematrix(Arr_liq_share_top1pc,strcat(OutputDir,'liq_share_top1pc.txt'),'Delimiter','tab');
writematrix(Arr_liq_share_top01pc,strcat(OutputDir,'liq_share_top01pc.txt'),'Delimiter','tab');
writematrix(Arr_liq_share_bot50pc,strcat(OutputDir,'liq_share_bot50pc.txt'),'Delimiter','tab');
writematrix(Arr_liq_share_bot25pc,strcat(OutputDir,'liq_share_bot25pc.txt'),'Delimiter','tab');
writematrix(Arr_liq_share_bot10pc,strcat(OutputDir,'liq_share_bot10pc.txt'),'Delimiter','tab');
writematrix(Arr_liq_p10pc,strcat(OutputDir,'liq_p10pc.txt'),'Delimiter','tab');
writematrix(Arr_liq_p50pc,strcat(OutputDir,'liq_p50pc.txt'),'Delimiter','tab');
writematrix(Arr_liq_p90pc,strcat(OutputDir,'liq_p90pc.txt'),'Delimiter','tab');

writematrix(Arr_nw_share_top10pc,strcat(OutputDir,'nw_share_top10pc.txt'),'Delimiter','tab');
writematrix(Arr_nw_share_top1pc,strcat(OutputDir,'nw_share_top1pc.txt'),'Delimiter','tab');
writematrix(Arr_nw_share_top01pc,strcat(OutputDir,'nw_share_top01pc.txt'),'Delimiter','tab');
writematrix(Arr_nw_share_bot50pc,strcat(OutputDir,'nw_share_bot50pc.txt'),'Delimiter','tab');
writematrix(Arr_nw_share_bot25pc,strcat(OutputDir,'nw_share_bot25pc.txt'),'Delimiter','tab');
writematrix(Arr_nw_share_bot10pc,strcat(OutputDir,'nw_share_bot10pc.txt'),'Delimiter','tab');
writematrix(Arr_nw_p10pc,strcat(OutputDir,'nw_p10pc.txt'),'Delimiter','tab');
writematrix(Arr_nw_p50pc,strcat(OutputDir,'nw_p50pc.txt'),'Delimiter','tab');
writematrix(Arr_nw_p90pc,strcat(OutputDir,'nw_p90pc.txt'),'Delimiter','tab');


writematrix(Arr_inc_share_top10pc,strcat(OutputDir,'inc_share_top10pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_share_top1pc,strcat(OutputDir,'inc_share_top1pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_share_top01pc,strcat(OutputDir,'inc_share_top01pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_share_bot50pc,strcat(OutputDir,'inc_share_bot50pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_share_bot25pc,strcat(OutputDir,'inc_share_bot25pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_share_bot10pc,strcat(OutputDir,'inc_share_bot10pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_share_bot10pc,strcat(OutputDir,'inc_share_bot10pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_p10pc,strcat(OutputDir,'inc_p10pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_p50pc,strcat(OutputDir,'inc_p50pc.txt'),'Delimiter','tab');
writematrix(Arr_inc_p90pc,strcat(OutputDir,'inc_p90pc.txt'),'Delimiter','tab');

writematrix(Arr_totinc_share_top10pc,strcat(OutputDir,'totinc_share_top10pc.txt'),'Delimiter','tab');
writematrix(Arr_totinc_share_top1pc,strcat(OutputDir,'totinc_share_top1pc.txt'),'Delimiter','tab');
writematrix(Arr_totinc_share_top01pc,strcat(OutputDir,'totinc_share_top01pc.txt'),'Delimiter','tab');
writematrix(Arr_totinc_share_bot50pc,strcat(OutputDir,'totinc_share_bot50pc.txt'),'Delimiter','tab');
writematrix(Arr_totinc_share_bot25pc,strcat(OutputDir,'totinc_share_bot25pc.txt'),'Delimiter','tab');
writematrix(Arr_totinc_share_bot10pc,strcat(OutputDir,'totinc_share_bot10pc.txt'),'Delimiter','tab');
writematrix(Arr_totinc_p10pc,strcat(OutputDir,'totinc_p10pc.txt'),'Delimiter','tab');
writematrix(Arr_totinc_p50pc,strcat(OutputDir,'totinc_p50pc.txt'),'Delimiter','tab');
writematrix(Arr_totinc_p90pc,strcat(OutputDir,'totinc_p90pc.txt'),'Delimiter','tab');

writematrix(Arr_con_share_top10pc,strcat(OutputDir,'con_share_top10pc.txt'),'Delimiter','tab');
writematrix(Arr_con_share_top1pc,strcat(OutputDir,'con_share_top1pc.txt'),'Delimiter','tab');
writematrix(Arr_con_share_top01pc,strcat(OutputDir,'con_share_top01pc.txt'),'Delimiter','tab');
writematrix(Arr_con_share_bot50pc,strcat(OutputDir,'con_share_bot50pc.txt'),'Delimiter','tab');
writematrix(Arr_con_share_bot25pc,strcat(OutputDir,'con_share_bot25pc.txt'),'Delimiter','tab');
writematrix(Arr_con_share_bot10pc,strcat(OutputDir,'con_share_bot10pc.txt'),'Delimiter','tab');
writematrix(Arr_con_p10pc,strcat(OutputDir,'con_p10pc.txt'),'Delimiter','tab');
writematrix(Arr_con_p50pc,strcat(OutputDir,'con_p50pc.txt'),'Delimiter','tab');
writematrix(Arr_con_p90pc,strcat(OutputDir,'con_p90pc.txt'),'Delimiter','tab');

writematrix(Arr_Ec_bN,strcat(OutputDir,'Ec_bN.txt'),'Delimiter','tab');
writematrix(Arr_Ec_b0close,strcat(OutputDir,'Ec_b0close.txt'),'Delimiter','tab');
writematrix(Arr_Ec_b0far,strcat(OutputDir,'Ec_b0far.txt'),'Delimiter','tab');

for i =1:Ttransition
    writematrix(Arr_PERCa(i,:),strcat(OutputDir,'PERCa.txt'),'Delimiter',' ');
    writematrix(Arr_PERCb(i,:),strcat(OutputDir,'PERCb.txt'),'Delimiter',' ');
    writematrix(Arr_PERCnw(i,:),strcat(OutputDir,'PERCnw.txt'),'Delimiter',' ');
    writematrix(Arr_PERCc(i,:),strcat(OutputDir,'PERCc.txt'),'Delimiter',' ');
    writematrix(Arr_PERCinc(i,:),strcat(OutputDir,'PERCinc.txt'),'Delimiter',' ');
    
    writematrix(Arr_Ea_nwQ(i,:),strcat(OutputDir,'Ea_nwQ.txt'),'Delimiter',' ');
    writematrix(Arr_Eb_nwQ(i,:),strcat(OutputDir,'Eb_nwQ.txt'),'Delimiter',' ');
    writematrix(Arr_Ec_nwQ(i,:),strcat(OutputDir,'Ec_nwQ.txt'),'Delimiter',' ');
    writematrix(Arr_Einc_nwQ(i,:),strcat(OutputDir,'Einc_nwQ.txt'),'Delimiter',' ');
    writematrix(Arr_Ea_incQ(i,:),strcat(OutputDir,'Ea_incQ.txt'),'Delimiter',' ');
    writematrix(Arr_Eb_incQ(i,:),strcat(OutputDir,'Eb_incQ.txt'),'Delimiter',' ');
    writematrix(Arr_Ec_incQ(i,:),strcat(OutputDir,'Ec_incQ.txt'),'Delimiter',' ');
    writematrix(Arr_Einc_incQ(i,:),strcat(OutputDir,'Einc_incQ.txt'),'Delimiter',' ');

end
% from the solnSTICKY (only first period saved)
for iy=1:ngpy
    writematrix(irfpriceexp.solnSTICKY.V{1}(:,:,iy),strcat(OutputDir,'V_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.d{1}(:,:,iy),strcat(OutputDir,'dep_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.c{1}(:,:,iy),strcat(OutputDir,'con_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.s{1}(:,:,iy),strcat(OutputDir,'sav_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.h{1}(:,:,iy),strcat(OutputDir,'hour_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.bdot{1}(:,:,iy),strcat(OutputDir,'bdot_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.gmat{1}(:,:,iy),strcat(OutputDir,'gjoint_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    
    writematrix(irfpriceexp.solnSTICKY.mpc{1}(:,:,iy),strcat(OutputDir,'mpc_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.subeff1ass{1}(:,:,iy),strcat(OutputDir,'subeff1ass_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.subeff2ass{1}(:,:,iy),strcat(OutputDir,'subeff2ass_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.wealtheff1ass{1}(:,:,iy),strcat(OutputDir,'wealtheff1ass_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
    writematrix(irfpriceexp.solnSTICKY.wealtheff2ass{1}(:,:,iy),strcat(OutputDir,'wealtheff2ass_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
      
    % SaveCumPolicyFnsIRF is false. If true we need different function
    % CumulativeConsTransition, not CumulativeConsumption
%     if SaveCumPolicyFnsIRF
%         writematrix(irfpriceexp.cumSTICKY.ccum1(:,:,iy),strcat(OutputDir,'ccum1_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
%         writematrix(irfpriceexp.cumSTICKY.ccum2(:,:,iy),strcat(OutputDir,'ccum2_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
%         writematrix(irfpriceexp.cumSTICKY.ccum4(:,:,iy),strcat(OutputDir,'ccum4_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
%         writematrix(irfpriceexp.cumSTICKY.dcum1(:,:,iy),strcat(OutputDir,'dcum1_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
%         writematrix(irfpriceexp.cumSTICKY.dcum2(:,:,iy),strcat(OutputDir,'dcum2_T1_y',num2str(iy),'.txt'),'Delimiter',' ');
%         writematrix(irfpriceexp.cumSTICKY.dcum4(:,:,iy),strcat(OutputDir,'dcum4_T1_y',num2str(iy),'.txt'),'Delimiter',' ');   
%     end
end


end




