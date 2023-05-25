# Function que calcula los índices correctos que no son los de la inversa.

function createindexesnotinverse(numgens::Int)
    inotinverse = []
    numtrans = 2numgens
    for k in 1:numtrans
        kinv = ((k + numgens - 1) % numtrans) + 1 # índice correspondiente a la inversa
        push!(inotinverse, append!(collect(kinv+1:numtrans), collect(1:(kinv-1)))) # índices que no corresponden a la inversa
    end
    inotinverse
end


# Function para dibujar puntos o círculos

function drawpoints(Z::Vector, c, r::Real=0.02)
    setcolor(c)
    for z in Z
        circle(point(z), r, :fill)
    end
end

function drawdrsticklercolor(coords::Vector, c)
    setcolor(c)    
    drawdrstickler(coords)
end

function drawcircles(Z::Vector, c)
    setcolor(c)
    for c in Z
        c isa Circ ? drawcircle(c) : drawline(c)
    end
end

function drawdiscs(Z::Vector, c)
    setcolor(c)    
    for c in Z
        circle(point(c.center), c.radius, :fill)
    end
end

function drawpearls(Z::Vector, c)
    pblend = createindrablend(c)
    for c in Z
        drawpearl(c, pblend=pblend)
    end
end

function terminationbranchpoints(Z::Vector, index::Int, level::Int, ε::Real=0.001)
    abs2(Z[1]-Z[end]) < ε # Si la distancia entre el primer punto y el último es muy pequeña regresar verdadero
end

function terminationbranchcircles(Z::Vector, index::Int, level::Int, ε::Real=0.001)
    terminate = true
    for c in Z
        terminate &= c.radius < ε # Operador &: true & true = true, false & X = false
    end
    terminate
end

function draworbitDFSrecursive(generators::Vector, Z::Vector; maxlevel::Int=8,
    terminationbranch::Function=terminationbranchpoints,
    draw::Function=drawpoints, colormap::ColorScheme=colorschemes[:jet])
    # Paso 1: "inicialización"
    numgenerators = length(generators)
    transformations = deepcopy(generators) # Para no modificar la lista de generadores original
    append!(transformations, [ inverse(T) for T in generators ]) # Arreglo de generadores y sus inversas
    numtransformations = length(transformations)    
    indexesnotinverse = createindexesnotinverse(numgenerators)
        
    # ¡Function dentro de function! y además es recursiva...
    function traverseforward(Z::Vector, index::Int, level::Int)
        if terminationbranch(Z, index, level) # Criterio de terminación de recorrido de la rama externo
            return
        end

        draw(Z, colormap[level/maxlevel]) # Function draw externa para dibujar el conjunto Z

        if level >= maxlevel # Criterio de terminación de recursión, con maxlevel externo
            return 
        end

        for k in indexesnotinverse[index] # Recorrido con vuelta a la izquierda, indexesnoinverse externo
            traverseforward(transformations[k].(Z), k, level+1) # Recursión, transformations externo
        end
    end
        
    # Paso 2: Nivel 0
    draw(Z, colormap[0.0]) # Dibujar nivel 0
    if maxlevel == 0 # Si solo se quiere dibujar el nivel 0 salir...
        return
    end 
        
    # Paso 3: recursión a los siguientes niveles, empezando por eln nivel 1 con las n ramas que salen de Id
    for k in 1:numtransformations
        traverseforward(transformations[k].(Z), k, 1)
    end
end

function draworbitDFSrecursiveInversions(generators::Vector, Z::Vector; maxlevel::Int=8,
    terminationbranch::Function=terminationbranchpoints,
    draw::Function=drawpoints, colormap::ColorScheme=colorschemes[:jet])
    # Paso 1: "inicialización"
    numgenerators = length(generators)
    transformations = deepcopy(generators) # Para no modificar la lista de generadores original
    append!(transformations, [ inverse(T) for T in generators ]) # Arreglo de generadores y sus inversas
    numtransformations = length(transformations)    
    indexesnotinverse = createindexesnotinverse(numgenerators)
        
    # ¡Function dentro de function! y además es recursiva...
    function traverseforward(Z::Vector, index::Int, level::Int)
        if terminationbranch(Z, index, level) # Criterio de terminación de recorrido de la rama externo
            return
        end

        draw(Z, colormap[level/maxlevel]) # Function draw externa para dibujar el conjunto Z

        if level >= maxlevel # Criterio de terminación de recursión, con maxlevel externo
            return 
        end

        for k in 1:numgenerators # Recorrido con vuelta a la izquierda, indexesnoinverse externo
            if k != index
                traverseforward(transformations[k].(Z), k, level+1) # Recursión, transformations externo
        
            end
        end
    end
        
    # Paso 2: Nivel 0
    draw(Z, colormap[0.0]) # Dibujar nivel 0
    if maxlevel == 0 # Si solo se quiere dibujar el nivel 0 salir...
        return
    end 
        
    # Paso 3: recursión a los siguientes niveles, empezando por eln nivel 1 con las n ramas que salen de Id
    for k in 1:numtransformations
        traverseforward(transformations[k].(Z), k, 1)
    end
end