function nueva_netlistCell= NetlistCircuitoEquivalente(netlistCell)
    

    % Inicialización de variable para guardar info
    X=1;
    X2=1;

    nueva_netlistCell= {};
    
        % Se recorre el netlist para encontrar distribuidos
    for i=1:size(netlistCell,1)

            
            nodoInicial=netlistCell{i,2};
            nodoFinal=netlistCell{i,3};
            type=cell2mat(netlistCell(i,4));
            value=cell2mat(netlistCell(i,5));
            Bl= cell2mat(netlistCell(i,6));
            Bl=deg2rad(Bl);
            opFreq=cell2mat(netlistCell(i,7));

            pat=digitsPattern;
            nodoFinalCero=cell2mat(extract(nodoFinal,pat));
    
            if type=="TL" && nodoFinalCero~="0" 
                % Guarda informacion de las lineas de transmision
                Info(X,:)={nodoInicial,nodoFinal,value,Bl,opFreq,type};
                X=X+1;
            elseif type=="TL" && nodoFinalCero=="0" 
                % Una linea de transmision a Tierra es un stub en corto circuito
                newType= 'SSC'
                nueva_netlistCell(X2,:)=[{newType},{nodoInicial},{nodoFinal},{newType},{value},netlistCell{i,6},{opFreq}];
                X2=X2+1;
            else
                % Asigna directamente los elementos concentrados a la nueva
                % lista
                nueva_netlistCell(X2,:)=netlistCell(i,:);
                X2=X2+1;
            end
    
    end
    
    % Con la información obtenida, crea el nuevo netlist
    % Variable Info no existe cuando una netlist es completamente de concentrados
    if exist("Info","var")
        for j=1:size(Info,1)
        
        % Agregar circuito equivalente
        % Y1=Y21, Y2=Y11+Y12 y Y3=Y22+Y12
        tipo=Info{j,6};
        
        NombreY1=[tipo '_Y1'];
        NombreY2=[tipo '_Y2'];
        NombreY3=[tipo '_Y3'];

        Y1=[{NombreY1},{Info{j,1}},{Info{j,2}},{NombreY1},{Info{j,3}},{Info{j,4}},{Info{j,5}}];
        Y2=[{NombreY2},{Info{j,1}},{'0'},{NombreY2},{Info{j,3}},{Info{j,4}},{Info{j,5}}];
        Y3=[{NombreY3},{Info{j,2}},{'0'},{NombreY3},{Info{j,3}},{Info{j,4}},{Info{j,5}}];
        
        % Se guardan las nuevas impedancias al netlist
        last_column=size(nueva_netlistCell,1)+1;
        nueva_netlistCell(last_column:last_column+2,:)=[Y1;Y2;Y3];

        end
    end
    
    % Se busca si no hay nodo de Tierra, significa que estan en serie

    nodesC2 = nueva_netlistCell(:,2); %elements start nodes
    nodesC3 = nueva_netlistCell(:,3); %elements end nodes
    allNodesConn = [nodesC2; nodesC3];
    Nodes = unique(allNodesConn,'sorted');

    pat=digitsPattern;
    firstNode=cell2mat(extract(Nodes{1,1},pat));
    
    seriesType='';
    seriesValue=[];
    seriesBl=[];
    seriesopFreq=[];

    if firstNode ~="0"
        for j=1:size(nueva_netlistCell,1)
           tipo2=nueva_netlistCell{j,4};
           seriesType= [tipo2, ',',seriesType];

           value2=nueva_netlistCell{j,5};
           seriesValue= [value2, seriesValue];

           Bl2=nueva_netlistCell{j,6};
           seriesBl= [Bl2, seriesBl];

           opFreq2=nueva_netlistCell{j,7};
           seriesopFreq= [opFreq2, seriesopFreq];

           nueva_netlistCell(1,:)=['Series','N001','N002',{seriesType},{seriesValue},{seriesBl},{seriesopFreq}];
        end

        nueva_netlistCell=nueva_netlistCell(1,:);
    end

    
     
end