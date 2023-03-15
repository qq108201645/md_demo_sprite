START:
    dc.l    $FFFFFE
    dc.l    EntryPoint
    dcb.l   26,except_unknown   ;包含26个异常与中断
    dc.l    hblank_interrupt ;0x70水平中断
    dc.l    except_unknown
    dc.l    vblank_interrupt ;0x78垂直中断
    dcb.l   33,except_unknown
    dc.b    'SEGA GENESIS    '  ;0x100控制台名称
    dc.b    '(C) NAMELESS    '  ;版本所有和发布日期
    dc.b    '写精灵测试 2023-3-24    '     
    dc.b    'by悠然小赐 qq108201645 '

    dcb.w   31,$0

    dc.w    $0  ;0x18e校验和
    dc.b    'J               '
    dc.l    $0
    dc.l    __end
    dc.l    $FF0000    ;RAM起始地址
    dc.l    $FFFFFF    ;RAM结束地址
    dcb.l   16,$0
    dc.b    'JUE             '



EntryPoint:
    tst.l $A10008
    beq mainSKIP1
    jmp __main
mainSKIP1:
    tst.w $A1000C
    beq mainSKIP2
    jmp __main
mainSKIP2:
  
    move.l #$0,d0
    move.l #$0,a0
    move.l #$3fff,d1
clearMemory:
    move.l d0,-(a0)
    dbra d1,clearMemory
    
    move.b $A10001,d0
    and.b #$f,d0
    beq VersionSkip
    move.l #'SEGA',$A14000
VersionSkip:
    
    move.w #$100,$A11100
    move.w #$100,$A11200
Z80_Zero:
    btst #0,$A11100
    bne Z80_Zero
    
    move.l #Z80DataAddress,A0
    move.l #$A00000,A1
    move.l #$29,d0
CopyZ80Data:
    move.b (a0)+,(a1)+
    dbra d0,CopyZ80Data
    
    move.w #0,$A11200
    move.w #0,$A11100

    move.l #PSGDataAddress,a0
    move.l #3,d0
CopyPsg:
    move.b (a0)+,$C00011
    dbra d0,CopyPsg
    
    move.l #VDPRegisters,a0
    move.l #$18,d0
    move.l #$8000,d1
CopyVDP:
    move.b (a0)+,d1
    move.w d1,$C00004
    add.w #$100,d1
    dbra d0,CopyVDP
    
    move.b #0,$A10009
    move.b #0,$A1000b
    move.b #0,$A1000d
    
    move.l #$ff0000,a0
    movem.l (a0),d0-d7/a1-a7
    move.l #0,a0
    
    move #$2000,sr

    
    jmp __main
    
    rts 
    
Z80DataAddress:
    dc.w $af01, $d91f
   dc.w $1127, $0021
   dc.w $2600, $f977
   dc.w $edb0, $dde1
   dc.w $fde1, $ed47
   dc.w $ed4f, $d1e1
   dc.w $f108, $d9c1
   dc.w $d1e1, $f1f9
   dc.w $f3ed, $5636
   dc.w $e9e9, $8104
   dc.w $8f01

PSGDataAddress:
    dc.w $9fbf, $dfff
VDPRegisters:
    dc.b $14 ; 0:H中断打开，调色板打开
   dc.b $74 ;  1：垂直。中断打开，显示打开，DMA 打开，V28 模式（垂直 28 个单元格），+ 位 2
   dc.b $30 ;  2：#$C000 处滚动平面 A 的模式表（位 3-5）
   dc.b $40 ; 3：#$10000 处窗口平面的图案表（位 1-5）
   dc.b $05 ; 4：#$A000 处滚动平面 B 的模式表（位 0-2）
   dc.b $5E ; 5：#$E000 处的 Sprite 表（位 0-6）
   dc.b $00 ; 6：未使用
   dc.b $00 ; 7：背景颜色 - 位 0-3 = 颜色，位 4-5 = 调色板
   dc.b $00 ; 8: 未使用
   dc.b $00 ; 9: 未使用
   dc.b $00 ; 10：水平的频率。光栅中断（光束行进的线数）
   dc.b $08 ; 11：外部中断开启，V/H滚动开启
   dc.b $81 ; 12：关闭阴影和高光，关闭隔行扫描，H40 模式（水平 40 个单元格）
   dc.b $34 ; 13：水平。 #$D000 处的滚动表（位 0-5）
   dc.b $00 ; 14: 未使用
   dc.b $00 ; 15: 关闭自动递增
   dc.b $01 ; 16: 垂直。滚动32，水平。滚动 64
   dc.b $00 ; 17：窗口平面X位置0左（位0-4中的位置，位7中的左/右）
   dc.b $00 ; 18：窗口平面Y位置0向上（位0-4中的位置，位7中的向上/向下）
   dc.b $00 ; 19：DMA 长度 低 字节
   dc.b $00 ;20：DMA 长度高字节
   dc.b $00 ; 21：DMA源地址低字节
   dc.b $00 ; 22：DMA 源地址中间字节
   dc.b $00 ; 23：DMA 源地址高字节，内存到 VRAM 模式（位 6-7）


Palettes:
    dc.w $0
    dc.w $0034
    dc.w $0282
    dc.w $0ccc
    dc.w $0268
    dc.w $0880
    dc.w $0aaa
    dc.w $0666
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0


    dc.w $0
    dc.w $0730
    dc.w $07d4
    dc.w $0fff
    dc.w $0eee
    dc.w $0dd4
    dc.w $0d82
    dc.w $0840
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    dc.w $0
    

    
sprite1:    ;站，上半身32x32
    incbin 'sprite/sprite1'
sprite2:    ;站，下半身24x16
    incbin 'sprite/sprite2'
sprite3:    ;跑,上半身32x24
    incbin 'sprite/sprite3'
sprite4:    ;跑1,下半身24x16
    incbin 'sprite/sprite4'
sprite5:    ;跑2,下半身24x16
    incbin 'sprite/sprite5'
sprite6:    ;跑3,下半身24x24
    incbin 'sprite/sprite6'
sprite7:    ;出招1上半身,24x32
    incbin 'sprite/sprite7'
sprite8:    ;出招1下半身,24x16
    incbin 'sprite/sprite8'
sprite9:    ;出招2上半身,32x24
    incbin 'sprite/sprite9'
sprite10:   ;出招2下半身,32x16
    incbin 'sprite/sprite10'
sprite11:   ;出招3上半身,32x24
    incbin 'sprite/sprite11'
sprite12:   ;蹲上半身,16x24
    incbin 'sprite/sprite12'
sprite13:   ;蹲下半身,16x24
    incbin 'sprite/sprite13'
sprite14:   ;发波1, 24x16
    incbin 'sprite/sprite14'
sprite15:   ;发波2, 24x16
    incbin 'sprite/sprite15'
sprite16:   ;跳起下半身24x16
    incbin 'sprite/sprite16'
sprite17:   ;张开手跳起32x24
    incbin 'sprite/sprite17'
sprite18:   ;张开手跳起24x24脚部分
    incbin 'sprite/sprite18'
sprite19:   ;刀锋,16x16
    incbin 'sprite/sprite19'
sprite20:   ;;跑1,下半身脚8x8
    incbin 'sprite/sprite20'
sprite21:   ;;跑2,下半身脚8x16
    incbin 'sprite/sprite21'
sprite22:   ;跳起的刀锋,8x8
    incbin 'sprite/sprite22'
sprite23:   ;蹲动画的手,8x16
    incbin 'sprite/sprite23'
sprite24:   ;刀波,dimension 24x32  binary 1011
    incbin 'sprite/sprite24'
 

BackGround: ;背景图
    incbin 'sprite/map_img'
sprite_end:

sprite1VRAM EQU 0
sprite2VRAM EQU (sprite1VRAM+(sprite2-sprite1))
sprite3VRAM EQU (sprite2VRAM+(sprite3-sprite2))
sprite4VRAM EQU (sprite3VRAM+(sprite4-sprite3))
sprite5VRAM EQU (sprite4VRAM+(sprite5-sprite4))
sprite6VRAM EQU (sprite5VRAM+(sprite6-sprite5))
sprite7VRAM EQU (sprite6VRAM+(sprite7-sprite6))
sprite8VRAM EQU (sprite7VRAM+(sprite8-sprite7))
sprite9VRAM EQU (sprite8VRAM+(sprite9-sprite8))
sprite10VRAM EQU (sprite9VRAM+(sprite10-sprite9))
sprite11VRAM EQU (sprite10VRAM+(sprite11-sprite10))
sprite12VRAM EQU (sprite11VRAM+(sprite12-sprite11))
sprite13VRAM EQU (sprite12VRAM+(sprite13-sprite12))
sprite14VRAM EQU (sprite13VRAM+(sprite14-sprite13))
sprite15VRAM EQU (sprite14VRAM+(sprite15-sprite14))
sprite16VRAM EQU (sprite15VRAM+(sprite16-sprite15))
sprite17VRAM EQU (sprite16VRAM+(sprite17-sprite16))
sprite18VRAM EQU (sprite17VRAM+(sprite18-sprite17))
sprite19VRAM EQU (sprite18VRAM+(sprite19-sprite18))
sprite20VRAM EQU (sprite19VRAM+(sprite20-sprite19))
sprite21VRAM EQU (sprite20VRAM+(sprite21-sprite20))
sprite22VRAM EQU (sprite21VRAM+(sprite22-sprite21))
sprite23VRAM EQU (sprite22VRAM+(sprite23-sprite22))
sprite24VRAM EQU (sprite23VRAM+(sprite24-sprite23))

mapVRAM EQU (sprite24VRAM+(BackGround-sprite24))
HZK16VRAM EQU (mapVRAM+(sprite_end-BackGround))  

mapID EQU (mapVRAM/32)
HZK16ID EQU (HZK16VRAM/32)

    
sprite1ID   EQU  (sprite1VRAM/32)
sprite2ID   EQU  (sprite2VRAM/32)
sprite3ID   EQU  (sprite3VRAM/32)
sprite4ID   EQU  (sprite4VRAM/32)
sprite5ID   EQU  (sprite5VRAM/32)
sprite6ID   EQU  (sprite6VRAM/32)
sprite7ID   EQU  (sprite7VRAM/32)
sprite8ID   EQU  (sprite8VRAM/32)
sprite9ID   EQU  (sprite9VRAM/32)
sprite10ID   EQU  (sprite10VRAM/32)
sprite11ID   EQU  (sprite11VRAM/32)
sprite12ID   EQU  (sprite12VRAM/32)
sprite13ID   EQU  (sprite13VRAM/32)
sprite14ID   EQU  (sprite14VRAM/32)
sprite15ID   EQU  (sprite15VRAM/32)
sprite16ID   EQU  (sprite16VRAM/32)
sprite17ID   EQU  (sprite17VRAM/32)
sprite18ID   EQU  (sprite18VRAM/32)
sprite19ID   EQU  (sprite19VRAM/32)
sprite20ID   EQU  (sprite20VRAM/32)
sprite21ID   EQU  (sprite21VRAM/32)
sprite22ID   EQU  (sprite22VRAM/32)
sprite23ID   EQU  (sprite23VRAM/32)
sprite24ID   EQU  (sprite24VRAM/32)

stand:
    dc.w $0000
    dc.b %00001111  ;32x32
    dc.b $1
    dc.b $20
    dc.b sprite1ID
    dc.w $0
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite2ID
    dc.w $8
squat1:
    dc.w $0010
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite12ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite13ID
    dc.w $08
squat2:
    dc.w $0010
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite14ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $2
    dc.b $20
    dc.b sprite13ID
    dc.w $08
    
    dc.w $0010
    dc.b %00000001  ;8x16
    dc.b $0
    dc.b $20
    dc.b sprite23ID
    dc.w $0

squat3:
    dc.w $0010
    dc.b %00001001  ;32x16
    dc.b $1
    dc.b $20
    dc.b sprite15ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite13ID
    dc.w $08
run1:
    dc.w $0000
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite3ID
    dc.w $00
    
    dc.w $0018
    dc.b %00001001  ;24x16
    dc.b $2
    dc.b $20
    dc.b sprite4ID
    dc.w $08
    
    dc.w $20
    dc.b %00000001  ;8x16
    dc.b $0
    dc.b $20
    dc.b sprite20ID
    dc.w $20
   
run2:
    dc.w $0000
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite3ID
    dc.w $0
    
    dc.w $0018
    dc.b %00001010  ;24x24
    dc.b $2
    dc.b $20
    dc.b sprite5ID
    dc.w $8
    
    dc.w $0020
    dc.b %0  ;8x8
    dc.b $0
    dc.b $20
    dc.b sprite21ID
    dc.w $20
run3:
    dc.w $0000
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite3ID
    dc.w $0
    
    dc.w $0018
    dc.b %00001010  ;24x24
    dc.b $0
    dc.b $20
    dc.b sprite6ID
    dc.w $8
    
    
strike1:    ;出招
   dc.w $0000
    dc.b %00001011  ;24x32
    dc.b $1
    dc.b $20
    dc.b sprite7ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite8ID
    dc.w $08
strike2:
   dc.w $0008
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite9ID
    dc.w $00
    
    dc.w $0020
    dc.b %00001101  ;32x16
    dc.b $2
    dc.b $20
    dc.b sprite10ID
    dc.w $00
    
    dc.w $10
    dc.b %00000101  ;16x16
    dc.b $0
    dc.b $20
    dc.b sprite19ID
    dc.w -$10
strike3:
    dc.w $0008
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite11ID
    dc.w $00
    
    dc.w $0020
    dc.b %00001101  ;32x16
    dc.b $0
    dc.b $20
    dc.b sprite10ID
    dc.w $00

jump1:
    dc.w $0000
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite17ID
    dc.w $0
    
    dc.w $0018
    dc.b %00001010  ;24x24
    dc.b $2
    dc.b $20
    dc.b sprite18ID
    dc.w $8
    
    dc.w $0
    dc.b %0  ;8x8
    dc.b $0
    dc.b $20
    dc.b sprite22ID
    dc.w $20
jump2:
    dc.w $0008
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite12ID
    dc.w $08

    
    dc.w $0018
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite16ID
    dc.w $08

jump3:
    dc.w $0008
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite14ID
    dc.w $08


    
    dc.w $0018
    dc.b %00001001  ;24x16
    dc.b $2
    dc.b $20
    dc.b sprite16ID
    dc.w $08
    
    dc.w $008
    dc.b %00000001  ;8x16
    dc.b $0
    dc.b $20
    dc.b sprite23ID
    dc.w 0
jump4:
    dc.w $0008
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite15ID
    dc.w $8

    
    dc.w $0018
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite16ID
    dc.w $08
    
sprite_frame_end


stand_flip:
    dc.w $0000
    dc.b %00001111  ;32x32
    dc.b $1
    dc.b $20
    dc.b sprite1ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite2ID
    dc.w $8
squat1_flip:
    dc.w $0010
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite12ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite13ID
    dc.w $08
squat2_flip:
    dc.w $0010
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite14ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $2
    dc.b $20
    dc.b sprite13ID
    dc.w $08
    
    dc.w $0010
    dc.b %00000001  ;8x16
    dc.b $0
    dc.b $20
    dc.b sprite23ID
    dc.w $20

squat3_flip:
    dc.w $0010
    dc.b %00001001  ;32x16
    dc.b $1
    dc.b $20
    dc.b sprite15ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite13ID
    dc.w $08
run1_flip:
    dc.w $0000
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite3ID
    dc.w $08
    
    dc.w $0018
    dc.b %00001001  ;24x16
    dc.b $2
    dc.b $20
    dc.b sprite4ID
    dc.w $8
    
    dc.w $20
    dc.b %00000001  ;8x16
    dc.b $0
    dc.b $20
    dc.b sprite20ID
    dc.w $0
   
run2_flip:
    dc.w $0000
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite3ID
    dc.w $08
    
    dc.w $0018
    dc.b %00001010  ;24x24
    dc.b $2
    dc.b $20
    dc.b sprite5ID
    dc.w $8
    
    dc.w $0020
    dc.b %0  ;8x8
    dc.b $0
    dc.b $20
    dc.b sprite21ID
    dc.w $0
run3_flip:
    dc.w $0000
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite3ID
    dc.w $08
    
    dc.w $0018
    dc.b %00001010  ;24x24
    dc.b $0
    dc.b $20
    dc.b sprite6ID
    dc.w $8
    
    
strike1_flip:    ;出招
   dc.w $0000
    dc.b %00001011  ;24x32
    dc.b $1
    dc.b $20
    dc.b sprite7ID
    dc.w $08
    
    dc.w $0020
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite8ID
    dc.w $8
strike2_flip:
   dc.w $0008
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite9ID
    dc.w $8
    
    dc.w $0020
    dc.b %00001101  ;32x16
    dc.b $2
    dc.b $20
    dc.b sprite10ID
    dc.w $8
    
    dc.w $10
    dc.b %00000101  ;16x16
    dc.b $0
    dc.b $20
    dc.b sprite19ID
    dc.w $28
strike3_flip:
    dc.w $0008
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite11ID
    dc.w $8
    
    dc.w $0020
    dc.b %00001101  ;32x16
    dc.b $0
    dc.b $20
    dc.b sprite10ID
    dc.w $8

jump1_flip:
    dc.w $0000
    dc.b %00001110  ;32x24
    dc.b $1
    dc.b $20
    dc.b sprite17ID
    dc.w $08
    
    dc.w $0018
    dc.b %00001010  ;24x24
    dc.b $2
    dc.b $20
    dc.b sprite18ID
    dc.w $8
    
    dc.w $0
    dc.b %0  ;8x8
    dc.b $0
    dc.b $20
    dc.b sprite22ID
    dc.w $20
jump2_flip:
    dc.w $0008
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite12ID
    dc.w $08

    
    dc.w $0018
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite16ID
    dc.w $08

jump3_flip:
    dc.w $0008
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite14ID
    dc.w $08


    
    dc.w $0018
    dc.b %00001001  ;24x16
    dc.b $2
    dc.b $20
    dc.b sprite16ID
    dc.w $08
    
    dc.w $008
    dc.b %00000001  ;8x16
    dc.b $0
    dc.b $20
    dc.b sprite23ID
    dc.w $20
jump4_flip:
    dc.w $0008
    dc.b %00001001  ;24x16
    dc.b $1
    dc.b $20
    dc.b sprite15ID
    dc.w $8

    
    dc.w $0018
    dc.b %00001001  ;24x16
    dc.b $0
    dc.b $20
    dc.b sprite16ID
    dc.w $08
    
sprite_frame_flip_end



hblank_count EQU $FF0000
vblank_count EQU (hblank_count+4)
sprite_size EQU ((sprite_end-sprite1)/32)
    
except_unknown:
     stop #$2700 
hblank_interrupt:
    addi.l #1,hblank_count
    rte
vblank_interrupt:

    addi.l #1,vblank_count
    rte
    
LoadTiles:
    swap d0
    add.l #$40000000,d0
    move.l d0,$c00004
    subq.b #1,d1
    
CopyToVRAM:
    move.w #7,d2
ByteCopy:
    move.l (a0)+,$c00000
    dbra d2,ByteCopy
    dbra d1,CopyToVRAM
    rts
 

Pad1 EQU $ff0010
Pad2 EQU (Pad1+4)
    
use:
   move.w #$100,$00A11100 
testSkip_:
    btst #0,$a11100     ;测试 A11100 的位 0 看 68k 是否已经访问 Z80 总线
    bne testSkip_

   ; movem.w d0-a7,-(sp)
    move.w #$100,$a11100    ;通过写入 $0100 请求访问 Z80 总线,进入 BUSREQ 端口
    move.w #$100,$00A11200 
    moveq #$f,d0

   ; move.w #0,$a11100

   ; movem (sp)+,d0-a7

    rts
close:
    lea  $a10003,a1
    
    MOVE.B  #$0,$0006(A1)
    MOVE.B  #$0,(A1)


    move.w #0,$a11100
    ; move.b  #$00,$000A10008 ; 控制器端口 1 CTRL
   ;  move.b  #$00,$000A10009 ; 控制器端口 1 CTRL
    move.b  #$00,$000A1000B ; 控制器端口 2 CTRL
   ; move.b  #$00,$000A1000D ; EXP 端口 CTRL

    rts
    
ReadJoypads:
    movem.l d0-a7,-(sp)
    ; jsr use
;读取控制器 1 数据的加载地址
     LEA     Pad1,A0     ;;写入读取结果的加载地址
     LEA     $00A10003,A1 ;读取控制器 1 数据的加载地址
     BSR     ReadsubJoypad
;手柄2   
     LEA     Pad2,A0       
     ADDQ.W  #2,A1            
     BSR     ReadsubJoypad
     movem.l (sp)+,d0-a7
    ; jsr close
    rts
    
ReadsubJoypad:

    MOVE.B  #$40,$0006(A1)    ;读取手柄数据端口
    MOVE.B  #$40,(A1)         
    NOP                       
    NOP                       
    MOVE.B  (A1),D0           
    ANDI.B  #$3F,D0    ;C/B/Dpad 低 6 位       
    MOVE.B  #$00,(A1)       ;再读取手柄数据端口
  
    NOP                       
    NOP                       
    MOVE.B  (A1),D1           
    LSL.B   #2,D1        ;移动它们，使它们位于最高 2 位     
    ANDI.B  #$C0,D1          ;高2位开始/A 
    OR.B    D1,D0             ;合并结果
    NOT.B   D0          ;使有按键的置1        
    MOVE.B  D0,D1             
    MOVE.B  (A0),D2           
    EOR.B   D2,D0             
    MOVE.B  D1,(A0)+          
    AND.B   D1,D0             
    MOVE.B  D0,(A0)+          
    MOVE.B  #$40,(A1)         
    NOP                       
    NOP                       
    MOVE.B  (A1),D0           
    MOVE.B  #$00,(A1)         
    NOP                       
    NOP                       
    MOVE.B  (A1),D0           
    ANDI.B  #$0F,D0           
    BNE     PadReturn  
    MOVE.B  #$40,(A1)         
    NOP                       
    NOP                       
    MOVE.B  (A1),D0           
    MOVE.B  #$00,(A1)         
    NOP                       
    NOP                       
    MOVE.B  (A1),D1           
    MOVE.B  #$40,(A1)         ;读取手柄数据端口
    NOT.B   D0                
    ANDI.B  #$0F,D0           
    MOVE.B  D0,D1             
    MOVE.B  (A0),D2           
    EOR.B   D2,D0             
    MOVE.B  D1,(A0)+          
    AND.B   D1,D0             
    MOVE.B  D0,(A0)+   
PadReturn:       
    RTS    
    
    
SetSpriteFlip:
    movem.l d0-a7,-(sp)
    lea $ff2000,a0
   
    clr.l d3
    move.b d0,d3
    mulu.w #8,d3
    add.b #4,d3
   ; swap d3
   ; add.l #$60000003,d3
   ; move.l d3,$c00004
    add.l d3,a0
    move.w d1,(a0)
    
    movem.l (sp)+,d0-a7
    rts
    
SetSpritePosX:
    movem.l d0-a7,-(sp)

    lea $ff2000,a0

    clr.l d3
    move.b d0,d3
    mulu.w #8,d3
    add.b #6,d3
  ;  swap d3
*    add.l #$60000003,d3
*    move.l d3,$c00004
    
    add.l d3,a0
    move.w d1,(a0)
    
    movem.l (sp)+,d0-a7
    rts
SetSpritePosY:
    movem.l d0-a7,-(sp)
    
     lea $ff2000,a0
     
    clr.l d3
    move.b d0,d3
    mulu.w #8,d3

 ;   swap d3
*    add.l #$60000003,d3
*    move.l d3,$c00004
     add.l d3,a0

    move.w d1,(a0)
    
    movem.l (sp)+,d0-a7
    rts
 
sprite_status   EQU $ff0020         ;状态地址
sprite_attr_point  EQU (sprite_status+$10)  ;属性表地址
sprite_attr_flip_point  EQU (sprite_attr_point+$10)  ;属性表地址
sprite_animation_point  EQU     (sprite_attr_flip_point+$10) ;动画地址
sprite_attribute_ptr  EQU   (sprite_animation_point+$10)
sprite_attribute_flip_ptr  EQU   (sprite_attribute_ptr+$10)
sprite_animation_data  EQU  (sprite_attribute_flip_ptr+$10)
sprite_dir_status   EQU (sprite_animation_data+$10)
sprite_act_status    EQU (sprite_dir_status+$10)
sprite_ani_status   EQU (sprite_act_status+$10)
sprite_ani_finish EQU (sprite_ani_status+$10)
sprite_delay_status EQU (sprite_ani_finish+$10)


stand_status EQU 0
squat_status EQU $1
run_status EQU $2
strike_status EQU $3
jump_status EQU $4
Animation_flag EQU 5

Zero_status EQU $0

sprite_attr_stand_addr:
    dc.l    stand       ;站
sprite_attr_squat_addr:
    dc.l    squat1      ;蹲
    dc.l    squat2
    dc.l    squat3
sprite_attr_run_addr:
    dc.l    run1        ;跑
    dc.l    run2
    dc.l    run3
sprite_attr_strike_addr:
    dc.l    strike1     ;出招
    dc.l    strike2
    dc.l    strike3
sprite_attr_jump_addr:
    dc.l    jump1       ;跳1
    dc.l    jump2       ;蓄力1
    dc.l    jump3       ;打1
    dc.l    jump4          ;打2
    
;翻转
sprite_attr_stand_flip_addr:
    dc.l    stand_flip       ;站
sprite_attr_squat_flip_addr:
    dc.l    squat1_flip      ;蹲
    dc.l    squat2_flip
    dc.l    squat3_flip
sprite_attr_run_flip_addr:
    dc.l    run1_flip        ;跑
    dc.l    run2_flip
    dc.l    run3_flip
sprite_attr_strike_flip_addr:
    dc.l    strike1_flip     ;出招
    dc.l    strike2_flip
    dc.l    strike3_flip
sprite_attr_jump_flip_addr:
    dc.l    jump1_flip       ;跳1
    dc.l    jump2_flip       ;蓄力1
    dc.l    jump3_flip       ;打1
    dc.l    jump4_flip          ;打2


   ; dc.l $0
sprite_stand_addr:
    dc.w    (squat1-stand)/8       ;站
sprite_squat_addr:
    dc.w    (squat2-squat1)/8      ;蹲
    dc.w    (squat3-squat2)/8
    dc.w    (run1-squat3)/8
sprite_run_addr:
    dc.w    (run2-run1)/8        ;跑
    dc.w    (run3-run2)/8
    dc.w    (strike1-run3)/8
sprite_strike_addr:
    dc.w    (strike2-strike1)/8     ;出招
    dc.w    (strike3-strike2)/8
    dc.w    (jump1-strike3)/8
sprite_jump_addr:
    dc.w    (jump2-jump1)/8       ;跳1
    dc.w    (jump3-jump2)/8       ;蓄力1
    dc.w    (jump4-jump3)/8      ;打1
    dc.w    (sprite_frame_end-jump4)/8         ;打2

sprite_attr_addr:
    dc.l sprite_attr_stand_addr
    dc.l sprite_attr_squat_addr
    dc.l sprite_attr_run_addr
    dc.l sprite_attr_strike_addr
    dc.l sprite_attr_jump_addr

sprite_attr_flip_addr:
    dc.l sprite_attr_stand_flip_addr
    dc.l sprite_attr_squat_flip_addr
    dc.l sprite_attr_run_flip_addr
    dc.l sprite_attr_strike_flip_addr
    dc.l sprite_attr_jump_flip_addr
    
sprite_animation_addr:
    dc.l sprite_stand_addr
    dc.l sprite_squat_addr
    dc.l sprite_run_addr
    dc.l sprite_strike_addr
    dc.l sprite_jump_addr
     
LoadSpriteTables:
    LEA $ff2000,a1
    subq.b #1,d0
AttrCopy:
    move.l (a0)+,(a1)+
    move.l (a0)+,(a1)+
    dbra d0,AttrCopy
    rts
WaitVblankStart:
    move.w $c00004,d0
    andi.w #8,d0
    bne WaitVblankStart
    rts
    
WaitVblankEnd:
    move.w $c00004,d0
    andi.w #8,d0
    beq WaitVblankEnd
    rts
 
calc_address:
      
    move.w sprite_status,d0
    lsl.w #2,d0
    
    lea sprite_animation_addr,a0
    add.w d0,a0
    move.l (a0),sprite_animation_point
    
    lea sprite_attr_addr,a0
    add.w d0,a0
    move.l (a0),sprite_attr_point
    
    lea sprite_attr_flip_addr,a0
    add.w d0,a0
    move.l (a0),sprite_attr_flip_point
    
    ;;;-----------------
    cmp.w #squat_status,sprite_status   ;站的话
    beq   SetZero   
  
*    cmp.w #run_status,sprite_status   ;跑
*    beq NoSetZero

*    cmp.w #squat_status,sprite_status   ;蹲
*    bne NoSetZero
*    cmp.w #3,sprite_act_status  ;有动画的话
*    beq NoSetZero
   tst.w sprite_status
    bne NoSetZero
SetZero:
    cmp.w #Animation_flag,sprite_act_status
    beq NoSetZero
    move.w #$ffff,sprite_ani_status
    move.w #0,sprite_act_status
NoSetZero:
    
    cmp.w #$ffff,sprite_ani_status
    beq noAddFrames
    move.l sprite_animation_point,a0
    
    move.w sprite_ani_status,d0
    lsl.w #1,d0
    add.w d0,a0
    move.w (a0),sprite_animation_data
    
    move.l sprite_attr_point,a0

    lsl.w #1,d0
    add.w d0,a0
    move.l (a0),sprite_attribute_ptr
    
    move.l sprite_attr_flip_point,a0
    add.w d0,a0
    move.l (a0),sprite_attribute_flip_ptr
    rts
noAddFrames:
    move.l sprite_animation_point,a0
    move.w (a0),sprite_animation_data
   
    move.l sprite_attr_point,a0
    move.l (a0),sprite_attribute_ptr
    
    move.l sprite_attr_flip_point,a0
    move.l (a0),sprite_attribute_flip_ptr
    rts
    

LoadMapPlaneB:
    ; a0 (l) - 映射地址 (ROM)
; d0 (b) - 字数
; d1 (b) - Y 偏移量
; d2 (w) - 第一个图块 ID
; d3 (b) - 调色板 ID

	mulu.w  #$40, d1            ;将 Y 偏移量乘以线宽（字）
	swap    d1                     ;移至高位字
	add.l   #$60000002, d1 ;添加PlaneB写cmd+地址
	move.l  d1, $C00004	       ;将目标地址移动到 VDP 控制端口

	rol.l   #$08, d3              ;将调色板 ID 移至位 14-15
	rol.l   #$05, d3             ;一次只能滚动 8 位

	subq.b  #$01, d0              ; d0 中的 Num 个字，减 1 为计数器
	
MapCopyPlaneB:
	move.w  (a0)+, d4              ;将图块 ID 从地图数据移动到较低的 d4
	and.l   #%0011111111111111, d4 ;屏蔽原始调色板 ID
	or.l    d3, d4                 ;换成我们自己的
	add.w   d2, d4                 ;将第一个图块偏移量添加到 d4
	move.w  d4, $C00000      ;移动到 VRAM
	dbra    d0, MapCopyPlaneB   ; 循环

    rts

 move.w #%0010000000000000,d1

LoadMapPlaneA:
    ; a0 (l) - 映射内存地址 (MEMORY)
; d0 (b) - 字数
; d1 (b) - Y 偏移量
; d2 (w) - 第一个图块 ID
; d3 (b) - 调色板 ID

	mulu.w  #$40, d1            ;将 Y 偏移量乘以线宽（字）
	add.w d4,d1
	swap    d1                     ;移至高位字
	add.l   #$40000003, d1 ;添加PlaneA写cmd+地址
	move.l  d1, $C00004	       ;将目标地址移动到 VDP 控制端口

	rol.l   #$08, d3              ;将调色板 ID 移至位 14-15
	rol.l   #$05, d3             ;一次只能滚动 8 位

	subq.b  #$01, d0              ; d0 中的 Num 个字，减 1 为计数器
	clr.w d5
MapCopyPlaneA:
    add.w #1,d5
     clr.l d4
	;move.w  (a0)+, d4              ;将图块 ID 从地图数据移动到较低的 d4
	and.l   #%0001111111111111, d4 ;屏蔽原始调色板 ID
	or.l    d3, d4                 ;换成我们自己的
	add.w   d2, d4                 ;将图块偏移量添加到 d4
	move.w  d4, $C00000      ;移动到 VRAM
	add.w #1,d2
	cmp.w #2,d5
	bne SetD5
	clr.w d5
    add.w #2,d2
SetD5:	
	dbra    d0, MapCopyPlaneA              ; 循环

    rts
    
AddPlaneAText:
    move.w #1,d5
NextAddText:
    movem.l d0-d7,-(sp)
    mulu.w #2,d0
    jsr LoadMapPlaneA
    movem.l (sp)+,d0-d7
    add.w #2,d1
    add.w #2,d2
    dbra d5,NextAddText
    rts

Speed EQU 2
PosX EQU (sprite_delay_status+$10)
PosVX EQU (PosX+$10)
PosY EQU (PosVX+$10)
PosVY EQU (PosY+$10)
PosYCount  EQU  (PosVY+$10)
GravityMem EQU (PosYCount+$10)
TextCount EQU (GravityMem+$10)
scrollFildA EQU  (TextCount+$10)
scrollFildB EQU (scrollFildA+$2)


__main:
;设置偏移量
    move.w #$8f02,$c00004

;加载调色板   
    move.l #$C0000000,$00C00004
    lea Palettes,a0
    move.l #$f,d0
PalettesLoop:
    move.l (a0)+,$C00000
    dbra d0,PalettesLoop
;设置背景色
    move.w #$8700,$c00004
    
;加载全部贴图
    lea sprite1,a0
    move.l #sprite1VRAM,d0
    move.l #sprite_size,d1
    jsr loadTiles
    
    lea $ff3020,a2
    clr.l d7
    move.b #4,d7
    jsr LoadHKZ16
    
    lea $ff3020,a0
    move.l #HZK16VRAM,d0
    move.l TextCount,d1
    mulu.w #4,d1
    jsr loadTiles
    
    
    lea $ff3020,a0
    move.l TextCount,d0
    move.l #6,d1
    move.l #$20,d4
    move.l #HZK16ID,d2
    move.w #1,d3                ; d3 中的调色板 ID
    jsr AddPlaneAText

    
    lea      LevelMapData, a0           ; a0中的地图数据
	move.w   #1984, d0     ; d0 中的大小（字） 每次写两个字节
	move.l   #$0, d1               ;d1 中的 Y 偏移量
	move.w   #mapID, d2  ; d2 中的第一个图块 ID
	move.l   #0, d3                ; d3 中的调色板 ID
	jsr      LoadMapPlaneB           ; 跳转到子程序
    
    
;加载初始sprite  
    lea stand,a0
    move.l #2,d0
    jsr LoadSpriteTables
    
    move.w #$b0,PosX
    move.w #$120,PosY
    move.w #$ff,sprite_ani_finish
GameLoop:
    nop    
   jsr ReadJoypads
   bsr Action
    bsr collision
    
    bsr calc_address
     
    jsr WaitVblankStart
    
    
    jsr SetAnimation
    jsr SetXY
    jsr power_inc
    jsr LinkedListHandle
    jsr DMA_DRAW
    
    jsr WaitVblankEnd
    
    jmp GameLoop

    

    rte
    
DMA_DRAW:
    
    move.l scrollFildA,d0
    neg.l d0
    move.l #$50000003,$c00004
    move.l d0,$c00000
    
    move.w #$8174,$c00004
   ; move.w #$7800,$c00004
    lea $00C00004,A0
    move.w (A0),d0
    btst #1,d0
    bne DMA_DRAW
    
    move.l #$93009401,(A0)
    move.l #$95009690,(A0)
    move.l #$977f7C00,(A0)
 
      ;move.w #$8174,$c00004
    move.w #$0082,-(sp)
    
    move.w (sp)+,(A0)

    rts



 
*----------------------------------------------------------------------
SetAnimation:
    clr.l d0
    move.w sprite_status,d0

    cmp #squat_status,d0
    bne squat_status_Skip
    move.l sprite_attribute_ptr,a0
    move.w sprite_animation_data,d0
    
    jsr LoadSpriteTables

    rts
squat_status_Skip

    cmp.w #run_status,d0
    bne run_status_Skip
    
    clr.l d0
    move.l sprite_attribute_ptr,a0
    
    move.w sprite_animation_data,d0

    jsr LoadSpriteTables
    
    rts
run_status_Skip:
    
    cmp #strike_status,d0
strike_status_Skip
    cmp #jump_status,d0
jump_status_Skip
    
    move.l sprite_attribute_ptr,a0
    move.w sprite_animation_data,d0
    jsr LoadSpriteTables

    rts
    
SetXY:
    move.w sprite_dir_status,d0
    cmp.w #0,d0
    bne leftFlip
    move.l sprite_attribute_ptr,a0
    bra leftFlipSkip
leftFlip:
    move.l sprite_attribute_flip_ptr,a0
leftFlipSkip:
    move.w sprite_animation_data,d2

       
    subi.b #1,d2
    clr.l d5
    clr.l d1
SetSkip:
    
    move.w (a0),d1
    add.w PosY,d1
    move.w d5,d0
    jsr SetSpritePosY
    
    move.w 6(a0),d1
    

    add.w PosX,d1
     
    move.w d5,d0
    jsr SetSpritePosX
    
    
    move.w 4(a0),d1
    move.w sprite_dir_status,d0
    lsl.w #7,d0
    or.w d0,d1
    
    move.w d5,d0
    jsr SetSpriteFlip
    
    add.l #8,a0
    add.w #1,d5
    dbf d2,SetSkip
    rts
*----------------------------------------------------------------------
Action:
    
   ; jsr power_inc   ;推进波
    cmp.w #jump_status,sprite_status
    bne ACT_end_1
    cmp.w #Animation_flag,sprite_act_status
    bne ACT_end_1 
  ;  cmp.w #$0,PosVY
  ;  bcs ACT_end_1
  ;  cmp.w #$fffd,PosVY
  ;  bcc ACT_end_1
    
    jsr INC_Frame

    rts
   
ACT_end_1:

    cmp.w #Animation_flag,sprite_act_status
    beq WalkSkip
    
    bsr PadOperator

    cmp #squat_status,sprite_status
    beq WalkSkip
    
    jsr scroll_Op
    
    move.w  PosVX,d0
    add.w  d0,PosX  
*----------------------------------------------------------------------      
WalkSkip:
    
    move.w  PosVY,d0
    add.w  d0,PosY  
    
    jsr ACT_Op

     rts
     
*----------------------------------------------------------------------     
frames_inc:
    tst sprite_act_status
    beq SetAniFrameZero
    addi.w #1,sprite_delay_status
    cmp.w #7,sprite_delay_status
    bcs SetAniFrameZero
    
    move.l #0,sprite_delay_status
    addi.w #1,sprite_ani_status     ;推进一帧
    
    
    cmp.w #3,sprite_ani_status   ;大于第二帧就置0，让动画在0~2循环
    bcs SetAniFrameZero
    move.w #0,sprite_ani_status
    move.w #$ff,sprite_ani_finish
SetAniFrameZero:
    rts
*----------------------------------------------------------------------
PadOperator:
    
    cmp.w #jump_status,sprite_status
    beq squatSkip
    move.b Pad1,d0  ;是不是蹲下
    and.b #2,d0
    beq squatSkip

     move.b Pad1,d0  
     and.b #4,d0
     beq left_squat
     move.w #$0,sprite_dir_status
left_squat:
     move.b Pad1,d0  
     and.b #8,d0
     beq right_squat
     move.w #$10,sprite_dir_status
 right_squat:
 
    move.w #squat_status,sprite_status
     move.w #0,sprite_ani_status  ;初始动画帧
    move.w #0,sprite_delay_status
   
    rts
squatSkip:
   ; move.b #$20,Pad1    ;再处理跳

    move.b Pad1+1,d0
    and.w #$20,d0
    beq JumpCnt
    cmp.w #jump_status,sprite_status
    beq JumpCnt
    move.w #jump_status,sprite_status
    move.w #0,sprite_act_status
    move.w #0,sprite_ani_status
    move.w #-6,PosVY
    move.w #0,GravityMem
    move.w #0,sprite_delay_status
    
JumpCnt:
    cmp.w #jump_status,sprite_status
    bne JumpSkip
    
    move.b Pad1,d0
    and.b #4,d0
    beq subLeft
    move.w #-2,PosVX
subLeft:
    move.b Pad1,d0
    and.b #8,d0
    beq subRight
    move.w #2,PosVX
subRight:   
    add.w #1,sprite_delay_status
    cmp.w #10,sprite_delay_status
    bcs Jump_Cnt
    move.w 0,sprite_delay_status
    
    eor.w #1,GravityMem
    move.w GravityMem,d0
    
    add.w d0,PosVY
    move.w PosVY,d0
    
    add.w d0,PosY
Jump_Cnt:
    
    rts
JumpSkip: 
    move.b Pad1,d0
    and.b #4,d0
    beq leftWalkSkip    ;;往左走

    move.w #-Speed,PosVX
    
    and.w #$f,sprite_dir_status
    
    bra animation_frames
    
leftWalkSkip:   
    move.b Pad1,d0
    and.b #8,d0
    beq rightWalkSkip   ;往右走
    move.w #Speed,PosVX
    
    or.w #$10,sprite_dir_status ;翻转标志
    
animation_frames:

     move.w #run_status,sprite_status   ;跑标志
    
    cmp.w #Zero_status,sprite_act_status
    bne no_init_run
    
    move.w #run_status,sprite_act_status   ;跑标志
    move.w #0,sprite_ani_status  ;初始动画帧
    move.w #0,sprite_delay_status

    rts    ;跳转到加载属性表
no_init_run: 
    bsr frames_inc
    rts
    
rightWalkSkip:
   
    cmp.w #Animation_flag,sprite_act_status
    beq SetStatusZero
    move.w #stand_status,sprite_status
SetStatusZero:
    move.w #0,PosVX
    ;move.w #0,sprite_ani_status
    ;move.w #0,sprite_act_status

    ;move.w #0,Pad1_count
  
    rts


SET_FLAG:
     move.w #Animation_flag,sprite_act_status   ;
    move.w #$0,sprite_ani_status  ;初始动画帧
    move.w #0,sprite_delay_status
    move.w #$0,sprite_ani_finish
    rts
*----------------------------------------------------------------------
ACT_Op:  
    move.b Pad1+1,d0
    and.b #$10,d0
    beq ACTSkip
    cmp.w #squat_status,sprite_status
    beq strikeSkip
    cmp.w #jump_status,sprite_status
    beq JumpHandle
    
    cmp.w #Animation_flag,sprite_act_status
    beq ACTSkip

    
    move.w #strike_status,sprite_status ;出招标志

   jsr SET_FLAG   ;站出招标志


    
    bra ACTSkip
strikeSkip:    
    cmp.w #squat_status,sprite_status
    bne ACTSkip
    tst sprite_act_status
    bne ACTSkip
   jsr SET_FLAG  ;设置标志为蹲出招
   jsr power_handle ;处理波
    bra ACTSkip
    
JumpHandle:  
    cmp.w #jump_status,sprite_status
    bne ACTSkip
    cmp.w #Animation_flag,sprite_act_status
    beq ACTSkip
    
   ; cmp.w #$0,PosVY
   ; bcs ACTSkip
   ; cmp.w #$fffd,PosVY
   ; bcc ACTSkip
   cmp.w #$ff,sprite_ani_finish
    bne Jump_finish
    move.w #0,PosVY
    move.w #Animation_flag,sprite_act_status
    move.w #jump_status,sprite_status ;出招标志
    move.w #$0,sprite_ani_finish

   ; jsr SET_FLAG
Jump_finish:

    rts
ACTSkip:
    cmp.w #strike_status,sprite_status
    beq INC_Frame
    cmp.w #Animation_flag,sprite_act_status
    bne ACT_squat_end
INC_Frame:
    jsr frames_inc
    
    tst sprite_ani_status
    bne  ACT_squat_end
    cmp.w #$ff,sprite_ani_finish
    bne ACT_squat_end
    move.w #0,sprite_act_status
    move.w #$ffff,sprite_ani_status

ACT_squat_end:   
    
    
    rts
    
*----------------------------------------------------------------------
collision:
    cmp.w #jump_status,sprite_status
    bne collision_Skip
    move.w PosY,d0
    add.w #$20,d0
    cmp.w #$140,d0
    bcs collision_Skip
    move.w #$120,PosY
    move.w #0,PosVY
    move.w #0,GravityMem
    move.w #stand_status,sprite_status
collision_Skip:
    cmp.w #$78,PosX
    bcc SetLeftX
    move.w #$78,PosX
SetLeftX:
    move.w PosX,d0
    add.w #18,d0
    cmp.w #$1a0,PosX
    bcs SetRightX
    move.w #$1a0,PosX
SetRightX:
    

    rts
   
    
power_wave_total EQU $ff1000
power_wave_status EQU (power_wave_total+$10)         ;状态
power_wave_dir  EQU (power_wave_status+$10) 
power_wave_cycle EQU (power_wave_dir+$10)  ;生命周期
power_wave_ani EQU (power_wave_cycle+$10)         ;动画帧
power_wave_ani_finish EQU (power_wave_ani+$10)    ;动画结束帧
power_wave_x  EQU (power_wave_ani_finish+$10) ;x坐标
power_wave_y  EQU (power_wave_x+$10)   ;y坐标
power_wave_vx  EQU (power_wave_y+$10)     ;vx加速度
power_wave_vy  EQU (power_wave_vx+$10)    ;vy加速度
power_wave_count EQU 8


scroll_Op:
    move.w scrollFildB,d0
    move.w PosX,d1
    move.w PosVX,d2
    add.w d2,d1
    add.w #$c,d1
    cmp.w #$108,d1   ;d1小于#$fc就分支
    bcs RightScroll
    cmp.w #$100,d0  ;d0大于#$100就分支
    bcc RightScroll
    move.b Pad1,d3
    and.b #8,d3
    beq RightScroll 
    add.w d2,scrollFildB
    move.w #$0,PosVX
    sub.w #1,d2
    add.w d2,scrollFildA

    rts
RightScroll 
    move.w scrollFildB,d0
    move.w PosX,d1
    move.w PosVX,d2
    add.w d2,d1
    cmp.w #$fc,d1

    bcc leftScroll ;d1比#$fc大就跳过
    cmp.w #$1,d0
    bcs leftScroll   ;d0比0大就继续
    move.b Pad1,d3
    and.b #4,d3
    beq leftScroll
    add.w d2,scrollFildB
    move.w #$0,PosVX
    add.w #1,d2
    add.w d2,scrollFildA
    

leftScroll: 
    rts
    
    
POWER_DIRECTION:
    dc.w $0
    dc.w $18
POWER_SPEED:
    dc.w $FFFc
    dc.w $4

power_handle:
    move.w #$FFFF,d0
power_op:
    add.w #1,d0
    cmp.w #power_wave_count,d0     ;不超过3个波
    bcc power_finish
    
    clr.l d2
    move.w d0,d2
    lsl.w #1,d2
    lea power_wave_status,a0
    cmp.w #1,(a0,d2)
    beq power_op
    
    
    

    ;设置初始值
    move.w sprite_dir_status,d1
    
    lea power_wave_dir,a0
    move.w d1,(a0,d2)
    
    lea power_wave_status,a0
    move.w #1,(a0,d2)
    
    lea power_wave_cycle,a0
    move.w #$40,(a0,d2)
    
    lea power_wave_ani,a0
    move.w #0,(a0,d2)
    
    lea power_wave_ani_finish,a0
    move.w #0,(a0,d2)
   
    
    ;方向左:0    方向右:0x10
    lsr.w #3,d1 ;右移四位0->0   0x10->2
    
    lea power_wave_x,a0
    move.w #POWER_DIRECTION,a1
    add.w d1,a1
    move.w (a1),d0
    add.w (PosX),d0
    move.w d0,(a0,d2) ;把右移的方向值加入地址寻址，找到方向不同的偏移值
    
    lea power_wave_vx,a0
    move.w #POWER_SPEED,a1
    add.w d1,a1
    move.w (a1),d0
    move.w d0,(a0,d2)
    
    lea power_wave_y,a0
    move.w PosY,d0
    add.w #8,d0
    move.w d0,(a0,d2)
    
    lea power_wave_vy,a0
    move.w #0,(a0,d2)

power_finish:
    rts



power_inc:
    move.w #0,(power_wave_total)

    move.w #$ffff,d0
    clr.w d3 
    
    move.w sprite_animation_data,d3
   ; sub.w #1,d1
    mulu.w #8,d3
    
power_z1:   
    
    add.w #1,d0
    cmp #power_wave_count,d0
    beq INc_p
    
    move.w d0,d1
    lsl.w #1,d1
    
    lea power_wave_status,a0
    move.w (a0,d1),d2
    cmp.w #1,d2
    bne INc_p
    add.w #1,(power_wave_total)
    
    
    lea power_wave_cycle,a1
    sub.w #1,(a1,d1)
    cmp.w #0,(a1,d1)
    bne clearPower
    sub.w #1,(power_wave_total)
    move.w #0,(a0,d1)
    bra INc_p
clearPower:
  
    ;y传送
    lea power_wave_y,a0
    move.w (a0,d1),d2
        
    lea $ff2000,a1
    move.w d2,(a1,d3)
    
    move.b #%00001011,2(a1,d3)

    lea power_wave_dir,a0
    move.w (a0,d1),d2
    
    tst.w d2
    bne SetZero_flip
    move.b #%00100000,4(a1,d3)
    bra power_next
SetZero_flip:
    move.b #%00101000,4(a1,d3)
power_next:
    move.b #sprite24ID,5(a1,d3)
    
    lea power_wave_x,a0
    lsr.w #3,d2
    move.w #POWER_SPEED,a2
    add.w d2,a2
    move.w (a2),d2
    add.w d2,(a0,d1)
    
    move.w (a0,d1),6(a1,d3)
    
    add.w #8,d3
       
INc_p: 
    cmp #power_wave_count,d0
    bne power_z1
    
    rts
    
    
LinkedListHandle:
    
    ;处理链表
    clr.l d5
    lea power_wave_total,a0
    move.w (a0),d0
    tst.w d0
    beq check_finish
    
    lea sprite_animation_data,a1
    move.w (a1),d1
    add.w d0,d1
    sub.w #1,d1
    move.w d1,d5
    
    clr.l d0
    clr.l d1
    clr.l d2
    clr.l d3
    move.w #$ffff,d0
    lea $ff2000,a1
   
check_power_count:
    
    add.w #1,d0
    move.b d0,d1
    add.b #1,d1
    
  ;  move.w (a2),d2
  
    move.b d1,3(a1,d3)
    add.w #8,d3
  ;  bra check_power_count
      cmp.w d1,d5
    bne check_power_count
check_finish: 
    move.b #0,3(a1,d3)
    rts
    
HZK16:
    incbin 'hzk16'
Text:  
    dc.b 'ＢＹ悠然小赐ＱＱ１０８２０１６４５',0,0

    
CStrlen:    ;仿c_string计算长度

    clr.l d0    ;清0
    move.l a0,a1
    
calcLoop:
    
    tst.w (a1)+    ;不是0就
    beq calcSkip
    add.w #1,d0     ;计数器
    bra calcLoop

calcSkip:
     rts
  

memoryText:
    move.b d6,(a2)+    
    rts
    
    
AddTextToMem:
    movem.l d0-d7,-(sp)
    
    clr.l d0    ;字节计数器
    clr.l d1 
    
    lea $ff3000,a3
    move.w #1,d0
   
TextCopy1:
    move.w #15,d1
    clr.l d2 
 
    clr.l d3
    clr.l d4

TextCopy2:
    move.b (a1)+,(a3,d2)
    eor.w #8,d3
    add.w #1,d4
    move.w d4,d2
    lsr #1,d2
    add.w d3,d2
    
    dbra d1,TextCopy2
    add.w #$10,a3
    dbra d0,TextCopy1

        
    clr.l d0    ;字节计数器
    clr.l d1 
    clr.l d2 
    lea $ff3000,a3

LoadTextFinish:   
    move.w #7,d1    ;每次循环8次
    move.b (a3)+,d2
    clr.l d6
    
handleBin:
    clr.w d3
    clr.l d4
    clr.l d5
    move.l d7,d5
    
    move.b d2,d4


    ;---------------------
    lsr.b d1,d4
    and.b #1,d4
    tst.b d4
    beq Add_SetOne
    move.b d1,d3
    tst.l d3
    beq ZeroAdd
    sub.l #1,d3     ;左移时最多只有七次
leftShift: 
    lsl.l #4,d5 

    dbra d3,leftShift
ZeroAdd:
    or.l d5,d6
    
Add_SetOne: 
    dbra d1,handleBin   ;循环处理
    move.l d6,(a2)+   
    ;-------------------
    add.w #1,d0
    cmp.w #32,d0    ;总共32字节
    bcs LoadTextFinish
    
    movem.l (sp)+,d0-d7
    rts
    
LoadHKZ16:
    
    lea Text,a0
    jsr CStrlen ;计算长度
    move.l d0,TextCount  
    clr.w d1


TextElem:
    
    clr.w d2
    clr.w d3
    
    move.w (a0)+,d2
    move.b d2,d3
    lsr.w #8,d2
    
    sub.b #$a0,d2
    sub.b #1,d2
    
    sub.b #$a0,d3
    sub.b #1,d3
    
    mulu.w #94,d2
    add.w d3,d2
    
    lsl.l #5,d2
    
    lea HZK16,a1
    add.l d2,a1
    
   jsr AddTextToMem
    
    add.w #1,d1
    cmp.w d1,d0
    
    bne TextElem
    rts
    
 LevelMapData: ;背景
    incbin 'sprite/fieldA.bin'
__end: 

    END START















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
