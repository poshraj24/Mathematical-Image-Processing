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
function I_equalized = hist_eq(I)
    % Compute histogram of input image
    H = my_histo(I, 256); % Assuming 256 bins
    
    % Compute cumulative distribution function (CDF)
    CDF = cumsum(H) / sum(H);
    
    % Scale CDF to [0, 255] range
    CDF_scaled = uint8(255 * CDF);
    
    % Apply histogram equalization
    I_equalized = CDF_scaled(I + 1);
end
I = imread('test.jpg');
I_equalized = hist_eq(I);
subplot(1, 2, 1);
imagesc(I);
title('Original Image');
colormap(gray);
axis off;

subplot(1, 2, 2);
imagesc(I_equalized);
title('Equalized Image');
colormap(gray);
axis off;