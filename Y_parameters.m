function Y_Matrix = Y_parameters( Netlist_CellArray, Start_Freq, End_Freq, Step, Port_Num)
    
    %calculate the number of nodes for the matrix size
    NetlistCASize = size(Netlist_CellArray);
    nodesC2 = Netlist_CellArray(:,2); %elements start nodes
    nodesC3 = Netlist_CellArray(:,3); %elements end nodes
    allNodesConn = [nodesC2; nodesC3];
    AllNodes = unique(allNodesConn,'sorted'); 
    Step_num = 0; 

    if NetlistCASize(1,1) == 1 %Netlist has only one element, either a series or shunt element
        %For file netlist.net ground = 0, while for netlist.xlsx ground = N0
        if (ismember('N0', AllNodes) || ismember('0', AllNodes))
            Y_Matrix = zeros(2,2);
        else
            Y_Matrix = zeros(2,2, Step_num);
            for F = Start_Freq:(End_Freq-Start_Freq)/(Step-1):End_Freq
                Step_num = Step_num + 1;
                Bl=Netlist_CellArray{1,6};
                opFreq=Netlist_CellArray{1,7};
                Name=Netlist_CellArray{1,1};
                Y_Matrix(1,1,Step_num) = 1/(Calc_Impedance(Netlist_CellArray{1,4},Netlist_CellArray{1,5},F,Bl,opFreq,Name));
                Y_Matrix(1,2,Step_num) = -1/(Calc_Impedance(Netlist_CellArray{1,4},Netlist_CellArray{1,5},F,Bl,opFreq,Name));
                Y_Matrix(2,1,Step_num) = -1/(Calc_Impedance(Netlist_CellArray{1,4},Netlist_CellArray{1,5},F,Bl,opFreq,Name));
                Y_Matrix(2,2,Step_num) = 1/(Calc_Impedance(Netlist_CellArray{1,4},Netlist_CellArray{1,5},F,Bl,opFreq,Name));
            end
        end
    else %Netlist has more than one element 
        Z_Matrix = Z_parameters(Netlist_CellArray, Start_Freq, End_Freq, Step, Port_Num);
        Y_Matrix = pageinv(Z_Matrix);
    end
end