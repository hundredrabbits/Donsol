
;;;;;;;;;;;;;;;;;;;;;;;


;;;   iNES HEADER   ;;;


;;;;;;;;;;;;;;;;;;;;;;;

  .db  "NES", $1a              ; identification of the iNES header
  .db  PRG_COUNT               ; number of 16KB PRG-ROM pages
  .db  $01                     ; number of 8KB CHR-ROM pages
  .db  $70|MIRRORING           ; mapper 7
  .dsb $09, $00                ; clear the remaining bytes
  .fillvalue $FF               ; Sets all unused space in rom to value $FF

;;;;;;;;;;;;;;;;;;;;;


;;;   VARIABLES   ;;;


;;;;;;;;;;;;;;;;;;;;;

  .enum $0000                  ; Zero Page variables
; player
health                .dsb 1
shield                .dsb 1
shield_durability     .dsb 1
experience            .dsb 1
damages               .dsb 1
; flags
potion_sickness       .dsb 1
can_run               .dsb 1
; interface
dialog_id             .dsb 1
cursor_pos            .dsb 1
ui_health             .dsb 1
; controls
arrow_left_pressed    .dsb 1
arrow_right_pressed   .dsb 1
a_pressed             .dsb 1
; table
card1                 .dsb 1
card2                 .dsb 1
card3                 .dsb 1
card4                 .dsb 1
room_complete         .dsb 1
; stats
card_last             .dsb 1
card_last_type        .dsb 1
card_last_value       .dsb 1
; tests
test_id               .dsb 1
; redraws flags
reqdraws              .dsb 1
reqdraw_hp            .dsb 1
reqdraw_sp            .dsb 1
reqdraw_xp            .dsb 1
reqdraw_cursor        .dsb 1
reqdraw_card1         .dsb 1
reqdraw_card2         .dsb 1
reqdraw_card3         .dsb 1
reqdraw_card4         .dsb 1
reqdraw_dialog        .dsb 1
  .ende

;;;;;;;;;;;;;;;;;;;;;


;;;   CONSTANTS   ;;;


;;;;;;;;;;;;;;;;;;;;;

PRG_COUNT       = 1            ; 1 = 16KB, 2 = 32KB
MIRRORING       = %0001
PPU_Control     .equ $2000
PPU_Mask        .equ $2001
PPU_Status      .equ $2002
PPU_Scroll      .equ $2005
PPU_Address     .equ $2006
PPU_Data        .equ $2007
spriteRAM       .equ $0200
  .org $C000

;;;;;;;;;;;;;;;;;


;;;   RESET   ;;;


;;;;;;;;;;;;;;;;;

RESET:                         ; 
  SEI                          ; disable IRQs
  CLD                          ; disable decimal mode
  LDX #$40
  STX $4017                    ; disable APU frame IRQ
  LDX #$FF
  TXS                          ; Set up stack
  INX                          ; now X = 0
  STX $2000                    ; disable NMI
  STX $2001                    ; disable rendering
  STX $4010                    ; disable DMC IRQs
vblankwait1:                   ; First wait for vblank to make sure PPU is ready
  BIT $2002
  BPL vblankwait1
clrmem:                        ; 
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
  BNE clrmem
vblankwait2:                   ; Second wait for vblank, PPU is ready after this
  BIT $2002
  BPL vblankwait2