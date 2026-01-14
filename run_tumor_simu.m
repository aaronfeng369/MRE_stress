%% =========================================================================
% This code reproduces the results of Fig. 3 in the paper and generates the
% stress inversion results of the simulated wavefields under different 
% heterogeneous swelling pressures. 
% It compares stress inversion using two different direction fields: 
%   1. Original direction field from dataset (aa)
%   2. Radial direction field generated from geometric normals (aa2)
%% =========================================================================

clc;
clear;
close all;
%% 
warning off;

%% ====================== Load dataset =====================================
% Load precomputed simulated wavefield dataset for Fig.3
load dataset_fig3.mat;

% Store variables for convenience
lambda_ = lambda;  % stretch ratio
uvwt_   = uvwt;    % Simulated wavefield data

pic_i = 0;  % Counter for subplot indexing

%% ====================== Loop over selected pressures =====================
% Loop over pressures 2,4,6,8 (arbitrary choice from heterogeneous swelling pressures)
for p_i = [2, 4, 6, 8]
    pic_i = pic_i + 1;
    
    % Extract wavefield, direction field, and Lame parameter for current pressure
    aa     = squeeze(a_direction(:,:,:,p_i,:));  % Original direction field
    uvwt   = squeeze(uvwt_(:,:,:,p_i,:));        % Wavefield for current pressure
    lambda = squeeze(lambda_(:,:,:,p_i));        % stretch ratio at current pressure

    %% ====================== Generate radial direction field from geometry
    mask = isnan(real(squeeze(uvwt(:,:,:,1,1))));
    
    cc = bwconncomp(mask, 26);
    
    stats = regionprops3(cc, 'Volume');
    volumes = stats.Volume;
    
    [max_vol, max_idx] = max(volumes);
    max_region_mask = false(size(mask));
    max_region_mask(cc.PixelIdxList{max_idx}) = true;
    
    [ix, iy, iz] = ind2sub(size(max_region_mask), find(max_region_mask));
    c = [mean(ix), mean(iy), mean(iz)];
    
    [m, n, p] = size(max_region_mask);
    [X, Y, Z] = ndgrid(1:m, 1:n, 1:p);
    
    Vx = X - c(1);
    Vy = Y - c(2);
    Vz = Z - c(3);
    
    dist = sqrt(Vx.^2 + Vy.^2 + Vz.^2);
    Vx = Vx ./ dist;
    Vy = Vy ./ dist;
    Vz = Vz ./ dist;
    
    aa2 = cat(4, Vx, Vy, Vz);

    %% ====================== Compute ground truth material properties
    % Define material constants
    C10 = 500;
    C01 = 700;
    
    % Compute ground truth shear moduli (muA, muB, muC) based on theory
    mu0 = 2*lambda.^2*C10 + 2*lambda*C01;
    mu1 = 2./lambda*C10 + 2*lambda*C01;
    mu2 = 2./lambda*C10 + 2./(lambda.^2)*C01;
    
    % Store ground truth in 4D array
    mu_GT = cat(4, mu0, mu1, mu2);

    %% ====================== Stress inversion using original field
    W = squeeze(uvwt);             % Wavefield for stress inversion
    Freq_list = [50];              % Frequencies to use for inversion
    dxyz = [dx, dx, dx];           % Spatial resolution
    
    % Estimate stress using original direction field
    sigma_EST = stress_inversion_sim(W, squeeze(aa), dxyz, Freq_list);
    
    % Middle slice in y-direction for visualization
    xx = round((size(W,2)+1)/2);
    
    % Compute ground truth stress
    sigma_GT = abs(mu0 - mu2);
    sigma_GT(sigma_EST == 0) = NaN;  % Mask out zeros in estimated stress

    %% ====================== Stress inversion using radial field
    sigma_EST2 = stress_inversion_sim(W, squeeze(aa2), dxyz, Freq_list);
    sigma_GT(sigma_EST2 == 0) = NaN; % Mask zeros
    sigma_EST2(sigma_EST2 == 0) = NaN;

    %% ====================== Visualization
    figure(1);
    
    % Plot EST using original field
    subplot(4,3,pic_i*3-2);
    imagesc(imtile(squeeze(sigma_EST(:, xx, end:-1:1))).', [0, 3.2e3]);
    axis off; axis image; colormap('hot');
    title(['k = ', num2str(p_i*0.02), ' (EST1)']);
    
    % Plot EST using radial field
    subplot(4,3,pic_i*3-1);
    imagesc(imtile(squeeze(sigma_EST2(:, xx, end:-1:1))).', [0, 3.2e3]);
    axis off; axis image; colormap('hot');
    title(['k = ', num2str(p_i*0.02), ' (EST2)']);
    
    % Plot ground truth stress
    subplot(4,3,pic_i*3);
    imagesc(imtile(squeeze(sigma_GT(:, xx, end:-1:1))).', [0, 3.2e3]);
    axis off; axis image; colormap('hot');
    title(['k = ', num2str(p_i*0.02), ' (GT)']);
end
