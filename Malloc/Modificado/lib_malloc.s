.section .data
    .global original_brk
    original_brk: .quad 0                           #Variavel global para o valor de brk inicial
    atual_brk: .quad 0                              #Variavel global para o valor atual de brk

.section .text
.global setup_brk, dismiss_brk
.global memory_alloc, memory_free


setup_brk:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rdi
    movq $12, %rax
    syscall
    movq %rax, original_brk
    movq %rax, atual_brk
    popq %rbp
    ret



dismiss_brk:
    pushq %rbp
    movq %rsp, %rbp
    movq original_brk, %rdi
    movq %rdi, atual_brk
    movq $12, %rax
    syscall
    popq %rbp
    ret



memory_alloc:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r12                                      #calee save
    pushq %r13                                      #calee save
    movq original_brk, %r12                         #%r12 = endereco da maior memoria alocada livre, inicia com original_brk
    cmp %r12, atual_brk                             #Verifica se a heap esta vazia, se atual_brk == %r12
    je abre_memoria
    movq $99999999999999999, %r13                   #%r13 = tamanho da maior memoria alocada livre, inicia com um tamanho arbitrario muito grande
    movq original_brk, %r10                         #%r10 = iterador
  procura_maior_memoria_livre:                      #Coloca o endereco da maior memoria livre >= que a requisitada em %r12 e seu tamanho em %r13
    cmp atual_brk, %r10                             #Verifica se o iterador chegou no fim da heap e termina o laco caso verdade
    je fragmenta_memoria
    addq $9, %r10
    movb -9(%r10), %bl
    cmpb $1, %bl                                    #Verifica se a memoria apontada por %r10 esta livre
    je incremento
    movq -8(%r10), %r11                             #%r11 = tamanho da memoria apontada por %r10
    cmp %rdi, %r11                                  #verifica se o tamanho da memoria apontada por %r10 >= a memoria solicitada
    jl incremento
    cmp %r13, %r11                                  #Verifica se o tamanho da memoria apontada por %r10 <= %r13, caso verdade
    jg incremento                                   #coloca o tamanho da memoria apontada por %r10 em %r13 e copia %r10 para %r12
    movq %r10, %r12
    movq %r11, %r13
  incremento:                                       #Move o iterador (%r10) para o proximo endereco
    movq -8(%r10), %r9
    addq %r9, %r10
    jmp procura_maior_memoria_livre
  fragmenta_memoria:                                #Se a diferenca do tamanho da memoria apontada por %r12 e o tamanho da memoria solicitada
    cmp original_brk, %r12                          #for maior ou igual a 10 bytes particiona a memoria em duas, a primeira apontada por %r12
    je abre_memoria                                 #com o tamanho solicitado e a segunda logo abaixo com a diferenca de tamanho -9 bytes do
    movq %r13, %r9                                  #novo registro inserido
    subq %rdi, %r9                                  #Ordem certa? %r9 = %r9 - %rdi?
    cmp $10, %r9
    jl fim
    movq %r12, %r10
    addq %rdi, %r10                                 
    addq $9, %r10
    subq $9, %r9
    movb $0, -9(%r10)
    movq %r9, -8(%r10)
    movq %rdi, %r13
    jmp fim
  abre_memoria:                                     #Caso a heap esteja vazia ou nao se tenha encontrado nenhuma memoria livre ou com o
    addq $9, atual_brk                              #tamanho solicitado, chama o SO para abrir uma nova memoria livre com o tamanho solicitado
    movq atual_brk, %r12
    addq %rdi, atual_brk
    movq %rdi, %r13
    movq atual_brk, %rdi
    movq $12, %rax
    syscall
  fim:
    movq %r12, %rax                                 #coloca o endereco da memoria alocada no registrador de retorno
    movb $1, -9(%r12)                               #coloca 1 no registro, indicando que a memoria esta em uso
    movq %r13, -8(%r12)                             #coloca o tamanho da memoria alocada no registro
    popq %r13                                       #calee save
    popq %r12                                       #calee save
    popq %rbp
    ret



memory_free:
    pushq %rbp
    movq %rsp, %rbp
    cmp atual_brk, %rdi                             #Verifica se a memoria apontada por %rdi esta em area util, se nao retona 0
    jge erro
    movb -9(%rdi), %bl
    cmpb $0, %bl                                    #Verifica se a memoria apontada por %rdi ja foi liberada, se sim retorna 0
    je erro
    movb $0, -9(%rdi)                               #Marca que a memoria apontada por %rdi esta livre para uso/realocacao e retona 1
    movq $1, %rax
    jmp devolve
  erro:
    mov $0, %rax
  devolve:
    popq %rbp
    ret
