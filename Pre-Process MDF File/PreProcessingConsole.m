function ProcessingParameters = PreProcessingConsole(Stack)
    % <Documentation>
        % PreProcessingConsole()
        %   An interactive pre-processing console for an image stack. Allows for dynamic paramameter definitions.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ProcessingParameters = PreProcessingConsole(Stack)
        %
        % Description:
        %   This function creates a UI figure to visualize and adjust user-defined parameters of an input image
        %       stack. To control the displayed frame both the slider bar below the image and the left/right 
        %       arrow keys can be used. Parameters are dynamically controlled via input fields under the control
        %       panel. 
        %   Parameters are managed via the 'Cancel,' 'Reset,' and 'Confirm' buttons at the bottom of the control
        %       panel. The buttons perform the following actions:
        %           -'Cancel' does not save any parameters and closes the window.
        %           -'Reset' returns all parameters to their default values.
        %           -'Confirm' saves all parameters to structure and closes the window.   
        %   Large image stacks may experience slower performance when updating parameters such as the pixel shift.
        %   
        % Input:
        %   Stack - A numerical 3D array representing an image stack, with dimensions Rows x Columns x Frames. 
        %
        % Output:
        %   ProcessingParameters - A structure containing the user defined image stack parameters.
        %                           - FramesToDelete
        %                               - Indicies of beginning and ending frames to be deleted
        %                           - InterleavedChannels
        %                               - The number of interleaved channels within the image stack
        %                           - PixelShiftValue
        %                               - Applys a pixel shift along the x-axis of the image stack
        %                           - ApplyMotionCorrection
        %                               - Flag to apply motion correction during pre-processing
        %                           - Contrast
        %                               - Adjust the colormap minimum and maximum limits for pixel intensity
        %
    % <End Documentation>

    %% Initialization
        [~,~,TotalFrames] = size(Stack); 
        Frame = 1;
        UI_Shift = 0;
        UI_Channels = 1;
        MinIntensity = 0;
        MaxIntensity = 65535;

        ScreenSize = get(0, 'ScreenSize');
        WindowSize = [900, 600];
        LeftEdge = (ScreenSize(3) - WindowSize(1)) / 2;
        BottomEdge = (ScreenSize(4) - WindowSize(2)) / 2;

        FontSize = 14;

    %% Create UI figure
        %% Define UI layout
            Window = uifigure('Name', 'Pre-Processing Console for Imaging File', 'Position', [LeftEdge, BottomEdge, WindowSize]);
            Window.WindowKeyPressFcn = @KeyPressHandler;
            MainLayout = uigridlayout(Window, [1,2]);
            MainLayout.RowHeight = {'1x'};
            MainLayout.ColumnWidth = {'1x', 'fit'};

        %% Display raw image file
            ImagePanel = uipanel(MainLayout, "Title", 'Raw Image Stack Display');
            ImagePanel.Layout.Row = 1;
            ImagePanel.Layout.Column = 1;

            ImagePanelLayout = uigridlayout(ImagePanel, [3,1]);
            ImagePanelLayout.RowHeight = {'1x', 25, 50};
            ImagePanelLayout.ColumnWidth = {'1x'};

            ax_DisplayStack = uiaxes(ImagePanelLayout);
            ax_DisplayStack.Layout.Row = 1;
            ax_DisplayStack.Layout.Column = 1;
            DisplayStack = imshow(Stack(:,:,Frame), [], 'Parent', ax_DisplayStack);
            
        %% Define image processing parameters
            ControlPanel = uipanel(MainLayout, "Title", 'Control Panel');
            ControlPanel.Layout.Row = 1;
            ControlPanel.Layout.Column = 2;

            ControlPanelLayout = uigridlayout(ControlPanel, [3,1]);
            ControlPanelLayout.RowHeight = {'1x', 'fit', 50};
            ControlPanelLayout.ColumnWidth = {'fit'};
            

        %% Controls: 
            %% Image Panel - Title, Slider, Label
                CurrentFrame = uilabel(ImagePanelLayout, ...
                                      'Text', sprintf('Frame %d/%d	Pixel Shift: %d	Total Imaging Channels: %d', Frame, TotalFrames, UI_Shift, UI_Channels), ...
                                      'HorizontalAlignment', 'left' ... 
                                      );
                CurrentFrame.Layout.Row = 2;
                CurrentFrame.Layout.Column = 1;

                FrameSlider = uislider(ImagePanelLayout, ...
                                       'Limits', [1, TotalFrames], ...
                                       'Value', Frame, ...
                                       'ValueChangingFcn', @(src, event) Update_Frame(round(event.Value)) ...
                                      );
                FrameSlider.Layout.Row = 3;
                FrameSlider.Layout.Column = 1;
            
            %% Control Panel - Processing Parameter Inputs
                ParametersPanel = uipanel(ControlPanelLayout, "Title", 'Image stack pre-processing parameters');
                ParametersPanel.Layout.Row = 1;
                ParametersPanel.Layout.Column = 1;

                ParametersPanelLayout = uigridlayout(ParametersPanel, [5,1]);
                ParametersPanelLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit'};
                ParametersPanelLayout.ColumnWidth = {'1x'};

                % Control the frames to keep from the original image stack
                    DeleteFrames = uigridlayout(ParametersPanelLayout, [1,4]);
                    DeleteFrames.RowHeight = {'fit'};
                    DeleteFrames.ColumnWidth = {'fit', 'fit', 'fit', 'fit'};

                    DeleteFrames_Text1 = uilabel(DeleteFrames, ...
                                                 'Text', 'Keep frames from ', ...
                                                 'FontSize', FontSize, ...
                                                 'VerticalAlignment', 'center', ...
                                                 'HorizontalAlignment', 'left' ...
                                                );

                    DeleteFrames_FirstFrame = uispinner(DeleteFrames, ...
                                                        'Limits', [1, TotalFrames], ...
                                                        'Value', 1, ...
                                                        'Step', 1, ...
                                                        'ValueDisplayFormat', '%.0f', ...
                                                        'FontSize', FontSize ...
                                                       );

                    DeleteFrames_Text2 = uilabel(DeleteFrames, ...
                                                 'Text', 'to ', ...
                                                 'FontSize', FontSize, ...
                                                 'VerticalAlignment', 'center', ...
                                                 'HorizontalAlignment', 'left' ...
                                                ); %#ok<NASGU>

                    DeleteFrames_LastFrame = uispinner(DeleteFrames, ...
                                                       'Limits', [1, TotalFrames], ...
                                                       'Value', TotalFrames, ...
                                                       'Step', 1, ...
                                                       'ValueDisplayFormat', '%.0f', ...
                                                       'FontSize', FontSize ...
                                                      );

                    TextHeight = DeleteFrames_Text1.Position(4);
                    DeleteFrames_Text1.Position(4) = TextHeight;
                    DeleteFrames_FirstFrame.Position(4) = TextHeight;
                    DeleteFrames_LastFrame.Position(4) = TextHeight;

                % Deinterleave the image stack in to _ channels
                    DeinterleaveFrames = uigridlayout(ParametersPanelLayout, [1,3]);
                    DeinterleaveFrames.RowHeight = {'fit'};
                    DeinterleaveFrames.ColumnWidth = {'fit', 'fit', 'fit'};

                    DeinterleaveFrames_Text1 = uilabel(DeinterleaveFrames, ...
                                                       'Text', 'Deinterleave stack into ', ...
                                                       'FontSize', FontSize, ...
                                                       'VerticalAlignment', 'center', ...
                                                       'HorizontalAlignment', 'left' ...
                                                      );
                    DeinterleaveFrames_Channels = uispinner(DeinterleaveFrames, ...
                                                            'Limits', [1, Inf], ...
                                                            'Value', 1, ...
                                                            'Step', 1, ...
                                                            'ValueDisplayFormat', '%.0f', ...
                                                            'FontSize', FontSize, ...
                                                            'ValueChangedFcn', @(src, event) Update_Channels() ...
                                                           );
                    DeinterleaveFrames_Text2 = uilabel(DeinterleaveFrames, ...
                                                       'Text', 'channels', ...
                                                       'FontSize', FontSize, ...
                                                       'VerticalAlignment', 'center', ...
                                                       'HorizontalAlignment', 'left' ...
                                                      );
                    TextHeight = DeinterleaveFrames_Text1.Position(4);
                    DeinterleaveFrames_Channels.Position(4) = TextHeight;
                    DeinterleaveFrames_Text2.Position(4) = TextHeight;

                % Apply pixel shift
                    ApplyPixelShift = uigridlayout(ParametersPanelLayout, [1,2]);
                    ApplyPixelShift.RowHeight = {'fit'};
                    ApplyPixelShift.ColumnWidth = {'fit', 'fit'};

                    ApplyPixelShift_Text1 = uilabel(ApplyPixelShift, ...
                                                    "Text", "Shift pixels along x-axis ", ...
                                                    'FontSize', FontSize, ...
                                                    'VerticalAlignment', 'center', ...
                                                    'HorizontalAlignment', 'left' ...
                                                   );
                    ApplyPixelShift_Value = uispinner(ApplyPixelShift, ...
                                                      "Limits", [-Inf, Inf], ...
                                                      'Value', 0, ...
                                                      'Step', 1, ...
                                                      'ValueDisplayFormat', '%.0f', ...
                                                      'FontSize', FontSize, ...
                                                      'ValueChangedFcn', @(src, event) Update_PixelShift() ...
                                                     );
                    TextHeight = ApplyPixelShift_Text1.Position(4);
                    ApplyPixelShift_Value.Position(4) = TextHeight;
                
                % Apply motion correction to image stack
                    ApplyMotionCorrection = uicheckbox(ParametersPanelLayout, ...
                                                       "Text", 'Apply motion correction', ...
                                                       'FontSize', FontSize, ...
                                                       'Value', true ...    
                                                      );
                    ApplyMotionCorrection.Layout.Row = 5;
                    ApplyMotionCorrection.Layout.Column = 1;
            
            %% Control Panel - Image Quality (Contrast)
                ImageQualityPanel = uipanel(ControlPanelLayout, "Title", "Image quality control - Contrast");
                ImageQualityPanel.Layout.Row = 2;
                ImageQualityPanel.Layout.Column = 1;
            
                ImageQualityPanelLayout = uigridlayout(ImageQualityPanel);
                ImageQualityPanelLayout.RowHeight = {'fit'};
                ImageQualityPanelLayout.ColumnWidth = {'1x'};
                
                % Control image contrast
                    ContrastSlider = uislider(ImageQualityPanelLayout, ...
                                              "range", ...
                                              'Value', [0, 100], ...
                                              "Limits", [0, 100], ...
                                              'ValueChangingFcn', @(src, event) Update_Contrast(DisplayStack, event.Value) ...
                                             );
                    ContrastSlider.Layout.Row = 1;
                    ContrastSlider.Layout.Column = 1;

            %% Control Panel - Final Parameters (Cancel, Reset, Confirm)
                ConfirmPanel = uipanel(ControlPanelLayout);
                ConfirmPanel.Layout.Row = 3;
                ConfirmPanel.Layout.Column = 1;

                ConfirmPanelLayout = uigridlayout(ConfirmPanel, [1,4]);
                ConfirmPanelLayout.RowHeight = {'fit'};
                ConfirmPanelLayout.ColumnWidth = {'1x', '1x', '1x', '1x'};

                % Cancel pre-processing
                    Cancel = uibutton(ConfirmPanelLayout, ...
                                      "Text", 'Cancel', ...
                                      "FontSize", FontSize, ...
                                      "ButtonPushedFcn", @(btn, event) Cancel_Callback ...
                                     );
                    Cancel.Layout.Row = 1;
                    Cancel.Layout.Column = 1;
                
                % Reset pre-processing parameters
                    Reset = uibutton(ConfirmPanelLayout, ...
                                     "Text", 'Reset', ...
                                     "FontSize", FontSize, ...
                                     "ButtonPushedFcn", @(btn, event) Reset_Callback ...
                                    );
                    Reset.Layout.Row = 1;
                    Reset.Layout.Column = 2;
                
                % Preview
                    Preview = uibutton(ConfirmPanelLayout, ...
                                       "Text", 'Preview', ...
                                       "FontSize", FontSize, ...
                                       "ButtonPushedFcn", @(btn, event) Preview_Callback ...
                                      );
                    Preview.Layout.Row = 1;
                    Preview.Layout.Column = 3;

                % Finish pre-processing
                    Confirm = uibutton(ConfirmPanelLayout, ...
                                       "Text", 'Confirm', ...
                                       "FontSize", FontSize, ...
                                       "ButtonPushedFcn", @(btn, event) Confirm_Callback ...
                                      );
                    Confirm.Layout.Row = 1;
                    Confirm.Layout.Column = 4;

    %% Close figure when finished
        Output = struct;
        waitfor(Window, 'BeingDeleted', true)
        ProcessingParameters = Output;
    
    %% Helper functions
        %% UI controls
            function Update_Frame(NewFrame)
                Frame = NewFrame;
                DisplayStack.CData = Stack(:,:,Frame);
                CurrentFrame.Text = sprintf('Frame %d/%d	Pixel Shift: %d	Total Imaging Channels: %d', Frame, TotalFrames, UI_Shift, UI_Channels);
                FrameSlider.Value = Frame;
            end

            function KeyPressHandler(~, event)
                switch event.Key
                    case 'rightarrow'
                        if Frame < TotalFrames
                            Frame = Frame + 1;
                            Update_Frame(Frame);
                        end
                    case 'leftarrow'
                        if Frame > 1
                            Frame = Frame - 1;
                            Update_Frame(Frame);
                        end
                end
            end

            function Update_PixelShift()
                UI_Shift = ApplyPixelShift_Value.Value;
                ShiftedStack = PixelShiftCorrection(Stack, UI_Shift, 'SingleFrame', Frame);
                DisplayStack.CData = ShiftedStack(:,:,Frame);
                CurrentFrame.Text = sprintf('Frame %d/%d\tPixel Shift: %d\tTotal Imaging Channels: %d', Frame, TotalFrames, UI_Shift, UI_Channels);
            end

            function Update_Channels
                UI_Channels = DeinterleaveFrames_Channels.Value;
                CurrentFrame.Text = sprintf('Frame %d/%d\tPixel Shift: %d\tTotal Imaging Channels: %d', Frame, TotalFrames, UI_Shift, UI_Channels);
            end

            function Update_Contrast(DisplayStack, ContrastRange)
                ContrastRange = MinIntensity + (ContrastRange / 100) * (MaxIntensity - MinIntensity);
                DisplayStack.Parent.CLim = ContrastRange;
            end

        %% Callback functions to save parameters
            function Cancel_Callback()
                Output = NaN;
                
                delete(Window)
            end

            function Reset_Callback()
                DeleteFrames_FirstFrame.Value = 1;
                DeleteFrames_LastFrame.Value = TotalFrames;
                ApplyPixelShift_Value.Value = 0;
                ApplyMotionCorrection.Value = true;
                DeinterleaveFrames_Channels.Value = 1;
                ContrastSlider.Value = [0, 100];

                Frame = 1;
                FrameSlider.Value = Frame;
                
                UI_Shift = ApplyPixelShift_Value.Value;
                Shifted = PixelShiftCorrection(Stack, UI_Shift);
                DisplayStack.CData = Shifted(:,:,Frame);
                DisplayStack.Parent.CLim = [0,65535];

                CurrentFrame.Text = sprintf('Frame %d/%d\tPixel Shift: %d\tTotal Imaging Channels: %d', Frame, TotalFrames, UI_Shift, UI_Channels);
            end

            function Preview_Callback()
                
            end
            
            function Confirm_Callback()
                KeepFrameRegion = [DeleteFrames_FirstFrame.Value, DeleteFrames_LastFrame.Value];
                if KeepFrameRegion(1) > 1
                    InitialRegion = 1:KeepFrameRegion(1)-1;
                else
                    InitialRegion = [];
                end
                if KeepFrameRegion(2) < TotalFrames
                    FinalRegion = KeepFrameRegion(2)+1:TotalFrames;
                else
                    FinalRegion = [];
                end

                Output.FramesToDelete = [InitialRegion, FinalRegion];
                Output.InterleavedChannels = DeinterleaveFrames_Channels.Value;
                Output.PixelShiftValue = ApplyPixelShift_Value.Value;
                Output.ApplyMotionCorrection = ApplyMotionCorrection.Value;
                Output.Contrast = MinIntensity + (ContrastSlider.Value / 100) * (MaxIntensity - MinIntensity);

                delete(Window)
            end
end