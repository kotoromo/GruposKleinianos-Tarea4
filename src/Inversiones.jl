###
#   c :: Circ
#   z ↦ c.center + c.radius^2 / conj(z - c.center)
#
###

import Base: ∘

struct InversionByCircle
    z0::ComplexF64
    r0::Float64

    InversionByCircle(z0::ComplexF64=0, r0::Float64=1) = new(z0, r0)
    InversionByCircle(z0::Number=0, r0::Number=1) = new(z0, r0)
    InversionByCircle(c::Circ) = new(c.center, c.radius)
end

const InvByCirc = InversionByCircle

## Inversa de una inversión por círculo
inverse(IC::InvByCirc) = IC


## Función evaluación de la inversión por círculo
function (IC::InvByCirc)(z::ComplexF64)
    if z == IC.z0
        return Inf
    end

    if z == Inf
        return IC.z0
    end

    # Si z está en el círculo, entonces la inversión es la identidad
    if abs(z - IC.z0) == IC.r0
        return z
    end

    return IC.z0 + IC.r0^2 / conj(z - IC.z0)
end

function (IC::InvByCirc)(c::Circ)
    if c.center == IC.z0 && c.radius == IC.r0
        return c
    end

    image_center = IC(c.center)
    image_other = IC(c.center + c.radius)

    return Circ(image_center, abs(image_other - image_center))
    #return IC.z0 + IC.r0^2 / conj(z - IC.z0)
end

∘(IC::InvByCirc, ID::InvByCirc) = MobT(
    IC.r0^2 + IC.z0*conj(ID.z0) - abs(IC.z0)^2,
    -ID.z0*(IC.r0^2) + IC.z0*(ID.r0^2) + ID.z0*abs(IC.z0)^2 - IC.z0*abs(ID.z0)^2,
    conj(ID.z0 - IC.z0),
    ID.z0*conj(IC.z0) - abs(ID.z0)^2 + ID.r0^2
)

compose(IC::InvByCirc, ID::InvByCirc) = IC∘ID

#compose(IC::InvByCirc, T::MobT) = z -> IC(T(z))

#compose(T::MobT, IC::InvByCirc) = z -> T(IC(z))


#compose(f, g) = z -> f(g(z))