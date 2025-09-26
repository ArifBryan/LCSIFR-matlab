function [restoreOut, trans] = dehaze(input, w1, w2, num_iter) 
    % restoreOut is used to store the output of restoration
    restoreOut = zeros(size(input),'double');
    
    % Changing the precision level of input image to double
    input = double(input)./255;
    
    %% Dark channel Estimation from input
    darkChannel = min(input,[],3);

    % diff_im is used as input and output variable for anisotropic diffusion
    diff_im = w1*darkChannel;
    
    % 2D convolution mask for Anisotropic diffusion
    hN = [0.0625 0.1250 0.0625; 0.1250 0.2500 0.1250; 0.0625 0.1250 0.0625];
    hN = double(hN);
    
    %% Refine dark channel using Anisotropic diffusion.
    for t = 1:num_iter
        diff_im = conv2(diff_im,hN,'same');
    end
    
    %% Reduction with min
    diff_im = min(darkChannel,diff_im);
    
    diff_im = w2*diff_im ;
    trans = im2uint8(diff_im);
    
    %% Element-wise math to compute
    %  Restoration with inverse Koschmieder's law
    factor = 1.0./(1.0-(diff_im));
    restoreOut(:,:,1) = (input(:,:,1)-diff_im).*factor;
    restoreOut(:,:,2) = (input(:,:,2)-diff_im).*factor;
    restoreOut(:,:,3) = (input(:,:,3)-diff_im).*factor;
    restoreOut = uint8(255.*restoreOut);
end
