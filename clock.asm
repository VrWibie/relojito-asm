page 60, 132
title Relojito en ensamblador
.model small
.stack 68; 68 bytes
;----------------------
.data
    ubicacion db 'AquiToy'
    tiempo db 'HH:MM:SS:CS','$'; es una cadena de 11 bytes
    tiempoNum db 00h,00h,00h,00h
    diez db 10 ;Constante para la division de conversion
     
 ;---------------------
.code
    ;Resolviendo el segmento de datos
    mov ax, @data
    mov ds, ax
    mov es, ax

    ;obteniendo el tiempo del sistema
    mov ah,02ch
    int 21h;imprime tiempo con INT 21H con opcion 2Ch
    
    mov tiempoNum,ch; tiempoNum [0]= horas
    mov tiempoNum+1,cl; tiempoNum[1]= minutos
    mov tiempoNum+2,dh; tiempoNum[2]=segundos
    mov tiempoNum+3,dl; tiempoNum[3]=centesimas

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

    ;Ubicamos el cursor para imprimir el relojito
    ;primero posicionamos el cursor en el centro
    mov ah,02h
    mov dh,12d; fila 12
    mov dl, 35d; columna 35
    mov bh,00; numero de pagina
    int 10h 

    ;Imprimimos la cadena tiempo blanco y negro en el centro
    mov dx, offset tiempo
    mov ah,09h
    int 21h
    
    ;Finalizamos el programa
    mov ah, 4ch
    mov al, 0h
    int 21h
    

    

