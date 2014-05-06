# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

Dashing.on 'ready', ->
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [300, 360]
  Dashing.numColumns ||= 4

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout
      draggable:
        stop: Dashing.showGridsterInstructions
        start: -> Dashing.currentWidgetPositions = Dashing.getWidgetPositions()

  Batman.Filters.dateFormat = (dateStr) ->
        if !dateStr
           return "not yet released"
           
        try
           new Date(Date.parse(dateStr)).toLocaleDateString()
        catch error
           "not yet released"



Dashing.compute_level = (value, cool, warm) ->
      switch
          when value <= cool then 0
          when value >= warm then 4
          else
            bucketSize = (warm - cool) / 3 # Total # of colours in middle
            Math.ceil (value - cool) / bucketSize

Dashing.lightenDarkenColor = (col, amt) ->
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
