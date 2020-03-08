'use strict'

const opCodes = {
  ADC: 'Add with carry',
  AND: 'And',
  ASL: 'Arithmetic shift left',
  BCC: 'Branch on carry clear',
  BCS: 'Branch on carry set',
  BEQ: 'Branch on equal',
  BIT: 'Bit test',
  BMI: 'Branch on minus',
  BNE: 'Branch on not equal',
  BPL: 'Branch on plus',
  BRK: 'Break / interrupt',
  BVC: 'Branch on overflow clear',
  BVS: 'Branch on overflow set',
  CLC: 'Clear carry',
  CLD: 'Clear decimal',
  CLI: 'Clear interrupt disable',
  CLV: 'Clear overflow',
  CMP: 'Compare with accumulator',
  CPX: 'Compare with X',
  CPY: 'Compare with Y',
  DEC: 'Decrement',
  DEX: 'Decrement X',
  DEY: 'Decrement Y',
  EOR: 'Exclusive or',
  INC: 'Increment',
  INX: 'Increment X',
  INY: 'Increment Y',
  JMP: 'Jump',
  JSR: 'Jump subroutine',
  LDA: 'Load accumulator',
  LDX: 'Load X',
  LDY: 'Load Y',
  LSR: 'Logical shift right',
  NOP: 'No operation',
  ORA: 'Or with accumulator',
  PHA: 'Push accumulator onto stack',
  PHP: 'Push processor status onto stack',
  PLA: 'Pull accumulator from stack',
  PLP: 'Pull processor status from stack',
  ROL: 'Rotate left',
  ROR: 'Rotate right',
  RTI: 'Return from interrupt',
  RTS: 'Return from subroutine',
  SBC: 'Subtract with carry',
  SEC: 'Set carry',
  SED: 'Set decimal',
  SEI: 'Set interrupt disable',
  STA: 'Store accumulator',
  STX: 'Store X',
  STY: 'Store Y',
  TAX: 'Transfer accumulator to X',
  TAY: 'Transfer accumulator to Y',
  TSX: 'Transfer stack pointer to X',
  TXA: 'Transfer X to accumulator',
  TXS: 'Transfer X to stack pointer',
  TYA: 'Transfer Y to accumulator'
}

function lint6502 (text) {
  const lines = text.split('\n').filter((line) => { return line.trim() !== '' })

  function ucOpCodes (line) {
    return line.split(' ').map((word) => {
      return opCodes[word.toUpperCase()] ? word.toUpperCase() : word
    }).join(' ')
  }

  function padOpcodes (line) {
    if (!opCodes[line.trim().split(' ')[0].toUpperCase()]) { return line }
    return '  ' + line.trim()
  }

  function commentRoutine (line) {
    if (line.trim().split(' ')[0].indexOf(':') < 0) { return line }
    const parts = line.split(';')
    const routine = parts[0].trim()
    const comment = parts[1] ? parts[1].trim() : ' '
    return `${routine.padEnd(31, ' ')}; ${comment}`
  }

  function padComment (line) {
    if (line.indexOf(';') < 3) { return line }
    const parts = line.split(';')
    const instruction = parts[0].trimEnd()
    const comment = parts[1].trim()
    return `${instruction.padEnd(31, ' ')}; ${comment}`
  }

  function ucHexCode (line) {
    const parts = line.split(' ')
    return parts.map((item) => { return item.substr(0, 2) === '#$' ? item.toUpperCase() : item }).join(' ')
  }

  function blockComment (line, prev, next) {
    if (line.indexOf(';;') < 0) { return line }
    return `${prev && prev.trim().substr(0, 2) === ';;' ? '' : '\n'}${line.trim()}${next && next.trim().substr(0, 2) === ';;' ? '' : '\n'}`
  }

  for (const id in lines) {
    lines[id] = ucOpCodes(lines[id])
    lines[id] = commentRoutine(lines[id], lines[id - 1], lines[id + 1])
    lines[id] = blockComment(lines[id], lines[id - 1], lines[id + 1])
    lines[id] = padOpcodes(lines[id], lines[id - 1], lines[id + 1])
    lines[id] = padComment(lines[id], lines[id - 1], lines[id + 1])
    lines[id] = ucHexCode(lines[id], lines[id - 1], lines[id + 1])
  }
  return lines.join('\n')
}

// Load /src

const fs = require('fs')
const folder = 'src'

if (fs.existsSync(folder)) {
  fs.readdirSync(folder).forEach(file => {
    if (file.indexOf('.asm') > -1) {
      const path = folder+'/'+file
      const contents = fs.readFileSync(path, 'utf8')
      const linted = lint6502(contents)
      if (contents !== linted) {
        console.log(`Linting ${path}`)
        fs.writeFileSync(path, lint6502(contents))
      }
    }
  })

}
else{
  console.error('Error: Could not open folder /'+folder)
}

