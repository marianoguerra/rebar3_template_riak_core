BASEDIR = $(shell pwd)
REBAR = rebar3
RELPATH = _build/default/rel/{{ name }}
PRODRELPATH = _build/prod/rel/{{ name }}
DEV1RELPATH = _build/dev1/rel/{{ name }}
DEV2RELPATH = _build/dev2/rel/{{ name }}
DEV3RELPATH = _build/dev3/rel/{{ name }}
APPNAME = {{ name }}
SHELL = /bin/bash

release:
	$(REBAR) release
	mkdir -p $(RELPATH)/../{{ name }}_config
	[ -f $(RELPATH)/../{{ name }}_config/{{ name }}.conf ] || cp $(RELPATH)/etc/{{ name }}.conf  $(RELPATH)/../{{ name }}_config/{{ name }}.conf
	[ -f $(RELPATH)/../{{ name }}_config/advanced.config ] || cp $(RELPATH)/etc/advanced.config  $(RELPATH)/../{{ name }}_config/advanced.config

console:
	cd $(RELPATH) && ./bin/{{ name }} console

prod-release:
	$(REBAR) as prod release
	mkdir -p $(PRODRELPATH)/../{{ name }}_config
	[ -f $(PRODRELPATH)/../{{ name }}_config/{{ name }}.conf ] || cp $(PRODRELPATH)/etc/{{ name }}.conf  $(PRODRELPATH)/../{{ name }}_config/{{ name }}.conf
	[ -f $(PRODRELPATH)/../{{ name }}_config/advanced.config ] || cp $(PRODRELPATH)/etc/advanced.config  $(PRODRELPATH)/../{{ name }}_config/advanced.config

prod-console:
	cd $(PRODRELPATH) && ./bin/{{ name }} console

compile:
	$(REBAR) compile

clean:
	$(REBAR) clean

test:
	$(REBAR) ct

devrel1:
	$(REBAR) as dev1 release
	mkdir -p $(DEV1RELPATH)/../{{ name }}_config
	[ -f $(DEV1RELPATH)/../{{ name }}_config/{{ name }}.conf ] || cp $(DEV1RELPATH)/etc/{{ name }}.conf  $(DEV1RELPATH)/../{{ name }}_config/{{ name }}.conf
	[ -f $(DEV1RELPATH)/../{{ name }}_config/advanced.config ] || cp $(DEV1RELPATH)/etc/advanced.config  $(DEV1RELPATH)/../{{ name }}_config/advanced.config

devrel2:
	$(REBAR) as dev2 release
	mkdir -p $(DEV2RELPATH)/../{{ name }}_config
	[ -f $(DEV2RELPATH)/../{{ name }}_config/{{ name }}.conf ] || cp $(DEV2RELPATH)/etc/{{ name }}.conf  $(DEV2RELPATH)/../{{ name }}_config/{{ name }}.conf
	[ -f $(DEV2RELPATH)/../{{ name }}_config/advanced.config ] || cp $(DEV2RELPATH)/etc/advanced.config  $(DEV2RELPATH)/../{{ name }}_config/advanced.config

devrel3:
	$(REBAR) as dev3 release
	mkdir -p $(DEV3RELPATH)/../{{ name }}_config
	[ -f $(DEV3RELPATH)/../{{ name }}_config/{{ name }}.conf ] || cp $(DEV3RELPATH)/etc/{{ name }}.conf  $(DEV3RELPATH)/../{{ name }}_config/{{ name }}.conf
	[ -f $(DEV3RELPATH)/../{{ name }}_config/advanced.config ] || cp $(DEV3RELPATH)/etc/advanced.config  $(DEV3RELPATH)/../{{ name }}_config/advanced.config

devrel: devrel1 devrel2 devrel3

dev1-attach:
	$(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME) attach

dev2-attach:
	$(BASEDIR)/_build/dev2/rel/{{ name }}/bin/$(APPNAME) attach

dev3-attach:
	$(BASEDIR)/_build/dev3/rel/{{ name }}/bin/$(APPNAME) attach

dev1-console:
	$(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME) console

dev2-console:
	$(BASEDIR)/_build/dev2/rel/{{ name }}/bin/$(APPNAME) console

dev3-console:
	$(BASEDIR)/_build/dev3/rel/{{ name }}/bin/$(APPNAME) console

devrel-clean:
	rm -rf _build/dev*/rel

devrel-start:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/{{ name }}/bin/$(APPNAME) start; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do $$d/rel/{{ name }}/bin/$(APPNAME)-admin cluster join {{ name }}1@127.0.0.1; done

devrel-cluster-plan:
	$(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME)-admin cluster plan

devrel-cluster-commit:
	$(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME)-admin cluster commit

devrel-status:
	$(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME)-admin member-status

devrel-ping:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/{{ name }}/bin/$(APPNAME) ping; true; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/{{ name }}/bin/$(APPNAME) stop; true; done

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

