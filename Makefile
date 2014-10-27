all:compile

web:compile
	erl -noshell -pa deps/cowboy/ebin \
		-pa deps/cowlib/ebin \
		-pa deps/mochiweb/ebin \
		-pa deps/ranch/ebin \
		-pa ebin \
		-mnesia dir db/mom.data \
		-s msg_app start_web

init-database:compile
	erl -noshell \
		-pa ebin \
		-mnesia dir '"database"' \
		-s db_init do_this_once

compile:	
	rebar get-deps
	rebar clean
	rebar compile