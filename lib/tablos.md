
LINEAR RULES
T &
F |
F ->
T !
F !

RAMO
APLICA LR
RAMO


BRANCHING RULES
F &
T |
T ->

RAMO
APLICA BR
2 RAMOS

Não há mais BRs a aplicar,
e o tablô não está fechado
-> 
O ramo atual é aberto e saturado
-> 
O tablô está aberto.


CLOSING RULE
T A
F A
x

RAMO
APLICA CR
RAMO FECHADO
-> IR PROCURAR UM RAMO ABERTO

IR PROCURAR RAMO ABERTO
SE ACHAR MAIS DE UM,  ESCOLHE UM
SE NÃO ACHAR, O TABLÔ ESTÁ FECHADO 

O que fazer em todo ramo:
- aplicar todas as lineares possíveis
- verificar se fechou
- se não fechou, escolher UMA que bifurca e aplicar 

!!p, (p&q)->r |- !!r

p, (p&q)->r |- r

(I)
T p
T (p&q)->r
F r

(LI)
F p&q

(LLI)
F p
x

(RLI)
F q
o

(RI)
T r
x
