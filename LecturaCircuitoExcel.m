function Matriz_nodos = LecturaCircuitoExcel(Netlist,F)
Netlist = Netlist;
Tabla3 = table2cell(Netlist);                   %Convierto la netlist de tabla a celdas para operar con ella
Nodos = unique(Netlist(:,"NodoInicial"));       %Leo los nodos que tengo
Nodos = table2cell(Nodos);                      %Convierto los nodos de tabla a celdas para operar con ella
sz_nodos = size(Nodos);
sz_tabla3 = size(Tabla3);
Cantidad_nodos = sz_nodos(1,1);
F = F;
Matriz_nodos =zeros(sz_nodos(1,1));                               %Se crea una matriz de NxN donde N es la cantidad de puertos

for i = 1 : sz_nodos(1,1)                                         %Iteracion en la cantidad de nodos para los renglones
    for j = 1 : sz_nodos(1,1)                                     %Iteracion en la cantidad de nodos para las columas
        for k = 1: sz_tabla3(1,1)                                 %Iteracion para determinar los componentes en respectivo punto de la matriz nodal   

            if strcmpi(Nodos(i,1),Nodos(j,1))                      %Diagonal principal de la matriz de nodos
                
                if strcmpi(Nodos(j,1),Tabla3(k,2)) | strcmpi(Nodos(j,1),Tabla3(k,3));    %siempre que el nodo en analisis este presnete se sumara                
                    Matriz_nodos(i,j) = Matriz_nodos(i,j) + 1/(Impedancia(cell2mat(Tabla3(k,4)),cell2mat(Tabla3(k,5)),F));
                end

            else        %%diagonales los elementos que interactuan con el nodo principal y no principal
                if (strcmpi(Nodos(j,1),Tabla3(k,2)) | strcmpi(Nodos(j,1),Tabla3(k,3))) & (strcmpi(Nodos(i,1),Tabla3(k,2)) | strcmpi(Nodos(i,1),Tabla3(k,3)));
                    Matriz_nodos(i,j) = Matriz_nodos(i,j) - 1/cell2mat(Tabla3(k,5));
                    
                end
            
            end

        end    
    end
end