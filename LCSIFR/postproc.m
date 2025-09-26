function out = postproc(input)     
    % Stretching performs the histogram stretching of the image.
    % im is the input color image and p is cdf limit.
    % out is the contrast stretched image and cdf is the cumulative prob.
    % density function and T is the stretching function.
    
    p = 5;
    % RGB to grayscale conversion
    im_gray = im2gray(input);
    [row,col] = size(im_gray);
    
    % histogram calculation
    [count,~] = imhist(im_gray);
    prob = count'/(row*col); 
    
    % cumulative Sum calculation
    cdf = cumsum(prob(:));

    % finding less than particular probability
    i1 = length(find(cdf <= (p/100)));
    i2 = 255-length(find(cdf >= 1-(p/100)));
    
    o1 = floor(255*.10);
    o2 = floor(255*.90);
    
    t1 = (o1/i1)*(0:i1); 
    t2 = (((o2-o1)/(i2-i1))*(i1+1:i2))-(((o2-o1)/(i2-i1))*i1)+o1; 
    t3 = (((255-o2)/(255-i2))*(i2+1:255))-(((255-o2)/(255-i2))*i2)+o2; 
    
    T = (floor([t1 t2 t3]));
    
    input(input == 0) = 1;
    
    u1 = (input(:,:,1));
    u2 = (input(:,:,2));
    u3 = (input(:,:,3));
    
    % Replacing the value from look up table
    out1 = T(u1);
    out2 = T(u2);
    out3 = T(u3);
    
    out = zeros([size(out1),3], 'uint8');
    out(:,:,1) = uint8(out1);
    out(:,:,2) = uint8(out2);
    out(:,:,3) = uint8(out3);
end