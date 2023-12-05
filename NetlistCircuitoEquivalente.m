function nueva_netlistCell= NetlistCircuitoEquivalente(netlistCell)
    

    % Inicialización de variable para guardar info
    X=1;
    X2=1;
    
        % Se recorre el netlist para encontrar distribuidos
    for i=1:size(netlistCell,1)

            
            nodoInicial=netlistCell{i,2};
            nodoFinal=netlistCell{i,3};
            type=cell2mat(netlistCell(i,4));
            value=cell2mat(netlistCell(i,5));
            Bl= cell2mat(netlistCell(i,6));
            Bl=deg2rad(Bl);
            opFreq=cell2mat(netlistCell(i,7));
    
            if type=='TL'
                % Guarda informacion de los distribuidos
                Info(X,:)={nodoInicial,nodoFinal,value,Bl,opFreq};
                X=X+1;
            else
                % Asigna directamente los elementos concentrados a la nueva
                % lista
                nueva_netlistCell(X2,:)=netlistCell(i,:);
                X2=X2+1;
            end
    
    end
    
    % Con la información obtenida, crea el nuevo netlist
    for j=1:size(Info,1)
        
        % Agregar circuito equivalente
        % Y1=Y12, Y2=Y11-Y12 y Y3=Y22-Y12
       
        Y1=[{'TL_Y1'},{Info{j,1}},{Info{j,2}},{'TL_Y1'},{Info{j,3}},{Info{j,4}},{Info{j,5}}];
        Y2=[{'TL_Y2'},{Info{j,1}},{'0'},{'TL_Y2'},{Info{j,3}},{Info{j,4}},{Info{j,5}}];
        Y3=[{'TL_Y3'},{Info{j,2}},{'0'},{'TL_Y3'},{Info{j,3}},{Info{j,4}},{Info{j,5}}];
        
        % Se guardan las nuevas impedancias al netlist
        last_column=size(nueva_netlistCell,1)+1;
        nueva_netlistCell(last_column:last_column+2,:)=[Y1;Y2;Y3];

    end
     

end