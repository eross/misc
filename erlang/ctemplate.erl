-module(ctemplate).
-compile(export_all).

start() ->
    spawn(?MODULE, loop, []).

rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
	{Pid, Response} ->
	    Response
    end.

loop() ->
    receive
	{From, Args} ->
	    io:format("Received: ~p~n",[Args]),
	    From ! {self(),0},
	    loop()
    end.


