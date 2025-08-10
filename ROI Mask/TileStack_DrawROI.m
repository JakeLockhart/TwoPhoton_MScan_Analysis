function ROIs = TileStack_DrawROI(Stack)
    % <Documentation>
        % TileStack_DrawROI()
        %   Interactive interface for drawing multiple ROI shapes on mean projections of one or more image stacks.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ROIs = TileStack_DrawROI(Stack)
        %
        % Description:
        %   This function displays mean projections of multiple image stacks within a tiledlayout() with the 
        %       goal of allowing users to define various ROIs within a single image stack and see other 
        %       stacks simultaneously.
        %   To use this function, choose an ROI shape from the dropdown menu, and click on one of the tiles
        %       containing an image stack. Once both are selected click 'Draw ROI' to create the ROI on that
        %       image. An error will appear if a tile was not selected. Once finished drawing ROIs, click the
        %       'Done' button to save the ROI object information.
        %   Note that the input to this function requires image stacks to be contained within a single cell.
        %       This function can be used for a single image stack or multiple image stacks. If stacks are
        %       contained within a structure, use struct2cell(ImageStacks) as an input. If only a single
        %       image stack is being used, simply have {ImageStack} as an input.
        %   This function displays image stacks as mean projects only.
        %   Multiple ROI shapes are supported and can be selected through the dropdown menu. Note that if
        %       a new ROI shape is created, both this function's ROI_Shape_List and @DrawROI ROI_Shape must
        %       be updated to include the new ROI shape.
        %   
        % Input:
        %   Stack - A cell array representing an image stack, with dimensions Rows x Columns x Frames. 
        %
        % Output:
        %   ROIs  - Cell array of length equal to the number of image stack. Each cell contains a cell array
        %           of ROI structures drawn on the corresponding image stack (Shape, Position, Radius (if applicable))
    % <End Documentation>

    %% Initialization
        ROI_Shape_List = {'Rectangle', 'Circle', 'Line', 'Polygon', 'Freehand'};    % Define available ROI shapes
        TotalStacks = numel(Stack);                                                 % Define the total image stacks to analyze
        ROIs = cell(1, TotalStacks);                                                % Preallocate cell arrays for each ROIs within each image stack

    %% Create mean projection
        MeanStacks = cellfun(@(x) mean(x, 3), Stack, "UniformOutput", false);   % Average each image stack into a single frame

    %% Create UI figure
        %% Define UI layout
            Window = uifigure('Name', 'Tiled Mean Projections to Create ROIs'); % Create the UI figure window
            MainLayout = uigridlayout(Window, [2,1]);                           % Define two panels within the window (2 rows, 1 column)
            MainLayout.RowHeight = {'1x', 50};                                  % Define row height for each panel (first panel is dynamic height, second is fixed pixel height)
            MainLayout.ColumnWidth = {'1x'};                                    % Define column widteh for each panel (both panel widths dynamic)

        %% Mean image projection panel (tiledlayout())
            ImagePanel = uipanel(MainLayout);                                   % Create a panel for the tiled images to go into
            ImagePanel.Layout.Row = 1;                                          % Place the panel in the first panel of the main layout
            Tiles = tiledlayout(ImagePanel, 'flow');                            % Create a tiledlayout() with dynamic tile position
            Tiles.Padding = 'compact';                                          % Minimize spacing between tiles
            Tiles.TileSpacing = 'compact';                                      % Minimize spacing between tiles
            Tiles.Units = 'normalized';                                         % Maximimze tile size within panel
            Tiles.Position = [0, 0, 1, 1];                                      % Fill image within tile

            ax = gobjects(TotalStacks, 1);                                      % Create an (empty) array of graphic objects based on the number of image stacks 
            for i = 1:TotalStacks                                               % Loop through each stack to update the ax
                ax(i) = nexttile(Tiles);                                        % Create an ax for each tile
                DisplayImage = imshow(MeanStacks{i}, [], 'Parent', ax(i));      % Display the averaged image into the tile
                DisplayImage.ButtonDownFcn = @(src, ~) SetSelectedAx(ax(i));    % Create a callback function for user clicking on individual tiles
            end                                                                 % end
            
        %% Controls: ROI shape dropdown box, Draw, Done
            ControlPanel = uipanel(MainLayout);                                                                                     % Create a panel for the buttons/dropdown menu
            ControlPanel.Layout.Row = 2;                                                                                            % Place the panel in the second panel of the main layout
            ControlPanel_Grid = uigridlayout(ControlPanel, [1,3]);                                                                  % Create a grid to arrange each element within the panel (3 items within one row)
            ControlPanel_Grid.ColumnWidth = {'1x', 100, 100};                                                                       % Define width of each element (Dropdown menu is dynamic, buttons are static width)

            DropDown = uidropdown(ControlPanel_Grid, 'Items', ROI_Shape_List, 'Value', 'Rectangle', 'Tooltip', 'Select ROI shape'); % Create dropdown menu
            DropDown.Layout.Row = 1;                                                                                                % Define element position in panel
            DropDown.Layout.Column = 1;                                                                                             % Define element position in panel

            Draw = uibutton(ControlPanel_Grid, "Text", 'Draw ROI', 'ButtonPushedFcn', @Helper_DrawROI);                             % Create draw roi button
            Draw.Layout.Row = 1;                                                                                                    % Define element position in panel
            Draw.Layout.Column = 2;                                                                                                 % Define element position in panel

            Done = uibutton(ControlPanel_Grid, "Text", 'Done', 'ButtonPushedFcn', @(~,~) uiresume(Window));                         % Create done button (finished creating ROIs)
            Done.Layout.Row = 1;                                                                                                    % Define element position in panel
            Done.Layout.Column = 3;                                                                                                 % Define element position in panel

    %% Drawing logic
        SelectedAx = [];                                        % Clear selected tile
        for i = 1:TotalStacks                                   % Loop through each tile
            ax(i).ButtonDownFcn = @(src, ~) SetSelectedAx(src); % Identify the graphic object source for callback
        end                                                     % End

    %% Close figure when finished
        uiwait(Window); % Wait until the 'Done' button has been selected (uiresume(Window))
        close(Window);  % Close the figure window

    %% Helper functions
        function SetSelectedAx(src)
            SelectedAx = src;
        end

        function Helper_DrawROI(~,~)
            if isempty(SelectedAx)
                uialert(Window, 'Click on an image tile first to selecte it.', 'No Tile Selected')
                return;
            end

            Index = find(ax == SelectedAx, 1);
            if isempty(Index)
                return
            end

            ROI_ChosenShape = DropDown.Value;
            ROI_Object = DrawROI(SelectedAx, ROI_ChosenShape);

            ROI_Data.Shape = ROI_ChosenShape;
            ROI_Data.Position = ROI_Object.Position;
            if isprop(ROI_Object, 'Radius')
                ROI_Data.Radius = ROI_Object.Radius;
            end
            if isempty(ROIs{Index})
                ROIs{Index} = {ROI_Data};
            else
                ROIs{Index}{end+1} = ROI_Data;
            end
        end

end