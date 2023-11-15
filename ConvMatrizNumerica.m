function matrizNumerica=ConvMatrizNumerica(Matriz)
    numero='';
    potencia='';
    for i=1:size(Matriz,1)
        valor=Matriz(i,:,4);
        valor_ind(i,:)=double(valor);

        for j=1:size(valor_ind,2)
            if valor_ind(i,j)>58
                potencia=char(valor_ind(i,j));

                switch valor_ind(i,j)
                    case double('f')  
                        potencia='E-15';
                    case double('p')   
                        potencia='E-12';
                    case double('n')
                        potencia='E-9';
                    case double('u')  
                        potencia='E-6';
                    case double('m')  
                        potencia='E-3';
                    case double('k')  
                        potencia='E3';
                    case double('M')   
                        potencia='E6';
                    case double('G')  
                        potencia='E9';
                    case double('T')  
                        potencia='E12';
                    case double('P')
                        potencia='E15';
                end
 
            elseif valor_ind(i,j)>=48 && valor_ind(i,j)<=57
                numero(i,j)= char(valor_ind(i,j));
            else
                % mandar mensaje de que se necesitan valores numericos
            end
        
           
        end
        
        valor_num=[numero(i,:) potencia];
        Matriz(i,1:length(valor_num),4)=valor_num;
        matrizNumerica=Matriz;
    end

end