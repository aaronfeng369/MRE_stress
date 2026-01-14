%% =========================================================================
% This script reproduces the results of Figure 5 for Meningioma #4.
% It visualizes the T1 map, performs stress inversion on the tumor region,
% and plots both the estimated stress and the wavefield components on the
% brain and tumor surfaces.
%% =========================================================================

clc;
clear;
close all;
warning off;

%% ====================== Load dataset =====================================
% Load 3D brain MRI and tumor dataset
load dataset_tumor.mat;

%% ====================== Visualize T1 map =================================
% Display a middle slice of T1 map for reference
figure;
imagesc(squeeze(t1m(56, end:-1:1, end:-1:1)).');
axis off; 
axis image; 
colormap('gray');
title('T1 map');

%% ====================== Stress inversion ==================================
% Frequency for inversion
ff = 50;

% Compute estimated stress (sigma_EST) from the wavefield W
sigma_EST = stress_inversion_mre(W, ff, dxyz, M_tumor);

%% ====================== Visualize estimated stress on brain surface ======
% For reference, show uniform stress on brain surface
P = ones(size(sigma_EST));
M = M_brain(2:end-2, 2:end-2, 2:end-2);
plotPOnSurface_brain(P, M);
title('\sigma (Pa)');

% Visualize estimated stress on tumor surface
P = sigma_EST;
M = M_tumor(2:end-2, 2:end-2, 2:end-2);
plotPOnSurface(P, M);
ax2 = gca;
view(ax2, [az, el]);  % Set viewing angle

%% ====================== Visualize wavefield components ===================
% Loop over 3 wavefield components
for ii = 1:3

    P = ones(size(sigma_EST));
    M = M_brain(2:end-2, 2:end-2, 2:end-2);
    plotPOnSurface_brain(P, M);
    
    % Plot the ii-th wavefield component on tumor surface
    P = real(squeeze(W(2:end-2, 2:end-2, 2:end-2, ii)));
    M = M_tumor(2:end-2, 2:end-2, 2:end-2);
    plotPOnSurface_wave(P, M);
    
    % Set title for current wavefield component
    title(['u_', num2str(ii)]);
    
    % Adjust view angle
    ax2 = gca;
    view(ax2, [az, el]);
end
