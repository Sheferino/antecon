function k = PW_calibr(PW,f_sig)               %PW self-calibration
       
        k = 0;
        
        fprintf(PW,'*RST');
        pause(0.1);
        
        fprintf(PW,':CAL1:ZERO:TYPe INT');
        pause(0.1);

        fprintf(PW,':CAL1:ZERO:AUTO ON');
        pause(0.1);

        fprintf(PW,':CAL1:AUTO ON');
        pause(0.1);
        
        fprintf(PW,':FORM ASCii');
        pause(0.1); 

        fprintf(PW,':CAL1');
        
        s = 1;
        while s ~= 0  
            s = str2double(query(PW,':STATus:OPERation:CAL?'));
            pause(0.5);
        end;
        
        B = [':FREQ ' f_sig ' MHz'];
        fprintf(PW,B);
        pause(0.1);

        fprintf(PW,':AVER:COUNt:AUTO ON')
        pause(0.1);

        fprintf(PW,':UNIT1:POW DBM')
        pause(0.1); 
        
        st = query(PW,':STATus:QUEStionable:CAL?');
        
        if str2double(st) == 0 
            k = 1;
        end;
            
    end %end calib_PW