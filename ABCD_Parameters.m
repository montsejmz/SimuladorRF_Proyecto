function Parametros_ABCD = ABCD_Parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos)
 
sz = size(Netlist);

 if Num_Puertos == 2
    

        if sz(1,1) == 1
            X1 = ismember('N0',table2array(Netlist(:,"NodoFinal")));
            X2 = ismember('N0',table2array(Netlist(:,"NodoInicial")));
            if (X1 == 1 | X2 == 1);
        
                Parametros = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
                Parametros_ABCD = z2abcd(Parametros);
        
            else
        
                Parametros = Y_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
                Parametros_ABCD = y2abcd(Parametros);
        
            end
        
        
        else 
                             
             Parametros = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
             Parametros_ABCD = z2abcd(Parametros);
        end
 else
     disp("Los parametros ABCD solo funcionan para 2 puertos")
     Parametros_ABCD = 0;
 end

end