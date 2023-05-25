
# Functions útiles para dibujar con Luxor

"""
Convierte un número de Julia a un punto de Luxor
"""
point(z) = Point(real(z), imag(z))

"""
Dibuja el segmento de recta dado por 2 número complejos
"""
drawlineseg(z1, z2) = line(point(z1), point(z2), :stroke)


"""
Configura el área de dibujo, ajustando las coordenadas del área de dibujo de ancho W y alto h pixeles al
rectángulo del plano [x_min,x_max]x[y_min,y_max].

Se puede indicar que se muestren o no los ejes coordenados (verdadero por defecto).
"""
function configurecanvas(x_min,x_max,y_min,y_max; width=400, height=400, showaxes=true)
    s_x = width /(x_max-x_min)
    s_y = height/(y_min-y_max)
    v = Point(-(x_min + x_max)/2, -(y_min + y_max)/2)
    scale(s_x,s_y) # Invirtiendo eje Y
    translate(v)
    if showaxes
        arrow(Point(x_min,0), Point(x_max,0), arrowheadlength=(x_max-x_min)/60)
        arrow(Point(0,y_min), Point(0,y_max), arrowheadlength=(x_max-x_min)/60)
    end
end


"""
Crea un "blending" radial en el origen con radio inicial 0 y final 1,
con colores "shinecolor" (blanco por defecto) a "color".
"""
createindrablend(color, shinecolor = "white") = blend(O, 0, O, 1, shinecolor, color)

"""
Variable global para tener un "indrablend" para dibujar perlas.
"""
indrablend = createindrablend("blue4")

"""
Dibuja una perla con centro en p, radio r y con la acción indicada.
"""
function pearl(p,r,action=:fill; pblend=indrablend)
  @layer begin
    blendadjust(pblend,p,r,r)
    setblend(pblend)
    circle(p,r,action)
  end
end

#"""
#Dibuja una perla con centro en (x,y), radio r y con la acción indicada.
#"""
#pearl(x,y,r,action=:fill) = pearl(Point(x,y),r,action)


"""
Dibuja una flecha que representa un vector z como número complejo
"""
function vector(z; o=0, lw=1, head=0.25, anglearrow=false)
  if anglearrow
    @layer begin
      setdash("dash")
      r = abs(z)/2
      arrow(point(o), r, 0, angle(z), linewidth=lw, arrowheadlength=head)
    end
  end
  arrow(point(o), point(o+z), linewidth=lw, arrowheadlength=head)
end

vector(x,y; o=0, lw=1, head=0.25, anglearrow=false) = vector(complex(x,y), o=o, lw=lw, head=head, anglearrow=anglearrow)

