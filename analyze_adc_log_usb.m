function analyze_adc_log_usb(adc_filename, channels, usb)

total_adc_channels = 16;
if(usb)
    full_scale = 2^13-1;
    fs= 20e6;
    m = dlmread(adc_filename, ',',[9, 1, 16008, 2]);
    channels = channels(1);
    z = m(:,1)+1i*m(:,2);
else   
    full_scale = 2^14-1;
    fs= 10e6;
    f1 = fopen(adc_filename, 'r');
    x = fread(f1, 'uint16');
    % x_bit16 = bitand(x,16384)*2;
    % x=bitor(x, x_bit16);
    fclose(f1);
    numbits = 15;
    x(x>(2^(numbits-1)-1))= x(x>(2^(numbits-1)-1))-2^numbits;
    num_samples = length(x)/(2*total_adc_channels);
    z = zeros(num_samples, total_adc_channels);
    
    for(k= 1:length(channels))
        channel_indx = channels(k);
        z(:,k)= (x(channel_indx*2-1:(2*total_adc_channels):(num_samples*2*total_adc_channels)))...
            + 1i*(x(channel_indx*2:(2*total_adc_channels):(num_samples*2*total_adc_channels)));
    end
end
y= fft(z);
y = y/length(y);
y=y/(sqrt(2)/2*full_scale);
spect = db(abs(y));
f= (0:(length(y)-1))*fs/length(y);
start_bin = 10;
for k=1:length(channels)
    fg = figure(k);
    [mx, mxindx]= max(spect(start_bin:end, k));
    mxindx = mxindx+start_bin-1;
    Mhz5_bw_indx = length(find(f<5e6));
    sig = spect(1:Mhz5_bw_indx, k);
    thd = 0;
    harmonics = (mxindx-1)*[2,3,4,5]+1;
    for tone = harmonics
        if tone > Mhz5_bw_indx
            break
        else
            thd = thd + abs(sig(tone)^2);
        end
    end
    thd = mx - db(thd, 'power');
    %check what units are of -150-150 and if those values are enough to
    %eliminate the main signal
    sig(mxindx+(-150:150)) = -inf;
    sig(1:6) = -inf;
    max_spur = max(sig);
    sfdr = round((mx - max_spur)*10)/10;
    noise_p = db(mean(10.^(sig/10)), 'power');
    sndr = round((mx-noise_p)*10)/10;
    peak_mag = round(mx*10)/10;
    peak_freq = round(fs*(mxindx-1)/length(spect(:,k)));
    plot(f, spect(:,k))
    grid on
    title(['Signal Spectrum CH' num2str(k)])
    xlabel('Frequency [Hz]')
    ylabel('Amp [dBFS]')
    xlim([0 fs/2]);
    ylim([-120 0]);
    yticks(-120:10:0)
    xticks(0:fs/20:fs/2)
    str1 = sprintf('peak:\nAmp %0.1f dBFS\nFreq %0.1f Hz\nSNDR %d dB\nSFDR %0.1f dB\nTHD %0.1f dB', peak_mag, peak_freq, sndr, sfdr, thd);
    annotation(fg, 'textbox',[0.5 0.6 0.3 0.3], 'String', str1);
    
    figure(100)
    subplot(length(channels),1,k)
    plot([real(z(:,channels(k))) imag(z(:,channels(k)))])
    
    title(['Signal Time Domain CH' num2str(k)])
    xlabel('Sample')
    ylabel('ADC Value')
    ylim([-10e3 10e3]);
    grid on
end
