-module(quoted_log).
-export([from_url/1]).

-define(FILENAME, "/var/log/adgear-gateway/quoted.log").

from_url(Data) ->
    log(Data),
    quoted:from_url(Data).
    
log(Data) when is_binary(Data) ->
    log(binary_to_list(Data));
    
log(Data) when is_list(Data) ->
    case disk_log:balog(quoted, Data ++ "\n") of
        {error, no_such_log} ->
            {ok, _} = disk_log:open([{file, ?FILENAME}, {format, external}, {head, none}, {mode, read_write}, {name, quoted}, {size, {10000000, 2}}, {type, wrap}]),
            disk_log:balog(quoted, Data ++ "\n");
        ok -> ok
    end.