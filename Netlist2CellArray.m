function Netlist_CellArray = Netlist2CellArray(netlist_file)
    fileID= fopen(netlist_file,'r','n','UTF-8');
    
    n=1;
    pat= lettersPattern;
    
    while(~feof(fileID))
        nline = fgetl(fileID);
        if(~contains(nline,'.end') && ~contains(nline,'*') && ~contains(nline,'.backanno')) 
           splitted_nline = strsplit(nline);
           NumVal= sip2num(splitted_nline{:,4});
           
           %Define the type of element
           elem_Type = splitted_nline{:,1};
           elem_Type = cell2mat(extract(elem_Type,pat));
           %elem_Type(1,1);
    
           %For stubs and tranmision lines get Bl and frequency
           if elem_Type=="SOC" || elem_Type=="SSC" || elem_Type=="TL" 
               Bl= str2num(splitted_nline{:,5});
               freq=str2num(splitted_nline{:,6});
           else
               Bl=0;
               freq=0;
           end
    
           %Create custom cell array from netlist info 
           %Name, 1st Node, 2nd Node, type, Value
           Netlist_CellArray(n,:) = [splitted_nline{:,1}, splitted_nline{:,2}, splitted_nline{:,3}, {elem_Type}, {NumVal}, Bl, freq]; 
           n=n+1;
        end
    end
end   