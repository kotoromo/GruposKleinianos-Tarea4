# Círculos (y líneas) en la esfera de Riemann
# Como ya hay un Circle en Luxor, hay que cambiar el nombre...

# Círculo en el plano complejo
struct CircleComplex
    center::ComplexF64
    radius::Float64
    
    CircleComplex(c::Number, r::Real=1) = new(c,r)
    CircleComplex(x::Real, y::Real, r::Real) = new(complex(x,y), r)    
    CircleComplex(; center::Number=0, radius::Real=1) = new(center, radius)
    CircleComplex(c::CircleComplex) = new(c.center, c.radius)
end

const Circ = CircleComplex


# Diámetro
diameter(c::Circ) = 2c.radius
diameter(c::Number) = 0


# Línea en el plano 1complejo
struct LineComplex
    base::ComplexF64
    θ::Float64 # Más conveniente para el dibujo con Luxor
    
    LineComplex(z0::Number,a0::Real) = new(z0,a0)
end

const Linc = LineComplex
