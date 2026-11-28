%% 3.2.1 part a
% define given constants
q = 0.9;
r = 0.9;
M = 22;
% define impulse function
x = zeros(1,20);
x(1) = 1;

% first impulse response
h1 = generate_h1(q);
% using conv() instead of firfilt() since firfilt() not given
w = conv(x, h1);

% second impuse response
h2 = generate_h2(M,r);
% using conv() instead of firfilt() since firfilt() not given
% y is the impulse response of entire system because x was a impulse
% function
y = conv(w, h2);

% plot the impulse response for the whole system
figure;
n = 0:length(y)-1;
plot(n, y);
title('impulse response of cascade system');
xlabel('n');
ylabel('impulse response h[n]');

%% 3.2.1 part b
% because it is a cascade system, h[n] = conv(h1[n], h2[n]), where h1[n] is
% the impulse response for w[n] and h2[n] is the impulse response for y[n].
% This can be further expanded as h[n] = conv(delta[n]-q*delta[n-1]), h2[n]),
% where delta is an impulse function. Using the linearity of convolution
% and the shifting property, h[n] = conv(delta[n], h2[n]) -
% conv(q*delta[n-1], h2[n]), which is simply h[n] = h2[n] - q*h2[n-1]. We
% can now write out h2[n]. h[n] = sum(r^l * delta[n-l]) - q(r^l *
% delta[n-l-1]), where both summations are from l = 0 to M. when n = 0,
% h[0] = r^0 = 1. h[1] = r^1 -q*r^0. h[k] = r^k -q*r^(k-1) for k = 1 to M.
% at M+1, the first summation ends so h[M+1] = qr^M. From M+2, second
% summation also ends, so the h[n] = 0 for n > M+1.

%% 3.2.1 part c
% the identity property says that y[n] = delta[n]*x[n] = x[n], so if h[n] =
% h1[n]*h2[n] = delta[n], then y[n] = x[n].

%% 3.2.2 a
% load the image
load('echart.mat');
echart = double(echart);
%% 3.2.2 b
% define parameters
q = 0.9;

% generate impulse response from impulse function
h1 = generate_h1(q);
ech90 = conv2d(echart,h1);
%% 3.2.2 c
r = 0.9;
M = 22;
h2 = generate_h2(M,r);
y = conv2d(ech90, h2);

% plot for comparison
figure;
subplot(1,3,1)
imshow(echart, []);
title('original image');

subplot(1,3,2)
imshow(ech90, []);
title('Image distorted by FILTER-1');

subplot(1,3,3)
imshow(y, []);
title('Image distorted by FILTER-2');

% Describe the visual appearance of the output and explain its features by
% invoking your mathematical understanding of the cascade filtering
% process. -> the output of y seems to remove the distortion created by
% filter 1 for most of the places. However, there are faint white ghosts to
% the right of and below the white parts of each letter. As described in
% 3-2-1 part b, h[n] = h2[n] - q*h2[n-1], where h2[n] = r^n for n = 0 to M.
% Since q and r are both 0.9, q = r, so for n = 1 to M, h[n] = r^n -
% r*r^(n-1) = 0. The distortion cancels out for these values. At n = 0,
% h2[-1] doesn't exist, so h[0] = h2[0] = 1. This is what lets the original
% image come through unchanged. Thus, the overall h[n] = delta[n] -
% r^(M+1)*delta[n-(M+1)].
%
% Explain why you see "ghosts" in the output image, and use some previous
% calculations to determine how big the ghosts (or echoes) are, and where
% they are located. -> The cascade impulse response is
% h[n]=delta[n]-r^(M+1) * delta[n-(M+1)]). For M=22, the residual
% term is -0.0886*delta[n-23]. This means that each input pixel
% produces a negatively scaled copy 23 pixels to the right. Since the
% filters are applied in both the horizontal and vertical directions, each
% pixel also produces a negative copy 23 pixels below it and a positive
% copy shifted 23 pixels right and 23 pixels down. These residual copies
% form the faint ghost letters observed in the restored image.
%
% Evaluate the worst-case error in order
% to say how big the ghosts are relative to "black-white" transitions which
% are 0 to 255. -> In black-white transitions, the amplitude of one ghost
% is 255*0.0886 = 22.6, which is 8.86 percent error. In the worst case, the
% horizontal ghost and the vertical ghost land on the same pixel, and if
% both come from white pixels 255, they add up and double the error.
% Thus, the worst error is 2*22.6 = 45.2, which is 17.73 percent. The
% diagonal ghost is only 0.0079*255 = 2 gray levels at most, so it is
% negligible for bigger M values including M=22.

%% 3.2.3 a
M = [11,22,33];

% calculate the impulse response for each M value
h2_11 = generate_h2(M(1),r);
h2_22 = generate_h2(M(2),r);
h2_33 = generate_h2(M(3),r);

% calculate the output for each M value
y_11 = conv2d(ech90, h2_11);
y_22 = conv2d(ech90, h2_22);
y_33 = conv2d(ech90, h2_33);

% plot for comparison of M
figure;
subplot(1,3,1)
imshow(y_11, []);
title('deconvolved using M = 11');

subplot(1,3,2)
imshow(y_22, []);
title('deconvolved using M = 22');

subplot(1,3,3)
imshow(y_33, []);
title('deconvolved using M = 33');

% Describe the visual appearance of the output, and explain its features by
% invoking your mathematical understanding of the cascade filtering process.
%-> As M increases, the restored image becomes closer to the original
%image, and the ghost copies become less noticeable, and shifted in with
%bigger factor. The result with M=33 appears to provide the best
%restoration because it has the faintest residual ghosts.This can be
%explained by the impulse response of the cascaded filters. Since
%(q=r=0.9), the cascade impulse response is
%h[n]=delta[n]-r^(M+1)*delta[n-(M+1)]. The first term represents the
%original image, while the second term represents a negatively scaled,
%delayed copy of the image. The amplitude of the residual ghost is r^(M+1),
%which decreases as M increases because 0<r<1. For M=11, 22, and 33, the
%residual ghost coefficients are approximately 0.2824, 0.0886, and 0.0278,
%respectively. Therefore, increasing M reduces the ghost amplitude,
%allowing FILTER-2 to cancel more of the distortion introduced by FILTER-1.
%Although the ghost is shifted farther away as M increases, its amplitude
%becomes smaller. Thus, M=33 gives the best restoration among the three
%filters because it produces the smallest residual ghost artifacts.

%% 3.2.3 b
% from the mathematical equation described in the comments
ghost_coeff = r.^(M + 1);

% Worst-case error from two negative ghosts
worst_error = 2 * 255 .* ghost_coeff;

% Percentage of a black-white transition
error_percent = 100 * worst_error / 255;

results = table(M.', ghost_coeff.', ...
    worst_error.', error_percent.', ...
    'VariableNames', {'M', 'GhostCoefficient', ...
    'WorstErrorGrayLevels', 'ErrorPercent'});

disp(results);

% Can your eyes perceive a gray scale change of one level, i.e., one part
% in 256? -> One gray level is about 0.4% of the range, so it's generally
% invisible

%% helper functions
function h1 = generate_h1(q)
h1 = [1, -q];
end

function h2 = generate_h2(M,r)
h2 = zeros(1, M+1);
% assign value for each position
for i = 1:M+1
    h2(i) = r^(i-1);
end
end

function y = conv2d(x,h)
[H,W] = size(x);
% temporary variable that only have horizontal filtering
temp = zeros(H,W);
for i = 1:H
    t = conv(x(i,:), h);   % full convolution
    temp(i,:) = t(1:W);    % keep first W samples (causal)
end
% repeat the filtering in vertical direction
y = zeros(H,W);
for j = 1:W
    t = conv(temp(:,j), h(:));
    y(:,j) = t(1:H);
end
end
