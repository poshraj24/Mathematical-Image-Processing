function I_median = median_filter(I, filter_size)
    % Input Validation
    if ~isnumeric(filter_size) || ~isreal(filter_size) || mod(filter_size, 2) == 0 || filter_size <= 0
        error('Filter size must be a positive, odd integer.');
    end

    % Get image dimensions and pad the image for boundary handling
    [height, width, channels] = size(I);
    pad_size = (filter_size - 1) / 2;  
    I_padded = padarray(I, [pad_size, pad_size], 'replicate'); 

    % Initialize output image
    I_median = zeros(size(I), class(I)); 

    % Apply median filter for each channel
    for c = 1:channels
        for i = 1:height
            for j = 1:width
                % Extract neighborhood
                neighborhood = I_padded(i:i+filter_size-1, j:j+filter_size-1, c); 
                % Calculate median
                I_median(i, j, c) = median(neighborhood(:)); 
            end
        end
    end
end
% Load the image
I = imread('test.jpg');
I = rgb2gray(I);

% Apply median filtering with different window sizes
sizes = [3, 5, 7]; 
figure;
for i = 1:length(sizes)
    subplot(2, 2, i);
    I_filtered = median_filter(I, sizes(i));
    imshow(I_filtered);
    title(sprintf('Window Size: %d', sizes(i)));
end
subplot(2, 2, length(sizes) + 1);
imshow(I);
title('Original Image');