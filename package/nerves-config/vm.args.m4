ifelse(DISTRIBUTION, `y', `
## Name of the node
-sname SNAME

## Cookie for distributed erlang
-setcookie COOKIE
')
## Heartbeat management; auto-restarts VM if it dies or becomes unresponsive
## (Disabled by default..use with caution!)
##-heart

## Enable kernel poll and a few async threads
##+K true
##+A 5

## Increase number of concurrent ports/sockets
##-env ERL_MAX_PORTS 4096

## Tweak GC to run more often
##-env ERL_FULLSWEEP_AFTER 10

## Start the Elixir shell
#-noshell
#-user Elixir.IEx.CLI
#-extra --no-halt

## Start the LFE shell
#-user lfe_init
