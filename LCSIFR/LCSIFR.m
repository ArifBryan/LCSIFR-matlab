function [final, recov, trans] = LCSIFR(input, w1, w2, num_iter)
    if nargin < 4
        num_iter = 3;
    end

    if nargin < 3
        w2 = 0.65;
    end

    if nargin < 2
        w1 = 0.9;
    end

    %% Adaptive omega
    intensityThreshold = 200; 
    overexposured_T = 0.46; 

    brightChannel = max(input,[],3);
    histogramValues = imhist(brightChannel);
    pixelsHigherThanThreshold = sum(histogramValues(intensityThreshold+1:end));
    totalPixels = numel(brightChannel);
    percentageHigherThanThreshold = (pixelsHigherThanThreshold / totalPixels);
    if overexposured_T < percentageHigherThanThreshold
        w1 = 0.7;
    end

    [recov, trans] = dehaze(input, w1, w2, num_iter);
    final = postproc(recov);
end