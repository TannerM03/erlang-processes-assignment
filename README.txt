Assignment 4: Erlang Processes Program
Team Member: Tanner Macpherson

How to Run:
-----------
1. Compile: c(chain).
2. Start: chain:start().
3. Enter messages when prompted
4. Type all_done to quit

What Each Server Does:
----------------------
Server 1: Handles math operations like {add, 5, 3}, {sqrt, 16}, etc.
Server 2: Handles lists. If first element is integer, sums the list. If float, multiplies.
Server 3: Catches everything else and keeps count of unhandled messages.

Example Messages to Try:
------------------------
{add, 10, 5}
{sqrt, 64}
[1, 2, 3, 4]
[2.5, 4.0, 1.5]
{error, "test"}
random_atom
all_done

Notes:
------
- Had to use 'div' in quotes because div is a reserved word in Erlang
- All servers pass the halt message down the chain before shutting down
- Server 3 prints the total count of unhandled messages when it halts
