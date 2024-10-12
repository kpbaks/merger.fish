status is-interactive; or return

function _handle_merger_signal --on-signal USR1
    echo "received signal to merge history"
    history merge
end

function _send_merger_signal --on-event fish_exit
    # 1. Find all other interactive fish processes running
    if command -q pgrep
        set -f other_fish_pids (command pgrep fish)
    else
        # 2. send a signal to them with `kill`, on the signal handler defined above
        for exe in /proc/*/exe
            if test (path basename (path resolve $exe)) = fish
                set -a other_fish_pids (path dirname $exe)
            end
        end
    end

    for pid in $other_fish_pids
        command kill -USR1 $pid
    end
end
