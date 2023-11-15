function Parametros_Z_R = Z_parameters2(MatrizNodos,Nodos_n, Frec_inicial, Frec_final, Muestreo,Num_Puertos)

 Matriz_nodos_R = zeros(Nodos_n(1,1),Nodos_n(1,1), Muestreo)
 Parametros_Z_R = zeros(2,2, Muestreo);
 X = 0;

 for F = Frec_inicial:(Frec_final-Frec_inicial)/(Muestreo-1):Frec_final
        X = X + 1;
       Matriz_nodos_R = CalculoMatrizG(MatrizNodos,F,Nodos_n);

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

