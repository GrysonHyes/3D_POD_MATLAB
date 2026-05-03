clear
close all
clc

% --------- Params -------------
image_pattern = 'demo images\*.tif';
% ------------------------------

%% Load image directory

files = dir(image_pattern);

fprintf('Found %d images\n', size(files, 1))

%% Import first image to get dimensions

first = imread(fullfile(files(1).folder, files(1).name));
[n_y, n_x] = size(first);
n_t = size(files, 1);

% Initialize image array
images = zeros(n_y, n_x, n_t);

%% Load all images

for i = 1:n_t
    images(:, :, i) = imread(fullfile(files(1).folder, files(i).name));
end

%% Prepare for POD

S = reshape(images, [], n_t);

%% Run POD

[lamb, phi, a] = pod(S);

%% Reconstruct image for mode
n = 1; % mode number

img = reshape(phi(:,n), n_y, n_x);

figure
imagesc(img)
colormap(redbluecmap)
vmax = max(abs(img(:)));
clim([-vmax, vmax])
colorbar
title(sprintf('Spatial Reconstruction of Mode %d', n))
axis image

%% Total Energy

TKE_k = lamb ./ sum(lamb);
mode_num = 1:50;
TKE_cum = cumsum(TKE_k);

figure
yyaxis left
plot(mode_num, TKE_k, 'g')
ylabel('Energy Contribution')
hold on
yyaxis right
plot(mode_num, TKE_cum, 'r')
legend('Mode Energy Contribution', 'Cumulative Energy')
xlabel('Mode Number')
ylabel('Cumulative Energy')
title('Energy Distribution of Data')

grid on
