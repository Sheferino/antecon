function [A, time] = get_VSA(VSA, f)
%f - MHz in string format
    
    fprintf(VSA,':SYSTem:PRESet');
    pause(0.1);
    
    fprintf(VSA,':INST:SEL BASIC');
    pause(0.1);
    
    fprintf(VSA,':CONF:WAV');
    pause(0.1);
    
    B = [':FREQ:CENT ' f ' MHz'];
    fprintf(VSA,B);
    pause(0.1);
    
    fprintf(VSA,':WAV:SRAT 40 MHz'); %change to 10.23 * 4 in real oper
    pause(0.1);
              
    fprintf(VSA,':FORMat REAL,32');
    pause(0.1);
    
    %fprintf(VSA,':INIT:PAUSe');
    %pause(0.1);
    
    fprintf(VSA,':READ:WAV0?');
    pause(0.5)
    %A(1:100000)=0;
    
    i = 1;
    while (get(VSA,'BytesAvailable') > 0)
        
        C(i) = fread(VSA,1,'float');
        pause(0.001);
        %disp(VSA.BytesAvailable); %del in real oper
        i = i+1;
    
    end;
    pause(0.1);
    
    fprintf(VSA,':FORM ASCii');
    pause(0.1);
    
    st = query(VSA,':READ:WAV1?');
    pause(0.1)
    
    time = str2double(strtok(st,','));
    pause(0.1)
    
    i = 1;
    while (get(VSA,'BytesAvailable') > 0)
       
        B(i) = fread(VSA,1,'float');
        pause(0.001);
        i = i+1;
    
    end;
    
    C(1)=[];
    %C(numel(C))=[];
    
    %A = reshape(C,numel(C)/2,2);
    
    for i = 1:numel(C)
        
        if i == numel(C) break; end;
        if mod(i,2) ~= 0 A(ceil(i/2),1)=C(i); end;
        if mod(i,2) == 0 A(ceil(i/2),2)=C(i); end;
        
    end;
    
    fprintf(VSA,':INIT:RESTart');
    pause(0.1);
               
end

%VSA =
%tcpip('172.20.254.227',5025,'ByteOrder','littleEndian','InputBufferSize',10000000);