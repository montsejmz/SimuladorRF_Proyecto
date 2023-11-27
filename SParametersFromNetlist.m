function [SParamsObject]=SParametersFromNetlist(Netlist_CellArray,Start_Freq, End_Freq, Step, Z0)

    netlistCell= Netlist_CellArray;
    
    % Se crea el objeto de circuito
    circuito=circuit;
    
    % Crear y agregar componentes
    
    pat=digitsPattern; % Patron para quitar letras del nombre "L1", "C1", etc
    
    for i=1:size(netlistCell,1)
        
        name=cell2mat(netlistCell(i,1));
        nodoInicial=str2num(cell2mat(extract(netlistCell(i,2),pat)));
        nodoFinal=str2num(cell2mat(extract(netlistCell(i,3),pat)));
        type=cell2mat(netlistCell(i,4));
        value=cell2mat(netlistCell(i,5));
        Bl= cell2mat(netlistCell(i,6));
        Bl=deg2rad(Bl);
        opFreq=cell2mat(netlistCell(i,7));
        
    
        switch type
            case "R"
                add(circuito,[nodoInicial nodoFinal],resistor(value,name));
            case "L"
                add(circuito,[nodoInicial nodoFinal],inductor(value,name));
            case "C"
                add(circuito,[nodoInicial nodoFinal],capacitor(value,name));
            case "SOC"   % Open circuit (Capacitor)
                 Stub=txlineElectricalLength(LineLength=Bl,ReferenceFrequency=opFreq,StubMode="Series",Termination="Open",Z0=value,Name="StubOpen")
                 add(circuito,[nodoInicial nodoFinal],Stub);
    
            case "SSC"    % Short circuit (Inductor)
                Stub=txlineElectricalLength(LineLength=Bl,ReferenceFrequency=opFreq,StubMode="Series",Termination="Short",Z0=value,Name="StubCorto")
                add(circuito,[nodoInicial nodoFinal],Stub);
            case "TL"     % Tranmission line
                TL=txlineElectricalLength(LineLength=Bl,ReferenceFrequency=opFreq,Z0=value)
                add(circuito,[nodoInicial nodoFinal],Stub);
            otherwise
                disp("Ingrese un nombre valido")
        end
        
    end
    
    % Calcular parametros S
    setports(circuito,[1 0],[2 0]);
    circuito;
    freq=linspace(Start_Freq, End_Freq, Step);
    SParamsObject=sparameters(circuito,freq,Z0);

end
