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
    Nodes=test_nodes:get_nodes(),
    [N0,N1,N2,N3,N4,N5]=Nodes,  

    NodeNames=test_nodes:get_nodenames(),
    [NN0,NN1,NN2,NN3,NN4,NN5]=NodeNames,
    ok=start_leader(Nodes,Nodes),
    timer:sleep(4000),
   % shutdown_ok=rpc:call(c_0@c100,leader_server,stop,[],1000),
   % timer:sleep(2000),
    N0=rpc:call(N5,leader_server,who_is_leader,[],200),
    rpc:cast(N0,init,stop,[]),
    timer:sleep(2000),  
    N1=rpc:call(N5,leader_server,who_is_leader,[],200),
    {ok,N0}=start_slave(NN0),
    ok=start_leader([N0],Nodes),
    timer:sleep(2000),  
    N0=rpc:call(N5,leader_server,who_is_leader,[],200),

    init:stop(),
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
    NodeNames=test_nodes:get_nodenames(),
 %   ok=test_nodes:start_nodes(),
    Nodes=test_nodes:get_nodes(),
%    ['controller_0@c100','controller_1@c100','controller_2@c100','controller_3@c100','controller_4@c100']=Nodes,
    ['c_0@c100','c_1@c100','c_2@c100','c_3@c100','c_4@c100','c_5@c100']=Nodes,
    % Starts config and leader on all nodes

    
    R=[start_slave(NodeName)||NodeName<-NodeNames],
    io:format("Stared nodes ~p~n",[R]),
    
    ok.

start_slave(NodeName)->
    Pargs="-pa ebin -pa /home/joq62/erlang/infrastructure/sd/ebin",
    {ok,Node}=test_nodes:start_slave(NodeName,Pargs),
    {rpc:call(Node,application,start,[sd],1000),Node}.
    
