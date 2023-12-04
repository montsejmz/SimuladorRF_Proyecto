function ABCD=ABCD_SOC(Frec_inicial, Frec_final, Muestreo,Bl,Z,opFreq)
    %f=linspace(Frec_inicial,Frec_final,Muestreo);
        ABCD = zeros(2,2, Muestreo);

        % Variables de operación, obtener longitud [m] equivalente a la
        % longitud eléctrica en grados
        vp=3E8;
        oplambda=(vp/opFreq);
        opBeta=(2*pi)/(oplambda);
        l=Bl/opBeta;

        X=1;

    for f=Frec_inicial:(Frec_final-Frec_inicial)/(Muestreo-1):Frec_final
                
        lambda=(vp/f);
        Beta=(2*pi)/(lambda);

        A=-1;
        B=0;
        C=1/(tan(Beta*l)*Z*1i);
        D=1;


        ABCD(:,:,X)=[A,B; C, D];
        X=X+1;

    end
    
end