(function () {
  const searchParams = new URL(document.currentScript.src).searchParams

  var banner = document.createElement("div")
  banner.style.width = (searchParams.get('width') || '728') + 'px'
  banner.style.height = (searchParams.get('height') || '90') + 'px'
  banner.style.backgroundColor = "#f0f0f0"
  banner.style.border = "1px solid #ccc"
  banner.style.fontSize = "16px"
  banner.style.color = "#999"
  banner.textContent = "Ads"
  banner.style.display = "flex"
  banner.style['justify-content'] = "center"
  banner.style['align-items'] = "center"

  document.currentScript.parentElement.appendChild(banner)
})();
