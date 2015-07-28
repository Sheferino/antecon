function probe1(VSA)
    
    
    st = query(VSA,'*IDN?');
    disp (st);
    
    %fprintf(VSA,':SYST:PRES');
    %pause(0.5);
    
    %fprintf(VSA,':CONF:CHP');
    %pause(0.5);
       
    fprintf(VSA,':FREQ:CENT 1000 MHz');
    fprintf(VSA,':CHP:BAND:INT 40 MHz');
    
    fprintf(VSA,':CHP:AVER ON');
    fprintf(VSA,':CHP:AVER:COUNt 1000');
    
    i = 0;
    while i == 0
        st = query(VSA,':CHP:AVER:COUNt?');
        i = str2double(st);
        pause(0.1);
        disp('still wait');
        disp(st);
    end;
    
    st = query(VSA,':READ:CHP:CHP?');
    disp(st);

end
