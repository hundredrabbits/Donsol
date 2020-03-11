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

  function ucHexCode (line) {
    const parts = line.split(' ')
    return parts.map((item) => { return item.substr(0, 2) === '#$' ? item.toUpperCase() : item }).join(' ')
  }

  function routineComment (line) {
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

  function blockComment (line, prev, next) {
    if (line.indexOf(';;') < 0) { return line }
    return `${prev && prev.trim().substr(0, 2) === ';;' ? '' : '\n'}${line.trim()}${next && next.trim().substr(0, 2) === ';;' ? '' : '\n'}`
  }

  function padEqu (line) {
    if (line.indexOf('.equ') < 0) { return line }
    const parts = line.split('.equ')
    const name = parts[0].trim()
    const value = parts[1].trim()
    return `${name.padEnd(20, ' ')}.equ ${value}`
  }

  function padDsb (line) {
    if (line.indexOf('.dsb') < 0 || line.trim().substr(0, 4) === '.dsb') { return line }
    const parts = line.split('.dsb')
    const name = parts[0].trim()
    const value = parts[1].trim()
    return `${name.padEnd(24, ' ')}.dsb ${value}`
  }

  for (const id in lines) {
    // opcodes
    lines[id] = ucOpCodes(lines[id])
    lines[id] = padOpcodes(lines[id], lines[id - 1], lines[id + 1])
    lines[id] = ucHexCode(lines[id], lines[id - 1], lines[id + 1])
    // comments
    lines[id] = routineComment(lines[id], lines[id - 1], lines[id + 1])
    lines[id] = blockComment(lines[id], lines[id - 1], lines[id + 1])
    lines[id] = padComment(lines[id], lines[id - 1], lines[id + 1])
    // variables
    lines[id] = padEqu(lines[id], lines[id - 1], lines[id + 1])
    lines[id] = padDsb(lines[id], lines[id - 1], lines[id + 1])
  }
  return lines.join('\n')
}

//

function findDefs (defs, content) {
  const lines = content.split('\n').filter((line) => {
    if (line.indexOf(':') < 0) { return false }
    if (line.substr(0, 1) === '@') { return false }
    if (line.split(';')[0].indexOf(':') < 0) { return false }
    return true
  })

  for (const line of lines) {
    defs.push(line.trim().split(':')[0])
  }
}

function findCalls (calls, content) {
  const lines = content.split('\n').filter((line) => {
    if (line.substr(0, 2) !== '  ') { return false }
    if (line.substr(5, 1) !== ' ') { return false }
    if (line.substr(6, 1) === '#') { return false }
    if (line.substr(6, 1) === '@') { return false }
    if (line.substr(6, 1) === '$') { return false }
    if (line.substr(6, 1) === '%') { return false }
    return true
  })

  for (const line of lines) {
    const name = line.trim().substr(4).split(';')[0].trim().split(',')[0].trim()
    if (!calls[name]) { calls[name] = 0 }
    calls[name] += 1
  }
}

function findUncalledDefs (defs, calls) {
  for (const def of defs) {
    if (!calls[def]) { console.log(`Routine ${def}, is unused.`) }    
  }
}

// Load /src

const fs = require('fs')
const folder = 'src'
const defs = []
const calls = {}

if (fs.existsSync(folder)) {
  fs.readdirSync(folder).forEach(file => {
    if (file.indexOf('.asm') > -1) {
      const path = folder + '/' + file
      const contents = fs.readFileSync(path, 'utf8')
      const linted = lint6502(contents)
      if (contents !== linted) {
        console.log(`Linting ${path}`)
        fs.writeFileSync(path, lint6502(contents))
      }
      findDefs(defs, contents)
      findCalls(calls, contents)
    }
  })
  //
  findUncalledDefs(defs, calls)
} else {
  console.error('Error: Could not open folder /' + folder)
}
