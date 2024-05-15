
I = imread(['test.jpg']);
function H = my_histo(I, nbins)
    % Convert image to a vector
    I_vec = I(:);
    
    % Compute histogram
    H = zeros(1, nbins);
    for i = 1:nbins
        % Define bin edges
        bin_start = (i-1) * (256 / nbins);
        bin_end = i * (256 / nbins);
        
        % Count pixels in this bin
        H(i) = sum(I_vec >= bin_start & I_vec < bin_end);
    end
end
function I_transformed = hist_linear(I, range_min, range_max)
    % Compute histogram of input image
    H = my_histo(I, 256); % Assuming 256 bins
    
    % Compute cumulative distribution function (CDF)
    CDF = cumsum(H) / sum(H);
    
    % Linearly scale CDF to desired range
    scaled_CDF = (range_max - range_min) * CDF + range_min;
    
    % Apply transformation to the image
    I_transformed = interp1(1:256, scaled_CDF, double(I(:)), 'linear');
    
    % Reshape transformed image to original size
    I_transformed = reshape(I_transformed, size(I));
end
range_min = 0;
range_max = 255;
I_transformed = hist_linear(I, range_min, range_max);
subplot(1, 2, 1);
imagesc(I);
title('Original Image');
colormap(gray);
axis off;

subplot(1, 2, 2);
imagesc(I_transformed, [range_min, range_max]);
title('Transformed Image');
colormap(gray);
axis off;