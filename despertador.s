@   Projeto relogio
@ 
@   Configuracao do teclado:
@
@   7 8 9 x
@   4 5 6 x
@   1 2 3 x
@   0 x x T
@
@   Legenda: x - Comandos inválidos
@          T - Troca os modos - Despertador e Relogio
@
@   Especificação: O Relogio despertador funciona do dia 01/01/2000 00:00:00 até 30/12/2099 23:59:59


entry: b trocaModo          @pula as configuracoes

@Data num array, le: 01/01/2000 12:00:00, onde os dois primeiros digitos do ano nao podem ser alterados
data: .byte 0, 1, 0, 1, 0, 0, 1, 2, 0, 0, 0, 0
@Modo atual: 0 = RELOGIO, 1 = DESPERTADOR
modo: .byte 1
@despertador tem o formato hh:mm
despertador: .byte 0, 7, 0, 0 
@vetor de posicoes, mapeia as posicoes no visor com o vetor da data
posicoesData: .byte 1, 2, 4, 5, 9, 10, 12, 13, 15, 16, 18, 19
posicoesDespertador: .byte 1, 2, 4, 5
seletor: .byte 2
    .align

doisPontos: .asciz ":"
hifen: .asciz"-"
letraC: .asciz"C"
letraD: .asciz"D"
traco: .asciz"-"

start:
    b escreveDisplay
cont0:
    b verificaAlarme
cont1:
    b addSegundoUnidade
cont2:
    b verificaBotoes
    
verificaBotoes:
    @TODO Trocar os digitos

    @Alterando posicao seletor
    swi 0x202
    cmp r0, #0x01
    beq moveSeletorEsquerda
    cmp r0, #0x02
    beq moveSeletorDireita

    @Troca de modo, botao 3,3
    swi 0x203
    cmp r0, #1
    beq apertouSete
    cmp r0, #2
    beq apertouOito
    cmp r0, #4
    beq apertouNove
    cmp r0, #16
    beq apertouQuatro
    cmp r0, #32
    beq apertouCinco
    cmp r0, #64
    beq apertouSeis
    cmp r0, #256
    beq apertouUm
    cmp r0, #512
    beq apertouDois
    cmp r0, #1024
    beq apertouTres
    cmp r0, #4096
    beq apertouZero
    cmp r0, #32768
    beq trocaModo

    b start

apertouZero:
    mov r9, #0 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouUm:
    mov r9, #1 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouDois:
    mov r9, #2 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouTres:
    mov r9, #3 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouQuatro:
    mov r9, #4 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouCinco:
    mov r9, #5 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouSeis:
    mov r9, #6 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouSete:
    mov r9, #7 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouOito:
    mov r9, #8 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador
apertouNove:
    mov r9, #9 @r9 = Valor apertado
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq setRelogio
    bne setDespertador

setRelogio:
    @r9 -> Tem o valor a ser colocado
    @r8 -> Tem o local a ser alterado (No display)
    @r7 -> Endereço inicio do vetor data
    ldr r0, =seletor
    ldrb r8, [r0]
    ldr r7, =data
    cmp r8, #1
    beq setDataDiaDezena
    cmp r8, #2
    beq setDataDiaUnidade
    cmp r8, #4
    beq setDataMesDezena
    cmp r8, #5
    beq setDataMesUnidade
    cmp r8, #9
    beq setDataAnoDezena
    cmp r8, #10
    beq setDataAnoUnidade
    cmp r8, #12
    beq setDataHoraDezena
    cmp r8, #13
    beq setDataHoraUnidade
    cmp r8, #15
    beq setDataMinutoDezena
    cmp r8, #16
    beq setDataMinutoUnidade
    cmp r8, #18
    beq setDataSegundoDezena
    cmp r8, #19
    beq setDataSegundoUnidade
    b start

setDataDiaDezena:
    cmp r9, #4
    bge start
    cmp r9, #3
    beq verificaSetDiaTrinta
contSetDataDiaDezena:
    strb r9, [r7, #0]
    b start
verificaSetDiaTrinta:
    ldrb r5, [r7, #1]
    cmp r5, #0
    beq contSetDataDiaDezena
    b start

setDataDiaUnidade:
    ldrb r5, [r7, #0]
    cmp r5, #3
    bge start
    strb r9, [r7, #1]
    b start

setDataMesDezena:
    cmp r9, #2
    bge start
    cmp r9, #1
    beq verificaSetDataMesDezena
contSetDataMesDezena:
    strb r9, [r7, #2]
    b start
verificaSetDataMesDezena:
    ldrb r5, [r7, #3]
    cmp r5, #2
    ble contSetDataMesDezena
    b start

setDataMesUnidade:
    ldrb r5, [r7, #2]    
    cmp r5, #1
    bge verificaSetDataMesUnidade
contSetDataMesUnidade:
    strb r9, [r7, #3]
    b start
verificaSetDataMesUnidade:
    cmp r9, #2
    ble contSetDataMesUnidade
    b start

setDataAnoDezena:
    strb r9, [r7, #4]
    b start

setDataAnoUnidade:
    strb r9, [r7, #5]
    b start

setDataHoraDezena:
    cmp r9, #3
    bge start
    cmp r9, #2
    beq verificaSetDataHoraDezena
contSetDataHoraDezena:
    strb r9, [r7, #6]
    b start
verificaSetDataHoraDezena:
    ldrb r5, [r7, #7]
    cmp r5, #3
    ble contSetDataHoraDezena
    b start

setDataHoraUnidade:
    ldrb r5, [r7, #6]    
    cmp r5, #2
    bge verificaSetDataHoraUnidade
contSetDataHoraUnidade:
    strb r9, [r7, #7]
    b start
verificaSetDataHoraUnidade:
    cmp r9, #3
    ble contSetDataHoraUnidade
    b start

setDataMinutoDezena:
    cmp r9, #6
    bge start
    strb r9, [r7, #8]
    b start

setDataMinutoUnidade:
    strb r9, [r7, #9]
    b start

setDataSegundoDezena:
    cmp r9, #6
    bge start
    strb r9, [r7, #10]
    b start
setDataSegundoUnidade:
    strb r9, [r7, #11]
    b start


setDespertador:
    @r9 -> Tem o valor a ser colocado
    @r8 -> Tem o local a ser alterado (No display)
    @r7 -> Endereço inicio do vetor data
    ldr r0, =seletor
    ldrb r8, [r0]
    ldr r7, =despertador
    cmp r8, #1
    beq setDespertadorHoraDezena
    cmp r8, #2
    beq setDespertadorHoraUnidade
    cmp r8, #4
    beq setDespertadorMinutoDezena
    cmp r8, #5
    beq setDespertadorMinutoUnidade
    b start

setDespertadorHoraDezena:
    cmp r9, #3
    bge start
    cmp r9, #2
    beq verificaSetDespertadorHoraDezena
contSetDespertadorHoraDezena:
    strb r9, [r7, #0]
    b start
verificaSetDespertadorHoraDezena:
    ldrb r5, [r7, #1]
    cmp r5, #3
    ble contSetDespertadorHoraDezena
    b start

setDespertadorHoraUnidade:
    ldrb r5, [r7, #0]    
    cmp r5, #2
    bge verificaSetDespertadorHoraUnidade
contSetDespertadorHoraUnidade:
    strb r9, [r7, #1]
    b start
verificaSetDespertadorHoraUnidade:
    cmp r9, #3
    ble contSetDespertadorHoraUnidade
    b start

setDespertadorMinutoDezena:
    cmp r9, #6
    bge start
    strb r9, [r7, #2]
    b start

setDespertadorMinutoUnidade:
    strb r9, [r7, #3]
    b start

moveSeletorDireita:
    mov r0, #2
    swi 0x208 @limpa a linha do seletor

    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq moveDireitaRelogio
    bne moveDireitaDespertador

moveDireitaRelogio:
    ldr r0, =seletor
    ldrb r4, [r0]

    @Posicoes relogio
    cmp r4, #2
    beq pulaUm
    cmp r4, #10
    beq pulaUm
    cmp r4, #13
    beq pulaUm
    cmp r4, #16
    beq pulaUm
    cmp r4, #5
    beq pulaQuatro
    cmp r4, #19
    bge escreveTraco @nao permite adicionar alem do tamanho do vetor
    add r4, r4, #1
    strb r4, [r0]

    b escreveTraco

pulaUm:
    add r4, r4, #2
    strb r4, [r0]
    b escreveTraco

pulaQuatro:
    add r4, r4, #4
    strb r4, [r0]
    b escreveTraco

moveDireitaDespertador:
    ldr r0, =seletor
    ldrb r4, [r0]

    cmp r4, #2
    beq pulaUm
    cmp r4, #5
    bge escreveTraco @nao permite adicionar alem do tamanho do vetor

    add r4, r4, #1
    strb r4, [r0]

    b escreveTraco

moveSeletorEsquerda:
    mov r0, #2
    swi 0x208 @limpa a linha do seletor

    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq moveEsquerdaRelogio
    bne moveEsquerdaDespertador

moveEsquerdaRelogio:
    ldr r0, =seletor
    ldrb r4, [r0]
    @Garantindo posicoes corretas
    cmp r4, #4
    beq voltaUm
    cmp r4, #9
    beq voltaQuatro
    cmp r4, #12
    beq voltaUm
    cmp r4, #15
    beq voltaUm
    cmp r4, #18
    beq voltaUm
    cmp r4, #1
    ble escreveTraco @nao permite adicionar alem do tamanho do vetor

    sub r4, r4, #1
    strb r4, [r0]

    b escreveTraco

voltaUm:
    sub r4, r4, #2
    strb r4, [r0]
    b escreveTraco

voltaQuatro:
    sub r4, r4, #4
    strb r4, [r0]
    b escreveTraco

moveEsquerdaDespertador:
    ldr r0, =seletor
    ldrb r4, [r0]
    cmp r4, #4
    beq voltaUm
    cmp r4, #1
    ble escreveTraco @nao permite adicionar alem do tamanho do vetor

    sub r4, r4, #1
    strb r4, [r0]
    
    b escreveTraco

escreveTraco:
    ldr r0, =seletor
    ldrb r4, [r0]
    mov r0, r4
    mov r1, #2
    ldr r2, =traco
    swi 0x204
    b start

trocaModo:
    swi 0x206 @Apaga display

    @setando o seletor em 1 novamente
    ldr r0, =seletor
    mov r1, #1
    strb r1, [r0]
    @escrevendo o traco
    mov r0, #1  @Aponta r0 coluna correta
    mov r1, #2  @Aponta r1 para a linha correta do relogio
    ldr r2, =traco
    swi 0x204

    @trocando o modo
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq ativaModoDespertador
    bne ativaModoRelogio

ativaModoDespertador:
    ldr r0, =modo
    mov r1, #1
    strb r1, [r0]
    b start

ativaModoRelogio:
    ldr r0, =modo
    mov r1, #0
    strb r1, [r0]
    b start

verificaAlarme:     @Verifica se o alarme deve tocar
    ldr r0, =despertador
    ldr r1, =data

    ldrb r2, [r0, #0] @Carrega em r2 o valor do despertadorHoraDezena
    ldrb r3, [r1, #6] @Carrega em r3 o valor do horaDezena
    cmp r2, r3
    bne desligaDespertador    @sai da verificacao caso o valor seja diferente

    ldrb r2, [r0, #1] @Carrega em r2 o valor do despertadorHoraUnidade
    ldrb r3, [r1, #7] @Carrega em r3 o valor do horaUnidade
    cmp r2, r3
    bne desligaDespertador    @sai da verificacao caso o valor seja diferente

    ldrb r2, [r0, #2] @Carrega em r2 o valor do despertadorMinutoDezena
    ldrb r3, [r1, #8] @Carrega em r3 o valor do minutoDezena
    cmp r2, r3
    bne desligaDespertador    @sai da verificacao caso o valor seja diferente

    ldrb r2, [r0, #3] @Carrega em r2 o valor do despertadorMinutoUnidade
    ldrb r3, [r1, #9] @Carrega em r3 o valor do minutoUnidade
    cmp r2, r3
    bne desligaDespertador    @sai da verificacao caso o valor seja diferente

    @Verifica se a dezena do segundo é igual a 0 para acender as luzes

    ldrb r3, [r1, #10] @Carrega em r3 o valor do segundoDezena
    cmp r3, #0
    bne desligaDespertador    @sai da verificacao caso o valor seja diferente
    beq ligaDespertador

desligaDespertador:
    mov r0, #0x00
    swi 0x201
    b cont1

ligaDespertador:
    mov r0, #0x03
    swi 0x201    
    b cont1

escreveDisplay:
    ldr r0, =modo
    ldrb r1, [r0]
    cmp r1, #0
    beq escreveHora
    bne escreveDespertador

escreveHora: 
    mov r0, #0
    mov r1, #0
    ldr r2, =letraC
    swi 0x204

    ldr r8, =data

    @Aponta a coluna correta
    mov r0, #1
    @Aponta r1 para a linha correta do relogio
    mov r1, #1

    @escrevendo data
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldr r2, =hifen
    swi 0x204

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldr r2, =hifen
    swi 0x204

    add r0, r0, #1
    mov r2, #2
    swi 0x205

    add r0, r0, #1
    mov r2, #0
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    @espaco entre data e hora
    add r0, r0, #1

    @escrevendo hora
    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldr r2, =doisPontos
    swi 0x204

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldr r2, =doisPontos
    swi 0x204

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    b cont0

escreveDespertador:
    ldr r8, =despertador

    mov r0, #0
    mov r1, #0
    ldr r2, =letraD
    swi 0x204

    @Aponta a coluna correta
    mov r0, #1
    @Aponta r1 para a linha correta do relogio
    mov r1, #1

    @escrevendo hora
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldr r2, =doisPontos
    swi 0x204

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    add r0, r0, #1
    ldrb r2, [r8], #1
    swi 0x205

    b cont0

addSegundoUnidade:
    @Marca o tempo
    swi 0x6d
    mov r1, r0
    add r1, r1, #1000
esperaSegundoPassar:
    @Espera o segundo passar
    swi 0x6d
    mov r2, r0
    cmp r1, r2
    bge esperaSegundoPassar

    ldr r1, =data
    ldrb r2, [r1, #11] @Carrega em r2 o valor do segundo

    add r2, r2, #1
    cmp r2, #10
    beq addSegundoDezena
    strb r2, [r1, #11]

    b cont2

addSegundoDezena:

    ldr r1, =data
    mov r3, #0
    strb r3, [r1, #11] @zera a unidade do segundo

    ldrb r2, [r1, #10] @Carrega em r2 o valor da dezena do segundo
    
    add r2, r2, #1
    cmp r2, #6
    beq addMinutoUnidade
    strb r2, [r1, #10]

    b cont2

addMinutoUnidade:

    ldr r1, =data
    mov r3, #0
    strb r3, [r1, #10] @zera a dezena do segundo

    ldrb r2, [r1, #9] @Carrega em r2 o valor do minutoUnidade

    add r2, r2, #1
    cmp r2, #10
    beq addMinutoDezena
    strb r2, [r1, #9]

    b cont2

addMinutoDezena:

    ldr r1, =data
    mov r3, #0
    strb r3, [r1, #9] @zera a unidade do minuto

    ldrb r2, [r1, #8] @Carrega em r2 o valor do minutoDezena

    add r2, r2, #1
    cmp r2, #6
    beq addHoraUnidade
    strb r2, [r1, #8]

    b cont2



addHoraUnidade:
    
    ldr r1, =data
    mov r3, #0
    strb r3, [r1, #8] @zera a dezena do minuto

    ldrb r2, [r1, #7] @Carrega em r2 o valor do horaUnidade

    add r2, r2, #1

    cmp r2, #4
    beq verificaMeiaNoite

naoEhMeiaNoite:
    ldr r1, =data
    ldrb r2, [r1, #7] @Carrega em r2 o valor do horaUnidade

    add r2, r2, #1
    cmp r2, #10
    beq addHoraDezena
    strb r2, [r1, #7]

    b cont2

addHoraDezena:

    ldr r1, =data
    mov r3, #0
    strb r3, [r1, #7] @zera a dezena da hora

    ldrb r2, [r1, #6] @Carrega em r2 o valor do horaDezena

    add r2, r2, #1
    strb r2, [r1, #6]
    b cont2

ehMeiaNoite:
    ldr r1, =data
    mov r3, #0
    strb r3, [r1, #6] @zera dezena da hora
    strb r3, [r1, #7] @zera unidade da hora
    b addDiaUnidade

verificaMeiaNoite:
    
    ldr r1, =data
    ldrb r2, [r1, #6]
    cmp r2, #2
    beq ehMeiaNoite
    bne naoEhMeiaNoite


addDiaUnidade:
    ldr r1, =data
    ldrb r2, [r1, #1] @Carrega em r2 o valor da unidade do dia

    add r2, r2, #1
    cmp r2, #1
    beq verificaDiaTrinta

naoEhDiaTrinta:
    ldr r1, =data
    ldrb r2, [r1, #1] @Carrega em r2 o valor do horaUnidade

    add r2, r2, #1
    cmp r2, #10
    beq addDiaDezena
    strb r2, [r1, #1]

    b cont2

verificaDiaTrinta:

    ldr r1, =data
    ldrb r2, [r1]
    cmp r2, #3
    beq EhDiaTrinta
    bne naoEhDiaTrinta

EhDiaTrinta:
    ldr r1, =data
    mov r3, #0
    mov r4, #1
    strb r3, [r1] @zera dezena do dia
    strb r4, [r1, #1] @1 na unidade do dia
    b addMesUnidade

addDiaDezena:
    ldr r1, =data
    mov r3, #0
    strb r3, [r1, #1] @zera a unidade do dia

    ldrb r2, [r1] @Carrega em r2 o valor da dezena do dia
    
    add r2, r2, #1
    cmp r2, #4
    beq addMesUnidade
    strb r2, [r1]

    b cont2

addMesUnidade:
    ldr r1, =data
    mov r3, #0
    strb r3, [r1] @zera a dezena do dia

    ldrb r2, [r1, #3] @Carrega em r2 o valor da unidade do mes
    
    add r2, r2, #1

    cmp r2, #3
    beq verificaDezembro


naoEhDezembro:
    ldr r1, =data
    ldrb r2, [r1, #3] @Carrega em r2 o valor do unidade do mes

    add r2, r2, #1
    cmp r2, #10
    beq addMesDezena
    strb r2, [r1, #3]

    b cont2

verificaDezembro:
    ldr r1, =data
    ldrb r2, [r1, #2]
    cmp r2, #1
    beq ehDezembro
    bne naoEhDezembro

ehDezembro:
    ldr r1, =data
    mov r3, #0
    mov r4, #1
    strb r3, [r1, #2] @zera dezena do mes
    strb r4, [r1, #3] @zera unidade do mes
    b addAnoUnidade

addMesDezena:
    ldr r1, =data
    mov r3, #1
    strb r3, [r1, #3] @Volta para inicio do mes

    ldrb r2, [r1, #2] @carrega em r2 o valor da dezena do mes

    add r2, r2, #1
    strb r2, [r1, #2]

    b cont2
    
addAnoUnidade:
    ldr r1, =data
    ldrb r2, [r1, #5] @Carrega em r2 o valor da unidade do ano

    add r2, r2, #1
    cmp r2, #10
    beq addAnoDezena
    strb r2, [r1, #5]

    b cont2
    
addAnoDezena:
    ldr r1, =data
    mov r3, #0
    strb r3, [r1, #5] @zera a unidade do ano

    ldrb r2, [r1, #4] @Carrega em r2 o valor da dezena do ano
    
    add r2, r2, #1
    strb r2, [r1, #4]

    b cont2
    

stop:   b stop