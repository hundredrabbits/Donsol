const Donsol = require('./desktop/server/core/donsol')
const Terminal = require('./cli/terminal')

const donsol = new Donsol()
const terminal = new Terminal(donsol)

terminal.install();
terminal.start();
