%% -*- mode: erlang; -*-
{erl_opts, [debug_info, {parse_transform, lager_transform}]}.

{deps, [lager, recon, {riak_core, {pkg, riak_core_ng}}]}.

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
            {template, "./config/advanced.config", "etc/advanced.config"},
            {template, "./priv/01-{{ name }}.schema", "share/schema/01-{{ name }}.schema"},
            {template, "./config/erlang_vm.schema", "share/schema/03-vm.schema"},
            {template, "./config/riak_core.schema", "share/schema/04-riak_core.schema"},
            {template, "./config/lager.schema", "share/schema/05-lager.schema"}
        ]}
]}.

{plugins, [rebar3_run]}.

{project_plugins, [rebar3_cuttlefish]}.

{cuttlefish, [{schema_discovery, false}]}.

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
  {del, riak_core, [{erl_opts, [warnings_as_errors]}]},
  {del, poolboy, [{erl_opts, [warnings_as_errors]}]},
  {override, cuttlefish,
      [{escript_emu_args, "%%! -escript main cuttlefish_escript +S 1 +A 0\n"}]}
 ]}.
