{cuttlefish_conf, "{{ name }}.conf"}.
{rel_name, "{{ name }}"}.
{node, "{{ name }}3@127.0.0.1"}.

{web_ip,            "127.0.0.1"}.
{web_port,          8398}.
{handoff_port,      8399}.
{handoff_ip,        "127.0.0.1"}.
{sasl_error_log,    "./log/sasl-error.log"}.
{sasl_log_dir,      "./log/sasl"}.

{platform_bin_dir,  "./bin"}.
{platform_data_dir, "../{{ name }}_data"}.
{platform_etc_dir,  "../{{ name }}_config"}.
{platform_lib_dir,  "./lib"}.
{platform_log_dir,  "./log"}.

