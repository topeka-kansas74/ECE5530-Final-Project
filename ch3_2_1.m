%% part a
% define given constants
q = 0.9;
r = 0.9;
M = 22;
% define impuse funciton
x = zeros(1,20);
x(1) = 1;

% first impulse response 
h1 = [1, -q];
% using conv() instead of firfilt() since firfilt() not given
w = conv(x, h1);

% second impuse response
h2 = zeros(1, M+1);
% assign value for each position
for i = 1:M+1
    h2(i) = r^(i-1);
end
% using conv() instead of firfilt() since firfilt() not given
% y is the impulse response of entire system because x was a impulse
% function
y = conv(w, h2);

% plot the impulse response for the whole system
figure;
n = 0:length(y)-1;
plot(n, y);
title('impuse response of casecade system');
xlabel('n');
ylabel('impuse response h[n]');

%% part b
