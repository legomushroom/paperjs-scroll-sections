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

windowHeight = $(window).outerHeight()

window.PaperSections.$canvas 	= $(view.canvas)
window.PaperSections.data 	= window.PaperSections.$canvas.data()
window.PaperSections.data.colors = window.PaperSections.data.colors.split ':'
window.PaperSections.data.sectionscount ?= window.PaperSections.data.colors.length
view.setViewSize $(window).outerWidth(), (window.PaperSections.data.sectionheight*(window.PaperSections.data.sectionscount)) 

window.PaperSections.$content = $("##{window.PaperSections.data.contentid}")

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
		
		@makeBase()
		@listenToStop()

	listenToStop:->
		window.PaperSections.$container.on 'scroll', =>
			window.PaperSections.stop = false
			TWEEN.removeAll()


		window.PaperSections.$container.on 'stopScroll', =>
			window.PaperSections.stop = true
			duration = window.PaperSections.slice(Math.abs(window.PaperSections.scrollSpeed*25), 1400) or 3000
			console.log duration
			@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		0
			).then =>
				window.PaperSections.scrollSpeed = 0


			@translatePointY
				point: 	@base.segments[3].handleOut
				to: 		0


	translatePointY:(o)->
		dfr = new $.Deferred
		mTW = new TWEEN.Tween(new Point(o.point)).to(new Point(o.to), o.duration)
		mTW.easing o.easing or TWEEN.Easing.Elastic.Out

		mTW.onUpdate o.onUpdate or (a)->
			o.point.y = @y
			# window.PaperSections.$content.css 'top': "#{@y/2}px"
			window.PaperSections.$content.css '-webkit-transform': "translate3d(0,#{@y/2}px,0)"


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
		if !window.PaperSections.stop
			@toppie window.PaperSections.scrollSpeed
			@bottie window.PaperSections.scrollSpeed
			# window.PaperSections.$content.css 'top': "#{window.PaperSections.scrollSpeed/2}px"
			window.PaperSections.$content.css '-webkit-transform': "translate3d(0,#{window.PaperSections.scrollSpeed/2}px,0)"

		TWEEN.update()

	procent:(base, percents)->
		(base/100)*percents

class Sections
	contents:[]
	update:->
		for it,i in @contents
			it.update()

window.PaperSections.sections = new Sections


for i in [window.PaperSections.data.sectionscount..0]
	section = new SSection
		offset: (i*window.PaperSections.data.sectionheight) - 5
		height: window.PaperSections.data.sectionheight + 5
		color: window.PaperSections.data.colors[i]

	window.PaperSections.sections.contents.push section

onFrame = (e)->
	window.PaperSections.sections.update()










