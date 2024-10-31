#ifndef LIB_MALLOC
#define LIB_MALLOC

#include <stdio.h>

//Obtém o endereço de brk
void setup_brk();

//Restaura o endereço de brk
void dismiss_brk();

//Procura bloco livre com tamanho igual ou maior que a requisição
//Se encontrar, marca ocupação, utiliza os bytes necessários do
//bloco, retornando o endereço correspondente
//Se não encontrar, abre espaço para um novo bloco
void* memory_alloc(unsigned long int bytes);

//Marca um bloco ocupado como livre
int memory_free(void *pointer);

#endif
