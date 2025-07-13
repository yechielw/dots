function history_log {

       export HISTTIMEFORMAT="%F-%T-%Z "
       if [ ! -d "~/.logs/terminal_log" ]; then
              mkdir -p ~/.logs/terminal_log
       fi
       test "$(ps -ocommand= -p $PPID | awk '{print $1}')" == 'script' || (script -f ~/.logs/terminal_log/$(date "+%Z-%d-%m_%Y_%H-%M-%S")_"$$"_shell.log)
}
