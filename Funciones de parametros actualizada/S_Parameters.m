function Parametros_S = S_Parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos,Z0)
sz = size(Netlist);

if sz(1,1) == 1
    X1 = ismember('N0',table2array(Netlist(:,"NodoFinal")));
    X2 = ismember('N0',table2array(Netlist(:,"NodoInicial")));
    if (X1 == 1 | X2 == 1);

        Parametros = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
        Parametros_S = z2s(Parametros,Z0);

    else

        Parametros = Y_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
        Parametros_S = y2s(Parametros,Z0);

    end


else 
    Parametros = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
    Parametros_S = z2s(Parametros,Z0);

end

end