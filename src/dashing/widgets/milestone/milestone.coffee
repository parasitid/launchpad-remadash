class Dashing.Milestone extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".milestone").val(value).trigger('change')

  ready: ->
    #meter = $(@node).find(".meter")
    #meter.attr("data-bgcolor", meter.css("background-color"))
    #meter.attr("data-fgcolor", meter.css("color"))
    #meter.knob()


  climacon_class: (value) ->
     switch
        when value == 0 then 'haze'
        when value < 10 then 'cloud moon'
        when value < 40 then 'moon'
        when value < 60 then 'lightning'
        when value < 90 then 'cloud sun'

  compute_level: (value, cool, warm) ->
      switch
          when value <= cool then 0
          when value >= warm then 4
          else
            bucketSize = (warm - cool) / 3 # Total # of colours in middle
            Math.ceil (value - cool) / bucketSize

  lightenDarkenColor: (col, amt) ->
     rgb = col.match(/\d+/g);

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


  onData: (data) ->
      node = $(@node)

      zlist = node.find("#list")
      zlist.find("#essential").text("Ess:" + data.essential)
      zlist.find("#high").text("High:" + data.high)
      zlist.find("#medium").text("Med.:" + data.medium)
      zlist.find("#low").text("Low:" + data.low)

      value = parseInt data.value
      cool = parseInt node.data "cool"
      warm = parseInt node.data "warm"
      
      level = this.compute_level(value, cool, warm)
      climacon = this.climacon_class(value, cool, warm)

      backgroundClass = "climacon icon-background #{climacon} "

      node.find('i.climacon').attr 'class', "$backgroundClass"


      styleClass = node.attr 'class'
      console.log ( styleClass )
      node.addClass "hotness#{level}"

      meter = node.find(".meter")
      hotnessColor = node.css("background-color")

      meter.attr("data-bgcolor", this.lightenDarkenColor(hotnessColor,-50))
      meter.attr("data-fgcolor", this.lightenDarkenColor(hotnessColor,200))
      meter.knob()


