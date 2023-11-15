function Z_Nodo=Z_nodof(letra,Z_caracteres,w)

    switch letra
            case 'R'
                Z_Nodo=str2double(strrep(Z_caracteres,char(0),'')); % valor numerico de la resistencia correspondiente
            case 'C'
                % Para capacitor Z=1/-jwc
                Z=str2double(strrep(Z_caracteres,char(0),'')); % valor numerico de la resistencia correspondiente
                Z_Nodo=1/(-1i*w*Z)
            case 'L'
                %Para inductor Z=jwL
                Z=str2double(strrep(Z_caracteres,char(0),'')); % valor numerico de la resistencia correspondiente
                Z_Nodo=1i*w*Z
    
    end

end