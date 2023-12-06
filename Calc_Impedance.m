function Z = Calc_Impedance(Componente, Valor,F,Bl,opFreq)


    switch Componente
        case 'R'
            Z = Valor;
        case 'L'
            Z = 2*i*pi*Valor*F;
        case 'C'
            Z = 1/(2*i*pi*F*Valor);
        case 'TL_Y1'
            % Recordando que Y1=-Y21
            Y=Y_Distribuidos(F,Valor,Bl,opFreq,"TL");
            Y1=-Y(2,1);
            Z=1/Y1;
        case 'TL_Y2'
            % Recordando que Y2=Y11+Y12
            Y=Y_Distribuidos(F,Valor,Bl,opFreq,"TL");
            Y2=(Y(1,1)+Y(1,2));
            Z=1/Y2;
        case 'TL_Y3'
            % Recordando que Y3=Y22+Y12
            Y=Y_Distribuidos(F,Valor,Bl,opFreq,"TL");
            Y3=(Y(2,2)+Y(1,2));
            Z=1/Y3;

        case 'SSC'
            Y=Y_Distribuidos(F,Valor,Bl,opFreq,"SSC");
            Z=Y;
        case 'SOC'
            Y=Y_Distribuidos(F,Valor,Bl,opFreq,"SOC");
            Z=Y;
        
        
    end

end
