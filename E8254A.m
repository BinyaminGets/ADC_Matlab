 

classdef E8254A

    % E8254A Signal Generator programming class for Matlab

    % example:

    %   sigen=E8254A('192.168.1.6',7777);

    %   sigen.reset();

    %

    % type id.a_HELP_ME() to get list of mathoods

   

    properties

        ip = '10.0.0.16';

        port = 7777;

    end % properties

   

    properties (SetAccess = protected, GetAccess = private)

        id;

        points;

    end

   

    methods

        function dev = E8254A(ip,port)   % Constructor

            if nargin > 0 % Support calling with 0 arguments

                dev.ip=ip;

                dev.port=port;

            end

           

            fprintf('\nConnecting to Signal Generator ...\n');

            dev.id = tcpip(dev.ip,dev.port);

            set(dev.id,'InputBufferSize',30000);

            set(dev.id,'Timeout',5);

            fopen(dev.id);

           

        end % Constructor

       

        function dev=close_port(dev)   % Close port

            % close instrumen

            disp('Disconnecting from Signal Generator...');

            fclose(dev.id);

%            delete(dev.id);

%            clear sigen;

        end % Constructor

       

        

        function dev=wait_complete(dev)   % wait for complete

            done=0;

            while (~done)

                fprintf(dev.id,'*OPC?');

                done=str2double(fscanf(dev.id));

                if isnan(done)

                    done=0;

                end

            end

           

                fprintf(dev.id,'*WAI');

           

        end  % wait for complete

       

        

        function dev=reset(dev)   % preset

            fprintf(dev.id,':SYSTem:PRESet');

           

        end % Reset

       

        

        function dev=SetAmp(dev,amp_dbm)   % set CW frequency

            fprintf(dev.id,['POW:AMPL ' num2str(amp_dbm) ' DBM']);

        end % Reset

 

        function dev=SetFreq(dev,freq_mhz)   % set CW frequency

            fprintf(dev.id,['FREQ:CW ' num2str(freq_mhz) ' MHZ']);

%            fprintf(dev.id,'FREQ:CW ');

 %           fprintf(dev.id,['FREQ ' num2str(freq_mhz) ' MHZ']);

        end % Reset

 

       

        function dev=RF_Off(dev)   % set CW frequency

            fprintf(dev.id,'OUTP OFF');

        end % Reset

       

        function dev=RF_On(dev)   % set CW frequency

            fprintf(dev.id,"OUTP ON");

        end % Reset

 

        function dev=ALC_Off(dev)   % set CW frequency

            fprintf(dev.id,'POW:ALC OFF');

        end % Reset

       

        function dev=ALC_On(dev)   % set CW frequency

            fprintf(dev.id,'POW:ALC ON');

        end % Reset

 

        function dev=FM_Off(dev)   % set CW frequency

            fprintf(dev.id,'FM2:STAT OFF');

        end % Reset

       

        function dev=FM_On(dev)   % set CW frequency

            fprintf(dev.id,'FM2:STAT ON');

        end % Reset

 

 

        function dev=Mode_Off(dev)   % set CW frequency

           fprintf(dev.id,':OUTPut:MODulation:STATe OFF');

        end % Reset

       

        function dev=Mode_On(dev)   % set CW frequency

            fprintf(dev.id,':OUTPut:MODulation:STATe ON');

        end % Reset

 
        function dev=hello(dev)
            fprintf(dev.id,"hello");
        end
 

      

%         function rbw_s=rbw(dev,rbw_khz)   % set RBW

%             if (nargin == 1) % when no arg read from spectrum

%                 rbw_s=str2double(query(dev.id,'BAND?'));

%             else

%                 if (rbw_khz==0)

%                     fprintf(dev.id,'BAND:AUTO ON');

%                 else

%                     fprintf(dev.id,['BAND ' num2str(rbw_khz) ' KHZ']);

%                 end

%             end % if

%         end % RBW

%        

%        

%

%         function tlvl_s=trig_level(dev,level_dBm)   % set trigger source

%             if (nargin == 1) % when no arg read from spectrum

%                 tlvl_s=str2double(query(dev.id,':TRIGger:SEQuence:VIDeo:LEVel?'));

%             else

%                 fprintf(dev.id,[':TRIGger:SEQuence:VIDeo:LEVel ' num2str(level_dBm) ' dBm' ]);

%             end %if

%         end % trigger source

%        

%         function data=read_trace(dev,tracenum)   % read trace data from spectrum

%             fprintf( dev.id, '*WAI' ); % wait for previuos command to complete

%             fprintf( dev.id, ['TRAC:DATA?']); % TRACE' num2str(trace_num)] );

%             data = typecast(uint8(binblockread(dev.id)),'single');

%         end  % read trace data from spectrum

%        

%        

%         function dev=wait_complete(dev)   % wait for complete

%             done=0;

%             while (~done)

%                 fprintf(dev.id,'*OPC?');

%                 done=str2double(fscanf(dev.id));

%                 if isnan(done)

%                     done=0;

%                 end

%             end

%            

%                 fprintf(dev.id,'*WAI');

%            

%         end  % wait for complete

%        

%        

%         function dev=trigger(dev)   % wait for trigger

%             fprintf( dev.id, 'INIT:CONT 0' ); % Trigger a sweep and wait for completion

%             fprintf( dev.id, 'INIT:IMM' ); % Trigger a sweep and wait for completion

%         end  % read trace data from spectrum

%        

%         function dev=trace_data_format_real32(dev)   % Set the data trace format to REAL

%             % Set the data trace format to REAL, 32 bits

%             fprintf(dev.id,'FORM REAL,32');

%         end  % Set the data trace format to REAL

%

%        

%         function dev=plot_trace(dev)   % read trace data from spectrum

%             fprintf(dev.id,':DISPlay:WINDow1:TRACe:Y:SCALe:RLEVel?');

%             ref_lev=str2double(fscanf(dev.id));

%            

%             %         fprintf( dev.id, 'INIT:IMM; *WAI;' ); % Trigger a sweep and wait for completion

%             fprintf( dev.id, 'TRAC:DATA?' );

%             ydata = typecast(uint8(binblockread(dev.id)),'single');

%                        

%             fprintf(dev.id,':FREQuency:STARt?');

%             start_s=str2double(fscanf(dev.id))/1e6;

%             

%             fprintf(dev.id,':FREQuency:STOP?');

%             stop_s=str2double(fscanf(dev.id))/1e6;

%            

%             incr = (stop_s - start_s) / (401 - 1);

%             xdata = start_s:incr:stop_s;

%            

%             figure(1)

%             plot((1:401),ydata);

%             % Adjust the x limits to the nr of points

%             % and the y limits for 100 dB of dynamic range

%             xlim([1 401])

%             ylim([ref_lev-100 ref_lev])

%             %         set(gca,'XTickLabel',xdata);

%            

%             grid on

%         end  % read trace data from spectrum

%        

        function dev=a_HELP_ME(dev)   % print HELP!

            disp (' you can use the following methods:');

            disp (' obj.close_port() - close the port to the spectrum');

            disp (' obj.reset() - reset the spectrum (green button)');

           

            

        end % print HELP!

       

        

    end% methods

   

    methods (Static)

    end % methods statics

   

end% classdef