% GLOBALS FOR DIRECTORIES
global OutputDir OutputDirIRF EarningsProcessDir InputParamFile

%OPTIONS GLOBALS
global	ReportNonMonotonicity NoLaborSupply LaborSupplySepLaborSupplyGHH ...
EquilibriumRCalibrateCostFunctionDoImpulseResponses CalibrateDiscountRate ...
SaveCumPolicyFnsIRF ComputeDiscountedMPC
global SolveStickyPriceTransitionFirmDiscountRateImposeEqumInCalibration
global ComputeCumulativeMPCScaleDisutilityIdio SaveTime1PolicyFns ...
DoPriceExperiments DistributeProfitsInProportion TaxHHProfitIncome
global AdjGovBudgetConstraint ConvergenceRelToOutput AdjustProdGridFrisch
global GovExpConstantFracOutput GovBondResidualZeroWorld ...
PinKappa1ByKappa02 ImposeMaxHours OneAssetNoCapital
global ReadEarningsProcess PerfectAnnuityMarkets CalibrateRhoAtInitialGuess
global MatchRelativeToTargetOutput DividendFundLumpSum stickytransition
global maxiter maxitertransflex maxitertranssticky maxiterKFE maxiterequmss maxiterrho
 
global Vtol KFEtol deltass deltakfe deltacumcon nendtrans ...
 toltransitiondeltatransparam deltatransmin deltatransmax adjfricshgridfrac
%global deltatransvec(Ttransition) cumdeltatrans(Ttransition)
global deltatransvec cumdeltatrans
global tolequmss stepequmss tolrho stepstickytransK ...
 stepstickytransB stepstickytransRb dVamin dVbmin

%CALIBRATION OPTIONS
global EstimateKappa0EstimateKappa1EstimateKappa2...
EstimateKappa3EstimateKappa4EstimateRhoEstimateBorrWedge EstimateGamma
globalMatchMeanIllMatchMedianIllMatchP75Ill...
MatchFracIll0MatchMeanLiqMatchFracIll0Liq0MatchMedianLiq...
MatchFracLiq0MatchFracLiqNeg MatchKYratio
global calibrating iteratingtransition defnaclose defnbclose

%SHOCK GLOBALS
global IncludeMonetaryShock
global IncludeForwardGuideShock ForwardGuideShockQtrs
global MonetaryShockSize ForwardGuideShockSize
global MonetaryShockPers ForwardGuideShockPers
global forwardguide

%GRIDS GLOBALS
global  	ygrid logygrid		 %individual productivity
global 		agrid adelta adrift %illiquid asset
global 		bgrid bdelta bdrift %liquid asset
global 		abdelta
global 		abydelta
global 		afromaby bfromaby yfromaby abfromaby
global 		afromab bfromab
global      abyfromaby
global      abfromab
global 		dbgrid %liquid asset spacing
global 		dagrid %illiquid asset spacing

%GLOBALS FOR INCOME RISK
global  ydist
global  ytrans ymarkov ymarkovdiag ymarkovoff

%GLOBALS FOR VALUE FUNCTIONS AND DECISION
global V Vnew u gjoint c h d s ccum1 ccum4 ccum2 dcum1 ...
dcum4 dcum2 bdot mpc subeff1ass subeff2ass wealtheff1ass wealtheff2ass
global gamarg gbmarg gmat gabcum gabmarg
global gvec

%ITERATION GLOBALS
global delta

%PARAMETER GLOBALS
global rho gam utilcost chi frisch blim nbl abl ...
 prefshock fundlev fundbond deathrate meanlabeff profdistfrac
global elast alpha deprec alphatilde theta phitaylor ...
 phifg bondelast borrwedge mpshock bondadjust bondelastrelgdp
global 	kappa0_d kappa1_d kappa2_d kappa0_w kappa1_w kappa2_w kappa3 kappa4_d kappa4_w
global 	dmin taxincrstart taxincrdecay utilelast utilelastalpha

%EQUILIBRIUM GLOBALS
global ra rborr rcapital wage netwage KYratio KNratio mc ...
 rb tfp pi rnom gap bond capital labor output investment govexp ...
 taxrev govbond worldbond profit dividend divrate priceadjust equity
global labtax lumptransfer lumptransferpc ssdebttogdp corptax illassetdrop caputil tfpadj
global	neqmiter
global converged initialSS

%STATISTICS GLOBALS
global 	Ea Eb Ec Elabor Ed Ewage Enetlabinc ...
 Egrosslabinc Enetprofinc Egrossprofinc Einc Ehours Enw EbN EbP Eadjcost
global 	FRACa0 FRACa0close FRACb0 FRACb0close ...
 FRACb0a0 FRACb0aP FRACbN FRACnw0 FRACnw0close FRACb0a0close
global 	PERCa(11) PERCb(11) PERCnw(11) PERCc(11) PERCinc(11)
global 	GINIa GINIb GINInw GINIc GINIinc
global 	Ea_nwQ(4) Eb_nwQ(4) Ec_nwQ(4) Einc_nwQ(4) Ea_incQ(4) Eb_incQ(4) Ec_incQ(4) Einc_incQ(4)
global	Ec_bN Ec_b0close Ec_b0far

%CALIBRATION GLOBALS
global					nparam nmoments objeval ndfls
global 	paramguess(:) paramout(:) paramscale(:) paramlb(:) ...
 paramub(:) diagweight(:) nobsvec(:)
global		targetMeanIll targetMeanLiq targetMedianIll targetP75Ill ...
 targetMedianLiq targetFracIll0 targetFracLiq0 targetFracIll0Liq0 targetFracLiqNEG targetKYratio
global		modelMeanIll modelMeanLiq modelMedianIll modelP75Ill ...
 modelMedianLiq modelFracIll0 modelFracLiq0 modelFracIll0Liq0 modelFracLiqNEG modelKYratio
global 	kappa2min borrwedgemax






