%% =========================================================================
% This script reproduces the results of Figure 2 in the paper.
% It generates the stress inversion results of simulated wavefields under 
% different pressures and compares estimated stress (EST) with ground truth (GT).
%% =========================================================================

clc;
clear;
close all;
warning off;

%% ====================== Load dataset =====================================
% Load pre-saved dataset containing wavefields and parameters
load dataset_fig2.mat;

% Copy data for convenience
lambda_ = lambda; % stretch ratio
uvwt_   = uvwt;
ppl     = [];
ppl2    = [];

pic_i = 0;

%% ====================== Loop over different pressures =====================
for p_i = 1:12
    % Extract data for current pressure index
    aa     = squeeze(a_direction(:,:,:,p_i,:));
    uvwt   = squeeze(uvwt_(:,:,:,p_i,:));
    lambda = squeeze(lambda_(:,:,:,p_i));
    
    % Define material constants
    C10 = 400;
    C01 = 600;
    
    % Compute ground truth shear moduli (muA, muB, muC) based on theory
    mu0 = 2*lambda.^2*C10 + 2*lambda*C01;
    mu1 = 2./lambda*C10 + 2*lambda*C01;
    mu2 = 2./lambda*C10 + 2./(lambda.^2)*C01;
    mu_GT = cat(4, mu0, mu1, mu2);
    
    % Prepare data for stress inversion
    W = squeeze(uvwt);
    aa = squeeze(aa);
    Freq_list = [50];
    dxyz = [dx, dx, dx];

    %% ====================== Stress Inversion ==============================
    sigma_est = stress_inversion_sim(W, aa, dxyz, Freq_list);
    sigma_GT  = abs(mu0 - mu2);
    
    % Remove zeros for visualization
    sigma_GT(sigma_est == 0) = NaN;
    sigma_est(sigma_est == 0) = NaN;

    %% ====================== Visualization ================================
    if mod(p_i, 3) == 0
        xx = round((size(W, 2) + 1)/2);
        pic_i = pic_i + 1;

        figure(1);
        subplot(4, 2, pic_i*2-1);
        imagesc([imtile(squeeze(sigma_est(:, xx, end:-1:1)))].', [0, 1.2e3]);
        axis off; axis image; colormap('hot');
        title(['P = ', num2str(p_i*100), ' Pa (EST)']);

        subplot(4, 2, pic_i*2);
        imagesc([imtile(squeeze(sigma_GT(:, xx, end:-1:1)))].', [0, 1.2e3]);
        axis off; axis image; colormap('hot');
        title(['P = ', num2str(p_i*100), ' Pa (GT)']);
    end

    %% ====================== Store Mean Values =============================
    ppl(p_i)  = nanmean(sigma_est(:));
    ppl2(p_i) = nanmean(sigma_GT(:));
end

%% ====================== Comparison Plot ================================
figure(2);
plot([0,1000], [0,1000], 'r--', 'LineWidth', 2); hold on;
plot(ppl, ppl2, 'bo', 'LineWidth', 2);
axis equal;
xlim([0, 1000]);
ylim([0, 1000]);
xlabel('\sigma EST (kPa)');
ylabel('\sigma GT (kPa)');
title('Comparison of Estimated vs Ground Truth Stress');

return;
