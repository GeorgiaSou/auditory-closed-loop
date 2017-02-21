% -------------------------------------------------------------------------
% Delay of the filter BW
% -------------------------------------------------------------------------
clear all;
close all;

filter_case = 'CC2';   % 'BWLab' or 'BWProp' or 'CC2'

switch filter_case
    
    case 'BWLab'
        load('D:\SWS_Chord_PN\data\comp_filters\BWLab\BWLab.mat')
        
    case 'BWProp'
        load('D:\SWS_Chord_PN\data\comp_filters\BWProp\BWProp.mat')
        
    case 'CC2'
        load('D:\SWS_Chord_PN\data\comp_filters\CC2\CC2.mat')
end

%grpdelay(Hd_but1)

% -------------------------------------------------------------------------
% Slow Wave extraction
% -------------------------------------------------------------------------

% SWs from raw EEG extracted with filtfilt
x=find(sw_detect==0);
raw_samp_SW=raw_samp;
raw_samp_SW(x)=0;

% SWs from filt EEG extracted with filt
x=find(sw_detect_filt==0);
raw_samp_filt_SW=raw_samp_filt;
raw_samp_filt_SW(x)=0;

% SWs from filtfilt EEG extracted with filtfilt
x=find(sw_detect==0);
raw_samp_filtfilt_SW=raw_samp_filtfilt;
raw_samp_filtfilt_SW(x)=0;


%% Plot data with trigger_offline_filt
% -------------------------------------------------------------------------
% plot triggers and SW borders
figure
plot(raw_samp_filtfilt_SW)
hold on
plot(trigger_offline_filt,raw_samp_filtfilt_SW(trigger_offline_filt),'*')
hold on
plot(raw_samp_filt_SW,'r')
hold on
plot(trigger_offline_filt,raw_samp_filt_SW(trigger_offline_filt),'*r')
legend('filtfilt EEG','triggers with filt','filt EEG','triggers with filt')
hold on
for idx = 1 : length(sw)
    plot([sw(idx) sw(idx)], [min(raw_samp_filtfilt_SW) max(raw_samp_filtfilt_SW)]);
end
hold on
for idx = 1 : length(sw_filt)
    plot([sw_filt(idx) sw_filt(idx)], [min(raw_samp_filt_SW) max(raw_samp_filt_SW)],'r');
end
h=refline(0);
g=refline([0 30]);
set(h,'color','k')
set(g,'color','k')
xlabel('Samples')
ylabel('Amplitude')
title(['Filt and Filtfilt SWs with triggers from filt - ',filter_case])

%% Phase extraction
% -------------------------------------------------------------------------

hilb = hilbert(raw_samp_filt');
sigphase_filt = angle(hilb);
sigphase_degree_filt=(sigphase_filt+pi)./pi.*180;
clear hilb 

hilb = hilbert(raw_samp_filtfilt');
sigphase_filtfilt = angle(hilb);
sigphase_degree_filtfilt=(sigphase_filtfilt+pi)./pi.*180;
clear hilb 

sample_SW_hit=trigger_offline_filt(find(raw_samp_filtfilt_SW(trigger_offline_filt)));

phase_filt=sigphase_degree_filt(sample_SW_hit);
phase_filtfilt=sigphase_degree_filtfilt(sample_SW_hit);

% -------------------------------------------------------------------------
% polar histogram of phase hit at common detected SWs
figure
h1=rose(sigphase_filt(sample_SW_hit)+pi,12);
hold on
h=rose(sigphase_filtfilt(sample_SW_hit)+pi,12);
t=title(['Phase analyis on SWs detected both by filt and filtfilt - ',filter_case]);
set(t,'FontSize',18)

% x1 = get(h1, 'XData') ;
% y1 = get(h1, 'YData') ;
% p1 = patch(x1, y1,'b') ;
% 
% x = get(h, 'XData') ;
% y = get(h, 'YData') ;
% p = patch(x, y, 'g') ;

set(h1,'LineWidth',2.5)
set(h,'LineWidth',2.5,'Color','g')
l=legend('phase of filt EEG','phase of filtfilt EEG');
%set(l,'FontSize',18,'Position',[0.5 0.75 0.67 0.15])
get(l,'Position')
% -------------------------------------------------------------------------
% polar histogram of 
% plot triggers and SW borders
figure
plot(raw_samp_filtfilt)
hold on
plot(trigger_offline_filt,raw_samp_filtfilt(trigger_offline_filt),'*')
hold on
plot(raw_samp_filt,'r')
hold on
plot(trigger_offline_filt,raw_samp_filt(trigger_offline_filt),'*r')
legend('filtfilt EEG','triggers with filt','filt EEG','triggers with filt')
hold on
for idx = 1 : length(sw)
    plot([sw(idx) sw(idx)], [min(raw_samp_filtfilt) max(raw_samp_filtfilt)]);
end
hold on
for idx = 1 : length(sw_filt)
    plot([sw_filt(idx) sw_filt(idx)], [min(raw_samp_filt) max(raw_samp_filt)],'r');
end
hold on 
plot(raw_samp,'g')
h=refline(0);
g=refline([0 30]);
set(h,'color','k')
set(g,'color','k')
xlabel('Samples')
ylabel('Amplitude')
title(['Filt and Filtfilt SWs with triggers from filt - ',filter_case])







