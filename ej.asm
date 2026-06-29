page 60,132
title ejemplo
.model small 
.stack 800h
.data
Numero1 dd 25; numero en formato entero
Numero2 dd 1.25; numero en formato real 
               ;numero que solo puede ser accedido por el coprocesador
Resul dd ? ;variable para el resultado
Desca dd ? ;variable para correccio de pila

.code
Start:
    fild Dword ptr ds:[Numero1]; carga la variable
                            ;Numero 1 al copro
                            ;indicando que es un entero
    fld Dword ptr ds:[Numero2]; lo mismo que la instruccion
                            ;anterior pero con numero real
    fadd st(0),st(1) ;se suman
                    ;st(0)=st(0)+st(1)
    fstp Dword ptr ds:[Resul]; descargar el resultado
    fstp Dword ptr ds:[Desca]; descarta el otro valor
    mov eax,4C00h
    int 21h
    End Start
