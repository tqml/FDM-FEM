function makeGIF(U, x, x0, xend)
    %% makeGIF
    %
    % Code from:
    %   https://www.mathworks.com/matlabcentral/answers/94495-how-can-i-create-animated-gif-images-in-matlab
    %
    %

    % Defaults
    filename = 'fem.gif';
    DelayTime = 1/15; % 15 Frames per Second
    DitherOption = 'dither';
    LoopCount = Inf;

    h = figure;
    axis tight manual% this ensures that getframe() returns a consistent size
    set(gca, 'YLim', [-2 2]);
    set(gca, 'XLim', [x0 xend]);
    set(gca, 'nextplot', 'replacechildren')

    for n = 1:size(U, 2)
        % Draw plot for y = x.^n

        plot(x, U(:, n), 'LineWidth', 1);
        drawnow
        % Capture the plot as an image
        frame = getframe(h);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256, DitherOption);
        % Write to the GIF File
        if n == 1
            imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', DelayTime);
        else
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', DelayTime);
        end

    end

end
