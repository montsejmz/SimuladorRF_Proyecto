function Parametros_S = S_Parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos,Z0)

    Parametros = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
    Parametros_S = z2s(Parametros,Z0);

end