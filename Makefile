deps = -pa deps/cowboy/ebin \
	-pa deps/cowlib/ebin \
	-pa deps/mochiweb/ebin \
	-pa deps/ranch/ebin \
	-pa ebin

dbpath = -mnesia dir '"database"'

all:compile

#no program start
cmd:compile
	erl $(deps) $(dbpath)

#start socket server
socket:compile
	erl -noshell $(deps) $(dbpath) -s socket_server start

#start web server
web:compile
	erl $(deps) $(dbpath) -s msg_app start_web

#init database tables
init-database:compile
	erl -noshell $(deps) $(dbpath) -s db_init do_this_once

#only compile all program
compile:	
	rebar clean get-deps compile