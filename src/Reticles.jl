  
#
# Construye un arreglo de complejos que contiene una retícula del rectángulo [xmin,xmax]x[ymin,ymax],
# con cols columnas y rows renglones, además usando n,m puntos en los segmentos horizontales,verticales
#
function rectreticle(xmin::Real,xmax::Real,ymin::Real,ymax::Real;
  cols::Int=4,rows::Int=4,n::Int=100,m::Int=100)
    Δx, Δy = (xmax-xmin)/n, (ymax-ymin)/m
    Δc, Δr = (xmax-xmin)/cols,(ymax-ymin)/rows
    ret = [ complex(x,y) for x in xmin:Δx:xmax for y in ymin:Δr:ymax ]
    append!(ret, [ complex(x,y) for x in xmin:Δc:xmax for y in ymin:Δy:ymax ])
end


#
# Retícula radial
#
function radreticle(θmin::Real,θmax::Real,rmin::Real,rmax::Real;
  center::Number=0,cols::Int=4,rows::Int=4,n::Int=100,m::Int=100)
    Δθ, Δr = (θmax-θmin)/n, (rmax-rmin)/m
    Δcol, Δrow = (θmax-θmin)/cols,(rmax-rmin)/rows
    ret = [ center + complex(r*cos(θ),r*sin(θ)) for θ in θmin:Δθ:θmax for r in rmin:Δrow:rmax ]
    append!(ret, [ center + complex(r*cos(θ),r*sin(θ)) for θ in θmin:Δcol:θmax for r in rmin:Δr:rmax ])
end
