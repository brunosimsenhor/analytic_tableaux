Definitions.
Rules.
%% a lowercase character representing a simple proposition
[a-zA-Z\_0-9]+ : {token, {proposition, TokenLine, TokenChars}}.
%% open/close parentheses
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.
%% logic operators
\! : {token, {'negation', TokenLine}}.
\| : {token, {'disjunction', TokenLine}}.
\& : {token, {'conjunction', TokenLine}}.
\-> : {token, {'conditional', TokenLine}}.
%% white space
[\s\n\r\t]+ : skip_token.
%%
Erlang code.
