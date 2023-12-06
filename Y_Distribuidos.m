function Y=Y_Distribuidos(f,Z,Bl,opFreq,tipo)


        % Constantes, obtener longitud [m] equivalente a la
        % longitud eléctrica en grados introducida por el usuario
        vp=3E8;
        oplambda=(vp/opFreq);
        opBeta=(2*pi)/(oplambda);
        l=Bl/opBeta;


        % Dependientes  de frecuencia
        lambda=(vp/f);
        Beta=(2*pi)/(lambda);
        
        % Segun el tipo de componente cambia A,B,C y D
        switch tipo
            case "TL"
                A=cos(Beta*l);
                B=1i*Z*sin(Beta*l);
                C=1i*sin(Beta*l)/Z;
                D=cos(Beta*l);

                ABCD=[A B; C D];
                Y=abcd2y(ABCD);
            case "SSC"
                % La variable se llama Y, pero realmente es Zin
                % Inductor = j*2*pi*f*L
                Bl=deg2rad(Bl);
                Zin=1i*Z*tan(Bl*(f/opFreq));
                Y=Zin;
            case "SOC"
                % La variable se llama Y, pero realmente es Zin
                Bl=deg2rad(Bl);
                Zin=-1i*Z*cot(Bl*(f/opFreq));
                Y=Zin;
                
        end
        
        
end