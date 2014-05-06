class Dashing.Series extends Dashing.Widget

  @accessor 'active-progression', Dashing.AnimatedValue

  constructor: ->
        super
        @observe 'active-progression', (value) ->
                $(@node).find(".series").val(value).trigger('change')


  ready: -> this.applyColors( $(@node) )


  applyColors: (node) ->
     value = parseInt @get('value')
     cool = parseInt @get("cool")
     warm = parseInt @get("warm")
     level = Dashing.compute_level(value, cool, warm)
     node.addClass "hotness#{level}"
     meter = node.find(".meter")
     hotnessColor = node.css("background-color")
     meter.attr("data-bgcolor", Dashing.lightenDarkenColor(hotnessColor,-50))
     meter.attr("data-fgcolor", Dashing.lightenDarkenColor(hotnessColor,200))
     meter.knob()

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

        this.applyColors( node )




