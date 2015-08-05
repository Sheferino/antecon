function close_VSA(VSA)
    fprintf(VSA,':CAL:AUTO ON');
    fclose(VSA);
end