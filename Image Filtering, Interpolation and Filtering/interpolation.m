function I_filter = resize_filter(I, factor, filter)
    % Input Validation
    if ~isnumeric(factor) || factor <= 0
        error('Factor must be a positive numeric value.');
    end
    valid_filters = {'tent'};
    if ~ismember(filter, valid_filters)
        error('Invalid filter. Choose from: tent');
    end

    % Get image dimensions
    [height, width, channels] = size(I);

    % New image dimensions
    new_height = round(height * factor);
    new_width = round(width * factor);

    % Generate tent filter kernel
    kernel = @(x) (abs(x) <= 1) .* (1 - abs(x));
    
    % Support for values beyond [-1, 1]
    kernel = @(x) kernel(min(max(x, -1), 1));

    % Create sampling positions in the original image
    x_orig = (0:new_width-1) / factor + 0.5;
    y_orig = (0:new_height-1) / factor + 0.5;

    % Initialize resized image
    I_filter = zeros(new_height, new_width, channels);

    % Perform interpolation for each channel
    for c = 1:channels
        for i = 1:new_height
            for j = 1:new_width
                % Calculate filter weights
                x_weights = kernel(x_orig(j) - (1:width));
                y_weights = kernel(y_orig(i) - (1:height));
                
                % Normalize weights to sum to 1
                x_weights = x_weights / sum(x_weights);
                y_weights = y_weights / sum(y_weights);
                
                % Apply convolution for interpolation
                I_filter(i, j, c) = sum(sum(x_weights' .* double(I(:,:,c)) .* y_weights)); 
            end
        end
    end

    % Convert to uint8
    I_filter = uint8(I_filter);
end

% Load the image
img = imread('test.jpg');
img = rgb2gray(img);

% 'tent', 'bell', 'mitchell_netrevalli'
t_image = resize_filter(img, 2, 'tent');




figure;
subplot(2, 2, 1); 
imshow(img); 
title('Original Image');
subplot(2, 2, 2); 
imshow(t_image); 
title('Tent Filtered');
subplot(2, 2, 3); 
imshow(b_image); 
