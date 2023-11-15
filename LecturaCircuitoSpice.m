function [MatrizNodosNumerica,Num_Nodos]=LecturaCircuitoSpice(direccion)

    fileID= fopen(direccion,'r','n','UTF-8');
    Input=fscanf(fileID,'%c');
    
    A=strsplit(Input,'\n'); % Para separar por salto de renglon, la funcion da como salida tipo de dato celdas
    A=convertCharsToStrings(A); % Se convierte de celdas a strings para manipularlo mejor al separar
    
    % Se hace el for para quitar los renglones extras y a la vez separar por columnas con strsplit
    for i=2:length(A)-3
       B(i-1,1)=A(i);
       MatrizStr(i-1,:)=strsplit(B(i-1));  
    end
    
    % D matriz de 3 dimensiones ( fila (V,R,L,C, etc..), arreglos de chars, columna (componente,nodoInicial, nodoFinal,valor)
    % Son chars para que se pueda acceder a los caractereres individuales
    [Num_Nodos, MatrizStrNodosCorregidos]=RenombreNodos(MatrizStr);
    
    D=char(MatrizStrNodosCorregidos);
    MatrizNodosNumerica=ConvMatrizNumerica(D);
    
end