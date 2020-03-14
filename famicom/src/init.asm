
;; init

  SEI                          ; disable IRQs
  CLD                          ; disable decimal mode
  LDX #$40
  STX JOY2                     ; disable APU frame IRQ
  LDX #$FF
  TXS                          ; Set up stack
  INX                          ; now X = 0
  STX PPUCTRL                  ; disable NMI
  STX PPUMASK                  ; disable rendering
  STX $4010                    ; disable DMC IRQs
@vwait1:                       ; First wait for vblank to make sure PPU is ready
  BIT PPUSTATUS
  BPL @vwait1
@clear:                        ; 
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x                 ; move all sprites off screen
  INX
  BNE @clear
@vwait2:                       ; Second wait for vblank, PPU is ready after this
  BIT PPUSTATUS
  BPL @vwait2

;; Init

loadPalette:                   ; 
  BIT PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDA palettes, x
  STA PPUDATA
  INX
  CPX #$20
  BNE @loop

;;

  JSR show@splash

;; Run tests

  ; JSR run@tests