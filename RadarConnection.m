classdef RadarConnection
    
    properties
        ip='10.0.0.69';
        port=57;
    end
    
    properties (SetAccess = public, GetAccess = public)
        id;
        result;
        
    end
    
    methods
        function radar=RadarConnection(ip,port)
            if nargin > 0 % Support calling with 0 arguments

                radar.ip=ip;

                radar.port=port;
            end
            fprintf('\nConnecting to Radar ...\n');
            radar.id = tcpip(radar.ip,radar.port);
            set(radar.id,'InputBufferSize',8000000);
            set(radar.id,'Timeout',30);
            fopen(radar.id);

        end
        
        function radar=close_port(radar)
            fprintf('\nDisconnecting from Radar...\n');
            fclose(radar.id);
        end
        
        function radar = tech_mode_on(radar)
            command="$1,TE,TON*9F\r";
            fprintf(radar.id,command);
            pause(10/1000);
        end
        
        function radar = set_state_recievers(radar,channel1,channel2,channel3,channel4)
            command="16,"+channel1+','+channel2+','+channel3+','+channel4;
            fprintf(radar.id,command);
            pause(1);
        end
        
        function radar=set_vector(radar,vector)
            fprintf(radar.id,vector);
            pause(1);
        end
        
        function radar = start_recording_and_get_results(radar,fileLog)
            fprintf(radar.id,'3,BI,1');
            pause(80/1000);
            res=fread(radar.id,8000000, 'uint8');
            fprintf(fileLog,"%s",res);
        end
    end
end