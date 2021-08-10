Nonterminals predicate premise.
Terminals proposition 'not' 'or' 'and' 'implies' '(' ')'.
Rootsymbol predicate.

Left 100 'or' 'and' 'implies'.
Unary 200 'not'. 

predicate -> premise 'implies' predicate : {'implies', '$1', '$3'}.
predicate -> premise 'and' predicate : {'and', '$1', '$3'}.
predicate -> premise 'or' predicate : {'or', '$1', '$3'}.
predicate -> premise : '$1'.

premise -> '(' predicate ')' : '$2'.
premise -> 'not' predicate : {'not', '$2'}.
premise -> proposition : {'simple', unwrap('$1')}.

Erlang code.

unwrap({_,_,V}) -> V.
