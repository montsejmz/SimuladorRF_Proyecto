        function Nodes_Matrix = Nodes_Matrix_Fun(Netlist_CellArray, Freq) 
            Size_NodesCellArray = size(Netlist_CellArray);

            %calculate the number of nodes for the matrix size
            nodesC2 = Netlist_CellArray(:,2); %elements start nodes
            nodesC3 = Netlist_CellArray(:,3); %elements end nodes
            allNodesConn = [nodesC2; nodesC3];
            Nodes = unique(allNodesConn,'sorted'); 
            Nodes = Nodes(2:end); %Remove the reference node N0 (assumed it will always be named as that an therefore be at the top of the arrray)
            NodesNum = length(Nodes); 
            Nodes_Matrix = zeros(NodesNum,NodesNum); %Se crea una matriz de NxN donde N es la cantidad de puertos
            
            for i = 1 : NodesNum                                  %Iteracion en la cantidad de nodos para los renglones
                for j = 1 : NodesNum                              %Iteracion en la cantidad de nodos para las columas
                    for k = 1: Size_NodesCellArray(1,1)           %Iteracion para determinar los componentes en respectivo punto de la matriz nodal   
            
                        if strcmpi(Nodes(i),Nodes(j))             %Diagonal principal de la matriz de nodos
                            if strcmpi(Nodes(j),Netlist_CellArray(k,2)) || strcmpi(Nodes(j),Netlist_CellArray(k,3))    %siempre que el nodo en analisis este presente se sumara 
                                % -------- MODIFICADO DISTRIBUIDOS -----
                                Componente=Netlist_CellArray{k,4};
                                Bl=Netlist_CellArray{k,6};       % Para concentrados Bl=0 y no tiene efecto en Calc_Impedancia
                                opFreq=Netlist_CellArray{k,7};   % Para concentrados opFreq=0 y no tiene efecto en Calc_Impedancia
                                Nodes_Matrix(i,j) = Nodes_Matrix(i,j) + 1/(Calc_Impedance(Netlist_CellArray{k,4},Netlist_CellArray{k,5},Freq,Bl,opFreq));
                            end
                        else  %diagonales los elementos que interactuan con el nodo principal y no principal
                            if (strcmpi(Nodes(j),Netlist_CellArray(k,2)) || strcmpi(Nodes(j),Netlist_CellArray(k,3))) && (strcmpi(Nodes(i),Netlist_CellArray(k,2)) || strcmpi(Nodes(i),Netlist_CellArray(k,3)))
                                % --------- MODIFICADO DISTRIBUIDOS-------
                                Bl=Netlist_CellArray{k,6};       % Para concentrados Bl=0 y no tiene efecto en Calc_Impedancia
                                opFreq=Netlist_CellArray{k,7};   % Para concentrados opFreq=0 y no tiene efecto en Calc_Impedancia
                                Nodes_Matrix(i,j) = Nodes_Matrix(i,j) - 1/(Calc_Impedance(Netlist_CellArray{k,4},Netlist_CellArray{k,5},Freq,Bl,opFreq));
                            end
                        end
            
                    end    
                end
            end
        end