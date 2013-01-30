---
layout: default
---

# Title
if @document.title
	header '.page-header', ->
		h1 ->
			a '.page-link', href:@document.url, ->
				strong '.page-title', property:'dcterms:title', ->
					@document.title
				small '.page-date', property:'dc:date', ->
					" #{@document.date.toShortDateString()}"

# Content
div '.page-content', property: 'sioc:content',
	-> @content

# Footer
footer '.page-footer', ->
	# Subscribe Buttons
	section '.page-subscribe.subscribeButtons', ->
		# Google+
		#div '.subscribeButton.google', ->
		#	text """
		#		<div class="g-plusone" data-size="medium" data-href="#{h @site.url+@document.url}"></div>
		#		<script>
		#			(function() {
		#				var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
		#				po.src = 'https://apis.google.com/js/plusone.js';
		#				var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
		#			})();
		#		</script>
		#		"""

		# Tweet
		div '.subscribeButton.tweet', ->
			text """
				<a href="https://twitter.com/share" class="twitter-share-button" data-via="tomap" data-related="tomap">Tweet</a>
				<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
				"""

		# Twitter
		div '.subscribeButton.twitter', ->
			text """
				<a href="https://twitter.com/tomap" class="twitter-follow-button" data-show-count="false">Follow @tomap</a>
				<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
				"""

		# Github
		div '.subscribeButton.github', ->
			text """
				<iframe src="//ghbtns.com/github-btn.html?user=tomap&type=follow&count=true" allowtransparency="true" frameborder="0" scrolling="0" width="165" height="20"></iframe>
				"""

	# Related Posts
	relatedPosts = []
	for document in @document.relatedDocuments or []
		if document.url.indexOf('/blog') is 0 and document.url.indexOf('/blog/index') isnt 0
			relatedPosts.push(document)
	if relatedPosts.length
		section '.related-documents', ->
			h2 -> 'Related Posts'
			text @partial 'content/document-list', {
				documents: relatedPosts
			}

	# Disqus
	section '.page-comments', ->
		text @partial('services/disqus', @)