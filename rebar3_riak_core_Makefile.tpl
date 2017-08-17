BASEDIR = $(shell pwd)
REBAR = rebar3
RELPATH = _build/default/rel/{{ name }}
PRODRELPATH = _build/prod/rel/{{ name }}
APPNAME = {{ name }}
SHELL = /bin/bash
RELPATH_DEV1=$(BASEDIR)/_build/dev1/rel/{{ name }}
RELPATH_DEV2=$(BASEDIR)/_build/dev2/rel/{{ name }}
RELPATH_DEV3=$(BASEDIR)/_build/dev3/rel/{{ name }}

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
	mkdir -p $(RELPATH_DEV1)/../{{ name }}_config
	[ -f $(RELPATH_DEV1)/../{{ name }}_config/{{ name }}.conf ] || cp $(RELPATH_DEV1)/etc/{{ name }}.conf  $(RELPATH_DEV1)/../{{ name }}_config/{{ name }}.conf
	[ -f $(RELPATH_DEV1)/../{{ name }}_config/advanced.config ] || cp $(RELPATH_DEV1)/etc/advanced.config  $(RELPATH_DEV1)/../{{ name }}_config/advanced.config

devrel2:
	$(REBAR) as dev2 release
	mkdir -p $(RELPATH_DEV2)/../{{ name }}_config
	[ -f $(RELPATH_DEV2)/../{{ name }}_config/{{ name }}.conf ] || cp $(RELPATH_DEV2)/etc/{{ name }}.conf  $(RELPATH_DEV2)/../{{ name }}_config/{{ name }}.conf
	[ -f $(RELPATH_DEV2)/../{{ name }}_config/advanced.config ] || cp $(RELPATH_DEV2)/etc/advanced.config  $(RELPATH_DEV2)/../{{ name }}_config/advanced.config

devrel3:
	$(REBAR) as dev3 release
	mkdir -p $(RELPATH_DEV3)/../{{ name }}_config
	[ -f $(RELPATH_DEV3)/../{{ name }}_config/{{ name }}.conf ] || cp $(RELPATH_DEV3)/etc/{{ name }}.conf  $(RELPATH_DEV3)/../{{ name }}_config/{{ name }}.conf
	[ -f $(RELPATH_DEV3)/../{{ name }}_config/advanced.config ] || cp $(RELPATH_DEV3)/etc/advanced.config  $(RELPATH_DEV3)/../{{ name }}_config/advanced.config

devrel: devrel1 devrel2 devrel3

dev1-console:
	cd $(RELPATH_DEV1) && ./bin/$(APPNAME) console

dev2-console:
	cd $(RELPATH_DEV2) && ./bin/$(APPNAME) console

dev3-console:
	cd $(RELPATH_DEV3) && ./bin/$(APPNAME) console

devrel-start:
	for d in $(BASEDIR)/_build/dev*; do cd $$d/rel/{{ name }} && ./bin/$(APPNAME) start; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do cd $$d/rel/{{ name }} && ./bin/$(APPNAME)-admin cluster join {{ name }}1@127.0.0.1; done

devrel-cluster-plan:
	cd $(RELPATH_DEV1) && ./bin/$(APPNAME)-admin cluster plan

devrel-cluster-commit:
	cd $(RELPATH_DEV1) && ./bin/$(APPNAME)-admin cluster commit

devrel-status:
	cd $(RELPATH_DEV1) && ./bin/$(APPNAME)-admin member-status

devrel-ping:
	for d in $(BASEDIR)/_build/dev*; do cd $$d/rel/{{ name }} && ./bin/$(APPNAME) ping; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev*; do cd $$d/rel/{{ name }} && ./bin/$(APPNAME) stop; done

start:
	cd $(RELPATH) && ./bin/$(APPNAME) start

stop:
	cd $(RELPATH) && ./bin/$(APPNAME) stop

attach:
	cd $(RELPATH) && ./bin/$(APPNAME) attach

