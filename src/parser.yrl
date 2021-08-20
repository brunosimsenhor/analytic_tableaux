Nonterminals predicate premise.
Terminals proposition 'negation' 'disjunction' 'conjunction' 'conditional' '(' ')'.
Rootsymbol predicate.

Left 100 'disjunction' 'conjunction' 'conditional'.
Unary 200 'negation'. 

predicate -> premise 'conditional' predicate : {'conditional', '$1', '$3'}.
predicate -> premise 'conjunction' predicate : {'conjunction', '$1', '$3'}.
predicate -> premise 'disjunction' predicate : {'disjunction', '$1', '$3'}.
predicate -> premise : '$1'.

premise -> '(' predicate ')' : '$2'.
premise -> 'negation' predicate : {'negation', '$2'}.
premise -> proposition : {'proposition', unwrap('$1')}.

Erlang code.

unwrap({_,_,V}) -> V.
