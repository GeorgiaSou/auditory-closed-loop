% -------------------------------------------------------------------------
% Compare the BWLab, BWProp and CC2 filters
% -------------------------------------------------------------------------
clear all; close all;

% -------------------------------------------------------------------------
load('D:\SWS_Chord_PN\data\comp_filters\BWLab\BWLab.mat')

raw_samp_filt_BWLab=raw_samp_filt;
raw_samp_filtfilt_BWLab=raw_samp_filtfilt;
trigger_offline_filt_BWLab=trigger_offline_filt;
sw_detect_filt_BWLab=sw_detect_filt;
sw_detect_BWLab=sw_detect;
trigger_offline_BWLab=trigger_offline;

clear raw_samp_filt raw_samp_filtfilt trigger_offline_filt sw_detect_filt sw_detect trigger_offline

% -------------------------------------------------------------------------
load('D:\SWS_Chord_PN\data\comp_filters\BWProp\BWProp.mat')

raw_samp_filt_BWProp=raw_samp_filt;
raw_samp_filtfilt_BWProp=raw_samp_filtfilt;
trigger_offline_filt_BWProp=trigger_offline_filt;
sw_detect_filt_BWProp=sw_detect_filt;
sw_detect_BWProp=sw_detect;
trigger_offline_BWProp=trigger_offline;

clear raw_samp_filt raw_samp_filtfilt trigger_offline_filt sw_detect_filt sw_detect trigger_offline
clear g_SW gBW Hd_but1 PropBWfilt sos_SW sos_varBW sw sw_filt 

% -------------------------------------------------------------------------
load('D:\SWS_Chord_PN\data\comp_filters\CC2\CC2.mat')

raw_samp_filt_CC2=raw_samp_filt;
raw_samp_filtfilt_CC2=raw_samp_filtfilt;
trigger_offline_filt_CC2=trigger_offline_filt;
sw_detect_filt_CC2=sw_detect_filt;
sw_detect_CC2=sw_detect;
trigger_offline_CC2=trigger_offline;

clear raw_samp_filt raw_samp_filtfilt trigger_offline_filt sw_detect_filt sw_detect trigger_offline
clear sos_varCC2 gCC2 PropCC2filt sw sw_filt

% -------------------------------------------------------------------------
x_BWLab=find(sw_detect_BWLab==0);
raw_samp_filtfilt_BWLab_SW=raw_samp_filtfilt_BWLab;
raw_samp_filtfilt_BWLab_SW(x_BWLab)=0;

x_BWProp=find(sw_detect_BWProp==0);
raw_samp_filtfilt_BWProp_SW=raw_samp_filtfilt_BWProp;
raw_samp_filtfilt_BWProp_SW(x_BWProp)=0;

x_CC2=find(sw_detect_CC2==0);
raw_samp_filtfilt_CC2_SW=raw_samp_filtfilt_CC2;
raw_samp_filtfilt_CC2_SW(x_CC2)=0;

% -------------------------------------------------------------------------
plot(raw_samp_filtfilt_BWLab)
hold on
plot(raw_samp_filtfilt_BWProp,'g')
hold on
plot(raw_samp_filtfilt_CC2,'r')
legend('filtfilt BWLab','filtfilt BWProp','filtfilt CC2')
h=refline(0);
g=refline([0 30]);
set(h,'color','k')
set(g,'color','k')
xlabel('Samples')
ylabel('Amplitude')
