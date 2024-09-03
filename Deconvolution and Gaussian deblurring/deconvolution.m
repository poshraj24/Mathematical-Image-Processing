%% Deconvolution and co 

clear all
close all

% Handling the image

I = double(imread('cameraman.tif'));

figure, imagesc(I), colormap('gray'), axis image

% Adding noise for denoising purposes

% Gaussian noise + gaussian blur
k=5;
gamma = 2*k+1; % size of kernel
sigma = 2; % sqrt variance of kernel
[conv_op, conv_adj_op, k_A] = createGaussianBlurringOperator(size(I),gamma,sigma);

var = 5; % noise variance
I_nse = conv_op(I) + var * randn(size(I));

% visualize blurred and noisy image
figure; imagesc(I_nse); colormap('gray'); axis image;
%% 
function u = deconv_van_cittert(I_nse, k_A, iterations)
    % Initialize the deconvolved image with the blurred image
    u = I_nse;
    
    % Compute q in the frequency domain: q̂ = 1 - k̂A
    fft_kA = fft2(k_A);
    q_hat = 1 - fft_kA;

    % Perform van-Cittert iterations
    for i = 1:iterations
        % Convolve in the frequency domain and update u
        u = I_nse + real(ifft2(q_hat .* fft2(u)));
    end
end

%% Deconvolution using Van-Cittert iterations

% specifiy amount of Van-Cittert iterations
iterations=15;

% perform deconvolution with Van-Cittert iterations
uv = deconv_van_cittert(I_nse,k_A,iterations);

% visualize deconvolution results
figure; imagesc(real(uv)); colormap('gray'); axis image;
drawnow
%% 
function u = deconv_TV_pd(I_nse, k_A, lambda)
    % Set algorithm parameters
    tau = 0.125;
    sigma = 0.125;
    theta = 1;
    
    % Initialize variables
    [M, N] = size(I_nse);
    u = I_nse;
    u_bar = u;
    p = zeros(M, N, 2);

    % Compute convolution operators in frequency domain
    fft_kA = fft2(k_A);
    fft_kA_adj = conj(fft_kA);

    % Iterate primal-dual updates
    for iter = 1:100  % Adjust the number of iterations as needed
        % Gradient of u_bar
        [u_bar_x, u_bar_y] = gradient(u_bar);

        % Update dual variable p
        p(:, :, 1) = p(:, :, 1) + sigma * u_bar_x;
        p(:, :, 2) = p(:, :, 2) + sigma * u_bar_y;
        norm_p = max(1, sqrt(p(:, :, 1).^2 + p(:, :, 2).^2));
        p(:, :, 1) = p(:, :, 1) ./ norm_p;
        p(:, :, 2) = p(:, :, 2) ./ norm_p;

        % Update primal variable u
        div_p = divergence(p(:, :, 1), p(:, :, 2));
        u_old = u;
        u = (u + tau * (div_p - ifft2(fft_kA_adj .* fft2(I_nse - ifft2(fft_kA .* fft2(u)))))) / (1 + tau * lambda);
        
        % Update u_bar
        u_bar = u + theta * (u - u_old);
    end
end

function div_p = divergence(px, py)
    % Compute the divergence of the vector field (px, py)
    div_p = [px(2:end, :); zeros(1, size(px, 2))] - px + [py(:, 2:end), zeros(size(py, 1), 1)] - py;
end

%% Deconvolution with TV-regularization and changing operators

% specifiy regularization parameter
lambda = 0.001;

% perform deconvolution using TV regularization
u = deconv_TV_pd(I_nse,k_A,lambda);

% visualize deconvolution results
figure; imagesc(real(u)); colormap('gray'); axis image;
drawnow

