module KolmeDHelper
  def all_shades
    [ :twisted_shade , :curved_shade , :pair_shade,
      :bell_shade , :shade]
  end
  def twisted_shade_text
    [ "Twisted lamp",
      "Twist is achieved with the bottom (twist) control. Results are best for
    quite low segment values, so the triangles show better.
    "]
  end
  def curved_shade_text
    ["Curved lamp",
      "The extra radii (25,50,75) pull the shape into that direction. Only the 0
       and 100, ie top and bottom, are exact. Lots of fun to be had here.
    "]
  end
  def pair_shade_text
    ["Pair shape",
      "With the 5 control points can pull the shape out and back in.
       And by using the Segments get some very nice looks.
       This one is for large printers, but you can always scale.
    "]
  end
  def bell_shade_text
    ["1001 Nights",
      "A shape Raisa enjoyed so much she named it. "]
  end
  def shade_text
    name = params[:name] || "Your own"
    [name, "This is your own creation, enjoy and share. If you puts a name=
      key into the url, you can name it!"]
  end
end
