function [Num_Nodos,C]= RenombreNodos(C)

% D matriz de 3 dimensiones ( fila (V,R,L,C, etc..), arreglos de chars, columna (componente,nodoInicial, nodoFinal,valor)
% Son chars para que se pueda acceder a los caractereres individuales
D=char(C);

%Variables auxiliares para el for
j=1;
d=1;

% Para tener en una matriz el valor numerico de todos los nodos en la red
for i=1:size(D,1)
    if D(i,1,2)=='N'
        Nodo=D(i,:,2);
        Nodo_n=str2double(Nodo(2:length(Nodo)));
        NodosT(j,1)=Nodo_n;
        NodosT(j,2)=i;
        j=j+1;

    end

    if D(i,1,3)=='N'
        Nodo=D(i,:,3);
        Nodo_n=str2double(Nodo(2:length(Nodo)));
        NodosT2(d,1)=Nodo_n;
        NodosT2(d,2)=i;
        d=d+1;
    end
   
end

maxNI=size(unique(C(:,2)),1)
maxNF=size(unique(C(:,3)),1)
Num_Nodos=max(maxNI, maxNF)-1  % Se le resta 1 por el nodo de Tierra

% Inicializar variable de nodos disponibles en 2 para dejar reservado el
% nodo 1
nodo_disponible=2;
nodo_disponible2=2;

% Se convierte la Columna 2 de Nodos Iniciales

for i=1:size(NodosT,1)
    if NodosT(i,1)==1 || NodosT(i,1)==Num_Nodos
        
        for j=1:size(NodosT,1)

            if(isempty(NodosT(NodosT(:,1)==nodo_disponible)) && isempty(NodosT2(NodosT2(:,1)==nodo_disponible)))
                C(NodosT(i,2),2)=["N"+num2str(nodo_disponible)];  % Se remplaza en la matriz C con strings
                NodosT2(NodosT2(:,1)==nodo_disponible)
                
            else
                nodo_disponible=nodo_disponible+1
            end
        end

    end
end

% Se convierte la Columna 3 de Nodos Finales

for i=1:size(NodosT2,1)
    if NodosT2(i,1)==1 || NodosT2(i,1)==Num_Nodos
        for j=1:size(NodosT2,1)
           
            if(isempty(NodosT2(NodosT2(:,1)==nodo_disponible2)) && isempty(NodosT(NodosT(:,1)==nodo_disponible2)))
                C(NodosT2(i,2),3)=["N"+num2str(nodo_disponible2)];  % Se remplaza en la matriz C con strings
            else
                nodo_disponible2=nodo_disponible2+1
            end
        end

    end
end

% Convertir nodos de V1 y V2 a N1 y N final

for i=1:length(C)
    for j=2:size(C,2)
        C(i,j)=strrep(C(i,j),"V1","N1");
        C(i,j)=strrep(C(i,j),"V2","N"+num2str(Num_Nodos));      
    end
end

end
