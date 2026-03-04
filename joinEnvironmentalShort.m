%creating 3-month period JMP file
function out = joinEnvironmentalShort(in)

load("vars\UMBSWC.mat");
load("vars\UMBPAR.mat");
load("vars\UMBVPD.mat");
load("vars\UMBTA.mat");
load("vars\UMBSPI.mat");


labels = {'year', 'DJF', 'MAM', 'JJA', 'SON'};
labels = strcat('PAR_', labels, '_L0');
UMBPAR.Properties.VariableNames = labels;

labels = {'year', 'DJF', 'MAM', 'JJA', 'SON'};
labels = strcat('SWC_', labels, '_L0');
UMBSWC.Properties.VariableNames = labels;

labels = {'year', 'DJF', 'MAM', 'JJA', 'SON'};
labels = strcat('VPD_', labels, '_L0');
UMBVPD.Properties.VariableNames = labels;

labels = {'year', 'DJF', 'MAM', 'JJA', 'SON'};
labels = strcat('TA_', labels, '_L0');
UMBTA.Properties.VariableNames = labels;

labels = {'year', 'DJF', 'MAM', 'JJA', 'SON'};
labels = strcat('SPI_', labels, '_L0');
UMBSPI.Properties.VariableNames = labels;

all_vars = [UMBSWC UMBVPD UMBPAR UMBTA UMBSPI];

varsToRemove = {'SWC_year_L0','VPD_year_L0','PAR_year_L0','TA_year_L0', 'SPI_year_L0'};
all_vars = removevars(all_vars, varsToRemove);

L1 = all_vars;
L1(1,:) = [];
L1(end+1,:) = {nan};

labels = L1.Properties.VariableNames;
labels = erase(labels,'_L0');
labels = strcat (labels, '_L1');
L1.Properties.VariableNames = labels;

L2 = all_vars;
L2(1:2,:) = [];
L2(end+1:end+2,:) = {nan};

labels = L2.Properties.VariableNames;
labels = erase(labels,'_L0');

labels = strcat (labels, '_L2');
L2.Properties.VariableNames = labels;

L3 = all_vars;
L3(1:3,:) = [];
L3(end+1:end+3,:) = {nan};

labels = L3.Properties.VariableNames;
labels = erase(labels,'_L0');

labels = strcat (labels, '_L3');
L3.Properties.VariableNames = labels;

allvarsalllags = [all_vars, L1, L2, L3];
allvarsalllags.year = (2000:1:2021)';


out = join(in, allvarsalllags);

end



















