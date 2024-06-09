.data

##Usando las dimensiones del display, 8x8 y 512x512, con la ventana abierta hacia arribabajo al MAXIMO

frameBuffer: .space 1024    # (4× 256)₁ pixeles porque cada uno es de 4 bytes
colorRed:    .word 0xFF0030   # Rojo
colorGreen:  .word 0x10FF00   # Verde
colorBlue:   .word 0x4080ff   # Azul
colorYellow: .word 0xFFFF00   # Amarillo
colorCyan:   .word 0x00FFFF   # Cian
colorMagenta:.word 0xFF00FF   # Magenta
colorWhite: .word 0xFFFFFF


.text
drawLine:
	li  $t1, 0
	
color:
	lw $t2, colorYellow
	lw $t3, colorRed  # $t3 ← 0x00RRGGbb red
	lw $t4, colorBlue # $t4 ← 0x00rrggBB blue
	

count:
	li $t6, 3840     # maximo para pintar, (256x15)
	li $t9, 0        # contador para maximo
	li $t7, 1232 #para terminar antes de la ultima cuarta parte del ancho 
	li $t5, 1072     # minimo para iniciar a pintar

red:

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
	blt $t1, $t5, noPaintBlue #si no ha llegado al inicio, no pinta
	bgt $t1, $t7, noPaintBlue #si llega al limite, tampoco pinta
	sw $t4, frameBuffer($t1)# pintar cuadro
	bne $t1, $t7, noPaintBlue  #cuando llega al limite deseado, se suma 256 para que cambie de fila
	addi $t5, $t5, 256
	addi $t7, $t7, 256

	noPaintBlue:
		addi  $t1, $t1,     4  # incrementar por 4 para desplazarse en cuadros
		addi  $t9, $t9,     1  # $t9++
		beq   $t9, $t6, reset2  # si el contador llega al limite de abajo, se sale

	j blue # vuelve al llamado
reset2:
	li $a0, 10500 #para tiempo entre acciones
	li $s0, 2380 #coordenadas x iniciales
	li $s3, 2484 #coordenadas maximas x
	
	li $t1, 1344 
	li $t5, 1600
	li $t6, 1856
	
	li $t7, 2108
	li $t8, 2360 
		
claw:
	#li $t1, 1344 #coordenadas de la garra
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
	
	
	li $t1, 1344  #valores para las coordenadas de los pixeles de la garra
	li $t5, 1600
	li $t6, 1856
	
	li $t7, 2108
	li $t8, 2360

	goRight:
		#pixeles primera fila	
		bge $t8, $s3, return
		sw $t4, frameBuffer($t1)
		sub $t1, $t1, 4
		sw $t4, frameBuffer($t1)
		addi $t1, $t1, 8
		sw $t2, frameBuffer($t1)
		addi $t1, $t1, 4
		sw $t2, frameBuffer($t1)
		sub $t1, $t1, 4
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
		#2108, cuarta fila (separados)
		sw $t4, frameBuffer($t7)
		addi $t7, $t7, 4
		sw $t2, frameBuffer($t7)
		addi $t7, $t7, 8
		sw $t4, frameBuffer($t7)
		addi $t7, $t7, 4
		sw $t2, frameBuffer($t7)
		sub $t7, $t7, 12
		#2360, quinta fila (separados)
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
		li $t1, 1472 #se redefinen las ultimas posiciones de la garra para que empiecen justo al borde del limite deseado
		li $t5, 1728
		li $t6, 1984
	
		li $t7, 2244
		li $t8, 2504
	goLeft:
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
        	move $t0, $a0     # contador copiado a $t0

    		delay_loop:
        	addi $t0, $t0, -1 
        	bnez $t0, delay_loop # branch to delay_loop
        	jr $ra            # Retorna
	
	
end:

