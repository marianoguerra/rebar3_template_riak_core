%% -*- erlang -*-
{application, {{ name }},
 [
  {description, "A Riak Core Application"},
  {vsn, "1"},
  {registered, []},
  {applications, [
                  kernel,
                  stdlib,
                  sasl,
                  riak_core,
                  setup
                 ]},
  {mod, { {{ name }}_app, []}},
  {env, []}
 ]}.
