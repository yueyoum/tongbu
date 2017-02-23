%%% @author: Wang Chao <yueyoum@gmail.com>
%%% @doc
%%%
%%% @end
%%% Date created: 2017-02-22 13:50:22

-module(ws_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->
    {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
    %% erlang:start_timer(1000, self(), <<"Hello!">>),
    io:format("new connection!~n", []),
    {ok, State}.

websocket_handle({text, Msg}, State) ->
    Req = jiffy:decode(Msg, [return_maps]),
    io:format("DATA: ~p~n", [Req]),
    io:format("MS: ~p~n", [get_timestamp_ms()]),
    Reply = reply(Req),

    {reply, {text, Reply}, State};

websocket_handle(_Data, State) ->
    {ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
    erlang:start_timer(1000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, State};

websocket_info(_Info, State) ->
    {ok, State}.


%% ====
reply(#{<<"act">> := 1} = Req) ->
    % ping
    Req1 = Req#{ <<"server">> => get_timestamp_ms() },
    jiffy:encode(Req1);

reply(#{<<"act">> := 2} = Req) ->
    % report
    jiffy:encode(Req).

get_timestamp_ms() ->
    {M, S, Ms} = os:timestamp(),
    M * 1000000000 + S * 1000 + Ms div 1000.


