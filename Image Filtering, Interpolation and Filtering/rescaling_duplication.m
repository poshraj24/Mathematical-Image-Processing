function I_resize = resize_copy(I, factor)
    % Get size of original image
    [rows, cols] = size(I);
    
    % Calculate new size after resizing
    new_rows = rows * factor;
    new_cols = cols * factor;
    
    % Initialize resized image matrix
    I_resize = zeros(new_rows, new_cols);
    
    % Copy pixel values according to the factor
    for i = 1:new_rows
        for j = 1:new_cols
            % Find corresponding pixel value in original image
            row_index = ceil(i / factor);
            col_index = ceil(j / factor);
            
            % Copy pixel value
            I_resize(i, j) = I(row_index, col_index);
        end
    end
end
% loading image
I = imread('test.jpg');

% Define scaling factor
factor = 3; 
% Resize image using copy method
I_resize = resize_copy(I, factor);

% Display original and resized images
subplot(1, 2, 1);
imagesc(I);
title('Original Image');
colormap(gray);
axis off;

subplot(1, 2, 2);
imagesc(I_resize);
title('Resized Image (Copied)');
colormap(gray);
axis off;