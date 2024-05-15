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


% Load image
I = imread('test.jpg');
% number of bins
nbins = 256; 

% Compute histogram
H = my_histo(I, nbins);

% Display histogram
bar(H);
title('Histogram of Image');
xlabel('Intensity');
ylabel('Frequency');