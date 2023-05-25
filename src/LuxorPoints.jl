# Functions útiles para crear conjuntos de puntos y dibujarlos.

circlepoints(center::Number = 0, radius::Real = 1) = [ radius*exp(t*im)+center for t in 0:0.01:(2π) ]

drawpoint(z::Number, size::Real=0.01) = circle(point(z), size, :fill)
drawpoints(points::Array, size::Real=0.01) = [ drawpoint(z, size) for z in points ]
