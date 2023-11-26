function Parametros_Z_R = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos)
 Nodos = unique(Netlist(:,"NodoInicial"));
 Nodos_n = size(Nodos);
 Matriz_nodos_R = zeros(Nodos_n(1,1),Nodos_n(1,1), Muestreo);
 Parametros_Z_R = zeros(2,2, Muestreo);
 X = 0;
 sz = size(Netlist);
 Tabla3 = table2cell(Netlist);

if sz(1,1) == 1
    X1 = ismember('N0',table2array(Netlist(:,"NodoFinal")));
    X2 = ismember('N0',table2array(Netlist(:,"NodoInicial")));
    if (X1 == 1 | X2 == 1);
        
        for F = Frec_inicial:(Frec_final-Frec_inicial)/(Muestreo-1):Frec_final
        X = X + 1;
        Parametros_Z_R(:,:,X) = (Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        end
    else

        Parametros_Z_R(:,:) = 0;
        % Parametros_y_R = zeros(2,2, Muestreo);
        % for F = Frec_inicial:(Frec_final-Frec_inicial)/(Muestreo-1):Frec_final
        % X = X + 1;
        % Parametros_y_R(1,1,X) = 1/(Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        % Parametros_y_R(1,2,X) = -1/(Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        % Parametros_y_R(2,1,X) = -1/(Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        % Parametros_y_R(2,2,X) = 1/(Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        % end

    end


else    


 for F = Frec_inicial:(Frec_final-Frec_inicial)/(Muestreo-1):Frec_final
        X = X + 1;
       Matriz_nodos_R = Matriz_nodos(Netlist,F);

       Port_num = Num_Puertos;                     %Aqui se define la cantidad de puertos que queremos, de momento se deja en 2, esta declarada para
                                 %en caso de que se extrapole el metodo para mas puertos

        for i=1 : Port_num
            A = Matriz_nodos_R;            %Esta igualacion se usa para guardar la matriz de nodos y en la siguiente linea se 
            A(i,:) = [];                 %elimina un renglon, esto es para crear las matrices reducidas 11, 12,  21, etc.
        
            for j = 1 : Port_num
                B = A;                  
                z = [i,j];               %variable de control
                B(:,j) = [];            %lo mismo que en el caso anterior pero para eliminar columnas
        
                Parametros(i,j) = (det(Matriz_nodos_R)/det(B));  %Calculo de los parametros para calculas las impedancias
        
                 if j ~= i
                    if (rem(i,2) == 1 & rem(j,2) == 0) | (rem(i,2) == 0 & rem(j,2) == 1);  
                        Parametros_Z(i,j) =  -1/Parametros(i,j);            
                     else 
                         Parametros_Z(i,j) =  1/Parametros(i,j);
                     end
                 end
        
                  if j == i
                     Parametros_Z(i,j) =  1/Parametros(i,j);        %Conversion de parametros Y a Z diagonanl principal.
                  end
        
            end
        
        end

        Parametros_Z_R(:,:,X) = Parametros_Z;
 end
end

end

 % Parametros_Z_R = 1