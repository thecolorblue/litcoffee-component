This is a test of a number of technologies to see how they work. I am using a
grunt script to compile coffeescript in literate mode into documentation
(compiled with docco) and the js plugin. There is also a test file that has
documentation in it and tests for the plugin.

This is probably a good place to talk about how to get started. 
You should already have a package.json file. Run 'npm install' to install all of the dependencies for this project. Afterwards, you can run 'grunt' to compile the plugin and 'docco src/* -0 docs/' to compile the documentation (this file). Soon docco will be integrated with the grunt script but that is on the TODO list. 

In this file you will see the plugin broken up into classes and the methods on the class. Each should have a little explination of what they do. To see them in action head over to the test file, and the test file documentation. 

This is our global types object we will be attaching everything too. 

	types = {}

Tire size has a lot of functionality that should be attached to it. The
constructor accepts a string, parses the string and sets up the object for
quick lookup and comparing. We are doing a little magic here to get the size
to return a string instead of an object.

	Size = types.size = (string)->
		size = String(string)
		sizeParts = string.exec ///^(LT)(\d)/(\d)R(\d)///

		if /\D/.test size[0]
			prefix = size.shift()
		
		size.width = size.shift()
		size.diameter = size.shift()
		size.weightLimit = size.shift()
		size.prefix = prefix if prefix
		size.isP = @isP.bind @
		size.isLT = @isLT.bind @
		size


We want to easily filter out P and LT tire sizes. We create helpers for that.

	Size.prototype.isP = ()->
		@prefix is 'P'
	Size.prototype.isLT = ()->
		@prefix is 'LT'

Promotions for tires do not have as many functions and are mostly used as reference for the tire.

	type.promotion = (obj = {})->
		@when = obj.when if obj.when
		@do = obj.do if obj.do

And finally the tire, that will pull together these classes. We also set up a number of flags to make comparing easier.


	types.Tire = (obj = {})->
		@size = types.size obj.size
		@promotions = []
		@promotions.push new type.promotion promo for promo in obj.promotions
		@bwStaggered
		@setFlags()
		@attributes = obj
		@

I am trying out bitwise comparisons. I have done some basic performance tests
(http://jsperf.com/bitwise-compare) that show a good increase in performance
when comparing multiple flags. In fact, multiple flags seems to be the same to
compare as one flag, meaning we filter out winter tires, staggered sets and
OEA tires very quickly. Some more testing should be done in this area.

bwFlags is a combination of all the flags for this tire in one bit to make comparing faster.

bits:

 - winter
 - 3 season
 - all season
 - staggered
 - hasPromotions
 - OEM
 - OEA
 - P
 - LT

	types.Tire.prototype.setFlags = ()->
		winterFlag = 0x1 if @attributes.isWinter
		threeSeasonFlag = 0x2 if @attributes.season is '3 season'
		allSeasonFlag = 0x4 if @attributes.season is 'all season'
		staggeredFlag = 0x8 if @attributes.staggered
		promotionsFlag = 0x16 if @promotions.length > 0
		oemFlag = 0x32 if @attributes.program is 'OEM'
		oeaFlag = 0x64 if @attributes.program is 'OEA'
		pFlag = 0x128 if @size.isP()
		ltFlag = 0x256 if @size.isLT()

		@bwFlags = winterFlag | threeSeasonFlag | allSeasonFlag | staggeredFlag | promotionsFlag | oemFlag | oeaFlag
		@

