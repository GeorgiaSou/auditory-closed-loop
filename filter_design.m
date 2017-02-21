%-------------------------------------------------------------------------%
% Filter design for minimum phase shift delay
% Jan 2017, Version 1.0
% Authors: Laura Ferster
%
% This program shows the butterworth filter response used at the Lab and
% the response of the two proposed filters designed in terms of minimum
% phase shift delay
%-------------------------------------------------------------------------%
%close all;
clear all;

fs = 500; %sampling frequency

%--------------------------------------------------------------------------
% Filter used at Lab: Butterworth order 3
%--------------------------------------------------------------------------

Fc1=[0.319825 3.12648]/(fs/2);      % 0.319825 3.12648: cutoff frequecies for 0dB attenuation in [0.5-2]Hz
N1=3;                               % Filter order (# of sections) 
[z1,p1,k1] = butter(N1, Fc1);       % bandpass (0.5-2)Hz
[sos_var1,g1] = zp2sos(z1, p1, k1);
Hd_but1 = dfilt.df2sos(sos_var1, g1); % Filter

LabBWfilt = designfilt('bandpassiir','FilterOrder',N1*2, ...
          'HalfPowerFrequency1',0.319825,'HalfPowerFrequency2',3.12648, ...
          'SampleRate',fs);
      
      
%--------------------------------------------------------------------------
% Proposal 1: Butterworth order 2
%--------------------------------------------------------------------------

fc1 = 0.2;   % low cutoff frequency (-3dB)
fc2 = 5;   % high cutoff frequency (-3dB)
bwOrder = 2; % Filter order 

PropBWfilt = designfilt('bandpassiir','FilterOrder',bwOrder*2, ...
          'HalfPowerFrequency1',fc1,'HalfPowerFrequency2',fc2, ...
          'SampleRate',fs); 

[zBW,pBW,kBW] = PropBWfilt.zpk;
[sos_varBW,gBW] = zp2sos(zBW, pBW, kBW);
      
%--------------------------------------------------------------------------
% Proposal 2: Chevysheb Type 2
%
% Increasing the high stop band frequency (fs2CC2) the delay decreasys but
% decrease the selectivity of the filter in the [0.5-2]Hz band
%
%--------------------------------------------------------------------------

fs1CC2 = 0.225; % Low stop band frecuency 
fs2CC2 = 5;     % High stop band frecuency
Rs = 20;        % Attenuation (in dB) on the stop band
CC2Order = 3;   % Filter order 

PropCC2filt = designfilt('bandpassiir','FilterOrder',CC2Order*2, ...
    'StopbandFrequency1',fs1CC2,'StopbandFrequency2',fs2CC2, ...
    'SampleRate',fs,'DesignMethod','cheby2','StopbandAttenuation',Rs);

[zCC2,pCC2,kCC2] = PropCC2filt.zpk;
[sos_varCC2,gCC2] = zp2sos(zCC2, pCC2, kCC2);

%--------------------------------------------------------------------------
% Filters' response
%--------------------------------------------------------------------------

% Frequency domain response
filters = fvtool(LabBWfilt, PropBWfilt, PropCC2filt);  
legend(filters,strcat('BW@LAb order-',int2str(N1)), ...
    strcat('BW@MHSL order-',int2str(bwOrder)), ...
    strcat('CC2@MHSL order-',int2str(CC2Order))); 


% Time domain response
dataPath = 'D:\SWS_Chord_PN\data\comp_filters\raw_samp.mat';
data = load(dataPath);
% dataRaw = data.data_raw; 
% 
% dataIn = dataRaw(1.42e6:1.47e6);

dataIn = data.raw_samp;

% data filtered by BW@Lab, BW and CC@ filter
dataFilt_Lab = filter(LabBWfilt, dataIn);
dataFilt_BW = filter(PropBWfilt, dataIn);
dataFilt_CC2 = filter(PropCC2filt, dataIn);

% data filtered by BW@Lab, BW and CC@ filter with no phase shift delay
dataFilt_NoPhS_Lab = filtfilt(sos_var1,g1, dataIn);
dataFilt_NoPhS_BW = filtfilt(sos_varBW,gBW, dataIn);
dataFilt_NoPhS_CC2 = filtfilt(sos_varCC2,gCC2, dataIn);

figure(2)
ax31 = subplot(3,1,1);
plot(dataIn,'y'); hold on
plot(dataFilt_NoPhS_Lab, 'c'); hold on
plot(dataFilt_Lab, 'b'); hold on
ylim([-500 500])
xlim([1 length(dataIn)])
title('Time domain data by using butterworth filter at Lab')
legend('raw data', 'Filtered data','Filtfilt data')
grid on

ax32 = subplot(3,1,2);
plot(dataIn,'y'); hold on
plot(dataFilt_NoPhS_BW, 'k'); hold on
plot(dataFilt_BW, 'g'); hold on
title('Time domain data by using proposed butterworth filter')
legend('raw data', 'Filtered data','Filtfilt data')
grid on

ax33 = subplot(3,1,3);
plot(dataIn,'y'); hold on
plot(dataFilt_NoPhS_CC2, 'c'); hold on
plot(dataFilt_CC2, 'r'); hold on
title('Time domain data by using proposed chebyshev filter')
legend('raw data', 'Filtered data','Filtfilt data')
grid on

linkaxes([ax31, ax32, ax33],'xy')