%we can run this code separatly or at connectToRadarAndRecord.m
clear all
close all
adc_filename =  ['D:\MATLAB_15_2_22\vec80_10dbm.log'];



channels = 1:16;
show_plots=1;
analyze_adc_log_usb(adc_filename, channels,0);

%adc_filename2 = ['C:\Users\User\OneDrive\Engineering\Projects\HLS\Matlab\Common\uartRecord.log'];
%analyze_adc_log(adc_filename2, channels,show_plots);
