window.PaperSections ?= {}
window.PaperSections.$container = $('#wrapper')
window.PaperSections.i = 0
window.PaperSections.next = 0
window.PaperSections.prev = 0
window.PaperSections.scrollSpeed = 0
window.PaperSections.timeOut = null
window.PaperSections.invertScroll = false

window.PaperSections.slice = (val, max)->
	if val > 0 and val > max then return Math.min val, max
	if val < 0 and val < max then return Math.max val, - max
	val

window.PaperSections.$container.scroll (e)->
	clearTimeout window.PaperSections.timeOut
	window.PaperSections.timeOut = setTimeout ->
		window.PaperSections.i = 0
		window.PaperSections.$container.trigger 'stopScroll'
		window.PaperSections.prev = window.PaperSections.$container.scrollTop()
	, 50

	if window.PaperSections.i % 5 is 0
		direction = if window.PaperSections.invertScroll then -1 else 1
		window.PaperSections.next = window.PaperSections.$container.scrollTop()
		window.PaperSections.scrollSpeed = direction*window.PaperSections.slice (window.PaperSections.next - window.PaperSections.prev), window.PaperSections.data.sectionheight/2
		window.PaperSections.prev = window.PaperSections.next
	window.PaperSections.i++


gui = new dat.GUI
gui.add window.PaperSections, 'invertScroll'


$('.section-b').on 'click', ->
	$$ = $(@)
	window.PaperSections.sections.popSection $$.index()
	# console.log $$.index()
	





