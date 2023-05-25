

# Dr. Stickler
# (depende de LuxorUtils)

drsticklercoords = [
complex( 0, 7), #  1 Cabeza Centro
complex(-1, 7), #  2 Cara Centro
complex(-2, 7), #  3 Nariz Punta
complex( 0, 6), #  4 Cuello
complex( 0, 5), #  5 Hombros
complex(-2, 2), #  6 Codo Izq
complex(-4, 5), #  7 Mano Izq
complex( 2, 2), #  8 Codo Der
complex( 1,-1), #  9 Mano Der
complex( 0, 0), # 10 Centro
complex(-2,-4), # 11 Rodilla Izq
complex(-2,-8), # 12 Talón Izq
complex(-4,-8), # 13 Pie Punta Izq
complex( 1,-4), # 14 Rodilla Der
complex( 3,-8), # 15 Talón Der
complex( 1,-8)  # 16 Pie Punta Der
]


function drawdrstickler(coords)
  circle(real(coords[1]), imag(coords[1]), abs(coords[1]-coords[2]), :stroke) # Cabeza, es un círculo
  drawlineseg(coords[2], coords[3]) # Nariz
  drawlineseg(coords[4], coords[5]) # Cuello  
  drawlineseg(coords[5], coords[6]) # Brazo Izq
  drawlineseg(coords[6], coords[7]) # Antebrazo Izq
  drawlineseg(coords[5], coords[8]) # Brazo Der
  drawlineseg(coords[8], coords[9]) # Antebrazo Der
  drawlineseg(coords[5], coords[10]) # Tronco
  drawlineseg(coords[10], coords[11]) # Muslo Izq
  drawlineseg(coords[11], coords[12]) # Pantorrilla Izq
  drawlineseg(coords[12], coords[13]) # Pie Izq  
  drawlineseg(coords[10], coords[14]) # Muslo Der
  drawlineseg(coords[14], coords[15]) # Pantorrilla Der
  drawlineseg(coords[15], coords[16]) # Pie Der
end
