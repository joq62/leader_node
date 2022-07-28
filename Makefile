all:
	rm -rf  *~ */*~  src/*.beam test/*.beam erl_cra*;
	rm -rf _build test_ebin ebin;		
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs;
	git add -f *;
	git commit -m $(m);
	git push;
	echo Ok there you go!
check:
	rebar3 check
eunit:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs;
	rm -rf rebar.lock;
	rm -rf ebin;
	mkdir ebin;
	rebar3 compile;
	cp _build/default/lib/*/ebin/* ebin;
#	testing
	mkdir test_ebin;
	erlc -o test_ebin test/*.erl;
	erl -pa * -pa ebin -pa test_ebin\
	   -setcookie test_cookie\
	   -sname leader_node_test -run leader_node_eunit start
