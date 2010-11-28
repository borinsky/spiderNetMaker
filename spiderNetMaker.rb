# This Scripte write a SpiderNetGraphic with a ruby Script.
# You give the names and values of the axles and the script write the graphic in the Size an graphicformat you want. 
#
#
# useage: ruby spiderNetmaker.rb SizeX SizeY TitleLeftCorner AxleName1 Value1 .. AxleNameN ValueN  FileName.format

# Benötigte Pakete installieren
require 'rubygems'
require 'RMagick'

include Magick
include Math


# Analyse the given arguments
# fetch teh values

# Size of canvas
canvas_x=ARGV[0].to_i
canvas_y=ARGV[1].to_i

# 
numbers_of_arguments=ARGV.length.to_i
count_axle = (numbers_of_arguments-4)/2
end_values=numbers_of_arguments-2
name_of_graphic=ARGV[numbers_of_arguments-1].to_s

# get names and values
beschriftung = Array.new
werte = Array.new
for i in (3.step(end_values, 2)) do
  beschriftung << ARGV[i].to_s
  werte << ARGV[i+1].to_i  
end 
puts beschriftung
puts werte


# calculate the midpoint
mitte_x=canvas_x/2
mitte_y=canvas_y/2

# length of the axles
achsenlaenge = (canvas_y/2)-40


# Array für die x und y Werte des Poligon erzeugen
wertx = Array.new
werty = Array.new
points = Array.new

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
              Magick::HatchFill.new('white','lightcyan1'))
gc = Magick::Draw.new

# Zeichne die inneren Achsen
# 72,144,216,288,360 

for i in (0..count_axle-1)
  winkel = (i+1)*(360/count_axle)
  bogen=(PI/(180/(winkel.to_f)))
  delta_x=cos(bogen)*achsenlaenge
  delta_y=sin(bogen)*achsenlaenge
  wertx[i] = mitte_x-cos(bogen)*werte[i]*16
  werty[i] = mitte_y-sin(bogen)*werte[i]*16
  points << wertx[i].to_i
  points << werty[i].to_i
  gc.stroke('gray')
  gc.stroke_width(1)
  gc.line(mitte_x,mitte_y,mitte_x-delta_x,mitte_y-delta_y)
  gc.text(mitte_x-delta_x+5, mitte_y-delta_y+5, beschriftung[i])
end

polypoints = "M "+points.join("+").to_s+" z"
puts polypoints

# zeichenn des netzes
gc.stroke('#001aff')
gc.stroke_width(1)
gc.fill_opacity(0.2)
gc.path(polypoints)


# Bechriftungen
gc.stroke('black')
gc.stroke_width(1)
gc.text(10, 30, "Inhaltsbereiche")

gc.draw(canvas)
canvas.write(name_of_graphic)
