clc;
clear all;

%% System
%{
A = [0 1 0 0;
     0 0 -1 0;
     0 0 0 1;
     0 0 3.3 0];
B = [0; 0.1; 0; -0.03];
%}

A = [1.38 -0.2077 6.715 -5.676;
    -0.584 -4.29 0 0.675;
    1.067 4.273 -6.654 5.893;
    0.048 4.273 1.343 -2.104];
B = [0 0;5.679 0;1.136 -3.146;1.136 0];
%}
n = size(A,1);
m = size(B,2);

N = 50;

%% Time
tau = zeros(1,N);
for k = 1:N-1
    tau(k+1) = tau(k) + 0.1;
end

%% Input (fixed per run)
U = -1 + 2*rand(m,N);

%% ===== DEFINE ONLY ONE EPSILON =====
epsilon = 0.9;   % <-- CAMBIAS ESTO CADA VEZ

base_folder = 'data_example2';

folder_name = fullfile(base_folder, ...
    sprintf('epsilon_%.3f', epsilon));

if ~exist(folder_name, 'dir')
    mkdir(folder_name);
end

%% ===== Generate W =====
W = zeros(n,N);

for k = 1:N
    v = randn(n,1);
    v = v / norm(v);
    W(:,k) = epsilon^2 * rand()^(1/n) * v;
end

%% ===== Simulate =====
X = zeros(n,N);
X(:,1) = randn(n,1);

for k = 1:N-1
    h = tau(k+1) - tau(k);
    xdot = A*X(:,k) + B*U(:,k) + W(:,k);
    X(:,k+1) = X(:,k) + h*xdot;
end

%% Derivatives
Xdot = zeros(n,N);
for k = 1:N
    Xdot(:,k) = A*X(:,k) + B*U(:,k) + W(:,k);
end

%% Save
save(fullfile(folder_name,'X0.mat'),'X');
save(fullfile(folder_name,'U.mat'),'U');
save(fullfile(folder_name,'W.mat'),'W');
save(fullfile(folder_name,'Xdot.mat'),'Xdot');