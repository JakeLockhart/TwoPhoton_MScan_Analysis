%% Original script from the VesselDiameterAnalysis_FWHM.m Pipeline
    % TimeAxis = (0:size(FWHM, 1) - 1) / FPS;


    % figure
    % t = tiledlayout(length(ROIs), 1, "TileSpacing", "compact");
    % PixelNeighborhood = 10;

    % for i = 1:length(ROIs)
    %     nexttile
    %     NormalizedFWHM(:,i) = (FWHM(:,i) - mean(FWHM(:,i)))/mean(FWHM(:,i));
    %     FilteredFWHM(:,i) = medfilt1(NormalizedFWHM(:,i), PixelNeighborhood);

    %     [Peaks, Locations, Widths, Prominence] = findpeaks(FilteredFWHM(:,i), TimeAxis, "MinPeakProminence", 0.2, "WidthReference", "halfheight");
    %     for j = 1:length(Peaks)
    %         LeftEdge = Locations(j) - Widths(j)/2;
    %         RightEdge = Locations(j) + Widths(j)/2;

    %         [~, Index1] = min(abs(TimeAxis - LeftEdge));
    %         [~, Index2] = min(abs(TimeAxis - RightEdge));

    %         Index1 = max(1, Index1);
    %         Index2 = min(length(TimeAxis), Index2);

    %         hold on
    %         plot(TimeAxis, NormalizedFWHM(:,i), "Color", [0.7, 0.7, 0.7], "DisplayName", "Normalized Raw Data (ΔD/D̄)");
    %         plot(TimeAxis, FilteredFWHM(:,i), "Color", "b", "LineWidth", 1, "DisplayName", sprintf("Median Filtered %g", PixelNeighborhood));
    %         plot(Locations, Peaks, 'rv', 'MarkerFaceColor', 'r', "DisplayName", "Peak Dilations")


    %     end
    %     [CorrelationCoefficient{i,j}, Lag{i,j}] = CrossCorrelation(ROIs{1}, ROIs{i}, [Index1, Index2]);
    % end

%%
% Preprocessing
figure
numROIs = length(ROIs);
t = tiledlayout(numROIs, 1, "TileSpacing", "compact");
PixelNeighborhood = 20;

% Store peaks and locations for each ROI
AllPeaks = cell(1, numROIs);
AllLocations = cell(1, numROIs);
FilteredFWHM = zeros(length(TimeAxis), numROIs);
NormalizedFWHM = zeros(length(TimeAxis), numROIs);

for i = 1:numROIs
    nexttile
    NormalizedFWHM(:,i) = (FWHM(:,i) - mean(FWHM(:,i))) / mean(FWHM(:,i));
    MeanFWHM(:,i) = mean(FWHM(:,i));
    Sigma(:,i) = std(FWHM(:,i));
    NormalizedFWHM_Z(:,i) = (FWHM(:,i) - MeanFWHM(:,i)) / Sigma(:,i);
    FilteredFWHM_Z(:,i) = medfilt1(NormalizedFWHM_Z(:,i), PixelNeighborhood);

    FilteredFWHM(:,i) = medfilt1(NormalizedFWHM(:,i), PixelNeighborhood);
    [Peaks, Locations, Widths, Prominence] = findpeaks(FilteredFWHM(:,i), TimeAxis, "MinPeakProminence", 0.2, "WidthReference", "halfheight");
    AllPeaks{i} = Peaks;
    AllLocations{i} = Locations;
    hold on
    plot(TimeAxis, NormalizedFWHM(:,i), "Color", [0.7, 0.7, 0.7], "DisplayName", "Normalized Raw Data (ΔD/D̄)");
    plot(TimeAxis, FilteredFWHM(:,i), "Color", "b", "LineWidth", 1, "DisplayName", sprintf("Median Filtered %g", PixelNeighborhood));
    % Only plot red triangles and magenta FWHM lines at common peaks
    for k = 1:length(commonLocs)
        % Find the closest peak in this ROI to the common peak
        [minDist, idxPeak] = min(abs(AllLocations{i} - commonLocs(k)));
        if minDist <= window && ~isempty(idxPeak) && idxPeak > 0
            % Get peak and width
            peakLoc = AllLocations{i}(idxPeak);
            peakVal = AllPeaks{i}(idxPeak);
            % Find width for this peak
            [~, ~, widths, ~] = findpeaks(FilteredFWHM(:,i), TimeAxis, "MinPeakProminence", 0.2, "WidthReference", "halfheight");
            if idxPeak <= length(widths) && ~isempty(widths)
                width = widths(idxPeak);
                LeftEdge = peakLoc - width/2;
                RightEdge = peakLoc + width/2;
                FWHMheight = peakVal/2;
                % Plot magenta dotted line at FWHM height
                plot([LeftEdge, RightEdge], [FWHMheight, FWHMheight], 'Color', [1 0 1], 'LineWidth', 2, 'DisplayName', 'FWHM');
                % Plot red triangle at peak
                plot(peakLoc, peakVal, 'rv', 'MarkerFaceColor', 'r', "DisplayName", "Common Peak");
                % Plot vertical black line at common peak
                xline(commonLocs(k), '--k', 'LineWidth', 1.5, 'DisplayName', 'Common Peak');
            end
        end
    end
    tileIdx = tileIdx + 1;
end
xlabel('Time (s)');
ylabel('Normalized/Filtered FWHM');
title(t, 'Filtered FWHM with Common Peaks');

% Track the left and right endpoints of the FWHM for each common peak across all ROIs
LeftEdges = zeros(length(commonLocs), 1);
RightEdges = zeros(length(commonLocs), 1);

for k = 1:length(commonLocs)
    lefts = zeros(numROIs, 1);
    rights = zeros(numROIs, 1);
    for i = 1:numROIs
        [minDist, idxPeak] = min(abs(AllLocations{i} - commonLocs(k)));
        if minDist <= window && ~isempty(idxPeak) && idxPeak > 0
            [~, ~, widths, ~] = findpeaks(FilteredFWHM(:,i), TimeAxis, "MinPeakProminence", 0.2, "WidthReference", "halfheight");
            if idxPeak <= length(widths) && ~isempty(widths)
                peakLoc = AllLocations{i}(idxPeak);
                width = widths(idxPeak);
                lefts(i) = peakLoc - width/2;
                rights(i) = peakLoc + width/2;
            else
                lefts(i) = NaN;
                rights(i) = NaN;
            end
        else
            lefts(i) = NaN;
            rights(i) = NaN;
        end
    end
    % Remove NaNs for min/max
    LeftEdges(k) = min(lefts(~isnan(lefts)));
    RightEdges(k) = max(rights(~isnan(rights)));
end

% Plot as before, but only plot the magenta FWHM lines once per peak (not per ROI)
tileIdx = 1;
for i = 1:numROIs
    nexttile(tileIdx)
    hold on
    plot(TimeAxis, NormalizedFWHM(:,i), "Color", [0.7, 0.7, 0.7], "DisplayName", "Normalized Raw Data (ΔD/D̄)");
    plot(TimeAxis, FilteredFWHM(:,i), "Color", "b", "LineWidth", 1, "DisplayName", sprintf("Median Filtered %g", PixelNeighborhood));
    for k = 1:length(commonLocs)
        [minDist, idxPeak] = min(abs(AllLocations{i} - commonLocs(k)));
        if minDist <= window && ~isempty(idxPeak) && idxPeak > 0
            peakLoc = AllLocations{i}(idxPeak);
            peakVal = AllPeaks{i}(idxPeak);
            FWHMheight = peakVal/2;
            % Only plot the magenta FWHM line on the first ROI tile
            if i == 1
                plot([LeftEdges(k), RightEdges(k)], [FWHMheight, FWHMheight], ':', 'Color', [1 0 1], 'LineWidth', 2, 'DisplayName', 'FWHM');
            end
            plot(peakLoc, peakVal, 'rv', 'MarkerFaceColor', 'r', "DisplayName", "Common Peak");
            xline(commonLocs(k), '--k', 'LineWidth', 1.5, 'DisplayName', 'Common Peak');
        end
    end
    tileIdx = tileIdx + 1;
end
xlabel('Time (s)');
ylabel('Normalized/Filtered FWHM');
title(t, 'Filtered FWHM with Common Peaks');

% Return the left and right endpoints for each common peak
LeftEdges
RightEdges

% Cross-correlation for each common peak
for k = 1:length(commonLocs)
    % Define the range for this peak (convert LeftEdges/RightEdges to indices)
    [~, leftIdx] = min(abs(TimeAxis - LeftEdges(k)));
    [~, rightIdx] = min(abs(TimeAxis - RightEdges(k)));
    range = [leftIdx, rightIdx];
    
    figure('Name', sprintf('Cross-correlation for Peak %d', k));
    hold on;
    colors = lines(numROIs);
    legends = cell(1, numROIs);
    for i = 1:numROIs
        [corrCoeff, lag] = CrossCorrelation(FilteredFWHM(:,1), FilteredFWHM(:,i), range);
        plot(lag, corrCoeff, 'LineWidth', 1.5, 'Color', colors(i,:));
        legends{i} = sprintf('ROI1 vs ROI%d', i);
    end
    xlabel('Lag (frames)');
    ylabel('Correlation Coefficient');
    title(sprintf('Cross-correlation: Peak %d (%.2f-%.2f s)', k, LeftEdges(k), RightEdges(k)));
    legend(legends, 'Location', 'best');
    xlim([-10,10])
    ylim([0.9,1])
    grid on;
    hold off;
end