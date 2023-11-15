function G=CalculoMatrizG(D,f,Num_Nodos)
    G=zeros(Num_Nodos,Num_Nodos); %Actualizar para que dependa del numero de nodos
    %f=20E3;
    w=2*pi*f;  % R
    
    for i=1:size(D,1)
    % ------------------- Para calcular la diagonal
    
        % Analizando los nodos finales
         if D(i,1,3)=='N' 
             Nodo=D(i,:,3);
             Nodo_n=str2double(Nodo(2:length(Nodo))); % valor numerico del nodo como 0001 o 0002
             
             if D(i,1,1)=='R' || D(i,1,1)=='L' || D(i,1,1)=='C' 
                Z=Z_nodof(D(i,1,1),D(i,:,4),w);
                G(Nodo_n,Nodo_n)=(1/Z)+G(Nodo_n,Nodo_n);
             end
             
         end
    
         %Analizando los nodos iniciales
         if D(i,1,2)=='N'
             Nodo=D(i,:,2);
             Nodo_n=str2double(Nodo(2:length(Nodo))); % valor numerico del nodo
    
            if D(i,1,1)=='R' || D(i,1,1)=='L' || D(i,1,1)=='C' 
                Z=Z_nodof(D(i,1,1),D(i,:,4),w);
                G(Nodo_n,Nodo_n)=(1/Z)+G(Nodo_n,Nodo_n);
            end
         end
    
    %--------------- Para los demas terminos-------
    
    % Van los componentes que estan entre dos nodos
    
        if D(i,1,2)=='N' && D(i,1,3)=='N'
            NodoFinal=D(i,:,3);
            fila=str2double(NodoFinal(2:length(NodoFinal)));
            NodoInicial=D(i,:,2);
            columna=str2double(NodoInicial(2:length(NodoFinal)));
    
            if D(i,1,1)=='R' || D(i,1,1)=='L' || D(i,1,1)=='C' 
                Z=Z_nodof(D(i,1,1),D(i,:,4),w);
                G(fila,columna)=-(1/Z)+G(fila,columna);
                G(columna,fila)=-(1/Z)+G(columna,fila);
            end
    
        end
    
    end
end