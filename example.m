
% Example code to compute Spillover Asymmetry Measure (SAM) introduced in
%
% BARUNIK, J., KOCENDA, E. and VACHA, L., 2017.
% Asymmetric volatility connectedness on the forex market.
% Journal of International Money and Finance, 77, pp.39-56.
%
% The codes replicates the results
% by J.Barunik (c) 2016

%% REALIZED MEASURES
%
% First step is to obtain Realized Semivariance
% Save 5-minute high-frequency returs of one day to variable "data" and then

% RSp=sum((data.^2).*(data>0));    % Semivariance (positive)
% RSn=sum((data.^2).*(data<0));    % Semivariance (negative)

% In this code, however, I use processed data, as I can not distribute 5-min data by licence


%% Compute original DY 2012 directional indices

clear
clc

% chose horizons and lag length
H=10;
lags=2;

% Load realized variance

load spilloverdataFXRV.txt

dataA=log(sqrt(spilloverdataFXRV));


% Load realized semi-variances

load spilloverdataFXRVn.txt
load spilloverdataFXRVp.txt

datan=log(sqrt(spilloverdataFXRVn));
datap=log(sqrt(spilloverdataFXRVp));

data = [datap datan];


[ T vars ] = size(data);

%% Table 2: Volatility spillover from N-dimensional VAR (original DY2012)

[ S_VAR_table_G] = VAR_Spillover_table_directional(dataA, H, lags)

spilloverGAll=100*(sum(sum(S_VAR_table_G))-sum(diag(S_VAR_table_G)))/sum(sum(S_VAR_table_G))


%% Table 4: Volatility spillover for the 2N-dimensional VAR

[ S_VAR_table_G] = VAR_Spillover_table_directional(data, H, lags)

%S_VAR_table

% excluding own + on -
spillT=(100*(sum(S_VAR_table_G)'-diag(S_VAR_table_G')-[diag(S_VAR_table_G(size(datan,2)+1:end,1:size(datan,2)));diag(S_VAR_table_G(1:size(datan,2),size(datan,2)+1:end))])./sum(sum(S_VAR_table_G)))';

% Directional To excluding own shares (shock to RV1+ influences others?)
spilloverGto = (100*(sum(S_VAR_table_G)'-diag(S_VAR_table_G')-[diag(S_VAR_table_G(size(datan,2)+1:end,1:size(datan,2)));diag(S_VAR_table_G(1:size(datan,2),size(datan,2)+1:end))])./sum(sum(S_VAR_table_G)))'

% check to original DY
sum(spillT)

spilloverGp=sum(spillT(1:size(datan,2)))
spilloverGn=sum(spillT(size(datan,2)+1:end))

%% DY 2012 directional index

% Asymmetric 6D excluding own on diagonals
% but also excluding own positive on own negative!

 for t=1:T-199

     % Total spillover on RV:
     [ S_VAR_table_GALL] = VAR_Spillover_table_directional(dataA(t:t+199,:), H, lags);
     spilloverGAll(t)=100*(sum(sum(S_VAR_table_GALL))-sum(diag(S_VAR_table_GALL)))/sum(sum(S_VAR_table_GALL));

     % SAM on 2N-dimensional system:
     [ S_VAR_table_G] = VAR_Spillover_table_directional(data(t:t+199,:), H, lags);

     spilloverG(t) = 100*(sum(sum(S_VAR_table_G))-sum(diag(S_VAR_table_G)))/sum(sum(S_VAR_table_G));

     spill(t,:)=(100*(sum(S_VAR_table_G)'-diag(S_VAR_table_G')-[diag(S_VAR_table_G(size(datan,2)+1:end,1:size(datan,2)));diag(S_VAR_table_G(1:size(datan,2),size(datan,2)+1:end))])./sum(sum(S_VAR_table_G)))';

     spilloverGp(t)=sum(spill(t,1:size(datan,2)));
     spilloverGn(t)=sum(spill(t,size(datan,2)+1:end));

 end


%% Plot indices

% Diebold-Yilmaz (2012) spillover index
% Figure 2 in Barunik et al. (2016)

plot(spilloverGAll)

% SAM index
% Figure 4 in Barunik et al. (2016)

plot(spilloverGp-spilloverGn)

% Directional SAM - Figure 5a

figure
subplot(3,3,1);
plot(spill(:,1))
ylim([0,14])

subplot(3,3,2);
plot(spill(:,2))
ylim([0,14])

subplot(3,3,3);
plot(spill(:,3))
ylim([0,14])

subplot(3,3,4);
plot(spill(:,7))
ylim([0,14])

subplot(3,3,5);
plot(spill(:,8))
ylim([0,14])

subplot(3,3,6);
plot(spill(:,9))
ylim([0,14])

subplot(3,3,7);
plot(spill(:,1)-spill(:,7))
ylim([-10,10])

subplot(3,3,8);
plot(spill(:,2)-spill(:,8))
ylim([-10,10])

subplot(3,3,9);
plot(spill(:,3)-spill(:,9))
ylim([-10,10])


% Directional SAM - Figure 5b

figure
subplot(3,3,1);
plot(spill(:,4))
ylim([0,14])

subplot(3,3,2);
plot(spill(:,5))
ylim([0,14])

subplot(3,3,3);
plot(spill(:,6))
ylim([0,14])

subplot(3,3,4);
plot(spill(:,10))
ylim([0,14])

subplot(3,3,5);
plot(spill(:,11))
ylim([0,14])

subplot(3,3,6);
plot(spill(:,12))
ylim([0,14])

subplot(3,3,7);
plot(spill(:,4)-spill(:,10))
ylim([-10,10])

subplot(3,3,8);
plot(spill(:,5)-spill(:,11))
ylim([-10,10])

subplot(3,3,9);
plot(spill(:,6)-spill(:,12))
ylim([-10,10])
