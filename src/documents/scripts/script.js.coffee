# Wait
wait = (delay,callback) -> setTimeout(callback,delay)

# Hide failed images
images = document.getElementsByTagName('img')
for img in images
	img.onerror = ->
		a = @parentNode
		li = a.parentNode
		if li.tagName.toLowerCase() is 'li'
			li.parentNode.removeChild(li)
		else
			@parentNode.removeChild(@)

# Prevent Scroll Bubbling
# When the item has finished scrolling, prevent it the scroll from bubbling to parent elements
$.fn.preventScrollBubbling = ->
	$(@).bind 'mousewheel', (event, delta, deltaX, deltaY) ->
		@scrollTop -= (deltaY*20)
		event.preventDefault()

# Get Root URL
# https://github.com/balupton/history.js/blob/master/scripts/uncompressed/history.js#L358
getRootUrl = ->
	rootUrl = document.location.protocol + "//" + (document.location.hostname or document.location.host)
	rootUrl += ":" + document.location.port  if document.location.port or false
	rootUrl += "/"
	rootUrl

# ---------------------------------
# Selectors

# Internal Helper
$.expr[":"].internal = (obj, index, meta, stack) ->
	# Prepare
	$this = $(obj)
	url = $this.attr("href") or $this.data("href") or ""
	rootUrl = getRootUrl()

	# Check link
	isInternalLink = url.substring(0, rootUrl.length) is rootUrl or url.indexOf(":") is -1

	# Ignore or Keep
	return isInternalLink


# External Helper
$.expr[":"].external = (obj, index, meta, stack) ->
	return $.expr[":"].internal(obj, index, meta, stack) is false


# ---------------------------------
# jQuery's domReady

$ ->
	# Prepare
	$body = $(document.body)

	# ---------------------------------
	# Links

	# Open Link
	openLink = ({url,action}) ->
		if action is 'new'
			window.open(url,'_blank')
		else if action is 'same'
			wait(100, -> document.location.href = url)
		return

	# Open Outbound Link
	openOutboundLink = ({url,action}) ->
		# https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide
		hostname = url.replace(/^.+?\/+([^\/]+).*$/,'$1')
		if window._gaq
			_gaq.push(['_trackEvent', "Outbound Links", hostname, url, 0, true])
		openLink({url,action})
		return

	# Outbound Link Tracking
	$body.on 'click', 'a[href]:external:not(.fancybox)', (event) ->
		# Prepare
		$this = $(this)
		url = $this.attr('href')
		return  unless url

		# Discover how we should handle the link
		if event.which is 2 or event.metaKey
			action = 'default'
		else
			action = 'same'
			event.preventDefault()

		# Open the link
		openOutboundLink({url,action})

		# Done
		return

	# ---------------------------------
	# Images
	$('.fancybox').fancybox().bind (event) ->
		event.stopPropagation()
	# ---------------------------------
	# Misc

	# Prevent scrolling on our sidebar scrollers
	#$('.scroller').preventScrollBubbling()
	$('section.vimeo a').click (event) ->
		# Continue as normal for cmd clicks etc
		return true  if event.which is 2 or event.metaKey

		# Prevent the link, or special link handlers from occuring
		event.preventDefault()
		event.stopImmediatePropagation()

		# Show the fancybox
		$a = $(@)
		url = $a.attr('href')
		videoId = url.replace(/[^0-9]/g,'')
		video =
			id: videoId
			title: $a.attr('title')
			width: $a.data('width')
			height: $a.data('height')
		$.fancybox.open(
			href: "http://player.vimeo.com/video/#{video.id}"
			title: video.title
			width: video.width
			height: video.height
			padding: 0
			type: 'iframe'
		)

		# Track the click
		openOutboundLink({url,action:false})

		# Done
		return

	# Show javascript properties
	$('.js').removeClass('js')

	# Handle more to read areas
	$('.more-to-read').hide()
	$('.read-more').click ->
		if window._gaq
			_gaq.push(['_trackEvent', "Read More", document.title, document.location.href, 0, true])
		$(this).hide().next('.more-to-read').show()
