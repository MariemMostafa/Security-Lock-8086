
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt




 include 'emu8086.inc'
.MODEL SMALL 
.STACK 100H 
.data            
            
STRING1 DB 'Please enter your identification number', '$'
STRING2 DB 'Please enter your password', '$'          
STRING3 DB 'Please enter a correct identification number', '$'  
STRING4 DB 'Access denied! Please enter a correct password ', '$' 
STRING5 DB 'Allowed ', '$' 
identification_number DW ?   
password DB ? 
id DW 1111,2222,3333,4444,5555,6666,7777,8888,9999,1000,2000,3000,4000,5000,6000,7000,8000,9000,1010,2020
pw DB 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,1,2,3,4
x  DW -1


code segment 


start:
 
    ;set segment registers
    mov ax, @data
    mov ds, ax  
    mov es,ax
    
    
    lea dx, STRING1     ; load address of the STRING1 
    mov ah, 09h         ;output of a string at DS:DX
    int 21h     

    printn              ;new line
    
    ;get identification number          
    call scan_num
    mov identification_number,cx   
    mov ax,cx
    mov cx,0h 
        
    CALL   print_num  
    
    ; Check if the ID exists or not
    call CHECKID
       
    ;interrupt to exit
    mov ah,4ch
    int 21h   
        


;------------------------------------------------
CHECKID proc  
    mov x,-1          ;initialize the index
    mov cx,20         ;set loop counter 
    lea di,id         ;load effective address of id in di  
 j1:inc x             ;increment the index
    cmp ax,[di]       ;Check if the ID exists or not 
    jz  INSERTPW      ;if z=1(found the id) jump to insertpw
    add di,2          ;increment di by 2 (id 2 bytes)
    loop j1           ;loop until cx=0
    jnz WRONGID       ;if z=0(didnt find the id) jump to wrongid     
    
     printn
ret
ENDP    
     
;------------------------------------------------     
WRONGID proc 
    
     printn
    
    lea dx, STRING3 
    mov ah, 09h
    int 21h      
    
    printn
              
    call scan_num
    mov identification_number,cx   
    mov ax,cx
    ;mov cx,0h 
    
    call CHECKID 
ret         
ENDP                          

;------------------------------------------------  
 INSERTPW proc
    
   printn
    
    lea dx, STRING2   
    mov ah, 09h
    int 21h     
    
    printn  
    
    ;get password from user
    call scan_num
    mov password,cl
    mov al,cl   

    call MATCH
    
ret
ENDP 
 
   

;------------------------------------------------  
                                                   
MATCH proc
    
   printn
    
   mov di,x            ;copy index to di
   cmp al,pw[di]       ;compare input with the correct pw
   jnz WRONGPW         ;if input is not matching its corresponding id jump to WRONGPW
   
   lea dx, STRING5   
   mov ah, 09h
   int 21h      
    
    
ret         
ENDP   

;------------------------------------------------     
WRONGPW proc 
    
    printn
    
    lea dx, STRING4 
    mov ah, 09h      
    int 21h      
    
    printn
              
    call scan_num
    mov offset password,cx   
    mov ax,cx
    ;mov cx,0h 

       
    call MATCH
    
ret         
ENDP                    
;-----------------------------------------------

DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS     

end start
ends






