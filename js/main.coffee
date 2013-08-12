Path::setWidth = (width)->
    @segments[3].point.x = @segments[0].point.x + width
    @segments[2].point.x = @segments[1].point.x + width

Path::setHeight = (height)->
    @segments[1].point.y = @segments[0].point.y + height
    @segments[2].point.y = @segments[3].point.y + height

Path::reset = ->
	@setWidth 0
	@setHeight 0
	@smooth()

# Path::copyPath = (path)->
# 	for i in [path.segments.length-1..0]
# 		@.add new Point path.segments[i].point

h = 
    	getRand:(min,max)->
        Math.floor((Math.random() * ((max + 1) - min)) + min)



window.PaperSections ?= {}
window.PaperSections.$container = $('#wrapper')
window.PaperSections.i = 0
window.PaperSections.next = 0
window.PaperSections.prev = 0
window.PaperSections.scrollSpeed = 0
window.PaperSections.timeOut = null
window.PaperSections.invertScroll = true

windowHeight = $(window).outerHeight()

window.PaperSections.$canvas 	= $(view.canvas)
window.PaperSections.data 	= window.PaperSections.$canvas.data()
window.PaperSections.data.colors = window.PaperSections.data.colors.split ':'
window.PaperSections.data.sectionscount ?= window.PaperSections.data.colors.length
view.setViewSize $(window).outerWidth(), (window.PaperSections.data.sectionheight*(window.PaperSections.data.sectionscount)) 
window.PaperSections.data.sectionheight = parseInt window.PaperSections.data.sectionheight
window.PaperSections.$content = $("##{window.PaperSections.data.contentid}")
window.PaperSections.$sections = window.PaperSections.$content.children()


window.PaperSections.slice = (val, max)->
	if val > 0 and val > max then return Math.min val, max
	if val < 0 and val < max then return Math.max val, - max
	val

class SSection
	constructor:(o)->
		@o = o
		@w = view.size.width
		@h = view.size.height
		@ph = 60
		@sh = @procent @h, @ph
		@wh = 1*@w
		@scrollSpeed = 0
		@gapSize = @procent @h, (100-@ph)/2
		@colors = ['#69d2e7','#A7DBD8','#E0E4CC','#F38630','#FA6900']
		@twns = []
		
		@getPrefix()
		@makeBase()
		@listenToStop()

	getPrefix:->
		styles = window.getComputedStyle(document.documentElement, "")
		pre = (Array::slice.call(styles).join("").match(/-(moz|webkit|ms)-/) or (styles.OLink is "" and ["", "o"]))[1]
		@prefix = "-" + pre + "-"
		@transformPrefix = "#{@prefix}transform"


	listenToStop:->
		window.PaperSections.$container.on 'scroll', =>
			window.PaperSections.stop = false
			@poped = false
			TWEEN.removeAll()




		window.PaperSections.$container.on 'stopScroll', =>
			window.PaperSections.stop = true
			duration = window.PaperSections.slice(Math.abs(window.PaperSections.scrollSpeed*25), 1400) or 3000
			@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		0
				duration: duration
			).then =>
				window.PaperSections.scrollSpeed = 0

			@translatePointY
				point: 	@base.segments[3].handleOut
				to: 		0
				duration: duration


	translateLine:(o)->
		dfr = new $.Deferred
		mTW = new TWEEN.Tween(new Point(o.point)).to(new Point(o.to), o.duration)
		mTW.easing o.easing or TWEEN.Easing.Elastic.Out
		it = @
		mTW.onUpdate o.onUpdate or (a)->
			o.point.y = @y
			o.point2?.y = @y

		mTW.onComplete =>
			dfr.resolve()

		mTW.start()
		dfr.promise()


	notListenToStop:->
		window.PaperSections.$container.off 'stopScroll'
		window.PaperSections.$container.off 'scroll'


	translatePointY:(o)->
		dfr = new $.Deferred
		mTW = new TWEEN.Tween(new Point(o.point)).to(new Point(o.to), o.duration)
		mTW.easing o.easing or TWEEN.Easing.Elastic.Out
		it = @
		mTW.onUpdate o.onUpdate or (a)->
			o.point.y = @y
		
			!it.poped and window.PaperSections.$content.attr 'style', "#{it.transformPrefix}: translate3d(0,#{@y/2}px,0);transform: translate3d(0,#{@y/2}px,0);"
			(it.poped and !it.popedCenter) and window.PaperSections.$sections.eq(it.index).attr 'style', "#{it.transformPrefix}: translate3d(0,#{@y/2}px,0);transform: translate3d(0,#{@y/2}px,0);"

		mTW.onComplete =>
			dfr.resolve()

		mTW.start()
		dfr.promise()


	

	makeBase:->
		@base = new Path.Rectangle new Point(0, @o.offset), [@wh, @o.height]
		@base.fillColor = @o.color

	toppie:(amount)->
		@base.segments[1].handleOut.y = amount
		@base.segments[1].handleOut.x = (@wh/2)

	bottie:(amount)->
		@base.segments[3].handleOut.y = amount
		@base.segments[3].handleOut.x = - @wh/2


	createPath:(o)->
		path = new Path o.points
		o.flatten and path.flatten o.flatten
		path.fillColor = o.fillColor or 'transparent'
		path

	update:->
		if !window.PaperSections.stop and !@poped
			@toppie window.PaperSections.scrollSpeed
			@bottie window.PaperSections.scrollSpeed
			# window.PaperSections.$content.css 'top': "#{window.PaperSections.scrollSpeed/2}px"
			window.PaperSections.$content.attr 'style', "#{@transformPrefix}: translate3d(0,#{window.PaperSections.scrollSpeed/2}px,0);transform: translate3d(0,#{window.PaperSections.scrollSpeed/2}px,0);"

		TWEEN.update()

	procent:(base, percents)->
		(base/100)*percents

	pop:->
		@poped = true
		@popedCenter = true

		@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		-window.PaperSections.data.sectionheight/1.75
				duration: 100
				easing:TWEEN.Easing.Linear.None
		).then =>
			@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		0
			).then =>

			@translatePointY
					point: 	@base.segments[3].handleOut
					to: 		0

		@translatePointY
				point: 	@base.segments[3].handleOut
				to: 		window.PaperSections.data.sectionheight/1.75
				duration: 100
				easing:TWEEN.Easing.Linear.None

		

	popUP:->
		@poped = true
		@popedCenter = false

		@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		-window.PaperSections.data.sectionheight/1.75
				duration: 100
				easing:TWEEN.Easing.Linear.None

		).then =>
			@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		0
			).then =>

			@translatePointY
					point: 	@base.segments[3].handleOut
					to: 		0

		@translatePointY
				point: 	@base.segments[3].handleOut
				to: 		-window.PaperSections.data.sectionheight/1.75
				duration: 100
				easing:TWEEN.Easing.Linear.None

		

	popDOWN:->
		@poped = true
		@popedCenter = false
		@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		window.PaperSections.data.sectionheight/1.75
				duration: 100
				easing:TWEEN.Easing.Linear.None
		).then =>
			@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		0
			).then =>

			@translatePointY
					point: 	@base.segments[3].handleOut
					to: 		0

		@translatePointY
				point: 	@base.segments[3].handleOut
				to: 		window.PaperSections.data.sectionheight/1.75
				duration: 100
				easing:TWEEN.Easing.Linear.None



class Sections
	constructor:->
		@contents ?= []
		for i in [window.PaperSections.data.sectionscount..0]
			section = new SSection
				offset: (i*window.PaperSections.data.sectionheight) - 5
				height: window.PaperSections.data.sectionheight + 5
				color: window.PaperSections.data.colors[i]
			section.index = i
			@contents.push section

	update:->
		for it,i in @contents
			it.update()

	popSection:(n)->
		TWEEN.removeAll()

		for i in [@contents.length-1..0]
			if i > @contents.length-n-1
				@contents[i].popUP()

			if @contents.length-n-1 is i
				@contents[i].pop()

			if i < @contents.length-n-1
				@contents[i].popDOWN()

	teardown:->
		for i in [@contents.length-1..0]
			@contents[i].base.remove()
			@contents[i].notListenToStop()
			delete @contents[i]


window.PaperSections.sections = new Sections


onFrame = (e)->
	window.PaperSections.sections.update()

mwheel = (e, d)->
	$content = $('#js-content')
	$$ = $ @
	if $$.scrollTop() is 0 and d > 0
		e.stopPropagation()
		e.preventDefault()
	if d < 0 and ($$.scrollTop() is ($content[0].scrollHeight - window.PaperSections.$container.height()))
		e.stopPropagation()
		e.preventDefault()

$(window).on 'throttledresize', ->
	window.PaperSections.$container.off 'scroll'
	window.PaperSections.$container.off 'mousewheel'
	window.PaperSections.sections.teardown()
	delete window.PaperSections.sections
	window.PaperSections.sections = new Sections
	view.setViewSize window.PaperSections.$container.outerWidth(), (window.PaperSections.data.sectionheight*(window.PaperSections.data.sectionscount)) 
	window.PaperSections.$container.scroll window.PaperSections.scrollControl
	window.PaperSections.$container.on 'mousewheel', mwheel

window.PaperSections.$container.on 'mousewheel', mwheel




window.PaperSections.scrollControl = (e, d)->

	clearTimeout window.PaperSections.timeOut
	window.PaperSections.timeOut = setTimeout ->
		window.PaperSections.i = 0
		window.PaperSections.$container.trigger 'stopScroll'
		window.PaperSections.prev = window.PaperSections.$container.scrollTop()
	, 50

	if window.PaperSections.i % 4 is 0
		direction = if window.PaperSections.invertScroll then -1 else 1
		window.PaperSections.next = window.PaperSections.$container.scrollTop()
		window.PaperSections.scrollSpeed = direction*window.PaperSections.slice 1.2*(window.PaperSections.next - window.PaperSections.prev), window.PaperSections.data.sectionheight/2
		window.PaperSections.prev = window.PaperSections.next
	window.PaperSections.i++

	false

window.PaperSections.$container.scroll window.PaperSections.scrollControl

gui = new dat.GUI
gui.add window.PaperSections, 'invertScroll'



window.PaperSections.$container.on 'mouseenter', '.section-b', ->
	window.PaperSections.currSection = $(@).index()

window.PaperSections.$container.on 'click', '.section-b', ->
	$$ = $(@)
	window.PaperSections.sections.popSection $$.index()

if window.PaperSections.win or window.PaperSections.ff then window.PaperSections.$container.addClass 'is-with-scroll'



