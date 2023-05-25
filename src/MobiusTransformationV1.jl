# Pequeña biblioteca para transformaciones de Möbius, para el curso
# "Seminario de Geometría B - Grupos Kleinianos: Geometría y Visualización".
# Autor: Renato Leriche Vázquez

# Struct que representa a una transformación de Möbius en la esfera de Riemann
struct MobiusTransformation
    a::ComplexF64
    b::ComplexF64
    c::ComplexF64
    d::ComplexF64    
    
    # Constructor "normal"
    MobiusTransformation(a::Number, b::Number, c::Number, d::Number) = new(a,b,c,d)
    # Constructor para lineales y afines
    MobiusTransformation(a::Number, b::Number=0) = new(a,b,0,1)
    # Constructor con argumentos palabra clave
    MobiusTransformation(; a::Number=1, b::Number=0, c::Number=0, d::Number=1) = new(a,b,c,d)
    # Constructor copia
    MobiusTransformation(T::MobiusTransformation) = new(T.a,T.b,T.c,T.d)
end
    
# Alias de nombre de tipo para escribir menos
const MobT = MobiusTransformation 


# Constructor externo que crea la transformación de Möbius tal que
# z1 -> 1, z2 -> 0 y z3 -> Inf
function MobiusTransformation(z1::Number,z2::Number,z3::Number)
    if isinf(z1)
        return MobT(1,-z2,1,-z3) # Usando el constructor interno
    elseif isinf(z2)
        return MobT(0,z1-z3,1,-z3) # Usando el constructor interno
    elseif isinf(z3)
        return MobT(1,-z2,0,z1-z2) # Usando el constructor interno
    end
    MobT(z1-z3, -z2*(z1-z3), z1-z2, -z3*(z1-z2)) # Usando el constructor interno
end


# Constructor externo que crea la transformación de Möbius tal que
# z1 -> w1, z2 -> w2 y z3 -> w3
MobiusTransformation(z1::Number,z2::Number,z3::Number,w1::Number,w2::Number,w3::Number) = 
  inverse(MobT(w1,w2,w3)) ∘ MobT(z1,z2,z3)


# Functions útiles varias

# Verificador de coeficientes
coefficientsok(a::Number, b::Number, c::Number, d::Number) = !iszero(a*d - b*c)

# Matríz de GL(2,C) asociada
matrix(T::MobT) = [T.a T.b; T.c T.d]

# Matríz de SL(2,C) asociada, con "determinante" igual a 1
matrixSL2C(T::MobT) = [T.a T.b; T.c T.d]/sqrt(complex(T.a*T.d - T.b*T.c))

# "Determinante"
det(T::MobT) = T.a*T.d - T.b*T.d

# Inversa
inverse(T::MobT) = MobT(T.d, -T.b, -T.c, T.a)

# Polo
function pole(T::MobT)
    if iszero(T.c)
        return Inf
    end
    
    -T.d/T.c
end


# Evaluación de las transformaciones (usando la técnica de objeto función)
function (T::MobT)(z::Number)
    # Si c es 0, T es afín
    if iszero(T.c)
        if isinf(z)
            return Inf # No se maneja bien la operación Inf/(x+0im)
        end
        
        return (T.a*z + T.b)/T.d
    end
    
    # Si c no es cero, T no es afín
    
    # Si z es infinito
    if isinf(z)
        return T.a/T.c
    end

    Δ = T.c*z + T.d # El "denominador"
    
    # Si c es el polo
    if iszero(Δ) 
        return Inf
    end

    # Evaluación normal
    (T.a*z + T.b)/Δ
end


# Imagen de un círculo bajo una transformación de Möbius
function (T::MobT)(c::Circ)
    if iszero(T.c) # T de la forma az+b
        return Circ(T(c.center), abs(T.a/T.d)*c.radius)
    end
    
    zr = c.center + T.d/T.c # "radio"
    
    if iszero( abs(zr) - c.radius ) # Si el polo de T está en el círculo
        Tza = T(c.center + zr) # T(z_antipoda)
        Tzp = T(c.center + zr*im) # T(z_perpendicular_diametro)
        return Linc(Tza, angle(Tza-Tzp))
    end
    
    # Receta de la Abuela de las Perlas de Indra usando la inversión...
        
    if iszero(zr)
        z1 = T.a/T.c # Si el polo es el centro del círculo, el centro de T(C) es z_1=I_{T(C)}(Inf)=T(Inf)=a/c
    else
        z1 = T(c.center - (c.radius^2)/conj(zr)) # Usando la inversión
    end
    
    Circ(z1, abs(z1 - T(c.center + c.radius)))
end


# Operador composición de funciones
import Base: ∘

∘(T::MobT, S::MobT) = MobT(
    T.a*S.a + T.b*S.c, T.a*S.b + T.b*S.d,
    T.c*S.a + T.d*S.c, T.c*S.b + T.d*S.d
)

compose(T::MobT, S::MobT) = T∘S


# Puntos fijos
function fixedpoints(T::MobT)
    if iszero(T.c)
        if isapprox(T.a, T.d) # Si T es traslación
            return Inf, Inf # Repetido por coherencia
        end
        return -T.b/(T.a-T.d), Inf # Si T es afín
    end
    
    sqrtdiscr = sqrt((T.a - T.d)^2 + 4T.b*T.c)
    (T.a - T.d - sqrtdiscr) / (2T.c), (T.a - T.d + sqrtdiscr) / (2T.c) # Caso general
end


# Derivada "mejorada" (cáĺculo en infinito) de una transformaciónde Möbius
function derivative(T::MobT)
    function Tder(z::Number)
        (T.a*T.d - T.b*T.c) / ( isinf(z) ? T.a^2 : (T.c*z + T.d)^2 )
    end
end


# Traza
tr(T::MobT) = (T.a + T.d)/sqrt(det(T))

# Traza alcuadrado
tr2(T::MobT) = ((T.a + T.d)^2)/det(T)

# Clasificación por traza
# (recordadar que algunas pocas veces falla por falta de precisión en la aritmética de punto flotante.)
function kindbytr(T::MobT)
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


