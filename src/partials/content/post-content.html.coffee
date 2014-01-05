h2 '.document', 'typeof':'soic:post', about:@document.url, ->
	span ->
		"Last article: " 
	a '.document-link', href:@document.url, ->
		strong '.document-title', property:'dc:title', ->
			@document.title
		small '.document-date', property:'dc:date', ->
			@document.date.toDateString()
if @document.description
	p '.document-description', property:'dc:description', ->
		@document.description

# Content
div '.page-content', property: 'sioc:content',
	-> @content
