%include "rw32-2022.inc"

section .data
   
const1 dd 7.750
const2 dd 2.0

x dd 10.0
y dd 12.0

section .text


CMAIN:
                      ;st0    st1     st2     st3     st4     st5     st6     st7
fld dword [x]           ;x      
fld dword [const2]      ;2     x

FDIVP                 ;x/2    

FLD dword [y]           ;y      x/2
FADDP                 ;y+x/2

FABS                  ;|y+x/2|


fldpi                 ;pi     |y+x/2|
fld dword [x]           ;x      pi     |y+x/2|
fmulp                 ;pi*x   |y+x/2|

fld dword [y]           ;y      pi*x   |y+x/2|
FADDP                 ;y+pi*x |y+x/2|
FCOS                  ;cos(y+pi*x) |y+x/2|

fld dword [const1]      ;7.75   cos(y+pi*x) |y+x/2|
fld dword [y]           ;y      7.75   cos(y+pi*x) |y+x/2|
FADDP                 ;y+7.75 cos(y+pi*x) |y+x/2|
fsqrt                 ;sqrt(y+7.75) cos(y+pi*x) |y+x/2|
FXCH st0, st1        

fsubp          ;cos(y+pi*x)-sqrt(y+7.75) |y+x/2|
FXCH st0, st1        

FDIVP             ;(y+x/2)/(cos(y+pi*x)-sqrt(y+7.75))




ret