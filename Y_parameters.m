function Parametros_Y = Y_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos)

 sz = size(Netlist);
 X = 0;
 Tabla3 = table2cell(Netlist);

if sz(1,1) == 1
    X1 = ismember('N0',table2array(Netlist(:,"NodoFinal")));
    X2 = ismember('N0',table2array(Netlist(:,"NodoInicial")));
    if (X1 == 1 | X2 == 1);
        Parametros_Y = zeros(2,2)
        % for F = Frec_inicial:(Frec_final-Frec_inicial)/(Muestreo-1):Frec_final
        % X = X + 1;
        % Parametros_Z_R(:,:,X) = (Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        % end
    else

        Parametros_Y = zeros(2,2, Muestreo);
        for F = Frec_inicial:(Frec_final-Frec_inicial)/(Muestreo-1):Frec_final
        X = X + 1;
        Parametros_Y(1,1,X) = 1/(Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        Parametros_Y(1,2,X) = -1/(Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        Parametros_Y(2,1,X) = -1/(Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        Parametros_Y(2,2,X) = 1/(Impedancia(cell2mat(Tabla3(1,4)),cell2mat(Tabla3(1,5)),F));
        end

    end


else  



Parametros = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
Parametros_Y = pageinv(Parametros);
end

end
