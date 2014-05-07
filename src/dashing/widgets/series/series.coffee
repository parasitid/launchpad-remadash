class Dashing.Series extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
        super
        @observe 'value', (value) -> $(@node).find(".meter").val(value).trigger('change')

  ready: -> this.applyColors( $(@node) )

  onData: (data) ->
     this.applyColors( $(@node))

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

