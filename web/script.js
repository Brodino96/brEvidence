document.onload = function() {
    // Tells lua that the page has loaded
    fetch(`https://${GetParentResourceName()}/pageLoaded`, { method: "POST" })
}