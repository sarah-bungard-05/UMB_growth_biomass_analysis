%Detrend annual mean radial growth and biomass

function [dAnnualMeanGrowth, dAnnualMeanBiomass] = detrendGrowthBiomass(fileID, AnnualMeanGrowth, AnnualMeanBiomass)
    spec = {'acru','acsa','bepa','fagr','pist','pogr','potr','quru'};


    n=(1:1:22)';

    dAnnualMeanGrowth = AnnualMeanGrowth;
    dAnnualMeanBiomass = AnnualMeanBiomass;

    % fileID = fopen('AdditionalInfo.txt', 'w');

    fprintf(fileID, 'Start of Detrending \n');

    for i=1:1:9
        [a,~,~,~,stats] = regress(AnnualMeanGrowth{:,i+1},[ones(size(n)) n]);
        if stats(3)<=0.05
            fprintf(fileID, 'Species: %s growth is trending (coefficient:%d, R:%d p:%d) \n', spec{i}, a(2), stats(1), stats(3));
            dAnnualMeanGrowth{:,i+1} = detrend(AnnualMeanGrowth{:,i+1});
        end

        [a,~,~,~,stats] = regress(AnnualMeanBiomass{:,i+1},[ones(size(n)) n]);
        if stats(3)<=0.05
            fprintf(fileID, 'Species: %s biomass is trending (coefficient:%d, R:%d p:%d) \n', spec{i}, a(2), stats(1), stats(3));
            dAnnualMeanBiomass{:,i+1} = detrend(AnnualMeanBiomass{:,i+1});
        end
    end

    [a,~,~,~,stats] = regress(AnnualMeanGrowth{:,10},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID, 'All species growth is trending (coefficient:%d, R:%d p:%d) \n', a(2), stats(1), stats(3));
        dAnnualMeanGrowth{:,10} = detrend(AnnualMeanGrowth{:,10});
    end

    [a,~,~,~,stats] = regress(AnnualMeanBiomass{:,10},[ones(size(n)) n]);
    if stats(3)<=0.05
        fprintf(fileID, 'All species biomass is trending (coefficient:%d, R:%d p:%d) \n', a(2), stats(1), stats(3));
        dAnnualMeanBiomass{:,10} = detrend(AnnualMeanBiomass{:,10});
    end

    % [a,~,~,~,stats] = regress(AnnualMeanGrowth{:,11},[ones(size(n)) n]);
    % if stats(3)<=0.05
    %     fprintf(fileID, 'Iso species growth is trending (coefficient:%d, R:%d p:%d) \n', a(2), stats(1), stats(3));
    %     dAnnualMeanGrowth{:,11} = detrend(AnnualMeanGrowth{:,11});
    % end
    % 
    % [a,~,~,~,stats] = regress(AnnualMeanBiomass{:,11},[ones(size(n)) n]);
    % if stats(3)<=0.05
    %     fprintf(fileID, 'Iso species biomass is trending (coefficient:%d, R:%d p:%d) \n', a(2), stats(1), stats(3));
    %     dAnnualMeanBiomass{:,11} = detrend(AnnualMeanBiomass{:,11});
    % end
    % 
    % [a,~,~,~,stats] = regress(AnnualMeanGrowth{:,12},[ones(size(n)) n]);
    % if stats(3)<=0.05
    %     fprintf(fileID, 'Aniso species growth is trending (coefficient:%d, R:%d p:%d) \n', a(2), stats(1), stats(3));
    %     dAnnualMeanGrowth{:,12} = detrend(AnnualMeanGrowth{:,12});
    % end
    % 
    % [a,~,~,~,stats] = regress(AnnualMeanBiomass{:,12},[ones(size(n)) n]);
    % if stats(3)<=0.05
    %     fprintf(fileID, 'Aniso species biomass is trending (coefficient:%d, R:%d p:%d) \n', a(2), stats(1), stats(3));
    %     dAnnualMeanBiomass{:,12} = detrend(AnnualMeanBiomass{:,12});
    % end

    fprintf(fileID, '\n \n \n');
    % fclose(fileID);

end



