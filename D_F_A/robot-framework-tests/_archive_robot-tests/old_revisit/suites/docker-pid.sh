exec docker inspect --format '{{ .State.Pid }}' "$@"
