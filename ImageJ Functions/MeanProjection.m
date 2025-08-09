function ax = MeanProjection(Stack)
    % Show mean projection of image stack and return axes handle
    figure('Name', 'Draw ROI(s)')
    imagesc(mean(Stack, 3));

    axis image;
    colormap gray;
    xlabel('Pixels');
    ylabel('Pixels');
    title('Press Enter When Done');
    
    ax = gca;
end
