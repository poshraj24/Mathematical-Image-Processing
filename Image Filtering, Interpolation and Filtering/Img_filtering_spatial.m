function I_filter = image_filter(I, filter)
    switch filter
        case 'm'
            % Averaging filter
            m = 1/25 * ones(5);
            I_filter = conv2(I, m, 'same');
        case 'g'
            % Gaussian filter
            g = 1/81 * [1 2 3 2 1; 2 4 6 4 2; 3 6 9 6 3; 2 4 6 4 2; 1 2 3 2 1];
            I_filter = conv2(I, g, 'same');
        case 'Gamma'
            % Amplitude of gradient filter
            Gamma = [-1 0 1; -1 0 1; -1 0 1];
            I_filter = conv2(I, Gamma, 'same');
        case 'Del'
            % Laplacian filter
            Del = [0 1 0; 1 -4 1; 0 1 0];
            I_filter = conv2(I, Del, 'same');
        otherwise
            error('Invalid filter specified. Supported filters are: ''m'', ''g'', ''Gamma'', ''Del''.');
    end
end
% Load the image
I = imread('test.jpg');
I = rgb2gray(I);

% Apply the filter
filter_type1 = 'm'; % Choose from 'm', 'g', 'Gamma', 'Del'
filter_type2='g';
filter_type3='Gamma';
filter_type4='Del';
I_filtered1 = image_filter(I, filter_type1);
I_filtered2 = image_filter(I, filter_type2);
I_filtered3 = image_filter(I, filter_type3);
I_filtered4 = image_filter(I, filter_type4);

% Display the original and filtered images
figure;
subplot(1, 5, 1);
imshow(I);
title('Original Image');
subplot(1, 5, 2);
imshow(I_filtered1, []);
title('Filtered Image-averaging filter');
subplot(1,5, 3);
imshow(I_filtered2, []);
title('Gaussian filter');
subplot(1, 5, 4);
imshow(I_filtered3, []);
title('Gradient filter');
subplot(1, 5, 5);
imshow(I_filtered4, []);
title('Laplacian Filter');