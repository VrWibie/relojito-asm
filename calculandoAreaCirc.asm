page 60, 132
title Calculando el área de un círculo
.model small
.stack 64; 64 bytes
;--------------------------------------------------------
.data
    otro db 'aqui'
    data9 dd 2.45E+5
    otro1 dt 12365.589 ;se declara flotante en 10 bytes
    area dq 10
    Radio dd 2.0
;--------------------------------------------------------
.code
areas proc far
    mov ax,@data
    mov ds,ax
    mov es,ax

    fld radio; carga el radio de 2.0 como flotante a st(0)
    fmul st,st(0); radio al cuadrado es st(0)=2.0*2.0=4.0
    fldpi; empuja a pi a la pila entonces st(0)=pi y st(1)=4.0
    fmul; multiplicar st(0)=st(1)*st(2)=PI*4.0
    fstp area; guarda el resultado en la variable área y lo saca de la pila    fwait;espera a que el coprocesador termine la tarea
    mov ax,4C00h
    int 21h; termina el proceso
areas endp
      end areas