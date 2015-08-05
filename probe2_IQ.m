%for i = 1:numel(A)
%    if mod(i,3) == 0 B(ceil(i/3),1) = A(i); end;
%    if mod(i,3) == 1 B(ceil(i/3),2) = A(i); end;
%    if mod(i,3) == 2 B(ceil(i/3),3) = A(i); end;
%end;

%for i = 1:numel(A)
%    if mod(i,2) == 0 B(ceil(i/2),1) = A(i); end;
%    if mod(i,2) == 1 B(ceil(i/2),2) = A(i); end;
%end;

fprintf(VSA,':CALC:SPEC:MARK1:FUNC BPOW');
pause(2);

fprintf(VSA,':CALC:SPEC:MARK1:FUNC:BAND:SPAN 20 MHz');
pause(2);