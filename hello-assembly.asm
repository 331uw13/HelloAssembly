; ---------
; - very simple useless login thing
; Date: Fri Oct 30 2020
; ---------

global _start

section .text
_start:
	mov rsi, msg2
	call write
	call run
	call exit
exit:
	mov rax, 60
	mov rdi, 0
	syscall
exit2:
	mov rsi, msg4
	call write
	jmp exit
run: 
	cmp r10, 3				
	je exit2				; if enter username 3 times then print message and exit
	mov rsi, msg3
	call write
	mov rax, 0				; use read syscall
	mov rdi, 0				; stdin
	mov rsi, input			; save it to input
	mov rdx, 20				; max length
	syscall
	mov rdi, user
	call length				; get length of good username ("admin")
	mov rcx, rax
	add rcx, 1
	mov rdi, input
	call length
	mov rdx, rax
	mov rsi, user
	mov rdi, input
	cmp rcx, rdx
	jne wrong_input			; if input length is not user's ("admin") length then it cant be right
	repe cmpsb				; loop through input, decrease rcx and compare bytes
	jecxz login_ok			; and finally if rcx is 0 we know that everything is ok
	jmp wrong_input			; rcx didnt go to 0 then input is wrong
wrong_input:
	mov rsi, msg1
	call write
	add r10, 1
	jmp run
length:
	push rcx
	xor rcx, rcx
_loop:
	cmp [rdi], byte 0x0
	jz _break
	inc rdi
	inc rcx
	jmp _loop
_break:
	mov rax, rcx
	pop rcx
	ret
login_ok:
	mov rsi, msg0
	call write
	ret
write:
	mov rdi, rsi
	call length				; need message length
	mov rdx, rax
	mov rax, 1				; use write syscall
	mov rdi, 1				; stdout
	syscall
	ret

section .data
	msg0 db "+ ok!", 0xA, 0x0
	msg1 db "- try again", 0xA, 0x0
	msg2 db "Welcome to the very secure useless login thing. please give your username to login!", 0xA, 0x0
	msg3 db "user: ", 0x0
	msg4 db "too many attempts.", 0xA, 0x0
	user db "admin", 0x0
	testmsg db "test", 0xA, 0x0

section .bss
	input resb 20			; create space for input





