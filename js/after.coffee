




# getScroll = (elem, iscroll) =>
# 	if (Modernizr.touch && iscroll) 
# 		x = iscroll.x * -1;
# 		y = iscroll.y * -1;
# 	else 
# 		x = elem.scrollTop;
# 		y = elem.scrollLeft;

# 	{x: x, y: y}

window.PaperSections = {}
window.PaperSections.$container = $('#wrapper')
window.PaperSections.i = 0
window.PaperSections.next = 0
window.PaperSections.next2 = 0
window.PaperSections.scSpeed = 0
window.PaperSections.prev = 0
window.PaperSections.prev2 = 0
window.PaperSections.scrollSpeed = 0
window.PaperSections.scrollSpeed2 = 0
window.PaperSections.timeOut = null
window.PaperSections.anima = false
window.PaperSections.animaListener = false

window.PaperSections.slice = (val, max)->
	if val > 0 and val > max then return Math.min val, max
	if val < 0 and val < max then return Math.max val, - max
	val






# window.PaperSections.animationLoop = ->
# 	window.requestAnimationFrame(window.PaperSections.animationLoop)

# 	if window.PaperSections.i++ % 5 is 0
			
# 			if !window.PaperSections.stop

# 				window.PaperSections.next2 = -1*window.PaperSections.myScroller.y
# 				window.PaperSections.scrollSpeed2 = window.PaperSections.slice (window.PaperSections.next2 - window.PaperSections.prev2), 135
# 				window.PaperSections.prev2 = window.PaperSections.next2
# 				if Math.abs(window.PaperSections.scrollSpeed2) > 0
# 					window.PaperSections.$container.trigger 'lego:scroll'
# 					window.PaperSections.stop = true
# 					window.PaperSections.i = 0
# 					window.PaperSections.prev2 = window.PaperSections.next2
# 			TWEEN.removeAll()

			
# 			if window.PaperSections.stop
# 				if !window.PaperSections.anima
# 					window.PaperSections.next = -1*window.PaperSections.myScroller.y
# 					window.PaperSections.scrollSpeed = window.PaperSections.slice (window.PaperSections.next - window.PaperSections.prev), 135
# 					window.PaperSections.prev = window.PaperSections.next

# 				if window.PaperSections.scrollSpeed is 0
# 					window.PaperSections.$container.trigger 'lego:stopScroll'
# 					window.PaperSections.anima = true

# 					if !window.PaperSections.animaListener
# 						window.PaperSections.animaListener = true
# 						window.PaperSections.$container.on 'lego:animaComplete', ->
# 							console.log 'complete'
# 							window.PaperSections.stop = false
# 							window.PaperSections.anima = false




# Modernizr.touch = true
# Modernizr.touch and window.PaperSections.$container.addClass 'touch'


# if Modernizr.touch
	# window.PaperSections.myScroller = new iScroll 'wrapper'
												# bounce: false
												# momentum: false
# window.PaperSections.animationLoop()
# else
window.PaperSections.$container.scroll (e)->

	clearTimeout window.PaperSections.timeOut
	window.PaperSections.timeOut = setTimeout ->
		window.PaperSections.i = 0
		window.PaperSections.$container.trigger 'stopScroll'
		window.PaperSections.prev = window.PaperSections.$container.scrollTop()
	, 50

	if window.PaperSections.i % 4 is 0
		window.PaperSections.next = window.PaperSections.$container.scrollTop()
		window.PaperSections.scrollSpeed = window.PaperSections.slice (window.PaperSections.next - window.PaperSections.prev), 135
		window.PaperSections.prev = window.PaperSections.next
	window.PaperSections.i++

# setTimeout =>
# 	window.$container.animate 'scrollTop': 200
# , 2000

