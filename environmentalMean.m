%Calculate and detrend 3-month, growing/dormant, and annual environmental
%means
function environmentalMean(fileID,CombinedSWC)

mkdir vars\
folder = 'vars';

%% creating files with averages
%Read data from US-UMB Ameriflux Network
%Download both hourly and half hourly FLUXNET data from US-UMB AmeriFlux tower and change paths
UMBHR= readtable("ADD PATH");
UMBHH=readtable("ADD PATH");

% Creating a matrix  of dates corresponding with AF data
TimeHR = datetime(num2str(UMBHR.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');
TimeHH = datetime(num2str(UMBHH.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');
DataDate = [TimeHR(year(TimeHR)<2007);TimeHH];

%Reassigning columns in larger AF matrix to variables, cleaning and
%initializing matrices to store averages

%UMB... = 3-month periods
%season... = growing/dormant seasons
PARHR = UMBHR.PPFD_IN(:);
PARHH = UMBHH.PPFD_IN(:); 
PAR = [PARHR(year(TimeHR)<2007);PARHH];
PAR(PAR==-9999)=nan;
UMBPAR = nan(22,5);
UMBPAR(:,1) = 2000:2021;
seasonUMBPAR = nan(22,3);
seasonUMBPAR(:,1) = 2000:2021;

TAHR = UMBHR.TA_F(:);
TAHH = UMBHH.TA_F(:); 
TA = [TAHR(year(TimeHR)<2007);TAHH];
TA(TA==-9999)=nan;
UMBTA = nan(22,5);
UMBTA(:,1) = 2000:2021;
seasonUMBTA = nan(22,3);
seasonUMBTA(:,1) = 2000:2021;

%soil data = average between int sensors and weighted avg of pt sensors
%generated in averagesoilmoisture.m
SWC = CombinedSWC;

UMBSWC = nan(22,5);
UMBSWC(:,1) = 2000:2021;
seasonUMBSWC = nan(22,3);
seasonUMBSWC(:,1) = 2000:2021;

VPDHR = UMBHR.VPD_F(:);
VPDHH = UMBHH.VPD_F(:);
VPD = [VPDHR(year(TimeHR)<2007);VPDHH];
VPD(VPD==-9999)=nan;
UMBVPD = nan(22,5);
UMBVPD(:,1) = 2000:2021;
seasonUMBVPD = nan(22,3);
seasonUMBVPD(:,1) = 2000:2021;

% Calculating and storing 3-month season and growing/dormant season
% averages
for y=2000:2021
    l=y-1999;

    %Growing/Dormant Seasons
    SQ=NaT(3,1);
    SQ(1) = datetime([y-1,11,1]);
    SQ(2) = datetime([y,4,1]);
    SQ(3) = datetime([y,11,1]);

    for q = 1:2
        seasonUMBTA(l,q+1)=mean(TA(DataDate>=SQ(q) & DataDate<SQ(q+1)), "omitmissing");
        seasonUMBPAR(l,q+1)=mean(PAR(DataDate>=SQ(q) & DataDate<SQ(q+1)), "omitmissing");
        seasonUMBSWC(l,q+1)=mean(SWC(DataDate>=SQ(q) & DataDate<SQ(q+1)), "omitmissing");
        seasonUMBVPD(l,q+1)=mean(VPD(DataDate>=SQ(q) & DataDate<SQ(q+1)), "omitmissing");
    end

    %column 1: start of prev november - end of march (dormant season)
    %column 2: start of april - end of october (growing season)

    %3-Month Seasons
    Q=NaT(5,1);
    Q(1) = datetime([y-1,12,1]);
    Q(2) = datetime([y,3,1]);
    Q(3) = datetime([y,6,1]);
    Q(4) = datetime([y,9,1]);
    Q(5) = datetime([y,12,1]);

    for q = 1:4
        UMBTA(l,q+1)=mean(TA(DataDate>=Q(q) & DataDate<Q(q+1)), "omitmissing");
        UMBPAR(l,q+1)=mean(PAR(DataDate>=Q(q) & DataDate<Q(q+1)), "omitmissing");
        UMBSWC(l,q+1)=mean(SWC(DataDate>=Q(q) & DataDate<Q(q+1)), "omitmissing");
        UMBVPD(l,q+1)=mean(VPD(DataDate>=Q(q) & DataDate<Q(q+1)), "omitmissing");
    end

    %column 2: avg of prev yr december -> current year february (DJF)
    %column 3: start of march- end of may (MAM)
    %column 4: start of june- end of august (JJA)
    %column 5: start of september- end of november (SON)
end

%Manually making dormant season measurements NaN for 2000 because lack
%of data from Nov-Dec 1999 creates inaccurate average
seasonUMBTA(1,2)=NaN;
seasonUMBPAR(1,2)=NaN;
seasonUMBSWC(1,2)=NaN;
seasonUMBVPD(1,2)=NaN;

%Manually making DJF season NaN for 2000 because lack of data from from Dec
%1999 creates inaccurate average
UMBPAR(1,2)=NaN;
UMBVPD(1,2)=NaN;
UMBTA(1,2)=NaN;

%Making JJA season NaN for 2001 of UMBSWC because SWC data started Jun 25,
%2001
UMBSWC(2,4)=NaN;
seasonUMBSWC(2,3)= NaN;

%transforming matrices into tables for cleanliness
UMBPAR = array2table(UMBPAR, 'VariableNames',{'Year','DJF','MAM','JJA','SON'});
UMBVPD = array2table(UMBVPD, 'VariableNames',{'Year','DJF','MAM','JJA','SON'});
UMBSWC = array2table(UMBSWC, 'VariableNames',{'Year','DJF','MAM','JJA','SON'});
UMBTA = array2table(UMBTA, 'VariableNames',{'Year','DJF','MAM','JJA','SON'});

seasonUMBPAR = array2table(seasonUMBPAR, 'VariableNames',{'Year','Dormant','Growing'});
seasonUMBVPD = array2table(seasonUMBVPD, 'VariableNames',{'Year','Dormant','Growing'});
seasonUMBSWC = array2table(seasonUMBSWC, 'VariableNames',{'Year','Dormant','Growing'});
seasonUMBTA = array2table(seasonUMBTA, 'VariableNames',{'Year','Dormant','Growing'});

save(fullfile(folder,'UMBPAR.mat'), 'UMBPAR');
save(fullfile(folder,'UMBVPD.mat'),'UMBVPD');
save(fullfile(folder,'UMBSWC.mat'),'UMBSWC');
save(fullfile(folder,'UMBTA.mat'),'UMBTA');


save(fullfile(folder,'seasonUMBPAR.mat'),'seasonUMBPAR');
save(fullfile(folder,'seasonUMBVPD.mat'),'seasonUMBVPD');
save(fullfile(folder,'seasonUMBSWC.mat'),'seasonUMBSWC');
save(fullfile(folder,'seasonUMBTA.mat'),'seasonUMBTA');

DI = readtable(fullfile(folder,'DI_Input.csv'));

DI.month = month(DI.date);

djfDI = DI(DI.month==2,:);
mamDI = DI(DI.month==5,:);
jjaDI = DI(DI.month==8,:);
sonDI = DI(DI.month==11,:);

djfDI.year = year(djfDI.date);

shortDI = table( ...
    djfDI.year, ...
    djfDI.spi3(:), djfDI.spei3(:), ...
    mamDI.spi3(:), mamDI.spei3(:), ...
    jjaDI.spi3(:), jjaDI.spei3(:), ...
    sonDI.spi3(:), sonDI.spei3(:), ...
    'VariableNames', { ...
        'Year', ...
        'SPI_DJF','SPEI_DJF', ...
        'SPI_MAM','SPEI_MAM', ...
        'SPI_JJA','SPEI_JJA', ...
        'SPI_SON','SPEI_SON'
    });

UMBSPI = table(shortDI.Year, shortDI.SPI_DJF, shortDI.SPI_MAM, shortDI.SPI_JJA, shortDI.SPI_SON, ...
    'VariableNames',{'Year','SPI_DJF','SPI_MAM','SPI_JJA','SPI_SON'});
UMBSPEI = table(shortDI.Year, shortDI.SPEI_DJF, shortDI.SPEI_MAM, shortDI.SPEI_JJA, shortDI.SPEI_SON, ...
    'VariableNames',{'Year','SPEI_DJF','SPEI_MAM','SPEI_JJA','SPEI_SON'});

save(fullfile(folder,'UMBSPI.mat'),'UMBSPI');
save(fullfile(folder,'UMBSPEI.mat'),'UMBSPEI');

%% detrending environmental factors
n=(1:1:22)';

dUMBPAR = UMBPAR;
dUMBVPD = UMBVPD;
dUMBSWC = UMBSWC;
dUMBTA = UMBTA;
dUMBSPI = UMBSPI;
dUMBSPEI = UMBSPEI;

seasons = {'DJF','MAM','JJA','SON'};


for i=2:1:5
    [a,~,~,~,stats] = regress(UMBPAR{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s PAR is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dUMBPAR{:,i} = detrend(UMBPAR{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(UMBVPD{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s VPD is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dUMBVPD{:,i} = detrend(UMBVPD{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(UMBSWC{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s SWC is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dUMBSWC{:,i} = detrend(UMBSWC{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(UMBTA{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s TA is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dUMBTA{:,i} = detrend(UMBTA{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(UMBSPI{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s SPI is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dUMBSPI{:,i} = detrend(UMBSPI{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(UMBSPEI{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s SPEI is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dUMBSPEI{:,i} = detrend(UMBSPEI{:,i}, 'omitmissing');
    end
end

save(fullfile(folder,'dUMBPAR.mat'), 'dUMBPAR');
save(fullfile(folder,'dUMBVPD.mat'),'dUMBVPD');
save(fullfile(folder,'dUMBSWC.mat'),'dUMBSWC');
save(fullfile(folder,'dUMBTA.mat'),'dUMBTA');
save(fullfile(folder,'dUMBSPI.mat'), 'dUMBSPI');
save(fullfile(folder,'dUMBSPEI.mat'),'dUMBSPEI');

%% - season environmental detrending
DI.month = month(DI.date);

dDI = DI(DI.month==2,:);
gDI = DI(DI.month==8,:);

dDI.year = year(dDI.date);

shortDI = table( ...
    dDI.year, ...
    dDI.spi6(:), dDI.spei6(:), ...
    gDI.spi6(:), gDI.spei6(:), ...
    'VariableNames', { ...
        'Year', ...
        'SPI_D','SPEI_D', ...
        'SPI_G','SPEI_G', ...
    });

seasonUMBSPI = table(shortDI.Year, shortDI.SPI_D, shortDI.SPI_G, ...
    'VariableNames',{'Year','SPI_D','SPI_G'});
seasonUMBSPEI = table(shortDI.Year, shortDI.SPEI_D, shortDI.SPEI_G, ...
    'VariableNames',{'Year','SPEI_D','SPEI_G'});

save(fullfile(folder,'seasonUMBSPI.mat'), 'seasonUMBSPI');
save(fullfile(folder,'seasonUMBSPEI.mat'),'seasonUMBSPEI');

dseasonUMBPAR = seasonUMBPAR;
dseasonUMBVPD = seasonUMBVPD;
dseasonUMBSWC = seasonUMBSWC;
dseasonUMBTA = seasonUMBTA;
dseasonUMBSPI = seasonUMBSPI;
dseasonUMBSPEI = seasonUMBSPEI;

seasons = {'Dormant','Growing'};
for i=2:1:3
    [a,~,~,~,stats] = regress(seasonUMBPAR{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s PAR is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dseasonUMBPAR{:,i} = detrend(seasonUMBPAR{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(seasonUMBVPD{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s VPD is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dseasonUMBVPD{:,i} = detrend(seasonUMBVPD{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(seasonUMBSWC{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s SWC is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dseasonUMBSWC{:,i} = detrend(seasonUMBSWC{:,i}, 'omitmissing');
    end

    save(fullfile(folder, 'dseasonUMBSWC.mat'),'dseasonUMBSWC');

    [a,~,~,~,stats] = regress(seasonUMBTA{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s TA is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dseasonUMBTA{:,i} = detrend(seasonUMBTA{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(seasonUMBSPI{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s SPI is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dseasonUMBSPI{:,i} = detrend(seasonUMBSPI{:,i}, 'omitmissing');
    end

    [a,~,~,~,stats] = regress(seasonUMBSPEI{:,i},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID,'%s SPEI is trending (coeff: %d, R: %d, p: %d) \n', seasons{i-1}, a(2), stats(1), stats(3));
        dseasonUMBSPEI{:,i} = detrend(seasonUMBSPEI{:,i}, 'omitmissing');
    end
end

%% Calculating annual means where needed

GPPHR = UMBHR.GPP_NT_VUT_REF(:);
GPPHH = UMBHH.GPP_NT_VUT_REF(:);
GPP = [GPPHR(year(TimeHR)<2007);GPPHH];
GPP(GPP==-9999)=nan;

annualGPP = nan(22,1);

for y=2000:1:2021
    i = y-1999;
    annualGPP(i) = (mean(GPP(isbetween(DataDate, datetime(y,1,1), datetime(y,12,31))))*60*60*24*365.25)/1000000;

end

save(fullfile(folder,'annualGPP.mat'), 'annualGPP');
end



