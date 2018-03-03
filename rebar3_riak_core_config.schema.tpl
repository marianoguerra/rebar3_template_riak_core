%%-*- mode: erlang -*-
%% ex: ft=erlang ts=4 sw=4 et

%% @doc Enable/Disable HTTP API
{mapping, "http.enabled", "{{ name }}.http_enabled", [
  {datatype, {flag, yes, no}},
  {default, yes}
]}.

%% @doc port to listen to for HTTP API
{mapping, "http.port", "{{ name }}.http_port", [
  {datatype, integer},
  {default, {{default_config_http_port}} }
]}.

%% @doc number of acceptors to user for HTTP API
{mapping, "http.acceptors", "{{ name }}.http_acceptors", [
  {datatype, integer},
  {default, 100}
]}.

%% @doc Enable/Disable HTTPS API
{mapping, "https.enabled", "{{ name }}.https_enabled", [
  {datatype, {flag, yes, no}},
  {default, no}
]}.

%% @doc port to listen to for HTTPS API
{mapping, "https.port", "{{ name }}.https_port", [
  {datatype, integer},
  {default, 8443}
]}.

%% @doc number of acceptors to use for HTTPS API
{mapping, "https.acceptors", "{{ name }}.https_acceptors", [
  {datatype, integer},
  {default, 100}
]}.

%% @doc Enable/Disable HTTP CORS API
{mapping, "http.cors.enabled", "{{ name }}.cors_enabled", [
  {datatype, {flag, yes, no}},
  {default, no}
]}.

%% @doc HTTP CORS API allowed origins, it can be a comma separated list of
%% origins to accept or * to accept all
{mapping, "http.cors.origins", "{{ name }}.cors_origins", [
  {default, "*"}
]}.

{translation, "{{ name }}.cors_origins",
 fun(Conf) ->
         Setting = cuttlefish:conf_get("http.cors.origins", Conf),
         case Setting of
             "*" -> any;
             CSVs ->
                 Tokens = string:tokens(CSVs, ","),
                 Cleanup = fun (Token) ->
                                   CleanToken = string:strip(Token),
                                   list_to_binary(CleanToken)
                           end,
                 FilterEmptyStr = fun ("") -> false; (_) -> true end,
                 lists:filter(FilterEmptyStr, lists:map(Cleanup, Tokens))
         end
 end}.

%% @doc HTTP CORS API a comma separated list of allowed headers to accept
{mapping, "http.cors.headers", "{{ name }}.cors_headers", []}.

{translation, "{{ name }}.cors_headers",
 fun(Conf) ->
         CSVs = cuttlefish:conf_get("http.cors.headers", Conf),
         Tokens = string:tokens(CSVs, ","),
         Cleanup = fun (Token) ->
                           CleanToken = string:strip(Token),
                           list_to_binary(CleanToken)
                   end,
         FilterEmptyStr = fun ("") -> false; (_) -> true end,
         lists:filter(FilterEmptyStr, lists:map(Cleanup, Tokens))
 end}.

%% @doc HTTP CORS API indicates how long the results of a preflight request can
%% be cached
{mapping, "http.cors.maxage", "{{ name }}.cors_max_age_secs", [
  {datatype, {duration, s}},
  {default, "60s"}
]}.

%% @doc secret used to encrypt the session token, IMPORTANT: change this
{mapping, "auth.secret", "{{ name }}.auth_secret", [
  {default, "changeme"}
]}.

{translation, "{{ name }}.auth_secret",
 fun(Conf) ->
         Setting = cuttlefish:conf_get("auth.secret", Conf),
         list_to_binary(Setting)
 end}.

%% @doc time a session is valid after login
{mapping, "auth.session.duration", "{{ name }}.session_duration_secs", [
  {datatype, {duration, s}},
  {default, "24h"}
]}.
