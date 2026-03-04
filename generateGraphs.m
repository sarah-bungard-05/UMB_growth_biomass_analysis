% This script reads in AmeriFlux Network data, drought indices, 
% pre-processed annual growth data from the band dendrometer data at UMBS. 
% It groups the AF data by three-month periods and growing/dormant seasons 
% and runs linear regressions with annual growth with up to three year lags. 
% It generates figures included in paper as well as tables with R^2 and
% p-values for all significant relationships between environmental factors
% and growth.

%Needs AF files, SPEI/SPI, and output of IncrementBandMasterAnalysis.m

%need to add new spi data, biomass versions of graphs w growth

function generateGraphs(AnnualMeanGrowth, dAnnualMeanGrowth, AnnualMeanBiomass, ObsCount,bands) 
%% FIGURE #2 --------------------------------------------------------------
% Species composition of observations over time

rainbow = [
    227  26  28   % #E31A1C quru
    251 154 153   % #FB9A99 fagr
     31 120 180   % #1F78B4 acru
    166 206 227   % #A6CEE3 acsa
    178 223 138   % #B2DF8A bepa
     51 160  44   % #33A02C pist
    152  78 163   % #984EA3 pogr
    196 161 201   % #C4A1C9 potr
] / 255;

figure(2000);
b = bar([ObsCount.QURU, ObsCount.FAGR, ObsCount.ACRU, ...
    ObsCount.ACSA,ObsCount.BEPA, ObsCount.PIST, ...
    ObsCount.POGR, ObsCount.POTR], 'stacked');
for i = 1:8
    b(i).FaceColor = rainbow(i, :);
end
years = (2000:2021)';
xticks(1:length(years));
xticklabels(string(years));
xlabel("Year",'FontWeight','bold')
ylabel('Number of Observations','FontWeight','bold');
legend('QURU','FAGR','ACRU','ASCA','BEPA','PIST','POGR','POTR', 'Location','northwest','NumColumns', 2);

%% Figure #3 --------------------------------------------------------------
% Climate factors over time
figure(3000)
t = tiledlayout(3,2, "TileSpacing","compact");
t.TileIndexing = 'columnmajor'; % Changes to vertical order

sgtitle('Climate Factors Over Time')

load('vars\seasonUMBSWC.mat');
load('vars\seasonUMBVPD.mat');
load('vars\seasonUMBPAR.mat');
load('vars\seasonUMBTA.mat');

load('vars\seasonUMBSPEI.mat');
load('vars\seasonUMBSPI.mat');

colors = [
    0.6510  0.8078  0.8902
    0.1216  0.4706  0.7059
    0.6980  0.8745  0.5412
    0.2000  0.6275  0.1725
    0.9843  0.6039  0.6000
    0.8902  0.1020  0.1098
    0.9922  0.7490  0.4353
    1.0000  0.4980  0
    0.7922  0.6980  0.8392
    0.4157  0.2392  0.6039
    1.0000  0.9294  0.4353   % [255, 237, 111]
    0.9216  0.7529  0.0078   % [235, 192,   2]
];

nexttile
plot(seasonUMBSPEI.Year,seasonUMBSPEI.SPEI_G, 'LineWidth', 2, 'Color', colors(1,:), 'DisplayName','Growing SPEI');
hold on;
plot(seasonUMBSPEI.Year,seasonUMBSPEI.SPEI_D, 'LineWidth', 2, 'Color', colors(2,:), 'DisplayName','Dormant SPEI');
ylabel('SPEI','FontWeight','bold');
legend();
set(gca, 'XTickLabel', []);
text(0.02, 0.9, 'A','Units', 'normalized',  'FontSize', 12);
xlim([2000 2025]);

% Both growing and dormant SPEI are increasing significantly
[a,~,~,~,stats] = regress(seasonUMBSPEI.SPEI_G,[seasonUMBSPEI.Year,ones(size(seasonUMBSPEI.Year))]); %R2=0.32, p=0.006 
[a,~,~,~,stats] = regress(seasonUMBSPEI.SPEI_D,[seasonUMBSPEI.Year,ones(size(seasonUMBSPEI.Year))]); %R2=0.32, p=0.0077

nexttile
plot(seasonUMBSPI.Year,seasonUMBSPI.SPI_G, 'LineWidth', 2, 'Color',colors(3,:), 'DisplayName','Growing SPI');
hold on;
plot(seasonUMBSPI.Year,seasonUMBSPI.SPI_D, 'LineWidth', 2, 'Color',colors(4,:), 'DisplayName','Dormant SPI');
ylabel('SPI','FontWeight','bold');
text(0.02, 0.9, 'B','Units', 'normalized',  'FontSize', 12);

legend();
set(gca, 'XTickLabel', []); 

% Only dormant SPI is increasing significantly
[a,~,~,~,stats] = regress(seasonUMBSPI.SPI_G,[seasonUMBSPI.Year,ones(size(seasonUMBSPI.Year))]); %p=0.0779
[a,~,~,~,stats] = regress(seasonUMBSPI.SPI_D,[seasonUMBSPI.Year,ones(size(seasonUMBSPI.Year))]); %R=0.2283, p=0.0285

nexttile
plot(seasonUMBSWC.Year,seasonUMBSWC.Growing, 'LineWidth', 2, 'Color', colors(5,:), 'DisplayName','Growing SWC');
hold on;
plot(seasonUMBSWC.Year,seasonUMBSWC.Dormant, 'LineWidth', 2, 'Color', colors(6,:), 'DisplayName','Dormant SWC');
legend();
ylabel('SWC (%)','FontWeight','bold');
%set(gca, 'XTickLabel', []);
text(0.02, 0.9, 'C','Units', 'normalized',  'FontSize', 12);
xlim([2000 2025]);


% Both growing and dormant SWC are decreasing significantly
[a,~,~,~,stats] = regress(seasonUMBSWC.Growing,[seasonUMBSWC.Year,ones(size(seasonUMBSWC.Year))]); %R2=0.55, p=0.0001
[a,~,~,~,stats] = regress(seasonUMBSWC.Dormant,[seasonUMBSWC.Year,ones(size(seasonUMBSWC.Year))]); %R2=0.61, p<0.00001

nexttile
plot(seasonUMBTA.Year,seasonUMBTA.Growing, 'LineWidth', 2, 'Color', colors(7,:), 'DisplayName','Growing TA');
hold on;
plot(seasonUMBTA.Year,seasonUMBTA.Dormant, 'LineWidth', 2, 'Color', colors(8,:), 'DisplayName','Dormant TA');
legend();
ylabel('TA (\circC)','FontWeight','bold');
set(gca, 'XTickLabel', []);
text(0.02, 0.9, 'D','Units', 'normalized',  'FontSize', 12);
xlim([2000 2025]);

nexttile
plot(seasonUMBVPD.Year,seasonUMBVPD.Growing, 'LineWidth', 2, 'Color', colors(9,:), 'DisplayName','Growing VPD');
hold on;
plot(seasonUMBVPD.Year,seasonUMBVPD.Dormant, 'LineWidth', 2, 'Color', colors(10,:), 'DisplayName','Dormant VPD');
legend();
ylabel('VPD (hPa)','FontWeight','bold');
xlabel('Year','FontWeight','bold');
text(0.02, 0.9, 'E','Units', 'normalized',  'FontSize', 12);
xlim([2000 2025]);
set(gca, 'XTickLabel', []);


% Neither growing/dormant VPD is changing
[a,~,~,~,stats] = regress(seasonUMBVPD.Growing,[seasonUMBVPD.Year,ones(size(seasonUMBVPD.Year))]) % p=0.2065
[a,~,~,~,stats] = regress(seasonUMBVPD.Dormant,[seasonUMBVPD.Year,ones(size(seasonUMBVPD.Year))]) %p=0.877


% Neither growing/dormant TA is changing signficantly
[a,~,~,~,stats] = regress(seasonUMBTA.Growing,[seasonUMBTA.Year,ones(size(seasonUMBTA.Year))]) %p=0.4471
[a,~,~,~,stats] = regress(seasonUMBTA.Dormant,[seasonUMBTA.Year,ones(size(seasonUMBTA.Year))]) %p=0.4427

nexttile
plot(seasonUMBPAR.Year,seasonUMBPAR.Growing, 'LineWidth', 2, 'Color', colors(11,:), 'DisplayName','Growing PAR');
hold on;
plot(seasonUMBPAR.Year,seasonUMBPAR.Dormant, 'LineWidth', 2, 'Color', colors(12,:), 'DisplayName','Dormant PAR');
legend();
ylabel({'\bf PAR','\bf \mumol photons m^{-2} s^{-1}'})
%set(gca, 'XTickLabel', []);
text(0.02, 0.9, 'F','Units', 'normalized',  'FontSize', 12);
xlim([2000 2025]);

% Only growing PAR is increasing significantly
[a,~,~,~,stats] = regress(seasonUMBPAR.Growing,[seasonUMBPAR.Year,ones(size(seasonUMBPAR.Year))]) %R2=0.38,p=0.0021
[a,~,~,~,stats] = regress(seasonUMBPAR.Dormant,[seasonUMBPAR.Year,ones(size(seasonUMBPAR.Year))]) %p=0.326


hold off;
xlabel('Year','FontWeight','bold');

%% Figure 4 ----------------------------------------------------------------
%Species growth and GPP over time
rainbow = [
     31 120 180   % #1F78B4 acru
    166 206 227   % #A6CEE3 acsa
    178 223 138   % #B2DF8A bepa
    251 154 153   % #FB9A99 fagr
     51 160  44   % #33A02C pist
    152  78 163   % #984EA3 pogr
    196 161 201   % #C4A1C9 potr
    227  26  28   % #E31A1C quru
] / 255;

figure(4100);
load('vars\annualGPP.mat');
years = (2000:2021)';

yyaxis right
plot(years, annualGPP, 'LineWidth', 4, 'DisplayName','GPP');
ylabel('GPP (molCO_2 m^{-2} year^{-1})');
hold on;

[a,~,~,~,stats] = regress(annualGPP,[years,ones(size(years))]); %sig increase


yyaxis left

plot(years,AnnualMeanBiomass.AllSpec, '-', 'DisplayName','Biomass Increment','LineWidth', 4);
ylabel('Biomass Increment (kg)');
xlim([min(years) max(years)]);
legend();
set(gca, 'XTickLabel', []);

[a,~,~,~,stats] = regress(AnnualMeanBiomass.AllSpec,[years,ones(size(years))]); %p=0.326


figure(4200);
plot(years,AnnualMeanGrowth.ACRU, '-','DisplayName','ACRU', 'Color', [0 0.5 0],'LineWidth', 1);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.ACRU,[years,ones(size(years))]) %p=0.326

hold on;
plot(years,AnnualMeanGrowth.ACSA, '--','DisplayName','ACSA', 'Color', [0 0.5 0],'LineWidth', 1);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.ACSA,[years,ones(size(years))]) %p=0.326

plot(years,AnnualMeanGrowth.BEPA, 'o-','DisplayName','BEPA', 'Color', [0 0.5 0],'LineWidth', 1);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.BEPA,[years,ones(size(years))]) %p=0.326

plot(years,AnnualMeanGrowth.PIST, '+-', 'DisplayName','PIST', 'Color', [0 0.5 0],'LineWidth', 1);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.PIST,[years,ones(size(years))]) %p=0.326


plot(years,AnnualMeanGrowth.POGR, ':', 'DisplayName','POGR', 'Color', [0 0.5 0],'LineWidth', 1);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.POGR,[years,ones(size(years))]) %p=0.326

plot(years,AnnualMeanGrowth.POTR, '^-', 'DisplayName','POTR', 'Color', [0 0.5 0],'LineWidth', 1);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.POTR,[years,ones(size(years))]) %p=0.326

plot(years,AnnualMeanGrowth.FAGR, '-.', 'DisplayName','FAGR', 'Color', [0 0.5 0],'LineWidth', 1);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.FAGR,[years,ones(size(years))]) %p=0.326

plot(years,AnnualMeanGrowth.QURU, '-*', 'DisplayName','QURU', 'Color', [0 0.5 0],'LineWidth', 1);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.QURU,[years,ones(size(years))]) %p=0.326


plot(years,AnnualMeanGrowth.AllSpec, '-k', 'DisplayName','All Species Growth','LineWidth', 4);
[a,~,~,~,stats] = regress(AnnualMeanGrowth.AllSpec,[years,ones(size(years))]) %p=0.326

ylabel('Diameter Growth (cm)');

xlim([min(years) max(years)]);
legend('NumColumns',2);

%% Figure 5 -----------------------------------------------------------------
%Annual mean GPP and radial growth with different lag
figure(5000);
t=tiledlayout(2,4);
t.TileSpacing="compact";

nexttile
[a,~,~,~,stats] = regress(AnnualMeanGrowth.AllSpec,[annualGPP,ones(size(annualGPP))]);

synX = (min(annualGPP):0.1:max(annualGPP))';
plot(annualGPP,AnnualMeanGrowth.AllSpec,'.r',synX,[synX ones(size(synX))]*a,'-r', 'MarkerSize',12);
hold on;
ylabel({'\bf Annual Mean','\bf Diameter Growth (cm)'});
title('No Lag')
set(gca, 'XTickLabel', []);
ylim([0.15 0.25]);

text(0.98,0.95,['R^2=' num2str(round(stats(1),2)) ' p=' num2str(round(stats(3),3))],...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','top')


%one year average, one year lag
nexttile;
[a,~,~,~,stats] = regress(AnnualMeanGrowth.AllSpec(2:end),[annualGPP(1:end-1,:),ones(size(annualGPP(1:end-1,:)))]);
synX = (min(annualGPP):0.1:max(annualGPP))';
plot(annualGPP(1:end-1),AnnualMeanGrowth.AllSpec(2:end)','.r',synX,[synX ones(size(synX))]*a,'--r', 'MarkerSize',12);
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
ylim([0.15 0.25]);


title('1 Year Lag')
text(0.98,0.95,['p=' num2str(round(stats(3),3))],...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','top')

%one year average, two year lag
nexttile
[a,~,~,~,stats] = regress(AnnualMeanGrowth.AllSpec(3:end),[annualGPP(1:end-2,:),ones(size(annualGPP(1:end-2,:)))]);

synX = (min(annualGPP):0.1:max(annualGPP))';
plot(annualGPP(1:end-2,:),AnnualMeanGrowth.AllSpec(3:end),'.r',synX,[synX ones(size(synX))]*a,'--r','MarkerSize',12);

title('2 Year Lag')
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
ylim([0.15 0.25]);
text(0.98,0.95,['p=' num2str(round(stats(3),3))],...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','top')

%one year average, three year lag
nexttile
[a,~,~,~,stats] = regress(AnnualMeanGrowth.AllSpec(4:end),[annualGPP(1:end-3,:),ones(size(annualGPP(1:end-3,:)))]);

synX = (min(annualGPP):0.1:max(annualGPP))';
plot(annualGPP(1:end-3,:),AnnualMeanGrowth.AllSpec(4:end),'.r',synX,[synX ones(size(synX))]*a,'--r','MarkerSize',12);
title('3 Year Lag')
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
ylim([0.15 0.25]);
text(0.98,0.95,['p=' num2str(round(stats(3),3))],...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'VerticalAlignment','top')

%BIOMASS
nexttile;
[a,~,~,~,stats] = regress(AnnualMeanBiomass.AllSpec,[annualGPP,ones(size(annualGPP))]);
synX = (min(annualGPP):0.1:max(annualGPP))';
plot(annualGPP,AnnualMeanBiomass.AllSpec,'.b',synX,[synX ones(size(synX))]*a,'--b', 'MarkerSize',12);
hold on;
ylabel('\bf Annual Mean Biomass (kg)');
xlabel({'\bf Annual Mean GPP','\bf (molCO_2 m^{-2} year^{-1})'});
ylim([3.5 6.5]);
text(0.02,0.95,['p=' num2str(round(stats(3),3))],...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'VerticalAlignment','top')

%one year average, one year lag
nexttile;
[a,~,~,~,stats] = regress(AnnualMeanBiomass.AllSpec(2:end),[annualGPP(1:end-1,:),ones(size(annualGPP(1:end-1,:)))]);
synX = (min(annualGPP):0.1:max(annualGPP))';
plot(annualGPP(1:end-1),AnnualMeanBiomass.AllSpec(2:end)','.b',synX,[synX ones(size(synX))]*a,'--b', 'MarkerSize',12);
xlabel('\bf Annual Mean GPP');
set(gca, 'YTickLabel', []);
ylim([3.5 6.5]);
text(0.02,0.95,['p=' num2str(round(stats(3),3))],...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'VerticalAlignment','top')

%one year average, two year lag
nexttile
[a,~,~,~,stats] = regress(AnnualMeanBiomass.AllSpec(3:end),[annualGPP(1:end-2,:),ones(size(annualGPP(1:end-2,:)))]);

synX = (min(annualGPP):0.1:max(annualGPP))';
plot(annualGPP(1:end-2,:),AnnualMeanBiomass.AllSpec(3:end),'.b',synX,[synX ones(size(synX))]*a,'--b','MarkerSize',12);
xlabel('\bf Annual Mean GPP');
set(gca, 'YTickLabel', []);
ylim([3.5 6.5]);

text(0.02,0.95,['p=' num2str(round(stats(3),3))],...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'VerticalAlignment','top')

%one year average, three year lag
nexttile
[a,~,~,~,stats] = regress(AnnualMeanBiomass.AllSpec(4:end),[annualGPP(1:end-3,:),ones(size(annualGPP(1:end-3,:)))]);

synX = (min(annualGPP):0.1:max(annualGPP))';
plot(annualGPP(1:end-3,:),AnnualMeanBiomass.AllSpec(4:end),'.b',synX,[synX ones(size(synX))]*a,'--b','MarkerSize',12);
xlabel('\bf Annual Mean GPP');
set(gca, 'YTickLabel', []);
ylim([3.5 6.5]);

text(0.02,0.95,['p=' num2str(round(stats(3),3))],...
    'Units','normalized',...
    'HorizontalAlignment','left',...
    'VerticalAlignment','top')

%% Figure 6
% Plotting results of linear models 
load("vars\dseasonUMBSWC.mat");

d = AnnualMeanGrowth(:,2:end) - dAnnualMeanGrowth(:,2:end);
d.year = (2000:1:2021)';

bands.d = nan(height(bands),1);

%creating intermediate column with diff between trending and detrended
%average growth

Spec = {'ACRU','ACSA','BEPA','FAGR','PIST','POGR','POTR','QURU'};
spec = {'acru','acsa','bepa','fagr','pist','pogr','potr','quru'};

for i=1:1:8
    sub = strcmp(bands.species_acronym,spec{i});
    tmp = join(bands(sub,:),d,'RightVariables', [i 12],'Keys', 'year');
    bands{sub,"d"} = tmp{:,Spec{i}};
end

bands.dAnnualGrowth = bands.annual_growth_calc_cm - bands.d;
bands3 = join(bands, dseasonUMBSWC, 'LeftKeys','year', 'RightKeys','Year');

lmTable = bands3(strcmp(bands3.species_acronym, 'pist'),["Growing","annual_growth_calc_cm"]);
mdl = fitglm(lmTable , 'Distribution','normal' );
pistC = mdl.Coefficients{"Growing","Estimate"};
pistI = mdl.Coefficients{"(Intercept)","Estimate"};

lmTable = bands3(strcmp(bands3.species_acronym, 'potr'),["Growing","annual_growth_calc_cm"]);
mdl = fitglm(lmTable , 'Distribution','normal' );
potrC = mdl.Coefficients{"Growing","Estimate"};
potrI = mdl.Coefficients{"(Intercept)","Estimate"};

lmTable = bands3(strcmp(bands3.species_acronym, 'pogr'),["Growing","annual_growth_calc_cm"]);
mdl = fitglm(lmTable , 'Distribution','normal' );
pogrC = mdl.Coefficients{"Growing","Estimate"};
pogrI = mdl.Coefficients{"(Intercept)","Estimate"};

lmTable = bands3(strcmp(bands3.species_acronym, 'quru'),["Growing","annual_growth_calc_cm"]);
mdl = fitglm(lmTable , 'Distribution','normal' );
quruC = mdl.Coefficients{"Growing","Estimate"};
quruI = mdl.Coefficients{"(Intercept)","Estimate"};


minX = min(dseasonUMBSWC.Growing);
maxX = max(dseasonUMBSWC.Growing);
x = (minX:0.25:maxX);
% acruY = (x*acruC+acruI)';
pistY = (x*pistC+pistI)';
potrY = (x*potrC+potrI)';

pogrY = (x*pogrC+pogrI)';
quruY = (x*quruC+quruI)';

figure(6000)

hold on

colors = [ ...
    31 120 180;   % blue  - ACRU
    51 160  44;   % PIST
    152  78 163; %pogr
    227  26  28; %quru
    196 161 201]/255;  %POTR

% PIST
scatter(dseasonUMBSWC.Growing, AnnualMeanGrowth.PIST, ...
    30, colors(2,:), 'filled', ...
    'MarkerFaceAlpha',0.5,'HandleVisibility','off')
plot(x, pistY, ...
    'Color', colors(2,:), ...
    'LineWidth',2.5)

% POtR
scatter(dseasonUMBSWC.Growing, AnnualMeanGrowth.POTR, ...
    30, colors(5,:), 'filled', ...
    'MarkerFaceAlpha',0.5,'HandleVisibility','off')
plot(x, potrY,    'Color', colors(5,:), ...
    'LineWidth',2.5);

% POgR
scatter(dseasonUMBSWC.Growing, AnnualMeanGrowth.POGR, ...
    30, colors(3,:), 'filled', ...
    'MarkerFaceAlpha',0.5,'HandleVisibility','off')
plot(x, pogrY, ...
    'Color', colors(3,:), ...
    'LineWidth',2.5)

scatter(dseasonUMBSWC.Growing, AnnualMeanGrowth.QURU, ...
    30, colors(4,:), 'filled', ...
    'MarkerFaceAlpha',0.5,'HandleVisibility','off')
plot(x, quruY, ...
    'Color', colors(4,:), ...
    'LineWidth',2.5)

% Labels and legend
xlabel('Detrended Growing Season SWC')
ylabel('Annual Mean Diameter Growth (cm)')

legend({'PIST','POTR','POGR','QURU'}, ...
        'Location','best', ...
        'Box','off')

% Publication styling
set(gca, ...
    'FontSize',12, ...
    'LineWidth',1.2, ...
    'Box','off')

set(gcf,'Color','w')
grid on

end

