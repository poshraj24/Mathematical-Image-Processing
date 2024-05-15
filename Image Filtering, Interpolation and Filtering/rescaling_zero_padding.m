function I_padded = zero_padding(image_array, factor)
    % Compute the Fourier transform and shift
    fft_img = fft2(image_array);
    fft_shifted = fftshift(fft_img);

    % Get original size and calculate padded size
    [height, width] = size(fft_shifted);
    padded_height = round(height * factor);
    padded_width = round(width * factor);

    % Calculate padding amounts (making sure they are even)
    pad_top = floor((padded_height - height) / 2);
    pad_bottom = pad_top;
    pad_left = floor((padded_width - width) / 2);
    pad_right = pad_left;

    % Zero pad using 'padarray' for convenience and clarity
    padded_image = padarray(fft_shifted, [pad_top, pad_left], 0);

    % Shift back, inverse transform, and scale if needed
    padded_image = ifftshift(padded_image);
    I_padded = real(ifft2(padded_image)); 

    if factor ~= 1  % Only scale if factor is not 1
        I_padded = I_padded * factor;
    end

    I_padded = uint8(I_padded); 
end
% Load the image 
img = imread('test.jpg');

% Call zero_padding function with different factors
I_zeropad_1 = zero_padding(img, 1);
I_zeropad_2 = zero_padding(img, 2);
I_zeropad_5 = zero_padding(img, 5);

% Display the images
subplot(1, 4, 1);
imshow(img);
title('Original Image');

subplot(1, 4, 2);
imshow(I_zeropad_1);
title('Zero padded 1');

subplot(1, 4, 3);
imshow(I_zeropad_2);
title('Zero padded 2');

subplot(1, 4, 4);
imshow(I_zeropad_5);
title('Zero padded 5');