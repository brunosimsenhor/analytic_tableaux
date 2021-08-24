Definitions.
PROPOSITION = [a-zA-Z\_0-9]+
WHITESPACE  = [\s\n\r\t]

Rules.

%% a lowercase character representing a simple proposition
{PROPOSITION} : {token, {proposition, TokenLine, TokenChars}}.

%% open/close parentheses
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.

%% logic operators
\! : {token, {'negation', TokenLine}}.
\| : {token, {'disjunction', TokenLine}}.
\& : {token, {'conjunction', TokenLine}}.
\-> : {token, {'conditional', TokenLine}}.

%% white space
{WHITESPACE}+ : skip_token.

%%
Erlang code.
