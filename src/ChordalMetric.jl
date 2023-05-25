
#
# Distancia cordal general
#
function dchordal(z::Number, w::Number)
    if isinf(z) # verdadero si z es infinito
        return 2/sqrt(1+abs2(w))
    elseif isinf(w) # verdadero si w es infinito
        return 2/sqrt(1+abs2(z))
    end
    2abs(z-w)/sqrt((1+abs2(z))*(1+abs2(w))) # z y w finitos
end


#
# Distancia cordal entre dos puntos en el plano
#
dchordalplane(z::Number,w::Number) = 2abs(z-w)/sqrt((1+abs2(z))*(1+abs2(w)))


#
# Distancia cordal entre un punto en el plano y el infinito
#
dchordalinf(z::Number) = 2/sqrt(1+abs2(z))
