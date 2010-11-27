# Benötigte Pakete installieren
require 'rubygems'
require 'RMagick'
include Magick
include Math


# Größe der Grafik
canvas_x=800
canvas_y=450

# Mitte der Grafik (x=200,y=150)
mitte_x=canvas_x/2
mitte_y=canvas_y/2

# Achsenlänge festlegen
achsenlaenge = (canvas_y/2)-40

# Beschriftungen
beschriftung = ["Informationen und Daten","Algorithmen","Sprachen und Automaten","Informatiksysteme","Informatik, Mensch und Gesellschaft"]
# Werte für die Inhaltsbereiche
werte = [6,10,1,8,6]

# Array für die x und y Werte des Poligon erzeugen
wertx = []
werty = []

# Zeichnen eines Netzes 
#
# for i = 0 to 350 steps 72 (5 Pfeile auf 360%)
# => delta_x=cos(i/180)*PI*achsenlaenge
# => delta_y=sin(i/180)*PI*achsenlaenge
# => line(mitte_x,mitte_y,mitte_x-delta_y, mitte_y-delta_y)
#
#

# Pfeile für Inhaltsbereiche
# 5 Pfeile bedeuet 6 Felder zu haben
# Halbkreis hat 180 Grad : 6 Felder = 30 Grad/Feld (180:6=30)
# 
# Bereichung basiert auf einem rechtwinkligen Dreieck,
# wobei die Länge des Pfeles bekannt ist c = canvas_y/2
# wobei der Winkel bekannt ist alpha = 30 Grad
# 
#  aus sin alpha = a/c  also a = sin alpha x c 
#  ergibt sich die y koordinate, wenn man mitte_y - a berechnet
#  
#  aus cos alpha = b/c  also b = cos alpha x
#  erhibt sich die x koordinate, wenn mann mitte x -b berechnet

canvas = Magick::Image.new(canvas_x, canvas_y,
              Magick::HatchFill.new('white','lightcyan2'))
gc = Magick::Draw.new

# Zeichne die inneren Achsen
# 72,144,216,288,360 

for i in (0..4)
  winkel = (i+1)*72
  bogen=(PI/(180/(winkel.to_f+30)))
  delta_x=cos(bogen)*achsenlaenge
  delta_y=sin(bogen)*achsenlaenge
  wertx[i] = mitte_x-cos(bogen)*werte[i]*16
  werty[i] = mitte_y-sin(bogen)*werte[i]*16
  gc.stroke('gray')
  gc.stroke_width(1)
  gc.line(mitte_x,mitte_y,mitte_x-delta_x,mitte_y-delta_y)
  if i < 4
    gc.text(mitte_x-delta_x+5, mitte_y-delta_y+5, beschriftung[i])
  else
    gc.text(mitte_x-delta_x-200, mitte_y-delta_y+5, beschriftung[i])
  end
end

# zeichenn des netzes
gc.stroke('#001aff')
gc.stroke_width(3)
gc.fill_opacity(0)
gc.polygon(wertx[0],werty[0],wertx[1],werty[1],wertx[2],werty[2],wertx[3],werty[3],wertx[4],werty[4])


# Bechriftungen
gc.stroke('black')
gc.stroke_width(1)
gc.text(10, 30, "Inhaltsbereiche")

gc.draw(canvas)
canvas.write('Zeichnung.png')
