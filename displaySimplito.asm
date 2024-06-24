.data

##Usando las dimensiones del display, 8x8 y 512x512, con la ventana abierta hacia arribabajo al MAXIMO

frameBuffer: .space 1024    # (4× 256)₁ pixeles porque cada uno es de 4 bytes
colorRed:    .word 0xFF0030   # Rojo
colorBrown:  .word 0x6c5c41   # Café
colorGreen:  .word 0x10FF00   # Verde
darkerGreen: .word 0x38761d 
colorBlue:   .word 0x4080ff   # Azul
colorYellow: .word 0xFFFF00   # Amarillo
colorCyan:   .word 0x00FFFF   # Cian
colorMagenta:.word 0xFF00FF   # Magenta
colorWhite: .word 0xFFFFFF
colorPink:  .word 0xf5a2ca 
colorOrange: .word 0xf7931e
colorGray: .word 0xa9c6e3
colorBlue:   .word 0x4080ff   # Azul
colorYellow: .word 0xFFFF00   # Amarillo
brightGreen:  .word 0x8FCE00  # Verde
darkGreen:   .word 0x38761D   # Azul
black: .word 0x000000  


.text
drawLine:
	li  $t1, 0
	
color:
	lw $t2, colorYellow
  
getCoins:
	lw $s7, 0xffff0000  #aca llama la etiqueta del simulador de Keyboard de mips
        beq $s7, 1, keyDetected #y entra a la funcion si es igual a 1, o sea que recibe una tecla
	j waitForNum	
		keyDetected:
			lw $s7, 0xffff0004 #si el valor de la tecla coincide con el ascii de la barra espaciadora, o sea 32, baja
			blt $s7, 49, waitForNum
			ble $s7, 57, count
		
        	waitForNum:        	    
        		j getCoins  # Retorna
        		
count: #reinicializacion de variables
	li  $t1, 0	
	li $t6, 3840     # maximo para pintar, (256x15)
	li $t9, 0        # contador para maximo
	li $t7, 1232 	 #para terminar antes de la ultima cuarta parte del ancho 
	li $t5, 1072     # minimo para iniciar a pintar  
	      			
red:
	lw $t3, colorRed  # $t3 ← 0x00RRGGbb red
	blt $t1, $t5, noPaint #si no ha llegado al inicio, no pinta
	bgt $t1, $t7, noPaint #si llega al limite, tampoco pinta
	sw $t3, frameBuffer($t1)# pintar cuadro
	bne $t1, $t7, noPaint  #cuando llega al limite deseado, se suma 256 para que cambie de fila
	addi $t5, $t5, 256
	addi $t7, $t7, 256

	noPaint:
		addi  $t1, $t1,     4  # incrementar por 4 para desplazarse en cuadros
		addi  $t9, $t9,     1  # $t9++
		beq   $t9, $t6, reset  # si el contador llega al limite de abajo, se sale

	j red # vuelve al llamado


reset: #redefinen los contadores de nuevo
	li $t1, 0  
	li $t9, 0 
	li $t6, 2560 #maximo hacia abajo para pintar (256x7)
	li $t7, 1484 #para terminar antes de la ultima cuarta parte del ancho 
	li $t5, 1332# minimo para iniciar a pintar, un ancho mas pequenno para el cuadro interno y una fila abajo (1088+256)


blue:		
	lw $t4, colorBlue # $t4 ← 0x00rrggBB blue
	blt $t1, $t5, noPaintBlue #si no ha llegado al inicio, no pinta
	bgt $t1, $t7, noPaintBlue #si llega al limite, tampoco pinta
	sw $t4, frameBuffer($t1)# pintar cuadro
	bne $t1, $t7, noPaintBlue  #cuando llega al limite deseado, se suma 256 para que cambie de fila
	addi $t5, $t5, 256
	addi $t7, $t7, 256

	noPaintBlue:
		addi  $t1, $t1,     4  # incrementar por 4 para desplazarse en cuadros
		addi  $t9, $t9,     1  # $t9++
		beq   $t9, $t6, turtle  # si el contador llega al limite de abajo, se sale

	j blue # vuelve al llamado

reset2:
	li $t1, 0 # iterador de pixeles
	li $t6, 5940 #inicio primera fila: 256 x 23 + 52
	li $t5, 6089 # inicio última fila: 256 x 39 + 52 
	li $t7, 0 #cantidad de líneas de la montañita que ocupamos
	li $t8, 0 
	lw $t3, colorWhite
	
Pos:
	li $t5, 5950

noDrawCat:
	jal go

cat:
	blt $t1, $t5, noDrawCat
	sw $t3, frameBuffer($t1)
	addi $t1, $t1, 12
	sw $t3, frameBuffer($t1)
	subi $t1, $t1, 12
	addi $t1, $t1, 252
	sw $t3, frameBuffer($t1)
	li $t8, 4
	jal LineForw
	jal newLine
	lw $t3, colorBrown
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorWhite
	li $t8, 2
	jal LineBac
	lw $t3, colorBrown
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorWhite
	jal newLine
	li $t8, 4
	jal LineForw
	lw $t3, colorRed
	jal newLine
	li $t8, 3
	jal LineBac
	lw $t3, colorWhite
	addi $t1, $t1, 24
	sw $t3, frameBuffer($t1)
	addi $t1, $t1, 4
	jal newLine
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	subi $t1, $t1, 8
	li $t8, 5
	jal LineBac
	addi $t1, $t1, 4
	jal newLine
	li $t8, 4
	jal LineForw
	addi $t1, $t1, 12
	sw $t3, frameBuffer($t1)
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	jal newLine
	subi $t1, $t1, 12
	jal LineBac
	jal newLine
	li $t8, 4
	jal LineForw
	addi $t1, $t1, 8
	sw $t3, frameBuffer($t1)
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	subi $t1, $t1, 4
	jal newLine
	li $t8, 6
	jal LineBac
	jal newLine
	li $t8, 4
	jal LineForw
	jal newLine
	li $t8, 5
	jal LineBac
	
PosSecond:
	lw $t3, colorPink
	li $t1, 0
	li $t5, 8115

noDrawKirby:
	jal go

Kirby:
	blt $t1, $t5, noDrawKirby
	sw $t3, frameBuffer($t1)
	li $t8, 2
	jal LineForw
	addi $t1, $t1, 4
	jal newLine
	li $t8, 4
	jal LineBac
	subi $t1, $t1, 4
	jal newLine
	lw $t3, colorBrown
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorPink
	li $t8, 2
	jal LineForw
	lw $t3, colorBrown
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorPink
	li $t8, 2
	jal LineForw
	jal newLine
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorBrown
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorPink
	li $t8, 2
	jal LineBac
	lw $t3, colorBrown
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorPink
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	li $t8, 7
	jal newLine
	jal LineForw
	jal newLine
	li $t8, 7
	jal LineBac
	addi $t1, $t1, 4
	jal newLine
	li $t8, 5
	jal LineForw
	addi $t1, $t1, 4
	lw $t3, colorRed
	jal newLine
	li $t8, 2
	jal LineBac
	subi $t1, $t1, 8
	li $t8, 3
	jal LineBac

PosThird:
	lw $t3, colorOrange
	li $t1, 0 
	li $t5, 6285
	
noDrawAmong:
	jal go

amongUS:
	blt $t1, $t5, noDrawAmong
	sw $t3, frameBuffer($t1)
	li $t8, 2
	li $t8, 2
	jal LineForw
	addi $t1, $t1, 4
	jal newLine
	li $t8, 4
	jal LineBac
	subi $t1, $t1, 4	
	jal newLine
	li $t8, 2
	jal LineForw
	lw $t3, colorGray
	li $t8, 3
	jal LineForw
	addi $t1, $t1, 4
	jal newLine
	li $t8, 4
	jal LineBac
	lw $t3, colorOrange
	jal LineBac
	jal newLine
	li $t8, 4
	jal LineForw
	lw $t3, colorGray
	li $t8, 3
	jal LineForw
	lw $t3, colorOrange
	jal newLine
	li $t8, 7
	jal LineBac
	addi $t1, $t1, 4
	jal newLine
	li $t8, 6
	jal LineForw
	jal newLine
	li $t8, 1
	jal LineBac
	subi $t1, $t1, 8
	li $t8, 2
	jal LineBac
	
PosFourth:
	lw $t3, colorBrown
	li $t1, 0 
	li $t5, 7015

noDrawPotion:
	jal go

Potion:
	blt $t1, $t5, noDrawPotion
	sw $t3, frameBuffer($t1)
	li $t8, 2
	jal LineForw
	addi $t1, $t1, 4
	lw $t3, colorGray
	jal newLine
	li $t8, 4
	jal LineBac
	jal newLine
	lw $t3, colorBrown
	li $t8, 3
	jal LineForw
	lw $t3, colorGray
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	subi $t1, $t1, 4
	jal newLine
	lw $t3, colorCyan
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorGray
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	jal newLine
	lw $t3, colorCyan
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	lw $t3, colorGray
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	addi $t1, $t1, 4
	jal newLine
	lw $t3, colorCyan
	li $t8, 3
	jal LineBac
	lw $t3, colorGray
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	subi $t1, $t1, 4
	jal newLine
	lw $t3, colorCyan
	li $t8, 5
	jal LineForw
	lw $t3, colorGray
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	jal newLine
	lw $t3, colorCyan
	li $t8, 5
	jal LineBac
	lw $t3, colorGray
	subi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	addi $t1, $t1, 4
	jal newLine
	lw $t3, colorCyan
	li $t8, 3
	jal LineForw
	lw $t3, colorGray
	addi $t1, $t1, 4
	sw $t3, frameBuffer($t1)
	subi $t1, $t1, 4
	jal newLine
	li $t8, 2
	jal LineBac
	j turtle
	
newLine:
	addi $t1, $t1, 256
	sw $t3, frameBuffer($t1)
	jr $ra
	
go:
	addi $t1, $t1, 4
	jr $ra
	
LineForw:
	beq $t7, $t8, backfr
	addi $t1, $t1, 4 #loop 
	sw $t3, frameBuffer($t1)
	addi $t7, $t7, 1
	j LineForw
	backfr: 
		li $t7, 0
		jr $ra
	
LineBac:
	beq $t7, $t8,back
	subi $t1, $t1, 4 #loop 
	sw $t3, frameBuffer($t1)
	addi $t7, $t7, 1
	j LineBac
	back:
		li $t7, 0
		jr $ra
	
turtle:
	lw $t2, black
	lw $t3, brightGreen  # $t3 ← 0x00RRGGbb red
	lw $t4, darkGreen # $t4 ← 0x00rrggBB blue

	li $t6, 8516    
	
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 248
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 8
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 228
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)	
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t2, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	
	addi $t6, $t6, 224
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)	
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	
	addi $t6, $t6, 220
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t4, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	
	addi $t6, $t6, 228
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	
	addi $t6, $t6, 236
	sw $t3, frameBuffer($t6)	
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 12
	sw $t3, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t3, frameBuffer($t6)
		
reset3:
	li $a0, 20500 #para tiempo entre acciones
	li $s0, 2380 #coordenadas x iniciales
	li $s3, 2484 #coordenadas maximas x
	
	li $t1, 1344 
	li $t5, 1600
	li $t6, 1856
	
	li $t7, 2108
	li $t8, 2360 
	
		
claw:
	#li $t1, 1344 #coordenadas de la garra
	lw $t2, colorYellow
	lw $t4, colorBlue
	sw $t2, frameBuffer($t1)
	addi $t1, $t1, 4
	sw $t2, frameBuffer($t1)
	#s1 +256
	sw $t2, frameBuffer($t5)
	addi $t5, $t5, 4
	sw $t2, frameBuffer($t5)
	#s1 + 256x2
	sw $t2, frameBuffer($t6)
	addi $t6, $t6, 4
	sw $t2, frameBuffer($t6)
	#2108
	sw $t2, frameBuffer($t7)
	addi $t7, $t7, 12
	sw $t2, frameBuffer($t7)
	#2360
	sw $t2, frameBuffer($t8)
	addi $t8, $t8, 20
	sw $t2, frameBuffer($t8)
	
	li $s5, 1 #variable para saber si va a la derecha(1) o a la izquierda(0)
	li $t1, 1344  #valores para las coordenadas de los pixeles de la garra
	li $t5, 1600
	li $t6, 1856
	
	li $t7, 2108
	li $t8, 2360

	goRight:
		#pixeles primera fila	
		bge $t8, $s3, return #cuando t8, que esta al tope derecho, llega al limite, va para la izquierda
		sw $t4, frameBuffer($t1) #pinta de azul el actual ya que se va a mover
		sub $t1, $t1, 4 #resta para que el anterior tambien se repinte de azul 
		sw $t4, frameBuffer($t1)
		addi $t1, $t1, 8 #suma 8 para posicionarse en la columna nueva para pintar de amarillo
		sw $t2, frameBuffer($t1)
		addi $t1, $t1, 4 #y uno mas para la otra columna al lado
		sw $t2, frameBuffer($t1)
		sub $t1, $t1, 4 #luego se resta nuevamente para que quede en su posicion nueva izquierda
		#sucede lo mismo con las otras dos filas
		#s1 +256, segunda fila
		sw $t4, frameBuffer($t5)
		sub $t5, $t5, 4
		sw $t4, frameBuffer($t5)
		addi $t5, $t5, 8
		sw $t2, frameBuffer($t5)
		addi $t5, $t5, 4
		sw $t2, frameBuffer($t5)
		sub $t5, $t5, 4
		#s1 + 256x2, tercera fila
		sw $t4, frameBuffer($t6)
		sub $t6, $t6, 4
		sw $t4, frameBuffer($t6)
		addi $t6, $t6, 8
		sw $t2, frameBuffer($t6)
		addi $t6, $t6, 4
		sw $t2, frameBuffer($t6)
		sub $t6, $t6, 4
		#2108, cuarta fila (cuadros separados)
		sw $t4, frameBuffer($t7) #se pinta de azul la actual
		addi $t7, $t7, 4
		sw $t2, frameBuffer($t7) #se pinta de amarillo la siguiente 
		addi $t7, $t7, 8 #suma 8 para quedar en la posicion del cuadro hermano y pintarlo de azul
		sw $t4, frameBuffer($t7)
		addi $t7, $t7, 4 #suma 4 mas para pintar amarillo el nuevo cuadro
		sw $t2, frameBuffer($t7)
		sub $t7, $t7, 12 #resta 12 para quedar en la posicion inicial nueva a la izquierda
		#2360, quinta fila (cuadros separados)
		sw $t4, frameBuffer($t8)
		addi $t8, $t8, 4
		sw $t2, frameBuffer($t8)
		addi $t8, $t8, 16
		sw $t4, frameBuffer($t8)
		addi $t8, $t8, 4
		sw $t2, frameBuffer($t8)
		sub $t8, $t8, 20
		  
        	jal delay #para tener una velocidad moderada del cambio
		j goRight
	
	return:
		li $s5, 0
		li $t1, 1472 #se redefinen las ultimas posiciones de la garra para que empiecen justo al borde del limite deseado
		li $t5, 1728
		li $t6, 1984
	
		li $t7, 2244
		li $t8, 2504
	goLeft:
		#cuando va a la izquierda, las funciones de suma y resta se invierten y sea usa la misma logica
		ble $t8, $s0, claw #cuando llega al tope, reinicia el movimiento de garra desde la izquierda
		sw $t4, frameBuffer($t1)
		addi $t1, $t1, 4
		sw $t4, frameBuffer($t1)
		sub $t1, $t1, 8
		sw $t2, frameBuffer($t1)
		sub $t1, $t1, 4
		sw $t2, frameBuffer($t1)
		addi $t1, $t1, 4
		#addi $t1, $t1, 256   #s1 +256
		sw $t4, frameBuffer($t5)
		addi $t5, $t5, 4
		sw $t4, frameBuffer($t5)
		sub $t5, $t5, 8
		sw $t2, frameBuffer($t5)
		sub $t5, $t5, 4
		sw $t2, frameBuffer($t5)
		addi $t5, $t5, 4
		#addi $t1, $t1, 512  #s1 + 256x2
		sw $t4, frameBuffer($t6)
		addi $t6, $t6, 4
		sw $t4, frameBuffer($t6)
		sub $t6, $t6, 8
		sw $t2, frameBuffer($t6)
		sub $t6, $t6, 4
		sw $t2, frameBuffer($t6)
		addi $t6, $t6, 4
		#addi $t1, $t1, 764 #2108
		sw $t4, frameBuffer($t7)
		sub $t7, $t7, 4
		sw $t2, frameBuffer($t7)
		sub $t7, $t7, 8
		sw $t4, frameBuffer($t7)
		sub $t7, $t7, 4
		sw $t2, frameBuffer($t7)
		addi $t7, $t7, 12
		#addi $t1, $t1, 1016 #2360
		sw $t4, frameBuffer($t8)
		sub $t8, $t8, 4
		sw $t2, frameBuffer($t8)
		sub $t8, $t8, 16
		sw $t4, frameBuffer($t8)
		sub $t8, $t8, 4
		sw $t2, frameBuffer($t8)
		addi $t8, $t8, 20
		
		jal delay 
		j goLeft #reinicia bucle
		
    	delay: 
        	#a0 es el numero de iteraciones
        	move $t0, $a0    # contador copiado a $t0
    		delay_loop:
        		addi $t0, $t0, -1 
        		bnez $t0, delay_loop # cuando llega a cero se sale del loop   	
        	
        		lw $t9, 0xffff0000  #aca llama la etiqueta del simulador de Keyboard de mips
        		beq $t9, 1, keyboardListenerIf #y entra a la funcion si es igual a 1, o sea que recibe una tecla
			j keyboardListenerDone
	
		keyboardListenerIf:
			lw $t9, 0xffff0004 #si el valor de la tecla coincide con el ascii de la barra espaciadora, o sea 32, baja
			beq $t9, 32, moveDown
		
        	keyboardListenerDone:        	    
        		jr $ra  # Retorna
	
moveDown:
	#lw $t2, colorYellow
	#lw $t4, colorBlue
	li $s4, 8508 #maximo para abajo, que es la posicion y inicial del cuadro mas abajo sumado a 256x25
	li $t0, 200000
	moveLoop:
		bgt $t8, $s4, findMatch #si llega al tope, se detiene
		beq $s5, $zero, leftDirection #si la garra iba para la izquierda (s5=0)
		bne $s5, $zero, rightDirection #si la garra iba para la derecha (s5=1)
		
		rightDirection:
		
		sw $t4, frameBuffer($t8) 
		addi $t8, $t8, 20
		sw $t4, frameBuffer($t8)
		addi $t8, $t8, 256
		sw $t2, frameBuffer($t8)
		sub $t8, $t8, 20
		sw $t2, frameBuffer($t8)
		#penultimos cuadros
		sw $t4, frameBuffer($t7) 
		addi $t7, $t7, 12
		sw $t4, frameBuffer($t7)
		addi $t7, $t7, 256
		sw $t2, frameBuffer($t7)
		sub $t7, $t7, 12
		sw $t2, frameBuffer($t7)
		#barra, esta no se borra para que haga el efecto de que se alarga la garra
		#solo se repinta la ultima fila ya que de todos modos se va dejando el rastro de las anteriores
		addi $t6, $t6, 256
		sw $t2, frameBuffer($t6)
		addi $t6, $t6, 4
		sw $t2, frameBuffer($t6)
		sub $t6, $t6, 4

		j moveLoop
			
		leftDirection: #la diferencia con rightDirection es que aca las variables iniciales de la garra estan a la derecha y se les resta para poner su par
		sw $t4, frameBuffer($t8) 
		sub $t8, $t8, 20
		sw $t4, frameBuffer($t8)
		addi $t8, $t8, 256
		sw $t2, frameBuffer($t8)
		addi $t8, $t8, 20
		sw $t2, frameBuffer($t8)
		#penultimos cuadros
		sw $t4, frameBuffer($t7) 
		sub $t7, $t7, 12
		sw $t4, frameBuffer($t7)
		addi $t7, $t7, 256
		sw $t2, frameBuffer($t7)
		addi $t7, $t7, 12
		sw $t2, frameBuffer($t7)
		#barra, esta no se borra para que haga el efecto de que se alarga la garra
		addi $t6, $t6, 256
		sw $t2, frameBuffer($t6)
		sub $t6, $t6, 4
		sw $t2, frameBuffer($t6)
		addi $t6, $t6, 4
		j moveLoop	
	
	findMatch:
		li $t9, 8004 #copia de posicion de la tortuga, ajustada al maximo de la garra
		beq $s5, $zero, left #si la garra iba para la izquierda (s5=0)
		bne $s5, $zero, right #si la garra iba para la derecha (s5=1)
		left:
			beq $t9, $t6, winTurtle #si la pos final Y de la garra coincide con uno de los dos pixeles Y de la tortuga
			sub $t6, $t6, 4
			beq $t9, $t6, winTurtle
			j delay2 #sino, que siga jugando
		
		right:
			beq $t9, $t6, winTurtle
			addi $t6, $t6, 4
			beq $t9, $t6, winTurtle
			j delay2		
	winTurtle: #llamado a la victoria
		j WIN
	delay2: 			
        	addi $t0, $t0, -1 
        	bnez $t0, delay2
        	     		
games: 
	beq $s7, 49, end #como el contador de partidas esta en ASCII, 49=1
	sub $s7, $s7, 1 #a cada ronda, se le resta uno al contador
	j count

WIN:
    li $t3,  11096  # posicion inicial de win
    lw $t2, colorYellow # carga del color

    li $t1, 0    #carga del contador
   draw_w_row:
    # dibujar linea vertical
    drawW1:
    beq $t1, 7, drawW2
    addi $t3, $t3, 256   
    sw $t2, frameBuffer($t3)       
    addi $t1, $t1, 1
    j drawW1
    
    #dibujar diagonales de W
    drawW2:
    li $t1, 0
    sub $t3, $t3, 252
    sw $t2, frameBuffer($t3) 
    sub $t3, $t3, 252
    sw $t2, frameBuffer($t3) 
    sub $t3, $t3, 252
    sw $t2, frameBuffer($t3) 
    sub $t3, $t3, 256
    sw $t2, frameBuffer($t3) 
    
    addi, $t3, $t3, 516
    sw $t2, frameBuffer($t3) 
    addi $t3, $t3, 260
    sw $t2, frameBuffer($t3) 
    addi $t3, $t3, 260
    sw $t2, frameBuffer($t3) 
    
    #dibujar linea de W
    drawW3:
    beq $t1, 7, draw_i   
    sw $t2, frameBuffer($t3)    
    sub $t3, $t3, 256
    addi $t1, $t1, 1
    j drawW3
    
    #pintar I
   draw_i:
    li $t1, 0          
    addi $t3, $t3, 256
    addi $t3, $t3,  12
   draw_i_row:
    beq $t1, 7, draw_n  
    sw $t2, frameBuffer($t3)     
    addi $t3, $t3, 256 
    addi $t1, $t1, 1    
    j draw_i_row       

     # pintar "N"
    draw_n:
    li $t1, 0       
    sub $t3, $t3, 244
    drawN1: 
    sw $t2, frameBuffer($t3) 
    sub $t3, $t3, 256 
    addi $t1, $t1, 1
    bne $t1, 7, drawN1   
    jal resetL
 
    drawN2:      
    addi $t3, $t3, 260
    sw $t2, frameBuffer($t3)      
    addi $t1, $t1, 1    
    bne $t1, 7, drawN2
    jal resetL          # Loop

    drawN3:
    beq $t1, 7,endWin
    sw $t2, frameBuffer($t3) 
    sub $t3, $t3, 256 
    addi $t1, $t1, 1
    j drawN3   
    
endWin:
j delay2

   resetL:
    li $t1, 0
    jr $ra
    
end:

