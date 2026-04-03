if test -f ~/.env
    bass source ~/.env
end

if status is-interactive
    if type -q fnm
        fnm env --use-on-cd --shell fish | source
    end

    function set_proxy --description "Enable local proxy from PROXY_HOST/PROXY_PORT"
        if not set -q PROXY_HOST; or not set -q PROXY_PORT
            echo "PROXY_HOST/PROXY_PORT is not set."
            return 1
        end

        set -gx http_proxy "http://$PROXY_HOST:$PROXY_PORT"
        set -gx https_proxy "http://$PROXY_HOST:$PROXY_PORT"
        set -gx all_proxy "socks5://$PROXY_HOST:$PROXY_PORT"

        if set -q PROXY_NO_PROXY
            set -gx no_proxy $PROXY_NO_PROXY
        else
            set -gx no_proxy "localhost,127.0.0.1,::1,*.local"
        end

        echo "Proxy has been set."
    end

    function unset_proxy --description "Disable local proxy"
        set -e http_proxy
        set -e https_proxy
        set -e all_proxy
        set -e no_proxy
        echo "Proxy has been unset."
    end
end
