{erl_opts, [debug_info, {parse_transform, lager_transform}]}.

{deps, [
    {pbkdf2, {git, "git://github.com/marianoguerra/erlang-pbkdf2-no-history", {branch, "master"}}},
    {exometer_core, {git, "git://github.com/basho/exometer_core.git", {branch, "th/correct-dependencies"}}},
    {riak_core, {git, "git://github.com/basho/riak_core", {branch, "develop"}}}
]}.

{relx, [{release, { {{ name }} , "0.1.0"},
         [{{ name }},
          cuttlefish,
          sasl]},

        {dev_mode, true},
        {include_erts, false},

        {overlay_vars, "config/vars.config"},
        {overlay, [
            {mkdir, "etc"},
            {mkdir, "bin"},
            {mkdir, "data/ring"},
            {mkdir, "log/sasl"},
            {template, "./config/admin_bin", "bin/{{ name }}-admin"},
            {template, "./config/advanced.config", "etc/advanced.config"}
        ]}
]}.

{plugins, [
    {rebar3_run, {git, "git://github.com/tsloughter/rebar3_run.git", {branch, "master"}}}
]}.

{project_plugins, [{rebar3_cuttlefish, {git, "git://github.com/tsloughter/rebar3_cuttlefish.git", {branch, "master"}}}]}.

{profiles, [
    {prod, [{relx, [{dev_mode, false}, {include_erts, true}]}]},
    {dev1, [{relx, [{overlay_vars, ["config/vars.config", "config/vars_dev1.config"]}]}]},
    {dev2, [{relx, [{overlay_vars, ["config/vars.config", "config/vars_dev2.config"]}]}]},
    {dev3, [{relx, [{overlay_vars, ["config/vars.config", "config/vars_dev3.config"]}]}]}
]}.

{overrides,
 [{override, eleveldb,
   [
     {artifacts, ["priv/eleveldb.so"]},
     {pre_hooks, [{compile, "c_src/build_deps.sh get-deps"},
                  {compile, "c_src/build_deps.sh"}]},

     {post_hooks, [{clean, "c_src/build_deps.sh clean"}]},

     {plugins, [pc]},

     {provider_hooks, [{post,
                         [{compile, {pc, compile}},
                          {clean, {pc, clean}}
                         ]
                       }]
     }
   ]
  },
  {override, riak_ensemble,
  [
     {artifacts, ["priv/riak_ensemble_drv.so"]},
     {plugins, [pc]},
     {provider_hooks, [{post,
                         [{compile, {pc, compile}},
                          {clean, {pc, clean}}
                         ]}]},
      {erl_opts, [debug_info,
          warn_untyped_record,
          {parse_transform, lager_transform}]}
  ]},
  {override, riak_core,
  [
      {erl_opts, [debug_info,
          {parse_transform, lager_transform},
          {platform_define, "^[0-9]+", namespaced_types},
          {platform_define, "^R15", "old_hash"}]}
  ]}
 ]}.
