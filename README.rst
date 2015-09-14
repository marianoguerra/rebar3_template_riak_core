rebar3 riak_core template
=========================

A `rebar3 <http://rebar3.org>`_ template for riak_core applications.

Setup
-----

`Install rebar3 <http://www.rebar3.org/docs/getting-started>`_ if you haven't already.

then install this template::

    mkdir -p ~/.config/rebar3/templates
    git clone https://github.com/marianoguerra/rebar3_template_riak_core.git ~/.config/rebar3/templates/rebar3_template_riak_core

Use
---

::

    mkdir ricor
    cd ricor
    rebar3 new rebar3_riak_core name=ricor
    rebar3 release
    rebar3 run

    (ricor@127.0.0.1)1> ricor:ping().
    {pong,981946412581700398168100746981252653831329677312}

Author
------

Mariano Guerra

License
-------

Apache 2.0
