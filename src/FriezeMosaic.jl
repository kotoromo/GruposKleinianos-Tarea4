
# Traslación de un patrón
function Tv(pattern, vx, vy)
    @layer begin
        translate(vx,vy)
        pattern()
    end
end

# Aplica T_v^n y también las inversas al "patrón", con n=1 a N
function applyTvN(pattern, vx, vy, N)
    pattern()
    [ Tv(pattern,n*vx,n*vy) for n in 1:N ]
    [ Tv(pattern,-n*vx,-n*vy) for n in 1:N ]
end

# Aplica T_v^n y T_u^n y también las inversas al "patrón", con n=1 a N
function applymosaic(pattern, vx, vy, ux, uy, N)
    for m in -N:N
        @layer begin    
            translate(m*ux,m*uy) # T^m_u
            for n in -N:N
                @layer begin
                    translate(n*vx,n*vy) # T^n_v
                    pattern()
                end # layer n
            end # for n
        end # layer m
    end # for m
end
