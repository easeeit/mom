all:compile

web:compile
	erl -noshell -pa deps/cowboy/ebin \
		-pa deps/cowlib/ebin \
		-pa deps/mochiweb/ebin \
		-pa deps/ranch/ebin \
		-pa ebin \
		-s msg_app start_web

compile:	
	rebar get-deps
	rebar clean
	rebar compile