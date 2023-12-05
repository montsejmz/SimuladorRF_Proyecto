function Z_Matrix = Z_parameters(Netlist_CellArray, Start_Freq, End_Freq, Step, Port_Num) 
            
    %calculate the number of nodes for the matrix size
    NetlistCASize = size(Netlist_CellArray);
    nodesC2 = Netlist_CellArray(:,2); %elements start nodes
    nodesC3 = Netlist_CellArray(:,3); %elements end nodes
    allNodesConn = [nodesC2; nodesC3];
    AllNodes = unique(allNodesConn,'sorted'); 
    Nodes = AllNodes(2:end); %Remove the reference node N0 (assumed it will always be named as that an therefore be at the top of the arrray)
    NodesNum = length(Nodes); 
    Nodes_Matrix = zeros(NodesNum,NodesNum); %Se crea una matriz de NxN donde N es la cantidad de puertos
    Y_Parameter_Matrix = zeros(Port_Num,Port_Num); %Temp variable, not exacly Y parameter matrix 
    Z_Parameter_Matrix = zeros(Port_Num,Port_Num);
    Z_Matrix = zeros(Port_Num,Port_Num, Step);
    Step_num = 0; 

    if NetlistCASize(1,1) == 1 %Netlist has a single element, therefore a series or shunt element or NodesNum == 2 (including gnd)
        %For file netlist.net ground = 0, while for netlist.xlsx ground = N0
        if (ismember('N0', AllNodes) || ismember('0', AllNodes))
            for F = Start_Freq:(End_Freq-Start_Freq)/(Step-1):End_Freq
                Step_num = Step_num + 1;
                % ------ MODIFICADO DISTRIBUIDOS---
                Bl=Netlist_CellArray{1,6};
                opFreq=Netlist_CellArray{1,7};
                Z_Matrix(:,:,Step_num) = (Calc_Impedance(Netlist_CellArray{1,4},Netlist_CellArray{1,5},F,Bl,opFreq));
                % --------------------
            end
        else
            Z_Matrix(:,:) = 0; %Series element doesnt have Z param
        end
   
    else  %Netlist has more than 1 row  

        for F = Start_Freq:(End_Freq-Start_Freq)/(Step-1):End_Freq
            Step_num = Step_num + 1;
            Nodes_Matrix = Nodes_Matrix_Fun(Netlist_CellArray,F); %Nodes_Matrix_fun function   

            for i=1 : Port_Num
                RedRow_Nodes_Matrix = Nodes_Matrix;  %Esta igualacion se usa para guardar la matriz de Nodes_Matrix temporalmente y en la siguiente linea se 
                RedRow_Nodes_Matrix(i,:) = [];          %elimina un renglon, esto es para crear las matrices reducidas 11, 12,  21, etc.
            
                for j = 1 : Port_Num
                    RedCol_Nodes_Matrix = RedRow_Nodes_Matrix;                  
                    RedCol_Nodes_Matrix(:,j) = [];      %lo mismo que en el caso anterior pero para eliminar columnas
            
                    Y_Parameter_Matrix(i,j) = (det(Nodes_Matrix)/det(RedCol_Nodes_Matrix));  %Port admitance (since it is a nodes matriz), meaning Y parameter (escalar value)
            
                     if j ~= i
                        if (rem(i,2) == 1 && rem(j,2) == 0) || (rem(i,2) == 0 && rem(j,2) == 1)  
                            Z_Parameter_Matrix(i,j) =  -1/Y_Parameter_Matrix(i,j);            
                         else 
                             Z_Parameter_Matrix(i,j) =  1/Y_Parameter_Matrix(i,j);
                         end
                     else %j==i
                        Z_Parameter_Matrix(i,j) =  1/Y_Parameter_Matrix(i,j);        %Conversion de Parameter Y a Z diagonal principal.
                     end
                end
            
            end
    
            Z_Matrix(:,:,Step_num) = Z_Parameter_Matrix;
        end
    end
end