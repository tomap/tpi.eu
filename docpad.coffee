# =================================
# Misc Configuration

envConfig = process.env
githubAuthString = "client_id=#{envConfig.tomap_GITHUB_CLIENT_ID}&client_secret=#{envConfig.tomap_GITHUB_CLIENT_SECRET}"
getRankInUsers = (users) ->
	rank = null

	for user,index in users
		if user.login is 'tomap'
			rank = String(index+1)
			break

	return rank  if rank is null

	if rank >= 10 and rank < 20
		rank += 'th'
	else switch rank.substr(-1)
		when '1'
			rank += 'st'
		when '2'
			rank += 'nd'
		when '3'
			rank += 'rd'
		else
			rank += 'th'

	return rank


# =================================
# DocPad Configuration

module.exports =
	regenerateEvery: 1000*60*60  # hour
	
	port: 8080
	
	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:
		# Site Data
		site:
			domain: "tpî.eu"
			url: "http://tpî.eu"
			title: "Thomas Piart"
			author: "Thomas Piart"
			email: "me@tpî.eu"
			description: """
				Website of Thomas Piart. Made with DocPad.
				"""
			keywords: """
				tpiart, Thomas Piart, piartt, piart
				"""

			text:
				heading: "Thomas Piart"
				#subheading: '''
				#	<t render="html.coffee">
					# 	link = @getPreparedLink.bind(@)
					# 	text """
					# 		Aficionado of ...
					# 		"""
					# 		# #{link 'javascript'}, #{link 'nodejs'}, #{link 'opensource'} and #{link 'html5'}.
					# </t>
					# '''
				about: '''
					<t render="html.coffee">
						link = @getPreparedLink.bind(@)
						text """
							This website was created with #{link 'bevry'}’s #{link 'docpad'} and is #{link 'source'}
							"""
					</t>
					'''
				copyright: '''
					<t render="html.coffee">
						link = @getPreparedLink.bind(@)
						text """
							Unless stated otherwise, all content is licensed under the #{link 'cclicense'} and code licensed under the #{link 'mitlicense'}, &copy; #{link 'author'}
							"""
					</t>
					'''

			analytics:
				google: 'UA-44xxx'

			services:
				disqus: 'tpii'

			social:
				"""
				linkedin
				github
				twitter
				""".trim().split('\n')

			scripts: """
				//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js
				/vendor/fancybox-2.1.4/jquery.fancybox.js
				/scripts/script.js
				""".trim().split('\n')

			feeds: [
					href: 'http://tpî.eu/atom.xml'
					title: 'Blog Posts'
				,
					href: 'https://github.com/tomap.atom'
					title: 'GitHub Activity'
				,
					href: 'https://api.twitter.com/1/statuses/user_timeline.atom?screen_name=tomap&count=20&include_entities=true&include_rts=true'
					title: 'Tweets'
			]

			pages: [
					url: '/'
					match: '/index'
					label: 'home'
					title: 'Return home'
				,
					url: '/projects'
					label: 'projects'
					title: 'View projects'
				,
					url: '/blog'
					label: 'blog'
					title: 'View articles'
			]

			links:
				tpi:
					text: 'Thomas Piart'
					url: 'http://tpî.eu'
					title: 'Visit Website'
				author:
					text: 'Thomas Piart'
					url: 'http://tpî.eu'
					title: 'Visit Website'
				source:
					text: 'open-source'
					url: 'https://github.com/tomap/tomap.docpad'
					title: 'View Website Source'
				cclicense:
					text: 'Creative Commons Attribution License'
					url: 'http://creativecommons.org/licenses/by/3.0/'
					title: 'Visit Website'
				mitlicense:
					text: 'MIT License'
					url: 'http://creativecommons.org/licenses/MIT/'
					title: 'Visit Website'
				contact:
					text: 'Email'
					url: 'mailto:me@tpî.eu'
					title: 'Email me'
				bevry:
					text: 'Bevry'
					url: 'http://bevry.me'
					title: 'Visit Website'
				source:
					text: 'open-source'
					url: 'https://github.com/tomap/tpi'
					title: 'View Website Source'
				docpad:
					text: 'DocPad'
					url: 'http://docpad.org'
					title: 'Visit Website'

		# Link Helper
		getPreparedLink: (name) ->
			#console.log(name)
			link = @site.links[name]
			renderedLink = """
				<a href="#{link.url}" title="#{link.title}">#{link.text}</a>
				"""
			return renderedLink

		# Meta Helpers
		getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title
		getPreparedAuthor: -> @document.author or @site.author
		getPreparedEmail: -> @document.email or @site.email
		getPreparedDescription: -> @document.description or @site.description
		getPreparedKeywords: -> @site.keywords.concat(@document.keywords or []).join(', ')

	# =================================
	# Collections

	collections:
		pages: ->
			@getCollection('documents').findAllLive({pageOrder:$exists:true},[pageOrder:1])

		posts: ->
			@getCollection('documents').findAllLive({relativeOutDirPath:'blog'},[date:-1])


	# =================================
	# Events

	events:
		serverExtend: (opts) ->
			# Prepare
			docpadServer = opts.server

			# ---------------------------------
			# Server Configuration

			# Redirect Middleware
			#docpadServer.use (req,res,next) ->
			#	if req.headers.host in ['www.tomap.com','lupton.cc','www.lupton.cc','tomap.no.de','tomap.herokuapp.com']
			#		res.redirect 301, 'http://tpî.eu'+req.url
			#	else
			#		next()

			# ---------------------------------
			# Server Extensions

			# Demos
			docpadServer.get /^\/sandbox(?:\/([^\/]+).*)?$/, (req, res) ->
				project = req.params[0]
				res.redirect 301, "http://tomap.github.com/#{project}/demo/"
				# ^ github pages don't have https

			# Projects
			docpadServer.get /^\/projects\/(.*)$/, (req, res) ->
				project = req.params[0] or ''
				res.redirect 301, "https://github.com/tomap/#{project}"

			docpadServer.get /^\/(?:g|gh|github)(?:\/(.*))?$/, (req, res) ->
				project = req.params[0] or ''
				res.redirect 301, "https://github.com/tomap/#{project}"

			# Twitter
			docpadServer.get /^\/(?:t|twitter|tweet)(?:\/(.*))?$/, (req, res) ->
				res.redirect 301, "https://twitter.com/tomap"

			# # Sharing Feed
			# docpadServer.get /^\/feeds?\/shar(e|ing)(?:\/(.*))?$/, (req, res) ->
			# 	res.redirect 301, "http://feeds.feedburner.com/tomap/shared"

			# # Feeds
			# docpadServer.get /^\/feeds?(?:\/(.*))?$/, (req, res) ->
			# 	res.redirect 301, "http://feeds.feedburner.com/tomap"

		renderAfter: (opts) ->

			console.log "after run"

			#console.log(opts)

	# =================================
	# Plugin Configuration

	plugins:
		feedr:
			feeds:
				github:
					url: "https://github.com/tomap.atom"
				twitter:
					url: "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=tomap&count=20&include_entities=true&include_rts=true"
				#flickr:
				#	url: "http://api.flickr.com/services/feeds/photos_public.gne?id=35776898@N00&lang=en-us&format=json"

