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

        {sys_config, "./config/sys.config"},
        {vm_args, "./config/vm.args"},

        {dev_mode, true},
        {include_erts, false},

        {extended_start_script, true},

        {overlay_vars, "config/vars.config"},
        {overlay, [
            {mkdir, "etc"},
            {mkdir, "bin"},
            {mkdir, "data/ring"},
            {mkdir, "log/sasl"},
            {template, "./_build/default/plugins/cuttlefish/priv/erlang_vm.schema",
                        "share/schema/11-erlang_vm.schema"},
            {template, "./_build/default/lib/riak_core/priv/riak_core.schema", "share/schema/12-riak_core.schema"},
            {template, "./_build/default/lib/riak_sysmon/priv/riak_sysmon.schema", "lib/15-riak_sysmon.schema"},
            {template, "./_build/default/lib/eleveldb/priv/eleveldb.schema", "share/schema/21-leveldb.schema"},
            {template, "config/config.schema", "share/schema/22-{{ name }}.schema"},
            %{template, "./config/extended_bin", "bin/{{ name }}"},
            {copy, "./config/admin_bin", "bin/{{ name }}-admin"},
            {copy, "./config/nodetool", "bin/nodetool"},
            {template, "./config/advanced.config", "etc/advanced.config"},
            {copy, "./_build/default/bin/cuttlefish", "bin/cuttlefish"},
            {copy, "{{ meta_vm_args_path }}", "etc/vm.args"}
        ]}
]}.

{plugins, [
    {rebar3_cuttlefish, {git, "git://github.com/tsloughter/rebar3_cuttlefish.git", {branch, "master"}}}
]}.

{profiles, [
    {prod, [{relx, [{dev_mode, false}, {include_erts, true}]}]},
    {dev1, [{relx, [{overlay_vars, "config/vars_dev1.config"},
                    {vm_args, "./config/dev1_vm.args"}]}]},
    {dev2, [{relx, [{overlay_vars, "config/vars_dev2.config"},
                    {vm_args, "./config/dev2_vm.args"}]}]},
    {dev3, [{relx, [{overlay_vars, "config/vars_dev3.config"},
                    {vm_args, "./config/dev3_vm.args"}]}]}
]}.


{provider_hooks, [
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
     {artifacts, ["c_src/riak_ensemble_clock.o"]},
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

  {override, setup, [{post_hooks, []}, {deps, []}]},
  {override, parse_trans, [{deps, []}]},
  {override, folsom, [{deps, [{bear, {git, "git://github.com/boundary/bear.git", {tag, "0.8.2"}}}]}]}
 ]}.
