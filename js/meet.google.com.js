const scriptID = 'a33983864c08a1990b771ee6'

if (!window[scriptID]) {
  document.addEventListener('keydown', function(event) {
    if (['INPUT', 'TEXTAREA'].includes(event.target.tagName)) {
      return
    }
    switch (event.key) {
    case 'm': // toggle microphone (Cmd + D)
      document.dispatchEvent(new KeyboardEvent('keydown', {keyCode: 68, metaKey: true}))
      break
    case 'v': // toggle camera (Cmd + E)
      document.dispatchEvent(new KeyboardEvent('keydown', {keyCode: 69, metaKey: true}))
      break
    }
  })
}

window[scriptID] = true
