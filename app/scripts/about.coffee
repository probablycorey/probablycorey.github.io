colors = ["Aquamarine","Azure","Beige","Bisque","Black","Blue","Brown","Chartreuse","Chocolate","Coral","Cornsilk","Crimson","Cyan","Darkorange","Fuchsia","Gainsboro","Gold","Gray","Grey","Green","Indigo","Ivory","Khaki","Lavender","Lime","Linen","Magenta","Maroon","Moccasin","Navy","Olive","Orange","Orchid","Peru","Pink","Plum","Purple","Red","Salmon","Sienna","Silver","Snow","Tan","Teal","Thistle","Tomato","Turquoise","Violet","Wheat","White","Yellow"]

document.addEventListener 'DOMContentLoaded', ->
  color = colors[Math.floor(Math.random()*colors.length)]
  document.querySelector('.random-color').style.background = color

  colorName = color.replace(/([A-Z][a-z]+)/g, " $1").trim().toLowerCase()
  document.querySelector('.random-color-name').textContent = colorName
  document.querySelector('.random-color-name').style.color = color
