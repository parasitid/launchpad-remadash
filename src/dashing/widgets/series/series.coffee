class Dashing.Series extends Dashing.Widget

  @accessor 'active-progression', Dashing.AnimatedValue

  constructor: ->
        super
        @observe 'active-progression', (value) ->
                $(@node).find(".series").val(value).trigger('change')


  onData: (data) ->
        ###
        data_example = {
                series-name:"icehouse",
                active-progression:"85",// percentage progression of current active milestone tasks dev
                active-milestones-title:"2014.1.2,2014.1.3",
                remaining-bugs-total:8,
                remaining-bugs-high:3,
                remaining-specs-total:10,
                remaining-specs-high:0,
                last-release-version:"2014.1.1",
                last-release-date:"04/22/2014"
        }
        ###
        
        node = $(@node)

        node.find("#bugs-total").text(data["remaining-bugs-total"])
        node.find("#bugs-high").text(data["remaining-bugs-high"])


        node.find("#specs-total").text(data["remaining-specs-total"])
        node.find("#specs-high").text(data["remaining-specs-high"])

        node.find("#release-version").text(data["last-release-version"])
        try
           node.find("#release-date").text(Date.parse(data["last-release-date"]).toLocaleDateString())
        catch error
           node.find("#release-date").text("not yet released").toLocaleDateString
                
        bgColor = node.css("background-color")

        meter = node.find(".meter")
        meter.attr("data-bgcolor", this.lightenDarkenColor(bgColor,-50))
        meter.attr("data-fgcolor", this.lightenDarkenColor(bgColor,200))
        meter.knob()



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
