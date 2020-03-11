console.log('\n\nshuffle:')

function shuffle (a) {
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]]
  }
  return a
}

function toHex (int) {
  return '$' + int.toString(16).padStart(2, '0')
}

function format (acc, item, key) {
  return `${acc}${item}${key !== 53 ? ',' : ''}${(key + 1) % 14 === 0 ? '\n  ' : ''}`
}

// Generate deck

const deck = []

for (let i = 0; i < 54; i++) {
  deck.push(i)
}

console.log('  ' + shuffle(deck).map(toHex).reduce(format, '') + '\n\n')
