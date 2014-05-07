class Dashing.Meter extends Dashing.Widget
  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".meter").val(value).trigger('change')

  ready: -> this.applyColors( $(@node) )

  applyColors: (node) ->
     value = parseInt @get('value')
     cool = parseInt @get("cool")
     warm = parseInt @get("warm")
     level = this.compute_level(value, cool, warm)
     node.addClass "hotness#{level}"
     meter = node.find(".meter")
     hotnessColor = node.css("background-color")
     meter.attr("data-bgcolor", this.lightenDarkenColor(hotnessColor,-50))
     meter.attr("data-fgcolor", this.lightenDarkenColor(hotnessColor,200))
     meter.knob()

  onData: (data) ->
      this.applyColors( $(@node) )


  compute_level : (value, cool, warm) ->
      switch
          when value <= cool then 0
          when value >= warm then 4
          else
            bucketSize = (warm - cool) / 3 # Total # of colours in middle
            Math.ceil (value - cool) / bucketSize

  lightenDarkenColor : (col, amt) ->
     rgb = col.match(/\d+/g);

     if !rgb
        return col

     r = parseInt(rgb[0]) + amt;

     if (r > 255)
        r = 255
     else if  (r < 0) 
        r = 0

     g = parseInt(rgb[1]) + amt
     if (g > 255) 
        g = 255
     else if (g < 0) 
        g = 0
 
     b = parseInt(rgb[2]) + amt
 
     if (b > 255) 
        b = 255
     else if  (b < 0) 
        b = 0
	 
     "rgb("+r+", "+g+","+b+" )"

