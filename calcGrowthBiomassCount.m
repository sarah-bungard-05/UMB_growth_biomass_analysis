%Calculate annual mean radial growth and biomass increment for each
%species, entire plot, and isohydric/anisohydric species groupings 
function [AnnualMeanGrowth, AnnualMeanBiomass, ObsCount] = calcGrowthBiomassCount(bands)
    spec = {'acru','acsa','bepa','fagr','pist','pogr','potr','quru'};

    % isoNames = {'acru','acsa','bepa','pist','pogr','potr'};
    % anNames = {'quru','fagr'};
    
    startYr = 2000;
    endYr = 2021;

    NSpec = length(spec);

    AnnualMeanGrowth = nan(22,12);
    AnnualMeanGrowth(:,1) = (2000:1:2021)';

    AnnualMeanBiomass = nan(22,12);
    AnnualMeanBiomass(:,1) = (2000:1:2021)';

    ObsCount = nan(22,12);
    ObsCount(:,1) = (2000:1:2021)';


    %% Calculating values for each species
    for sp = 1:1:NSpec
        specSub = bands(strcmp(bands.species_acronym,spec{sp}),:);
        for yr=startYr:1:endYr
            i=yr-startYr+1;
            specYrSub = specSub(specSub.year==yr,:);
            AnnualMeanGrowth(i, sp+1) = mean(specYrSub.annual_growth_calc_cm, 'omitmissing');
            AnnualMeanBiomass(i, sp+1) = mean(specYrSub.annual_biomass_inc_kg, 'omitmissing');
            specYrSub(isnan(specYrSub.annual_growth_calc_cm),:) = [];
            ObsCount(i,sp+1) = height(specYrSub.annual_growth_calc_cm);
        end
    end

    %% Calculating values for all species
    for yr=startYr:1:endYr
        i=yr-startYr+1;
        yrSub = bands(bands.year==yr,:);
        AnnualMeanGrowth(i,10) = mean(yrSub.annual_growth_calc_cm, 'omitmissing');
        AnnualMeanBiomass(i,10) = mean(yrSub.annual_biomass_inc_kg, 'omitmissing');
        yrSub(isnan(yrSub.annual_growth_calc_cm),:) = [];

        ObsCount(i,10) = height(yrSub.annual_growth_calc_cm);
    end
    
    % %% Calculating values for an/isohydric species groupings
    % 
    % isoSub = bands(ismember(bands.species_acronym,isoNames),:);
    % for yr=startYr:1:endYr
    %     i=yr-startYr+1;
    %     isoYrSub = isoSub(year(isoSub.band_reading_date)==yr,:);
    %     AnnualMeanGrowth(i,11) = mean(isoYrSub.annual_growth_calc_cm, 'omitmissing');
    %     AnnualMeanBiomass(i,11) = mean(isoYrSub.annual_biomass_inc_kg, 'omitmissing');
    %     isoYrSub(isnan(isoYrSub.annual_growth_calc_cm),:) = [];
    %     ObsCount(i,11) = height(isoYrSub.annual_growth_calc_cm);
    % end
    % 
    % anSub = bands(ismember(bands.species_acronym,anNames),:);
    % for yr=startYr:1:endYr
    %     i=yr-startYr+1;
    %     anYrSub = isoSub(year(anSub.band_reading_date)==yr,:);
    %     AnnualMeanGrowth(i,12) = mean(anYrSub.annual_growth_calc_cm, 'omitmissing');
    %     AnnualMeanBiomass(i,12) = mean(anYrSub.annual_biomass_inc_kg, 'omitmissing');
    %     anYrSub(isnan(anYrSub.annual_growth_calc_cm),:) = [];
    %     ObsCount(i,12) = height(anYrSub.annual_growth_calc_cm);
    % end

    
    %% Combining calculated values into three tables: growth, biomass, count

    AnnualMeanGrowth = array2table(AnnualMeanGrowth, 'VariableNames',{'Year','ACRU','ACSA','BEPA','FAGR','PIST','POGR','POTR','QURU','AllSpec','Iso','Aniso'});
    AnnualMeanBiomass = array2table(AnnualMeanBiomass, 'VariableNames',{'Year','ACRU','ACSA','BEPA','FAGR','PIST','POGR','POTR','QURU','AllSpec','Iso','Aniso'});
    ObsCount = array2table(ObsCount, 'VariableNames',{'Year','ACRU','ACSA','BEPA','FAGR','PIST','POGR','POTR','QURU','AllSpec','Iso','Aniso'});

end
