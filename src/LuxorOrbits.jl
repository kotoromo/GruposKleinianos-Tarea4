
# Dibujar la órbita del punto z0
function drawpointorbit(T::MobT, z0::Number, iterations=10; pointsize=0.1)
    for f in [T, inverse(T)] # El grupo generado por T abarca las inversas de T^n
        zn = z0
        for n in 1:iterations
            drawpoint(zn, pointsize)
            zn = f(zn)
        end
    end
end


# Dibujar la órbita del círculo c0
function drawcircleorbit(T::MobT, c0::Circ, iterations=10; kind=:circle)
    for f in [T, inverse(T)]
        cn = c0
        for n in 1:iterations
            if !(cn isa Circ) 
                drawline(cn)
                #break # Si no es un círculo, es una recta, no está implementada la function aun... dejar de iterar
            else
                if kind == :disc
                    drawdisc(cn)
                elseif kind == :pearl
                    drawpearl(cn)
                else
                    drawcircle(cn)
                end
            end
            cn = f(cn)
        end
    end
end


# Dibujar la órbita de una recta c0
function drawlineorbit(T::MobT, c0::Linc, iterations=10; kind=:circle)
    for f in [T, inverse(T)]
        cn = c0
        for n in 1:iterations
            if !(cn isa Circ) 
                drawline(cn)
                #break # Si no es un círculo, es una recta, no está implementada la function aun... dejar de iterar
            else
                if kind == :disc
                    drawdisc(cn)
                elseif kind == :pearl
                    drawpearl(cn)
                else
                    drawcircle(cn)
                end
            end
            cn = f(cn)
        end
    end
end

