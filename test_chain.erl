%%% Test script for chain.erl
-module(test_chain).
-export([run_tests/0]).

run_tests() ->
    io:format("~n=== Starting Chain Server Tests ===~n~n"),

    % Start the chain servers
    Serv3 = spawn(chain, serv3, [0]),
    Serv2 = spawn(chain, serv2, [Serv3]),
    Serv1 = spawn(chain, serv1, [Serv2]),

    io:format("Servers started~n~n"),

    % Test serv1 - arithmetic operations
    io:format("--- Testing Server 1 (Arithmetic) ---~n"),
    Serv1 ! {add, 10, 5},
    timer:sleep(100),

    Serv1 ! {sub, 20, 7},
    timer:sleep(100),

    Serv1 ! {mult, 6, 7},
    timer:sleep(100),

    Serv1 ! {'div', 100, 4},
    timer:sleep(100),

    Serv1 ! {neg, 42},
    timer:sleep(100),

    Serv1 ! {sqrt, 64},
    timer:sleep(100),

    % Test serv2 - list operations
    io:format("~n--- Testing Server 2 (Lists) ---~n"),
    Serv1 ! [1, 2, 3, 4, 5],
    timer:sleep(100),

    Serv1 ! [2.5, 4.0, 1.5],
    timer:sleep(100),

    Serv1 ! [1, atom, 2, 3, hello],
    timer:sleep(100),

    % Test serv3 - error handling and unhandled messages
    io:format("~n--- Testing Server 3 (Errors and Unhandled) ---~n"),
    Serv1 ! {error, "Test error message"},
    timer:sleep(100),

    Serv1 ! unhandled_atom,
    timer:sleep(100),

    Serv1 ! {unknown, tuple, with, stuff},
    timer:sleep(100),

    Serv1 ! "string message",
    timer:sleep(100),

    % Test halt
    io:format("~n--- Testing Halt ---~n"),
    Serv1 ! halt,
    timer:sleep(200),

    io:format("~n=== Tests Complete ===~n~n").
