function Y=Y_TL(f,Z,Bl,opFreq)

        Y = zeros(2,2)

        % Constantes, obtener longitud [m] equivalente a la
        % longitud eléctrica en grados introducida por el usuario
        vp=3E8;
        oplambda=(vp/opFreq);
        opBeta=(2*pi)/(oplambda);
        l=Bl/opBeta;


        % Dependientes  de frecuencia
        lambda=(vp/f);
        Beta=(2*pi)/(lambda);

        A=cos(Beta*l);
        B=1i*Z*sin(Beta*l);
        C=1i*sin(Beta*l)/Z;
        D=cos(Beta*l);

        deltaABCD=(A*D)-(B*C)
        Y11=D/B;
        Y12(-deltaABCD)/B;
        Y21=(-1)/B;
        Y22=(A/B);

        Y=[Y11 Y12;Y21 Y22];
        
end