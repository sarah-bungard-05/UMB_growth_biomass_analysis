function normalGLM(bands, code, AnnualMean, dAnnualMean)

folder = 'results';
mkdir results;

% revamp linear models - imitate JMP analysis in MATLAB
spec = {'acru','acsa','bepa','fagr','pist','pogr','potr','quru'};
Spec = {'ACRU','ACSA','BEPA','FAGR','PIST','POGR','POTR','QURU'};
lagList = {'L0','L1','L2','L3'};
seasList = {'DJF','MAM','JJA','SON'};

bands.d(:)=nan;

% Definding y column in bands and adding predictor variables
switch code
    case 'dGrowth'
        d = AnnualMean(:,2:end) - dAnnualMean(:,2:end);
        d.year = (2000:1:2021)';
        
        for i=1:1:8
            sub = strcmp(bands.species_acronym,spec{i});
            tmp = join(bands(sub,:),d,'RightVariables', {Spec{i} 'year'},'Keys', 'year');
            bands{sub,"d"} = tmp{:,Spec{i}};
        end

        bands.y = bands.annual_growth_calc_cm - bands.d;
        bands2 = joinEnvironmentalShort_D(bands);

    case 'dBiomass'
        d = AnnualMean(:,2:end) - dAnnualMean(:,2:end);
        d.year = (2000:1:2021)';

        for i=1:1:8
            sub = strcmp(bands.species_acronym,spec{i});
            tmp = join(bands(sub,:),d,'RightVariables', {Spec{i} 'year'},'Keys', 'year');
            bands{sub,"d"} = tmp{:,Spec{i}};
        end

        bands.y = bands.annual_biomass_inc_kg - bands.d;
        bands2 = joinEnvironmentalShort_D(bands);

    case 'growth'
        bands.y = bands.annual_growth_calc_cm;
        bands2 = joinEnvironmentalShort(bands);

    case 'biomass'
        bands.y = bands.annual_biomass_inc_kg;
        bands2 = joinEnvironmentalShort(bands);
    
    otherwise
        warning('Unexpected code in GLM func');
end

%%
stat.SWC.p=nan(9,16);
stat.SWC.est=nan(9,16);

stat.VPD.p=nan(9,16);
stat.VPD.est=nan(9,16);

stat.PAR.p=nan(9,16);
stat.PAR.est=nan(9,16);

stat.TA.p=nan(9,16);
stat.TA.est=nan(9,16);

stat.SPI.p=nan(9,16);
stat.SPI.est=nan(9,16);
%%
for sp = 1:1:8
subSpec = strcmp(bands2.species_acronym,spec{sp});

    for lag = 1:1:4
        for seas = 1:1:4
            select = {
                ['SWC_' seasList{seas} '_' lagList{lag}], ...
                ['VPD_' seasList{seas} '_' lagList{lag}], ...
                ['PAR_' seasList{seas} '_' lagList{lag}], ...
                ['TA_'  seasList{seas} '_' lagList{lag}], ...
                ['SPI_' seasList{seas} '_' lagList{lag}]

            };    
            lmTable = bands2(subSpec,[select "y"]);
            mdl = fitglm(lmTable , 'Distribution','normal' );%
            
            stat.SWC.p(sp,(lag-1)*4+seas) = mdl.Coefficients.pValue(2);
            stat.VPD.p(sp,(lag-1)*4+seas) = mdl.Coefficients.pValue(3);
            stat.PAR.p(sp,(lag-1)*4+seas) = mdl.Coefficients.pValue(4);
            stat.TA.p(sp,(lag-1)*4+seas) = mdl.Coefficients.pValue(5);
            stat.SPI.p(sp,(lag-1)*4+seas) = mdl.Coefficients.pValue(6);

            stat.SWC.est(sp,(lag-1)*4+seas) = mdl.Coefficients.Estimate(2);
            stat.VPD.est(sp,(lag-1)*4+seas) = mdl.Coefficients.Estimate(3);
            stat.PAR.est(sp,(lag-1)*4+seas) = mdl.Coefficients.Estimate(4);
            stat.TA.est(sp,(lag-1)*4+seas) = mdl.Coefficients.Estimate(5);
            stat.SPI.est(sp,(lag-1)*4+seas) = mdl.Coefficients.Estimate(6);
        end

        lmTable = bands2(:,[select "y"]);
        mdl = fitglm(lmTable , 'Distribution','normal' );
    
        stat.SWC.p(9,(lag-1)*4+seas) = mdl.Coefficients.pValue(2);
        stat.VPD.p(9,(lag-1)*4+seas) = mdl.Coefficients.pValue(3);
        stat.PAR.p(9,(lag-1)*4+seas) = mdl.Coefficients.pValue(4);
        stat.TA.p(9,(lag-1)*4+seas) = mdl.Coefficients.pValue(5);
        stat.SPI.p(9,(lag-1)*4+seas) = mdl.Coefficients.pValue(6);
    
        stat.SWC.est(9,(lag-1)*4+seas) = mdl.Coefficients.Estimate(2);
        stat.VPD.est(9,(lag-1)*4+seas) = mdl.Coefficients.Estimate(3);
        stat.PAR.est(9,(lag-1)*4+seas) = mdl.Coefficients.Estimate(4);
        stat.TA.est(9,(lag-1)*4+seas) = mdl.Coefficients.Estimate(5);
        stat.SPI.est(9,(lag-1)*4+seas) = mdl.Coefficients.Estimate(6);

    end
end

specNames= {'ACRU';'ACSA';'BEPA';'FAGR';'PIST';'POGR';'POTR';'QURU'};
xlabels = {'L0 DJF', 'L0 MAM', 'L0 JJA', 'L0 SON','L1 DJF', 'L1 MAM', 'L1 JJA', 'L1 SON','L2 DJF', 'L2 MAM', 'L2 JJA', 'L2 SON', 'L3 DJF', 'L3 MAM', 'L3 JJA', 'L3 SON'};

n = fieldnames(stat);
for i=1:1:5
    % Filtering nonsignificant values
    mask = stat.(n{i}).p > 0.0125;
    stat.(n{i}).p(mask)   = NaN;
    stat.(n{i}).est(mask) = NaN;

    figure(gcf().Number+1);

    h = heatmap(xlabels, [specNames; {'AllSpec'}], stat.(n{i}).est);
    cmap = interp1([0 0.5 1],[1 0 0; 1 1 1;0 0 1],linspace(0,1,256));
    colormap(h, cmap);
    h.ColorLimits = [-.0000001 .00000001];
    h.Title = ['Estimates for ' n{i} ' from GLM with all detrended predictors and ' code];
    h.MissingDataColor = [1 1 1];

    pvals = stat.(n{i}).p;
    ests  = stat.(n{i}).est;

    summaryStrings = "p = " + string(pvals) + ...
                     ", est = " + string(ests);

    summaryTable = array2table(summaryStrings, ...
        'VariableNames', xlabels, ...
        'RowNames', [specNames; {'AllSpec'}]);

    writetable(summaryTable, ...
        fullfile(folder,[code '_' n{i} '_Summary.xlsx']), ...
        'WriteRowNames', true);
end 
    






