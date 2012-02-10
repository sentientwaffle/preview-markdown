stratus  = require 'stratus'
ui       = require 'stratus-ui'
KEY      = window.data.config["preview.markdown.html"] || "Alt-Control-m"
SHOWDOWN = "https://raw.github.com
/github/github-flavored-markdown
/gh-pages/scripts/showdown.js"


stratus.on "fractus.key.#{KEY}", (editor) ->
  syntax = editor.syntax.name
  return unless syntax && /^Markdown\b/.test(syntax)
  
  filename = _.last editor.path.split("/")
  markdown = editor.text()
  
  loadShowdown ->
    display filename, markdown
  

# Internal: Convert the `markdown` to html and render it.
# 
# filename - The String name of the file being previewed.
# markdown - Some markdown string.
# 
# Returns nothing.
display = (filename, markdown) ->
  html  = (new Showdown.converter()).makeHtml(markdown)
  $cont = $ "<div/>", class: "preview-markdown-html"
  # Remove <br>'s... cause they are annoying...
  html  = html.replace /<br ?\/>/g, " "
  
  $cont.html html
  ui.dialog "#{filename} &rarr; HTML", $cont
  $cont.closest(".dialog").css
    height: "100%"
    width:  "100%"


# Internal: Run the function when Showdown is loaded.
# 
# callback - A function called when Showdown is available.
# 
# Returns nothing.
loadShowdown = (callback) ->
  if window.Showdown
    callback()
  else
    jQuery.getScript SHOWDOWN, callback
