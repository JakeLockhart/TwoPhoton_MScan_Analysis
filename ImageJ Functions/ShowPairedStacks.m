function ShowPairedStacks(Stack1, Stack2)
    % <Documentation>
        % ShowPairedStacks()
        %   Displays two paired image stacks side-by-side in a synchronized viewer with a frame slider.
        %   Created by: jsl5865
        % 
        % Syntax:
        %   ShowPairedStacks(Stack1, Stack2)
        %
        % Description:
        %   This function creates an interactive UI to display two paired image stacks (i.e. for a recording
        %       that images in both the green and red channel, the images are synchronized) to view the results.
        %   A slider is used to dynamically control the frame displayed from the image stacks. Note that the 
        %       stacks must have the same number of frames.
        %   In the future, I would like to add onto this function a few things:
        %       1) Contrast control of individual image pairs (clim()). Note that clim() only accepts grayscale
        %          image stacks (3D), not RGB stacks (4D). 
        %       2) Add buttons to convert between RGB and Grayscale for the purpose of controlling the contrast
        %          of the image stacks and actually displaying the images.
        %       3) Have a slider control the clim() of each image stack.
        %
        % Input:
        %   Stack1 - A numerical 3D array representing the first image stack, with dimensions
        %            Rows x Columns x Frames.
        %   Stack2 - A numerical 3D array representing the second image stack, with dimensions
        %            Rows x Columns x Frames. Must have the same number of frames as Stack1.
        %
        % Output:
        %   None - This function generates an interactive UI display but does not return a value.
        %
    % <End Documentation>


    %% Validate stacks 
        if ~isequal(size(Stack1, 3), size(Stack2, 3))
            error('Stacks have a different number of total frames.')
        else
            TotalFrames = size(Stack1, 3);
            Frame = 1;
        end

    %% Create UI figure
        %% Define UI layout        
            Window = uifigure('Name', 'Displaying paired imaging channel');
            MainLayout = uigridlayout(Window, [2,1]);
            MainLayout.RowHeight = {'1x', 50};
            MainLayout.ColumnWidth = {'1x'};

        %% Paired image stack panel
            ImagePanel = uipanel(MainLayout);
            ImagePanel.Layout.Row = 1;

            Tiles = tiledlayout(ImagePanel, 'flow');
            Tiles.Padding = "compact";
            Tiles.TileSpacing = "compact";
            Tiles.Units = 'normalized';
            Tiles.Position = [0, 0, 1, 1];

            ax1 = nexttile(Tiles);
            ImageStack1 = imshow(Stack1(:,:,Frame), [], 'Parent', ax1);
            ax2 = nexttile(Tiles);
            ImageStack2 = imshow(Stack2(:,:,Frame), [], 'Parent', ax2);

        %% Control: Slider
            SliderBar = uislider(MainLayout, ...
                                 'Limits', [1, TotalFrames], ...
                                 'Value', Frame, ...
                                 'ValueChangingFcn', @(src, event) UpdateFrame(round(event.Value)) ...
                                );
            SliderBar.Layout.Row = 2;

    %% Helper functions
        function UpdateFrame(Frame)
            ImageStack1.CData = Stack1(:,:,Frame);
            ImageStack2.CData = Stack2(:,:,Frame);
        end

end