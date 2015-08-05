function A = get_VSA(VSA, f)
%f - MHz in string format
    
    fprintf(VSA,':SYSTem:PRESet');
    pause(0.5);
    
    fprintf(VSA,':INST:SEL BASIC');
    pause(0.5);
    
    fprintf(VSA,':CONF:SPEC');
    pause(0.5);
    
    B = [':FREQ:CENT ' f ' MHz'];
    fprintf(VSA,B);
    pause(0.5);
    
    fprintf(VSA,':SPEC:FREQ:SPAN 40 MHz');
    pause(0.5);
    
    fprintf(VSA,':SPECtrum:DIF:BANDwidth 40 MHz');
    pause(0.5);
    
    fprintf(VSA,':SPEC:BAND:RES 100 kHz');
    pause(0.5);
    
    %fprintf(VSA,':SPECtrum:AVERage:TACount 2')
    %pause(2);
        
    fprintf(VSA,':DISPlay:SPECtrum:VIEW1:WINDow2:TRACe:Y:COUPle ON');
    pause(0.1);
    
    fprintf(VSA,':FORMat REAL,32');
    pause(0.5);
    
    fprintf(VSA,':INIT:PAUSe');
    pause(0.5);
    
    fprintf(VSA,':READ:SPEC3?');
    %[B,N1] = fread(VSA,10002,'float32');
    [A,N1] = fread(VSA,10002,'float32');
    pause(0.5);
    
    fprintf(VSA,':INIT:RESTart');
    pause(0.5);
    
    %B(1) = []; %if 1st is wrong
    %N1 = N1-1;
    
    %for i = 1:10000
    %    if i == numel(B) break; end;
    %    if mod(i,2) ~= 0 A(ceil(i/2),1)=B(i); end;
    %    if mod(i,2) == 0 A(ceil(i/2),2)=B(i); end;
        
    %end;
               
end

%VSA =
%tcpip('172.20.254.227',5025,'ByteOrder','littleEndian','InputBufferSize',10000000);