#
# Biblioteca para transformaciones de Möbius, versión 2 (con subtipado)
#

#
# Estructuras para transformaciones de Möbius
#

# Supertipo abstracto base para transformaciones de Möbius
abstract type AbstractMobiusTransformation <: Function end


# Transformación General, caso c no 0
struct MobiusTransformation <: AbstractMobiusTransformation
    a::ComplexF64
    b::ComplexF64
    c::ComplexF64
    d::ComplexF64
    
    MobiusTransformation(a0::Number,b0::Number,c0::Number,d0::Number) = new(a0,b0,c0,d0)
    MobiusTransformation(T::MobiusTransformation) = new(T.a,T.b,T.c,T.d) # Constructor copia
end

const MobT = MobiusTransformation


# Transformación Afín, caso c=0 (y d=1)
struct AffineTransformation <: AbstractMobiusTransformation
    a::ComplexF64
    b::ComplexF64
    
    AffineTransformation(a0::Number,b0::Number=0) = new(a0,b0) # Sin verificación por eficiencia
    AffineTransformation(T::AffineTransformation) = new(T.a,T.b) # Constructor copia
end

const AffT = AffineTransformation


#
# Constructores externos especializados
#

MobiusTransformation(a0::Number,b0::Number=0) = AffT(a0, b0)

function MobiusTransformation(; a::Number, b::Number, c::Number=0, d::Number=1)
    if isapprox(c, 0)
        return AffT(a/d, b/d)
    end
    MobT(a,b,c,d)
end

# Constructor externo que crea la transformación de Möbius tal que
# z1 -> 1, z2 -> 0 y z3 -> Inf
function MobiusTransformation(z1::Number,z2::Number,z3::Number)
    if isinf(z1)
        return MobT(1,-z2,1,-z3) # Una transformación de Möbius general
    elseif isinf(z2)
        return MobT(0,z1-z3,1,-z3) # Una transformación de Möbius general
    elseif isinf(z3)
        return AffT(1/(z1-z2),-z2/(z1-z2)) # Una transformación afín
    end
    MobT(z1-z3, -z2*(z1-z3), z1-z2, -z3*(z1-z2)) # Una transformación de Möbius general
end

#
# Métodos varios
#

# Polo
pole(T::MobT) = -T.d/T.c
pole(T::AffT) = Inf

# Inversa
inverse(T::MobT) = MobT(T.d, -T.b, -T.c, T.a)
inverse(T::AffT) = AffT(1/T.a, -T.b/T.a)

# Derivada
derivative(T::MobT) = der(z::Number) = (T.a*T.d - T.b*T.c)/(isinf(z) ? T.a^2 : (T.c*z+T.d)^2)
derivative(T::AffT) = der(z::Number) = isinf(z) ? 1/T.a : T.a

# Puntos fijos
function fixedpoints(T::MobT)
    # Se asume c diferente de 0
    sqrtdiscr = sqrt((T.a - T.d)^2 + 4T.b*T.c)
    (T.a - T.d - sqrtdiscr) / (2T.c), (T.a - T.d + sqrtdiscr) / (2T.c) # Caso general
end

function fixedpoints(T::AffT)
    if isapprox(T.a, T.d) # Si T es traslación
        return Inf, Inf # Repetido por coherencia
    end
    -T.b/(T.a-T.d), Inf
end

# Accesores a atributos
_a(T::AbstractMobiusTransformation) = T.a # El "_" no es necesario ni convencional, sólo por gusto...
_b(T::AbstractMobiusTransformation) = T.b
_c(T::MobiusTransformation) = T.c
_d(T::MobiusTransformation) = T.d
_c(T::AffineTransformation) = 0
_d(T::AffineTransformation) = 1

# Determinante
det(T::MobiusTransformation) = T.a*T.d - T.b*T.c
det(T::AffineTransformation) = T.a

# ¡Functions genéricas para traza y traza^2!
tr(T::AbstractMobiusTransformation) =  (_a(T) + _d(T))/sqrt(det(T))
tr2(T::AbstractMobiusTransformation) =  ((_a(T) + _d(T))^2)/det(T)

# Clasificación por traza
function kindbytr(T::AbstractMobiusTransformation)
    numtr2 = tr2(T)
    
    if isapprox(imag(numtr2), 0.0) # Si la parte imaginaria es 0, es decir si tr2 es real
        realtr2 = real(numtr2)
        if isapprox(realtr2, 4.0)
            return :parabolic
        elseif realtr2 < 4 
            return :elliptic
        else
            return :hyperbolic
        end
    end
        
    :loxodromic
end


#
# Métodos para evaluación (objeto función)
#

function (T::AffT)(z::Number)
    isinf(z) ? Inf : T.a*z + T.b
end

function (T::MobT)(z::Number)
    if isinf(z) # Si z es infinito
        return T.a/T.c # Asumimos c no cero
    elseif isapprox(z, -T.d/T.c) # Si z es el polo
        return Inf
    end
    # Caso general
    (T.a*z + T.b)/(T.c*z + T.d)
end


function (T::AffT)(c::Circ)
    Circ(T(c.center), abs(T.a)*c.radius)
end

function (T::MobT)(c::Circ)
    zr = c.center + T.d/T.c # Segmento "radio"
    r2 = c.radius^2
    
    if isapprox( abs2(zr), r2 ) # Si el polo de T está en el círculo
        z1 = T(c.center + zr)
        z2 = T(c.center + zr*im)
        return Linc(z1, angle(z1-z2))        
    end
        
    # Receta de la Abuela de las Perlas de Indra...    
    z1 = isapprox(zr, 0) ? T(Inf) : T(c.center - r2/conj(zr))
    
    Circ(z1, abs(z1 - T(c.center + c.radius)))
end


function (T::AffT)(c::Linc)
    Linc(T(c.base), angle(T.a) + c.θ)
end

function (T::MobT)(c::Linc)
    # Tarea!
    c
end


#
# Sobrecarga del operador de composición de funciones
#

function compose(S::AbstractMobiusTransformation, T::AbstractMobiusTransformation)
    MobiusTransformation(
        a = _a(S)*_a(T) + _b(S)*_c(T),
        b = _a(S)*_b(T) + _b(S)*_d(T),
        c = _c(S)*_a(T) + _d(S)*_c(T),
        d = _c(S)*_b(T) + _d(S)*_d(T)
    ) # ¡Puede regresar general o afín!
end

compose(S::AffineTransformation, T::AffineTransformation) = AffineTransformation(S.a*T.a, S.a*T.b+S.b)


import Base: ∘

∘(S::AbstractMobiusTransformation, T::AbstractMobiusTransformation) = compose(S,T)


MobiusTransformation(z1::Number, z2::Number, z3::Number, w1::Number, w2::Number, w3::Number) =
    inverse(MobT(w1,w2,w3)) ∘ MobT(z1,z2,z3)
    
