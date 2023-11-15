function Parametros_ABCD = ABCD_Parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos)
 if Num_Puertos == 2
     Parametros = Z_parameters(Netlist, Frec_inicial, Frec_final, Muestreo,Num_Puertos);
     Parametros_ABCD = z2abcd(Parametros);
 else
     disp("Los parametros ABCD solo funcionan para 2 puertos")
     Parametros_ABCD = 0;
 end

end