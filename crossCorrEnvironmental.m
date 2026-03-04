%cross correlations of environmental vars
function crossCorrEnvironmental(fileID) 

load('vars\UMBSWC.mat');
load('vars\UMBPAR.mat');
load('vars\UMBTA.mat');
load('vars\UMBVPD.mat');
load('vars\UMBSPI.mat');

vars= {'SWC','VPD','PAR','TA','SPI'};

figure(gcf().Number+1);
t= tiledlayout(2,2);
t.Padding = 'compact';

map = [235, 67, 45
       255, 255, 255;
        65, 11, 189]/255;

cmap = interp1([0 .5 1],[1 0 0; 1 1 1; 0 0 1],linspace(0,1,10));
range = colormap(cmap);

DJF = [UMBSWC.DJF UMBVPD.DJF UMBPAR.DJF UMBTA.DJF UMBSPI.SPI_DJF];
DJF = DJF(3:end,:);
[R,p] = corrcoef(DJF);
R(p>0.05) = 0;
sgn = sign(R);
R = tril(R,-1);

R = R.^2;
R(R==0)=nan;
[rowIdx, colIdx] = find(~isnan(R));
for i=1:length(rowIdx)
fprintf(fileID, 'DJF %s is cross correlated w/ %s: R=%d, p=%d \n', vars{rowIdx(i)}, vars{colIdx(i)}, R(rowIdx(i),colIdx(i)),p(rowIdx(i),colIdx(i)));
end

nexttile;
h = heatmap(R.*sgn);
h.MissingDataColor = [1,1,1];
h.Colormap = range;
h.ColorLimits = [-1 1];
title('DJF');
%h.XDisplayLabels = repmat("",size(R,2),1);
h.XDisplayLabels = {'SWC','VPD','PAR','TA','SPI'};
h.YDisplayLabels = {'SWC','VPD','PAR','TA','SPI'};

MAM = [UMBSWC.DJF UMBVPD.MAM UMBPAR.MAM UMBTA.MAM UMBSPI.SPI_MAM];
MAM = MAM(3:end,:);
[R,p] = corrcoef(MAM);
R(p>0.05) = 0;
R = tril(R,-1);
sgn = sign(R);
R = R.^2;
R(R==0)=nan;
[rowIdx, colIdx] = find(~isnan(R));
for i=1:length(rowIdx)
    fprintf(fileID, 'MAM %s is cross correlated w/ %s: R=%d, p=%d \n', vars{rowIdx(i)}, vars{colIdx(i)}, R(rowIdx(i),colIdx(i)),p(rowIdx(i),colIdx(i)));
end

nexttile;
h = heatmap(R.*sgn);
h.MissingDataColor = [1,1,1];
h.Colormap = range;
h.ColorLimits = [-1 1];
title('MAM');
%h.XDisplayLabels = repmat("",size(R,2),1);
%h.YDisplayLabels = repmat("",size(R,2),1);
h.XDisplayLabels = {'SWC','VPD','PAR','TA','SPI'};
h.YDisplayLabels = {'SWC','VPD','PAR','TA','SPI'};



JJA = [UMBSWC.DJF UMBVPD.JJA UMBPAR.JJA UMBTA.JJA UMBSPI.SPI_JJA];
JJA = JJA(3:end,:);
[R,p] = corrcoef(JJA);
R(p>0.05) = 0;
R = tril(R,-1);
sgn = sign(R);
R = R.^2;
R(R==0)=nan;
[rowIdx, colIdx] = find(~isnan(R));
for i=1:length(rowIdx)
    fprintf(fileID, 'JJA %s is cross correlated w/ %s: R=%d, p=%d \n', vars{rowIdx(i)}, vars{colIdx(i)}, R(rowIdx(i),colIdx(i)),p(rowIdx(i),colIdx(i)));
end

nexttile;
h = heatmap(R.*sgn);
h.MissingDataColor = [1,1,1];
h.Colormap = range;
h.ColorLimits = [-1 1];
title('JJA');
h.YDisplayLabels = {'SWC','VPD','PAR','TA','SPI'};
h.XDisplayLabels = {'SWC','VPD','PAR','TA','SPI'};


SON = [UMBSWC.DJF UMBVPD.SON UMBPAR.SON UMBTA.SON UMBSPI.SPI_SON];
SON = SON(3:end,:);
[R,p] = corrcoef(SON);
R(p>0.05) = 0;
R = tril(R,-1);
sgn = sign(R);
R = R.^2;
R(R==0)=nan;
[rowIdx, colIdx] = find(~isnan(R));
for i=1:length(rowIdx)
fprintf(fileID, 'SON %s is cross correlated w/ %s: R=%d, p=%d \n', vars{rowIdx(i)}, vars{colIdx(i)}, R(rowIdx(i),colIdx(i)),p(rowIdx(i),colIdx(i)));
end

nexttile;
h = heatmap(R.*sgn);
h.MissingDataColor = [1,1,1];
h.Colormap = range;
h.ColorLimits = [-1 1];
title('SON');
h.XDisplayLabels = {'SWC','VPD','PAR','TA','SPI'};
%h.YDisplayLabels = repmat("",size(R,2),1);
h.YDisplayLabels = {'SWC','VPD','PAR','TA','SPI'};

end
