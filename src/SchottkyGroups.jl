
#
# Crea un generador de grupos de Schottky que transforma C a C´
# y transforma el interior de C en el exterior de C´.
# Adicionalmente se puede usar un ángulo de rotación.
#
function createSchottkyGen(C::Circ, C´::Circ, θ::Real=0)
    α = exp(θ*im)
    MobT(α*C´.center, C.radius*C´.radius - α*C.center*C´.center, α, -α*C.center)
end


#
# Function para tomar puntos sobre un círculo C, parametrizado este por el ángulo θ
# (esta function no debería estar en este archivo... pero como la usamos para
# creación de grupos de Schottky, aquí la dejé...)
#
pickpoint(c::Circ, θ::Real) = c.center + c.radius*exp(θ*im)
