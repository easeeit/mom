deps = -pa deps/cowboy/ebin \
	-pa deps/cowlib/ebin \
	-pa deps/mochiweb/ebin \
	-pa deps/ranch/ebin \
	-pa ebin

dbpath = -mnesia dir '"database"'

baseCommand = erl -noshell $(deps) $(dbpath)

all:compile

#no program start
cmd:compile
	erl $(deps) $(dbpath)

#start socket server
socket:compile
	$(baseCommand) -s socket_server start

ss:compile
	$(baseCommand) -detached +P 500000 -s socket_server start

#start web server
web:compile
	erl $(deps) $(dbpath) -s msg_app start_web

#init database tables
init-database:compile
	$(baseCommand) -s db_init do_this_once

#only compile all program
compile:	
	rebar clean get-deps compile