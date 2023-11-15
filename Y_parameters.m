function Parametros_Y = Y_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos)

Parametros = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
Parametros_Y = pageinv(Parametros);
end
