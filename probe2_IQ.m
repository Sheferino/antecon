function A = probe2_IQ(VSA)
    
    fprintf(VSA,':SYSTem:PRESet');
    pause(2);
    
    fprintf(VSA,':INST:SEL BASIC');
    pause(2);
    
    fprintf(VSA,':CONF:SPEC');
    pause(2);
    
    fprintf(VSA,':FREQ:CENT 2000 MHz');
    pause(2);
    
    fprintf(VSA,':SPEC:FREQ:SPAN 40 MHz');
    pause(2);
    
    fprintf(VSA,':SPECtrum:DIF:BANDwidth 40 MHz');
    pause(2);
    
    fprintf(VSA,':SPEC:BAND:RES 100 kHz');
    pause(2);
    
    %fprintf(VSA,':SPECtrum:AVERage:TACount 2')
    %pause(2);
        
    fprintf(VSA,':DISPlay:SPECtrum:VIEW1:WINDow2:TRACe:Y:COUPle ON');
    pause(2);
    
    fprintf(VSA,':FORMat REAL,32');
    pause(2);
    
    fprintf(VSA,':INIT:PAUSe');
    pause(2);
    
    fprintf(VSA,':READ:SPEC3?');
    [B,N1] = fread(VSA,10002,'float32');
    
    fprintf(VSA,':INIT:RESTart');
    pause(2);
    
    %B(1) = [];
    %N1 = N1-1;
    
    for i = 1:10000
        if i == numel(B) break; end;
        if mod(i,2) ~= 0 A(ceil(i/2),1)=B(i); end;
        if mod(i,2) == 0 A(ceil(i/2),2)=B(i); end;
        
    end;
               
end

%VSA =
%tcpip('172.20.254.227',5025,'ByteOrder','littleEndian','InputBufferSize',10000000);