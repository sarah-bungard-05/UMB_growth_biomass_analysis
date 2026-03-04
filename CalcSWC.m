
%creating new soil average
function CombinedSWC = CalcSWC()
%read in fluxnet SWC_F_MDS_!

%read in SWC_2_1_1, SWC_3_1_1, SWC_4_1_1

%take weighted averages of SWC_2_1_1, 3, 4
%SWC_1_1_1 = 0cm to 30cm integrated
%SWC_1_2_1 = 5cm deep
%SWC_1_3_1 = 15cm deep
%SWC_1_4_1 = 30cm deep

fluxnetHR= readtable("C:\Users\sarah\Documents\BandDendrometer\AMF_US-UMB_BASE-BADM_15-5\FLX_US-UMB_FLUXNET2015_SUBSET_HR_2000-2014_1-4.csv");
fluxnetHH=readtable("C:\Users\sarah\Documents\BandDendrometer\AMF_US-UMB_BASE-BADM_15-5\AMF_US-UMB_FLUXNET_FULLSET_HH_2007-2021_3-5.csv");

TimeHR = datetime(num2str(fluxnetHR.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');
TimeHH = datetime(num2str(fluxnetHH.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');
DataDate = [TimeHR(year(TimeHR)<2007);TimeHH];

SWCHR = fluxnetHR.SWC_F_MDS_1(:);
SWCHH = fluxnetHH.SWC_F_MDS_1(:);
intSWC = [SWCHR(year(TimeHR)<2007);SWCHH];
intSWC(intSWC==-9999)=nan;

ptHR = readtable("C:\Users\sarah\Documents\BandDendrometer\Biomass_master rework\AF\Increment band master\Analysis\Current Process\AMF_US-UMB_BASE_HR_10-1.csv");
ptHH = readtable("C:\Users\sarah\Documents\BandDendrometer\Biomass_master rework\AF\Increment band master\Analysis\Current Process\AMF_US-UMB_BASE_HH_24-5.csv");

ptTimeHR = datetime(num2str(ptHR.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');
ptTimeHH = datetime(num2str(ptHH.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');

ptHR = ptHR(ptTimeHR==TimeHR,:);
ptHH = ptHH(ptTimeHH<=TimeHH(end) & ptTimeHH>=TimeHH(1), :);


SWC_5cm = [nan(size(ptHR.TIMESTAMP_START(year(TimeHR)<2007)));ptHH.SWC_1_2_1];
SWC_15cm = [nan(size(ptHR.TIMESTAMP_START(year(TimeHR)<2007)));ptHH.SWC_1_3_1];
SWC_30cm = [nan(size(ptHR.TIMESTAMP_START(year(TimeHR)<2007)));ptHH.SWC_1_4_1];

SWC_5cm(SWC_5cm==-9999)=nan;
SWC_15cm(SWC_15cm==-9999)=nan;
SWC_30cm(SWC_30cm==-9999)=nan;

avg  = SWC_5cm*(10/30) + SWC_15cm*(12.5/30) + SWC_30cm*(7.5/30);

CombinedSWC = mean([avg(:), intSWC(:)], 2, 'omitnan');

end