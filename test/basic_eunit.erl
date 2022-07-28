%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(basic_eunit).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/logger.hrl").
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=setup(),

 %   init:stop(),
    ok.

start_leader([],_)->
    ok;
start_leader([Node|T],Nodes)->
    ok=rpc:call(Node,application,set_env,[[{leader,[{application_to_track,sd}]}]],5000),
    ok=rpc:call(Node,application,start,[leader],5000),
    start_leader(T,Nodes).
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

setup()->
    ok.
    
   

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

    
leader_init(Node,NodeDir)->
    NodeAppl="leader.spec",
    {ok,ApplId}=db_application_spec:read(name,NodeAppl),
    {ok,ApplVsn}=db_application_spec:read(vsn,NodeAppl),
    {ok,GitPath}=db_application_spec:read(gitpath,NodeAppl),
    {ok,StartCmd}=db_application_spec:read(cmd,NodeAppl),
    
    ok=rpc:call(Node,application,set_env,[[{leader,[{application_to_track,k3}]}]],5000),
    {ok,"leader.spec",_,_}=node:load_start_appl(Node,NodeDir,ApplId,ApplVsn,GitPath,StartCmd),
    pong=rpc:call(Node,leader,ping,[],5000),
    rpc:cast(node(),nodelog,log,[notice,?MODULE_STRING,?LINE,
					{"OK, Started application at  node ",leader," ",Node}]),
    ok.
