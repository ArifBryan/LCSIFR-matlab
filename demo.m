function demo(inputFile)
    addpath('LCSIFR/');

    inputImg = imread(inputFile);

    outputImg = LCSIFR(inputImg);
    
    [~, name, ext] = fileparts(inputFile);
    imwrite(outputImg, strcat(name, "_dehazed", ext), "Quality", 100);
end