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

Path::copyPath = (path)->
	for i in [path.segments.length-1..0]
		@.add new Point path.segments[i].point

h = 
    	getRand:(min,max)->
        Math.floor((Math.random() * ((max + 1) - min)) + min)

windowHeight = $(window).outerHeight()

view.setViewSize $(window).outerWidth(), 300


# Modernizr.touch = false



class SSection
	constructor:->
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
		# if !Modernizr.touch
		window.PaperSections.$container.on 'scroll', =>
			window.PaperSections.stop = false
			TWEEN.removeAll()


		window.PaperSections.$container.on 'stopScroll', =>
			window.PaperSections.stop = true
			duration = window.PaperSections.slice(Math.abs(window.PaperSections.scrollSpeed*25), 1400) or 3000

			@translatePointY(
				point: 	@base.segments[1].handleOut
				to: 		0
			).then =>
				console.log 'anim complete'
			

			@translatePointY
				point: 	@base.segments[3].handleOut
				to: 		0


	translatePointY:(o)->
		dfr = new $.Deferred
		mTW = new TWEEN.Tween(new Point(o.point)).to(new Point(o.to), o.duration)
		mTW.easing o.easing or TWEEN.Easing.Elastic.Out

		mTW.onUpdate o.onUpdate or (a)->
			o.point.y = @y

		mTW.onComplete =>
			dfr.resolve()

		mTW.start()
		dfr.promise()
		

	makeBase:->
		@flattenSize = 25
		@base = new Path.Rectangle new Point(0,@procent @h, (100-@ph)/2), [@wh, @sh]
		@base.fillColor = $(view.canvas).data().color
		# @base.selected = true

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
		if !@stop
			@toppie window.PaperSections.scrollSpeed
			@bottie window.PaperSections.scrollSpeed

		TWEEN.update()
		# console.log 'update'
		# @base.segments[1].point.y -= 1
		# 
	procent:(base, percents)->
		(base/100)*percents

section = new SSection

onFrame = (e)->
	section.update()


# class Precious
# 	constructor:->
# 		@updCnt = 0
# 		@twns = []
# 		@sections = []
# 		@chars = []
# 		@colors = ['red','green','blue','purple','pink','black','orange', 'yellow']

# 		@baseShape = [ new Point(60, 60), new Point(50, 80), new Point(95, 140), new Point(140, 80), new Point(130, 60), new Point(58, 60) ]

# 		@diamondShape = [
# 			{x:130,y:59}
# 			{x:140,y:80}
# 			{x:95, y:140}
# 			{x:50, y:80}
# 			{x:60, y:60}
			
			
# 			{x:127,y:60}
# 			{x: 115, y: 80}
# 			{x: 95, y: 62}
# 			{x: 75, y: 80}
# 			{x:60, y:62}

			
# 			{x:52, y:80}
# 			{x:140,y:80}
# 			{x: 115, y: 80}
# 			{x:95, y:137}
# 			{x: 75, y: 80}
# 		]

# 		@makeAnimations()

		



# 	makeBase:->
# 		@base = new Path @baseShape
# 		@base.strokeColor = 'black'
# 		@base.strokeWidth = 6
		

# 	makeAnimations:->
# 		@createSections()

# 		if !@uPath
# 			@uPath = @createPath points: [ 	
# 									{x: 15, 	y: 15}
# 									{x: 105, 	y: 85}
# 									{x: 190, 	y: 5}
# 									{x: 15, 	y: 85}
# 									{x: 145, 	y: 105}

# 									{x: 95, 	y: 25}
# 									{x: 65, 	y: 165}
# 									{x: 135, 	y: 65}
# 									{x: 5, 	y: 55}
# 									{x: 155, 	y: 155}
									
# 									{x: 170, 	y: 50}
# 									{x: 10, 	y: 160}
# 									{x: 70, 	y: 10}
# 									{x: 180, 	y: 100}
# 									{x: 10, 	y: 180}
# 									]

# 		@reflection = new Path [ 	
# 						{x: -30, y: 50}
# 						{x:0,y:50}
# 						{x:100,y:190}
# 						{x:70,y:190}
# 						]

# 		@sections.push @reflection


# 		center = new Point(115, 80);
# 		points = 5;
# 		radius1 = 3;
# 		radius2 = 7;
# 		@glare = new Path.Star(center, points, radius1, radius2);
# 		@glare.fillColor = 'white';
# 		@glare.opacity = 0


# 		center = new Point(130, 60);
# 		points = 5;
# 		radius1 = 3;
# 		radius2 = 7;
# 		@glare2 = new Path.Star(center, points, radius1, radius2);
# 		@glare2.fillColor = 'white';
# 		@glare2.opacity = 0

# 		@sections.push @glare
# 		@sections.push @glare2

# 		@write
# 			text: 'CURIOSITY'
# 			point: x:25, y:20

# 		@write
# 			text: 'AWARD!'
# 			point: x:50, y:190

# 		@translatePath(
# 				path: @uPath
# 				dest: @diamondShape
# 				easing: TWEEN.Easing.Bounce.Out
# 				# easing: TWEEN.Easing.Elastic.InOut
# 				duration: 1200
# 		).then =>
# 			@fadeInSections
# 				sections: @sections
# 				delay: 200

# 			@reflection.fillColor = 'white'
# 			@reflection.opacity = .6

# 			setTimeout =>
				
# 				@glare.opacity = 1
# 				@popCircle(
# 					path: @glare
# 					from: 	r: 0
# 					to: 		r: 18
# 					center: 	new Point(115,80)
# 					duration: 300
# 					easing: TWEEN.Easing.Cubic.In

# 				).then =>

# 					@popCircle
# 						path: @glare
# 						from: 	r: 18
# 						to: 		r: 0
# 						center: 	new Point(115,80)
# 						duration: 200
# 						easing: TWEEN.Easing.Cubic.Out

# 				setTimeout =>

# 					@glare2.opacity = 1
# 					@popCircle(
# 						path: @glare2
# 						from: 	r: 0
# 						to: 		r: 10
# 						center: 	new Point(130,60)
# 						duration: 300
# 						easing: TWEEN.Easing.Cubic.In

# 					).then =>
# 						@popCircle
# 							path: @glare2
# 							from: 	r: 10
# 							to: 		r: 0
# 							center: 	new Point(130,60)
# 							duration: 200
# 							easing: TWEEN.Easing.Cubic.Out

# 				, 100

# 			, 600

# 			@translateObj(
# 				obj: @reflection
# 				to: {x: 200, y: @reflection.position.y}
# 				duration: 1000
# 			)
	

# 	write:(o)->
# 		o.fSize ?= .1
# 		for i in [0...o.text.length]
# 			char = @createChar
# 					content: o.text[i]
# 					center: [o.point.x+(i*18),o.point.y]
# 					fSize: o.fSize
# 					color: "black"
# 					# color: @colors[h.getRand(0,@colors.length-1)]

# 			@chars.push char

# 	createChar:(o)->
# 		that = @
# 		class Char
# 			constructor:(o)->
# 				@char = new PointText(new Point(o.center));
# 				@char.characterStyle = 
# 					fontSize: o.fSize
# 					# font: 'BoB'
# 					fillColor: o.color
# 				@char.content = o.content
# 				@i = h.getRand 0, 1
# 				@rotationAmount = h.getRand 4, 8

# 				that.popChar 
# 					char: @char
# 					from: r:1
# 					to: r:8


# 			animate:->
# 				if @i is 0
# 					@char.rotate @rotationAmount
# 					@i = 1
# 				else 
# 					@i = 0
# 					@char.rotate -@rotationAmount

# 		return new Char o


		

# 	translateObj:(o)->
# 		dfr = new $.Deferred

# 		o.from ?= o.obj.position

# 		mTW = new TWEEN.Tween(new Point(o.from)).to(new Point(o.to), o.duration or 800)
# 		@twns.push mTW
# 		mTW.easing o.easing or TWEEN.Easing.Quartic.In
# 		that = @
# 		mTW.onUpdate o.onUpdate or (a)->
# 			o.obj.position.x = @x
# 			o.obj.position.y = @y

# 		mTW.onComplete =>
# 			dfr.resolve(mTW)


# 		dfr.promise()

# 	createSection:(o)->
# 		o.opacity ?= 0
# 		section = @createPath 
# 						fill: o.fill
# 						closed: true
# 						width:0
# 						color: 'transparent'
# 						opacity: o.opacity
# 						points: o.points
# 		@sections.push section

# 	createSections:->
# 		@createSection
# 				fill: '#ff4cae'
# 				points: [ 	
# 						{x:50, y:80}
# 						{x: 75, y: 80}
# 						{x:95, y:140}
# 						]

# 		@createSection
# 				fill: '#e053db'
# 				points: [ 	
# 						{x: 75, y: 80}
# 						{x: 115, y: 80}
# 						{x:94, y:140}
# 						]

# 		@createSection
# 				fill: '#b153db'
# 				points: [ 	
# 						{x: 115, y: 80}
# 						{x:140,y:80}
# 						{x:95, y:140}
# 						]

# 		# UPPPER
# 		@createSection
# 				fill: '#ff4cae'
# 				points: [ 	
# 						{x:50, y:80}
# 						{x:60, y:60}
# 						{x: 75, y: 80}
# 						]

# 		@createSection
# 				fill: '#ff4cae'
# 				points: [ 	
# 						{x:60, y:60}
# 						{x: 75, y: 80}
# 						{x:95,y:60}
# 						]

# 		@createSection
# 				fill: '#ed4ef2'
# 				points: [ 	
# 						{x: 75, y: 80}
# 						{x:95,y:60}
# 						{x: 115, y: 80}
# 						]

# 		@createSection
# 				fill: '#ce4adb'
# 				points: [ 	
# 						{x:95,y:60}
# 						{x: 115, y: 80}
# 						{x:130,y:60}
# 						]

# 		@createSection
# 				fill: '#b153db'
# 				points: [ 	
# 						{x: 115, y: 80}
# 						{x:130,y:60}
# 						{x:140,y:80}
# 						]

		

# 	translatePath:(o)->
# 		dfr = new $.Deferred
# 		for i in [0...o.path.segments.length]
# 			@translatePoint(
# 				point: 	o.path.segments[i].point
# 				to: 		o.dest[i]
# 				easing: 	o.easing
# 				duration: o.duration
# 			).then =>
# 				dfr.resolve()

# 		dfr.promise()


# 	translatePoint:(o)->
# 		dfr = new $.Deferred
# 		mTW = new TWEEN.Tween(new Point(o.point)).to(new Point(o.to), o.duration or 800)
# 		@twns.push mTW
# 		mTW.easing o.easing or TWEEN.Easing.Quartic.In
# 		that = @
# 		mTW.onUpdate o.onUpdate or (a)->
# 			o.point.x = @x
# 			o.point.y = @y


# 		mTW.onComplete =>
# 			dfr.resolve(mTW)

# 		dfr.promise()


# 	drawLongLine:(o)->
# 		o.cnt ?= -1
# 		o.cnt++
# 		# o.path ?= @createPath()
# 		if o.points[o.cnt] and o.points[o.cnt+1]
# 			o.path.add o.points[o.cnt]
# 			if o.cnt is 0 then o.path.add o.points[o.cnt]
# 			@drawLine(
# 				from: o.points[o.cnt]
# 				to: o.points[o.cnt+1]
# 				pointUpdate: o.path.segments[o.cnt+1].point
# 				duration: (o.duration/(o.points.length-1))
# 			).then =>
# 				o.then and o.path[o.then]()
# 				@drawLongLine o


# 	fade:(o)->
# 		if !o.obj? then return
# 		o.direction ?= 'in'
# 		o.duration ?= 800
# 		switch o.direction 
# 			when 'in'
# 				o.to ?= 1
# 			when 'out'
# 				o.to ?= 0

# 		dfr = new $.Deferred
# 		mTW = new TWEEN.Tween(opacity: o.obj.opacity).to(opacity: o.to, o.duration)
# 		mTW.easing o.easing or TWEEN.Easing.Quartic.Out
# 		mTW.onUpdate o.onUpdate or (a)->
# 			o.obj.opacity = @.opacity
			
# 		mTW.onComplete =>
# 			dfr.resolve(mTW)
		
# 		@twns.push mTW


# 		dfr.promise()

# 	fadeInSections:(o)->
# 		@fade(obj: @sections[0])
# 		@fade(obj: @sections[3])

# 		setTimeout =>
# 			@fade(obj: @sections[4])
# 			setTimeout =>
# 				@fade(obj: @sections[5])
# 				setTimeout =>
# 					@fade(obj: @sections[6])
# 					setTimeout =>
# 						@fade(obj: @sections[7])
# 					, o.delay/2
# 				, o.delay/2
# 			, o.delay/2
# 		, o.delay/2

# 		setTimeout =>
# 			@fade(obj: @sections[1])
# 			setTimeout =>
# 				@fade(obj: @sections[2])
# 			, o.delay
# 		, o.delay

		
# 	createPath:(o)->
# 		path = if o?.points then new Path o?.points else new Path

# 		o?.width ?= 6
# 		path.strokeWidth = o?.width
# 		path.strokeColor = o?.color or '#222'
# 		if o.fill then path.fillColor = o.fill
# 		o.closed and path.closed = true
# 		o.opacity ?= 1
# 		path.opacity = o.opacity

# 		path
		

# 	drawLine:(o)->
# 		dfr = new $.Deferred
# 		mTW = new TWEEN.Tween(new Point(o.from)).to(new Point(o.to), o.duration or 800)
# 		mTW.chained = o.chained
# 		@twns.push mTW
# 		mTW.easing o.easing or TWEEN.Easing.Quartic.In
# 		that = @
# 		mTW.onUpdate o.onUpdate or (a)->
# 			o.pointUpdate.x = @x
# 			o.pointUpdate.y = @y


# 		mTW.onComplete =>
# 			dfr.resolve(mTW)

# 		dfr.promise()

# 	popCircle:(o)->
# 		dfr = new $.Deferred
# 		mTW = new TWEEN.Tween(o.from).to(o.to, o.duration or 2000)
# 		mTW.chained = o.chained
# 		@twns.push mTW
# 		mTW.easing o.easing or TWEEN.Easing.Cubic.Out
# 		that = @
# 		@i = 0
# 		mTW.onUpdate o.onUpdate or (a)->

# 			o.path.fitBounds @r, @r

# 			o.path.position.x = o.center.x
# 			o.path.position.y = o.center.y

# 			# o.path.smooth()


# 		mTW.onComplete =>
# 			dfr.resolve(mTW)

# 		dfr.promise()

# 	popChar:(o)->
# 		dfr = new $.Deferred
# 		mTW = new TWEEN.Tween(o.from).to(o.to, o.duration or 800)
# 		mTW.delay 2500
# 		@twns.push mTW
# 		# mTW.easing o.easing or TWEEN.Easing.Back.InOut
# 		mTW.easing o.easing or TWEEN.Easing.Elastic.Out
# 		that = @
# 		@i = 0
# 		mTW.onUpdate o.onUpdate or (a)->
# 			o.char?.fontSize  = @r
# 			# o.char?.position.x = o.center.x - (@r/2)
# 			# o.char?.position.y = o.center.y + (@r/2)

# 		mTW.onComplete =>
# 			dfr.resolve(mTW)

# 		dfr.promise()


# 	reset:->
# 		@uPath?.remove()
# 		@glare?.remove()
# 		@glare2?.remove()

# 		delete @uPath
# 		delete @glare
# 		delete @glare2

# 		TWEEN.removeAll()
# 		@clearStack @twns
# 		@clearChars()
# 		@clearSections()
		
# 		@makeAnimations()


# 	clearStack:(stack)->
# 		for i in [0...stack.length]
# 			stack[i]?.stop?()
# 			stack[i]?.remove?()
# 			delete stack[i]
# 		stack = []

# 	clearChars:()->
# 		for i in [0...@chars.length]
# 			@chars[i]?.char.stop?()
# 			@chars[i]?.char.remove?()
# 			delete @chars[i].char
# 		@chars = []

# 	clearSections:()->
# 		for i in [0...@sections.length]
# 			@sections[i]?.remove()
# 			delete @sections[i]
# 		@sections = []

# 	startTweens:->
# 		for i in [0...@twns.length]
# 			if !@twns[i]?.started and !@twns[i]?.chained
# 				@twns[i]?.start()
# 				@twns[i]?.started = true

# 	animateChars:->
# 		for i in [0...@chars.length]
# 			@chars[i]?.animate()

# 	update:(e)->

# 		# if ++@updCnt % 10 is 0
# 		# 	@animateChars()

# 		if !@allowAnimation then return

		
# 		@startTweens()
# 		TWEEN.update()


# precious = new Precious

# onFrame = (e)->
# 	precious.update()


# $can = $('#myCanvas')

# $can.on 'mouseover', =>
# 	precious.allowAnimation = true

# $can.on 'mouseleave', =>
# 	precious.reset()
# 	precious.allowAnimation = false










