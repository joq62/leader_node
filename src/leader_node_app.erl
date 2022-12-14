%%%-------------------------------------------------------------------
%% @doc leader_node public API
%% @end
%%%-------------------------------------------------------------------

-module(leader_node_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    leader_node_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
