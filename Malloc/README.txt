Nicolas Costa da Silva - GRR:20221228
Eduardo Giehl - GRR:20221222

Implementaçâo de uma biblioteca memory_alloc, simplificada, em Assembly-AMD64 seguindo a estratégia worst_fit,
utilizando registro de 9 bytes, 1 byte de verificação e 8 bytes informando o tamanho da memória corespondente ao registro.

De Inicio conversamos e chegamos no concenso não fazer a tradução direta de um malloc em C por nós criado, assim indo direto para a implementação em Assembly-AMD64.
Usamos como método de estudo as aulas disponiveis no moodle, e como base os arquivos disponibilizados no corpo do trabalho.


Registradores usados:
    %r12 e %r13:
        Endereço e tamanho da memória a ser retornada respectivamente, usado para preservar os parâmetros após a chamada do SO           (callee save)

    %r9, %r10 e %r11:
        Variável auxiliar, iterador de endereços de memória e tamanho da memória apontada pelo iterador respectivamente

    %rdi e %rax:
        Argumento e retorno de funções respectivamente

    %bl:
        Para armazenamento e teste de 1 byte de verificação

    %rbp e %rsp:
        Movimentação da pilha


Variáveis globais usadas:
   original_brk:
        Variável global para o valor de brk inicial

    atual_brk:
        Variável global para o valor atual de brk

Enfrentamos dificulades na implementação para pensar em como iriamos desenvolver a lógica do nosso malloc, uma vez isso definido foi praticamente quebrar a cabeça escrevendo o código.

Aprendemos muito com esse trabalho, principalmente sobre heap, e foi muito divertido desenvolver uma ferramenta de gerênciamento de memória tão usada por todos nós :)
