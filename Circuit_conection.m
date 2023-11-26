function Circuito_Final = Circuit_conection(Netlist_1, Piedra_manoseada, Netlist_2)

Touchstone = sparameters(Piedra_manoseada);
Frecuencias = Touchstone.Frequencies;
sz = size(Frecuencias);
Frec_inicial = Frecuencias(1,1);
Frec_final = Frecuencias(sz(1,1),1);
Muestreo = sz(1,1);
Z0 = Touchstone.Impedance;
Matriz_S_TS = Touchstone.Parameters;

if isreal(Netlist_1)
    Input_Matriz = 1;
else
    Input_Matriz = ABCD_Parameters(Netlist_1,Frec_inicial,Frec_final,Muestreo,2);
end

if isreal(Netlist_2)
    Output_Matriz = 1;
else
    Output_Matriz = ABCD_Parameters(Netlist_2,Frec_inicial,Frec_final,Muestreo,2);
end

%El la matriz de parametros s del touchstone lo convierto a parametros Z

Matriz_ABCD_TS = s2abcd(Matriz_S_TS,Z0);
In_Ts = pagemtimes(Input_Matriz,Matriz_ABCD_TS);
IN_TS_OUT = pagemtimes(In_Ts,Output_Matriz);

Circuito_Final = abcd2s(IN_TS_OUT,Z0);

end