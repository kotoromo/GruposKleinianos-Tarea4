# Para dibujo de circunferencias, discos y perlas a partir de un objeto Circle

using Luxor

# Dibuja un círculo de Luxor con los datos de la struct
drawcircle(c::Circ) = circle(point(c.center), c.radius, :stroke)

# Dibuja un disco (círculo de Luxor con :fill) con los datos de la struct
drawdisc(c::Circ) = circle(point(c.center), c.radius, :fill)

# Dibuja un disco (círculo de Luxor con :fill) con los datos de la struct, al estilo "perla"
function drawpearl(c::Circ, color="blue", colorshine="white")
    @layer begin
        p = point(c.center)
        setblend(blend(p, 0, p, c.radius, colorshine, color))
        circle(p, c.radius, :fill)
    end
end

# Dibuja un disco (círculo de Luxor con :fill) con los datos de la struct, al estilo "perla"
function drawpearl(c::Circ; pblend=indrablend)
    @layer begin
        p, r = point(c.center), c.radius
        blendadjust(pblend,p,r,r)        
        setblend(pblend)
        circle(p, r, :fill)
    end
end

# Dibuja una línea recta que
drawline(l::Linc) = rule(point(l.base), l.θ)
