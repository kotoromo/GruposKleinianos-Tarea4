
# Generador de un arreglo de arreglos conteniendo las listas de índices permitidos
# (los que no corresponden al de la inversa).
function allowedindexes(numgenerators::Int, numtransformations::Int)
    # Aquí se guardaran los arreglos de índices correspondientes a k que no son de la inversa
    indexesnotinverse = []
    for k in 1:numtransformations
        # índice correspondiente a la inversa, el prohibido para k
        kinv = ((k + numgenerators - 1) % numtransformations) + 1 
        # índices que no corresponden a la inversa, los permitidos para k
        push!(indexesnotinverse, append!(collect(1:(kinv-1)), collect(kinv+1:numtransformations))) 
    end
    indexesnotinverse
end


# Para liberar memoria en arreglos de arreglos de arreglos.
function freelevelsets!(levelsets::Vector)
    for ss in levelsets
        for s in ss
            empty!(s)
        end
        empty!(ss)
    end
    empty!(levelsets)
end


# Functions diversas de dibujos de diversos tipos de conjuntos

function drawpoints(Z::Vector, r::Real=0.02)
    for z in Z
        circle(point(z), r, :fill) # Dibujar los puntos en Z, con la instrucción de Luxor
    end
end

function drawcircles(Z::Vector)
    for c in Z
        drawcircle(c)
    end
end

function drawpearls(Z::Vector; pblend=indrablend)
    for c in Z
        drawpearl(c, pblend=pblend)
    end
end

function drawlines(Z::Vector)
    for c in Z
        drawline(c)
    end
end

function drawcircleslines(Z::Vector)
    for c in Z
        c isa Circ ? drawcircle(c) : drawline(c)
    end
end


# Dibujo de órbitas de un conjunto Z bajo un grupo finitamente generado por [a,b].
# Una implementación del algoritmo BFS (Breath First Search, o búsqueda primero por ancho).
function draworbitBFS(generators::Vector, Z::Vector; N::Int=4, drawfunction::Function=drawpoints,
        colormap::ColorScheme=colorschemes[:jet])
    # Paso 1
    numgenerators = length(generators) # Número de generadores
    transformations = deepcopy(generators) # Para no modificar la lista de generadores original
    append!(transformations, [ inverse(T) for T in generators ]) # Arreglo de generadores y sus inversas
    numtransformations = length(transformations) # Número de transformaciones: generadores + inversos
    
    # Paso 2
    sethue(colormap[0.0]) # Usar color 0
    drawfunction(Z) # Dibujar nivel 0
    
    if N < 1 # Si sólo se quiere dibujar el nivel 0, pues ya se hizo
        return
    end
    
    # Paso 3
    currentlevelsets = []

    sethue(colormap[1.0/N]) # Usar color 1/N
    for T in transformations # Para cada transformación...
        TZ = T.(Z) # Calcular T(Z) del nivel 1
        drawfunction(TZ) # Dibujar T(Z) del nivel 1
        push!(currentlevelsets, [TZ]) # Guardar T(Z) del nivel 1 como nivel actual
    end
    
    # Paso 4
    indexesnotinverse = allowedindexes(numgenerators, numtransformations)
    
    for n in 2:N
        nextlevelsets = fill([], numtransformations) # nuevo conjunto de conjuntos vacíos para el siguiente nivel

        sethue(colormap[n/N]) # Usar color n/N
        for k in 1:numtransformations # Para cada transformación...
            T = transformations[k]
            nextlevelsetk = []
                        
            for j in indexesnotinverse[k]
                for Z´ in currentlevelsets[j]
                    TZ´ = T.(Z´) # Calcular T(Z') del nivel n
                    drawfunction(TZ´) # Dibujar T(Z') del nivel n
                    push!(nextlevelsetk, TZ´) # Guardar T(Z') del nivel n
                end # for currentlevelsets[j]
            end # for j, sets
            
            nextlevelsets[k] = nextlevelsetk
        end # for k, transformations
        
        freelevelsets!(currentlevelsets) # siguiente nivel calculado, borrar el actual que ya no se usará
        currentlevelsets = nextlevelsets # reemplazar el actual con el siguiente
    end # for n, levels
    
    freelevelsets!(currentlevelsets) # borrar el actual que ya no se usará, aunque es inncesario por que está al final de la function
    
end # function


# Function para liberar memoria de arreglos de arreglos de círculos (o líneas)
function freelevelsetscircles!(levelsets::Vector)
    for s in levelsets
        empty!(s)
    end
    empty!(levelsets)
end


# Dibujo de órbitas del arreglo de discos de Schottky [Ca,Cb,CA,CB] bajo un grupo finitamente generado por [a,b].
# Una implementación del algoritmo BFS (Breath First Search, o búsqueda primero por ancho).
function drawSchottkyarraysBFS(generators::Vector, schottkycircles::Vector; N::Int=4,
        ε::Real=0.01, colormap::ColorScheme=colorschemes[:jet])
    # Paso 1
    numgenerators = length(generators)
    transformations = deepcopy(generators) # Para no modificar la lista de generadores original
    append!(transformations, [ inverse(T) for T in generators ]) # Arreglo de generadores y sus inversas
    numtransformations = length(transformations)
    
    # Paso 2
    pblend = createindrablend(colormap[0.0])
    drawpearls(schottkycircles, pblend=pblend)

    if N < 1 # Si sólo se quiere dibujar el nivel 0, pues ya se hizo
        return
    end
    
    # Paso 3
    indexesnotinverse = allowedindexes(numgenerators, numtransformations) 
    currentlevelsets = fill([], numtransformations)

    pblend = createindrablend(colormap[1.0/N])
    for k in 1:numtransformations                
        T = transformations[k]
        circlesk = []
        
        for j in indexesnotinverse[k]
            TC=T(schottkycircles[j])
            drawpearl(TC, pblend=pblend)            
            push!(circlesk, TC)
        end
        
        currentlevelsets[k] = circlesk
    end
    
    # Paso 4
    for n in 2:N
        nextlevelsets = fill([], numtransformations) # nuevo conjunto de conjuntos vacíos para el siguiente nivel

        pblend = createindrablend(colormap[n/N])
        for k in 1:numtransformations
            T = transformations[k]
            circlesk = []
            
            for j in indexesnotinverse[k]
                for C in currentlevelsets[j]
                    TC = T(C)
                    if TC.radius > ε
                        drawpearl(TC, pblend=pblend)
                        push!(circlesk, TC)
                    end
                end # for currentlevelsets[j]
            end # for j, sets
            
            nextlevelsets[k] = circlesk
        end # for k, transformations
        
        freelevelsetscircles!(currentlevelsets)    
        currentlevelsets = nextlevelsets # reemplazar el actual con el siguiente
    end # for n, levels
    
    freelevelsetscircles!(currentlevelsets)
    
end # function

