function PixelIntensity = PlotZAxisProfile(Stack)
    % <Documentation>
        % PlotZAxisProfile()
        %   Plots the Z-axis profile of one or multiple image stacks by calculating mean pixel intensity.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   PixelIntensity = PlotZAxisProfile(Stack)
        %   
        % Description:
        %   This function computes and plots the mean pixel intensity along the Z-axis for either a single 
        %       image stack or a structure containing multiple stacks. Logic to calculate the mean pixel 
        %       intensity is based on whether the input is a structure containing multiple image stacks or
        %       a single image stack.
        %   A new figure window is made each time this function is called. Legend() is only added for the
        %       multi-stack inputs.
        %   Using ~isstruct() may be a more efficient method to organize the pixel intensity calculation, 
        %       I wanted to learn the try/catch system with matlab. If this becomes problematic, the logic
        %       will be updated.
        %   
        % Input:
        %   Stack - A numerical 3D array representing an image stack, with dimensions Rows x Columns x Frames. 
        %   
        % Output:
        %   PixelIntensity - Single input stack
        %                       Numerical array of mean pixel intensities
        %                  - Multiple image stack (structure)
        %                       Cell array of mean pixel intensities. Each cell corresponds to a single stack
        %
    % <End Documentation>

    fprintf('Plotting Z-Axis Profile...\n') % Opening statement

    try Fields = fieldnames(Stack);                                     % Error handling to determine if a structure of multiple stacks or a single image stack was input
        Flag = "MultiStack";                                            % No error occurs: multiple elements detected. Create flag callback
        fprintf('\tPlotting multiple stack.\n')                         % Command line update
    catch ME                                                            % Error occurs
        if (strcmp(ME.identifier, 'MATLAB:fieldnames:InvalidInput'))    % Desired error: : no elements detected, single stack submitted 
            Flag = "SingleStack";                                       % Create flag callback
            fprintf('\tPlotting single stacks.')                        % Command line update
        else                                                            % Undesired error: other
            rethrow(ME)                                                 % Push error message through
        end                                                             %
    end                                                                 % End error handling
        
    figure                                                                  % Create a new figure window
    switch Flag                                                             % Identify flag callback
        case "SingleStack"                                                  % Callback is a single stack
            PixelIntensity = MeanPixelIntensity(Stack);                     % Calculate mean pixel intensity for single stack
            plot(PixelIntensity)                                            % Plot intensities
        
        case "MultiStack"                                                   % Callback is a multi stack
            PixelIntensity = cell(1,length(Fields));                        % Preallocate mean pixel intensity cell array
            ColorMap = hsv(length(Fields));                                 % Create a color map for multiple image stacks
            for i = 1:length(Fields)                                        % Loop through each element of the input stack structure
                PixelIntensity{i} = MeanPixelIntensity(Stack.(Fields{i}));  % Calculate mean pixel intensity for each stack
                hold on                                                     % Plot elements on the same figure
                plot(PixelIntensity{i}, 'Color', ColorMap(i,:));            % Plot intensities
            end                                                             % End loop
            
            legend(Fields{:}, "Interpreter", "none", "Location", "best")    % Create a legend for each element
            hold off                                                        % Stop plotting elements on figure
    end                                                                     % End callback logic

    xlabel('Frame')                                                         % Create x-axis label
    ylabel('Mean Intensity')                                                % Create y-axis label
    title(sprintf('Z-Axis Profile\nMean Pixel Intensity'))                  % Create title
    axis 'auto xy'                                                          % Fix boundaries of figure

    fprintf('Z-axis profile plotted ✓\n')  % Ending statement

end