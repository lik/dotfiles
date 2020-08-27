# Start X at login
if status --is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx -- -keeptty
    end
end

# OPAM configuration
# . /home/wonton/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
set -gx PATH $PATH ~/.yarn/bin
