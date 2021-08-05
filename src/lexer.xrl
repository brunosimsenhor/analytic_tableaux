Definitions.
Rules.
%% a lowercase character representing a simple proposition
[a-z] : {token, {proposition, TokenLine, TokenChars}}.
%% open/close parentheses
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.
%% logic operators
\! : {token, {'not', TokenLine}}.
\| : {token, {'or', TokenLine}}.
\& : {token, {'and', TokenLine}}.
\-> : {token, {'implies', TokenLine}}.
%% white space
[\s\n\r\t]+ : skip_token.
%%
Erlang code.
