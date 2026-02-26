% Assignment 4 - Erlang Processes Program
% Team Members: Tanner Macpherson

-module(chain).
-export([start/0, serv1/1, serv2/1, serv3/1]).

% Main start function - spawns the 3 servers and starts input loop

start() ->
    Serv3 = spawn(chain, serv3, [0]),        % start serv3 with count = 0
    Serv2 = spawn(chain, serv2, [Serv3]),
    Serv1 = spawn(chain, serv1, [Serv2]),
    io:format("(main) Servers started.~n"),
    input_loop(Serv1).

input_loop(Serv1) ->
    io:format("(main) Enter message (or 'all_done' to quit): "),
    {ok, [Input]} = io:fread("", "~p"),
    case Input of
        all_done ->
            Serv1 ! halt,
            io:format("(main) all_done received. Exiting.~n"),
            ok;
        _ ->
            Serv1 ! Input,
            input_loop(Serv1)
    end.

% Server 1 - handles arithmetic operations

serv1(Next) ->
    receive
        halt ->
            Next ! halt,
            io:format("(serv1) Halting.~n"),
            ok;

        % arithmetic operations
        {add, A, B} ->
            R = A + B,
            io:format("(serv1) add ~p + ~p = ~p~n", [A,B,R]),
            serv1(Next);

        {sub, A, B} ->
            R = A - B,
            io:format("(serv1) sub ~p - ~p = ~p~n", [A,B,R]),
            serv1(Next);

        {mult, A, B} ->
            R = A * B,
            io:format("(serv1) mult ~p * ~p = ~p~n", [A,B,R]),
            serv1(Next);

        {'div', A, B} ->
            R = A / B,
            io:format("(serv1) div ~p / ~p = ~p~n", [A,B,R]),
            serv1(Next);

        {neg, A} ->
            R = -A,
            io:format("(serv1) neg ~p = ~p~n", [A,R]),
            serv1(Next);

        {sqrt, A} ->
            R = math:sqrt(A),
            io:format("(serv1) sqrt ~p = ~p~n", [A,R]),
            serv1(Next);

        % forward to next server if not handled
        Msg ->
            Next ! Msg,
            serv1(Next)
    end.

% Server 2 - handles lists

serv2(Next) ->
    receive
        halt ->
            Next ! halt,
            io:format("(serv2) Halting.~n"),
            ok;

        % check if message is a list with a number as head
        L when is_list(L) andalso L =/= [] ->
            [H|_] = L,
            case is_number(H) of
                true ->
                    Numbers = [X || X <- L, is_number(X)],
                    case is_integer(H) of
                        true ->
                            Sum = lists:sum(Numbers),
                            io:format("(serv2) Integer head, sum = ~p~n", [Sum]);
                        false ->
                            Prod = lists:foldl(fun(X,Acc)-> X*Acc end, 1, Numbers),
                            io:format("(serv2) Float head, product = ~p~n", [Prod])
                    end,
                    serv2(Next);
                false ->
                    Next ! L,
                    serv2(Next)
            end;

        % forward to serv3
        Msg ->
            Next ! Msg,
            serv2(Next)
    end.

% Server 3 - handles errors and counts unprocessed messages

serv3(Count) ->
    receive
        halt ->
            io:format("(serv3) Unprocessed count = ~p~n", [Count]),
            io:format("(serv3) Halting.~n"),
            ok;

        {error, Msg} ->
            io:format("(serv3) Error: ~p~n", [Msg]),
            serv3(Count);

        Msg ->
            io:format("(serv3) Not handled: ~p~n", [Msg]),
            serv3(Count + 1)
    end.
