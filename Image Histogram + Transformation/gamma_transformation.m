function I_gamma = hist_gamma(I, gamma)
    % Ensure image is in double format for calculations
    I = double(I);
    
    % Normalize image intensity values to range [0, 1]
    I_normalized = I / max(I(:));
    
    % Apply gamma transformation
    I_gamma = I_normalized .^ gamma;
    
    % Scale the values back to the original intensity range
    I_gamma = uint8(255 * I_gamma);
end
I = imread('test.jpg');
gamma = 0.1;
I_gamma = hist_gamma(I, gamma);
subplot(1, 2, 1);
imagesc(I);
title('Original Image');
colormap(gray);
axis off;

subplot(1, 2, 2);
imagesc(I_gamma);
title(['Gamma Transformed Image (\gamma = ' num2str(gamma) ')']);
colormap(gray);
axis off;
