%Compilation of entire analysis process
clear
cd 'C:\Users\sarah\Documents\BandDendrometer\Biomass_master rework\AF\Increment band master\Analysis\Current Process\package'

%open a text file to log significant results
fileID = fopen('AdditionalInfo.txt', 'w');
currentDate = datetime("now");
formattedDate = string(currentDate, 'dd-MMM-yyyy HH:mm');
fprintf(fileID, 'Start of %s Analysis \n', formattedDate);


%Read file with radial growth and biomass increments for all band
%dendrometer observations
bands = readtable('UMB_UMd_upload.csv');

%filter to only bands in the UMB plot (exclude UMd)
bands = bands(strcmp(bands.site_ID,'UMB'), :);

%generate year column and filter for when environmental data is available
bands.year = year(bands.band_reading_date);
bands = bands(bands.year>=2000&bands.year<=2021,:);

%Calculate annual mean diameter growth, biomass increment, and observation count
%for each species, entire plot, and isohydric/anisohydric species groupings

[AnnualMeanGrowth, AnnualMeanBiomass, ObsCount] = calcGrowthBiomassCount(bands); 

%Detrend annual mean radial growth and biomass
[dAnnualMeanGrowth, dAnnualMeanBiomass] = detrendGrowthBiomass(fileID, AnnualMeanGrowth,AnnualMeanBiomass);

%Calculate SWC as average between integrated and point sensors
CombinedSWC = CalcSWC();

%Calculate and detrend 3-month period, growing/dormant, and annual environmental means
environmentalMean(fileID, CombinedSWC);

%shortAnalysisTrending(AnnualMeanGrowth, 'Trending Growth');
normalGLM(bands,'dGrowth',AnnualMeanGrowth,dAnnualMeanGrowth);
normalGLM(bands,'dBiomass',AnnualMeanBiomass,dAnnualMeanBiomass);
normalGLM(bands,'growth',AnnualMeanGrowth,AnnualMeanGrowth);
normalGLM(bands,'biomass',AnnualMeanGrowth,AnnualMeanBiomass);

crossCorrEnvironmental(fileID);

generateGraphs(AnnualMeanGrowth, dAnnualMeanGrowth, AnnualMeanBiomass, ObsCount, bands);

fclose(fileID);
