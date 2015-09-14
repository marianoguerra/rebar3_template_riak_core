BASEDIR = $(shell pwd)
REBAR = $(shell pwd)/rebar3
RELPATH = _build/default/rel/{{ name }}
APPNAME = {{ name }}

release:
	$(REBAR) release

compile:
	$(REBAR) compile

clean:
	$(REBAR) clean

test:
	$(REBAR) ct

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

console:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) console

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

