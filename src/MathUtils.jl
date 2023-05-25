
# Raiz cuadrada de a usando el algoritmo de Newton-Raphson
function newtonraphsonsqrt(a, x0=1, maxiterations=4)
    xn = x0
    for n in 1:maxiterations
      xn = 0.5(xn + a/xn)
    end
    xn
end


# Calcula y regresa un arreglo con (una parte finita de) la órbita de x
function calcorbit(f, x, N=100)
    orbit = [x]
    for n in 1:N
        x = f(x)
        push!(orbit, x)
    end
    orbit
end


# Crea una function que será un polinomio de grado length(coeffs)-1
function createpolynomial(coeffs) # coeffs debe ser una arreglo de coeficientes
    function polynomial(x)
        finalval = coeffs[end] # Coeficiente a_{n-1}, índice n=end
        for k in (length(coeffs)-1):-1:1 # Coeficientes a_{n-2} (índice n-1) a a_0 (índice 1)
            finalval = coeffs[k] + x*finalval
        end
        finalval
    end
end


# Crea la derivada numérica (aproximada de acuerdo a ε) de una función dada
function createnumderivative(f, ε=0.001)
    function numder(x)
        (f(x+ε)-f(x-ε))/(2ε)
    end
end


# Regresa un número pseudo-aleatorio entre a y b
randab(a, b) = a + (b-a)*rand()


my_const_test = 42

