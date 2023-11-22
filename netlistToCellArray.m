%MAIN PROGRAM
%clear all
netlist_file = 'Rnetwork_portNamed.net'; %'CircuitoT2.net'; %'Rnetwork.net'%
%netlist_file = 'CircuitoT.net' %has C & L
Freq=20E3;

Netlist_CellArray = Netlist2CellArray(netlist_file);
Nodes_Matrix = Nodes_Matrix_Fun(Netlist_CellArray, Freq);



%The function assumes the ports are named as following:
%Reference node N0 and the the ports as N1, N2, ...Nn 
%While internal nodes are named after ports with the next consecutive
%number. In this case nodes and ports can have any name as long as they
%follow the acendent order (ports named fist then nodes).

%While if only ports are named (nodes names are assigned by the tool), 
%their name must start as N001 or with a leter before N in the alfabet so the line
%Nodes = unique(allNodesConn,'sorted'); in Nodes_Matrix_Fun()
%sorts all nodes and ports in the correct manner (ports first, then nodes),
%otherwise the sort will be backwards ej. port1 = 'N1', port2 = 'N2',
%int_node1 = 'N001', int_node2 = 'N002' <-- Named automatically by LTspice
%will get sorted as {'N001', 'N002', 'N1', 'N2'} where it should have been
%{'N1', 'N2', 'N001', 'N002'} as requested for the processing in
%Nodes_Matrix_Fun().s
function Netlist_CellArray = Netlist2CellArray(netlist_file)
fileID= fopen(netlist_file,'r','n','UTF-8');

n=1;
while(~feof(fileID))
    nline = fgetl(fileID);
    if(~contains(nline,'.') && ~contains(nline,'*')) 
       splitted_nline = strsplit(nline);
       NumVal= sip2num(splitted_nline{:,4});
       
       %Define the type of element
       elem_Type = splitted_nline{:,1};
       elem_Type = elem_Type(1,1);

       %Create custom cell array from netlist info 
       %Name, 1st Node, 2nd Node, type, Value
       Netlist_CellArray(n,:) = [splitted_nline{:,1}, splitted_nline{:,2}, splitted_nline{:,3}, {elem_Type}, {NumVal}]; 
       n=n+1;
    end
end
end        


%-------------------------------------------------------------------------------------------------------------------------------------
        function Z = Calc_Impedance(Elem_Type, Value, Freq)
            switch Elem_Type
                case 'R'
                    Z = Value;
                case 'L'
                    Z = 2*1i*pi*Value*Freq;
                case 'C'
                    Z = 1/(2*1i*pi*Freq*Value);
            end
        end

function Nodes_Matrix = Nodes_Matrix_Fun(Netlist_CellArray, Freq)
            %Netlist_CellArray = table2cell(Netlist_table);     %Convierto la netlist de tabla a celdas para operar con ella
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
                                Nodes_Matrix(i,j) = Nodes_Matrix(i,j) + 1/(Calc_Impedance(Netlist_CellArray{k,4},Netlist_CellArray{k,5},Freq));
                            end
                        else  %diagonales los elementos que interactuan con el nodo principal y no principal
                            if (strcmpi(Nodes(j),Netlist_CellArray(k,2)) || strcmpi(Nodes(j),Netlist_CellArray(k,3))) && (strcmpi(Nodes(i),Netlist_CellArray(k,2)) || strcmpi(Nodes(i),Netlist_CellArray(k,3)))
                                Nodes_Matrix(i,j) = Nodes_Matrix(i,j) - 1/(Calc_Impedance(Netlist_CellArray{k,4},Netlist_CellArray{k,5},Freq));
                            end
                        end
            
                    end    
                end
            end
        end