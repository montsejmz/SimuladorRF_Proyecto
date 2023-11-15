function Z = Impedancia(Componente, Valor,F)

switch Componente(1,1)
    case 'R'
        Z = Valor;
    case 'L'
        Z = 2*i*pi*Valor*F;
    case 'C'
        Z = 1/(2*i*pi*F*Valor)
end


end
