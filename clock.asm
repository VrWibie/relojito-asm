page 60, 132
title Relojito en ensamblador; nombre del programa
.model small; modelo de memoria pequeño
.stack 68; 68 bytes
;----------------------
.data
    ubicacion db 'AquiToy'
    tiempo db 'HH:MM:SS:CS','$'; es una cadena de 11 bytes
    tiempoNum db 00h,00h,00h,00h
    diez db 10 ;Constante para la division de conversion
    varTemp db 00h;
 ;---------------------
.code
main proc
    call Datasegment
    call clrscr
    call hidecursor
    call animaRelojito
    call creaMarco
    call terminarPrograma
    
main endp
Datasegment proc
    ;Resolviendo el segmento de datos
    mov ax, @data
    mov ds, ax
    mov es, ax
    ret
Datasegment endp

clrscr proc
    ;limpiamos la pantalla
    mov AH,0FH	; obtiene modo de video actual en AL
	int 10H
	mov AH,0	; reestablece el modo, limpia pantalla
	int 10H
    ret
clrscr endp

hidecursor proc
    ;ocultamos cursor
    mov ah,01h
	mov cx,02607h
	int 10h 
    ret
hidecursor endp 

creatTime proc
    ;obteniendo el tiempo del sistema
    mov ah,02ch
    int 21h;imprime tiempo con INT 21H con opcion 2Ch
    
    mov tiempoNum,ch; tiempoNum [0]= horas
    mov tiempoNum+1,cl; tiempoNum[1]= minutos
    mov tiempoNum+2,dh; tiempoNum[2]=segundos
    mov tiempoNum+3,dl; tiempoNum[3]=centesimas
    ret
creatTime endp

num2char proc
    ;imprimir por pantalla el reloj
    ;debemos poner el arrglo tiempoNum en la cadenaReloj
    mov bx, offset tiempoNum; apuntador al arreglo tiempoNum
    mov si, offset tiempo; apuntador a la cadena tiempo
    ;convirtiendo de decimal a ASCII
    mov cx,4; va para horas, minutos, segundos y centesimas (4 iteraciones)
construye:
    xor ax,ax
    mov al,[bx]; al=valor actual
    mov dl,diez; dl=10
    div dl; division de al/dl nos da al=cociente(decenas) y
          ; ah=residuo(unidades)
    xor ax,3030h; sumamos 3030h a ax, lo que nos convierte al y ah
               ; en ASCII
    mov [si],ax;Escribe los dos caracteres ASCII en la posicion
               ; actual
    inc bx
    add si,3; avanza 3(2 digitos y el separador ':')
    loop construye
    ret
num2char endp

gotoxy proc
    push bp
    mov bp,sp; ponemos como ancla bp en la cima de la pila bp+0=sp
    mov dx,[bp+4]; dx=[bp+4],dx toma el valor que se le paso como parámetro
               ;que fue el registro dx igualmente
               ;bp queda fijo, el offset hace el trabajo
    ;teniendo el valor tanto de la fila como la columna exacta ahora si
    ; hacemos la interrupción para ubicar el cursor
    mov ah,02h; posicionamos el cursor
    ; con dx en dh=fila y dl=columna
    int 10h
    pop bp; restauramos el bp real
    ret 2; regresa el caller y limpia a DX de la pila
gotoxy endp

cursorCentro proc
    ;primero posicionamos el cursor en el centro
    mov dh,12d; fila 12
    mov dl, 35d; columna 35
    push dx; metemos dx en la pila
    call gotoxy
    ret
cursorCentro endp

imprimeCadV1 proc
    ;Imprimimos la cadena tiempo blanco y negro 
    mov dx, offset tiempo
    mov ah,09h
    int 21h
    ret
imprimeCadV1 endp

animaRelojito proc  
    anima:
    call creatTime
    call num2char
    call cursorCentro
    call imprimeCadV1
    call creaMarco
    
    mov ah,01h
    int 16h;ZF=1 si no hay tecla presionada
           ;ZF=0 si hay tecla presionada
    jz anima

    mov ah,00h
    int 16h
    cmp al,1Bh;1Bh es el ASCII de ESC, con ESC saldremos del bucle
    jne anima
    ret
animaRelojito endp

creaMarco proc
    ;nos posicionamos en donde queremos la parte superior del marco
    mov dh,04d; fila 4
    mov dl,30d; columna 30
    push dx
    call gotoxy

    ;ahora si hacemos la interrupcion para imprimir el marco

    ;esquina superior izquierda
    mov ah,09h
	mov al,0C9h;Es el código ASCII de la esquina en decimal 201 (╔)
    mov bh,00h; número de página
    mov bl,0Fh; fondo negro fuente blanca brillante
    mov cx,1; solo lo imprimimos una vez
    int 10h; interrupcion de la BIOS
    
    ;esquina superior derecha
    mov dh,04d; fila 4
    mov dl,51d; columna 51
    push dx
    call gotoxy
    mov ah,09h
	mov al,0BBh;Es el código ASCII de la esquina superior derecha en decimal 187 (╗) 
    mov bh,00h; número de página
    mov bl,0Fh; fondo negro fuente blanca brillante
    mov cx,1; solo lo imprimimos una vez
    int 10h; interrupcion de la BIOS

    ;esquina inferior izquierda
    mov dh,20d; fila 20
    mov dl,30d; columna 30
    push dx
    call gotoxy
    mov ah,09h
	mov al,0C8h;Es el código ASCII de la esquina en inferior izquierda en decimal  200 (╚)
    mov bh,00h; número de página
    mov bl,0Fh; fondo negro fuente blanca brillante
    mov cx,1; solo lo imprimimos una vez
    int 10h; interrupcion de la BIOS

    ;esquina inferior derecha
    mov dh,20d; fila 20
    mov dl,51d; columna 30
    push dx
    call gotoxy
    mov ah,09h
	mov al,0BCh;Es el código ASCII de la esquina en inferior derecha en decimal  188 (╝)
    mov bh,00h; número de página
    mov bl,0Fh; fondo negro fuente blanca brillante
    mov cx,1; solo lo imprimimos una vez
    int 10h; interrupcion de la BIOS

    mov dh,04d;fila 4 (solo se moverá la fila la columna es la misma)
ladoH:;línea horizontal
    mov  dl,31d; columna 31
    push dx
    call gotoxy

    mov ah,09h
	mov al,0CDh;Es el código ASCII de la linea horizontal 205 (═══)
    mov bh,00h; número de página
    mov bl,0Fh; fondo negro fuente blanca brillante
    mov cx,20; imprimimos 20 veces el caracter
    int 10h; interrupcion de la BIOS
    cmp dh,04d;
    mov dh,20d; nos movemos al lado horizontal de abajo
    je ladoH
    
  mov dh, 05d
ladoV:
    push dx          ; guarda DX antes de los calls

    mov dl, 030d     ; lado izquierdo
    push dx
    call gotoxy
    mov ah,09h
    mov al,0BAh
    mov bh,00h
    mov bl,0Fh
    mov cx,01
    int 10h

    mov dl, 051d     ; lado derecho
    push dx
    call gotoxy
    mov ah,09h
    mov al,0BAh
    mov bh,00h
    mov bl,0Fh
    mov cx,01
    int 10h

    pop dx           ; recupera DX original
    inc dh
    cmp dh, 20d
    jl ladoV
    ret
creaMarco endp

imprimeASCII proc
    push bp; metemos el bp viejo
    mov bp,sp;ponemos como ancla bp en la cima de la pila BP+0=sp
    mov al,[bp+6];sera el ASCII en hexa del caracter a imprimir
    mov bl,[bp+5];será el fondo que es dh del push dx
    mov cl,[bp+4];el numero de caracteres a imprimir que es dl del push dx
    mov ah,09h; opcion de la interrupción
    mov bh,00h; número de página
    int 10h; interrupción de la BIOS
    pop bp; restauramos el bp real
    ret 4; push AX(2 bytes) y push DX(2 bytes) 4 bytes en total 
imprimeASCII endp

terminarPrograma proc
    ;Finalizamos el programa
    mov ah, 4ch
    mov al, 0h
    int 21h
    ret
terminarPrograma endp

end main; le dice al linker "cuando el usuario corra el .exe

    

