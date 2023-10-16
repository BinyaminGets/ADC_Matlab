# ADC_Matlab
This project is ment to monitor the performance of the recievers.

# Overview
The output of the mixer of the reciever is I and Q. Both of the are sine waves shifted 90 deg on from each other. This is something
that we can check with osilloscop and see if the signals are right or not, and have the desired frequency (ATP test). The ADC test, converts those 
I and Q signals from analog to digital, transfer them via HIGH speed through the digital part of the reciever to the SOM, and displays those I and Q
on Matlab.

![image](https://github.com/BinyaminGets/ADC_Matlab/assets/136570559/ec743376-0d7d-4fc4-919e-13e78ed66354)


# Procedure
ADC test is the most important procedure of the system. It checks wheather the signals received are desired or not.
When we run ADC test according to the comments that are at the main file "connectToRadarAndRecord.m", we should get the FFT plots
of all the channles that we set for the check, and time domain plots. 

Desired result for each channel is:
1. One peak at 2MHz
2. maximum amplitude less than 0 DBFS
3. SNDR more than 50
4. SFDR around 40 (it might be less bc of wrong calculation)
5. THD around -50db

Notes:
1. For each reciever the amplitude should be the same, allowed difference is +- 2 DBFS
2. Indication that something is wrong when we see Harmonics on the plot
3. We would like to see only peak at 2MHZ and nothing else

This is an example for a good signal
   
![Capture](https://github.com/BinyaminGets/ADC_Matlab/assets/136570559/421b2ddc-b6f7-424c-8d9a-4d850a89ade5)
