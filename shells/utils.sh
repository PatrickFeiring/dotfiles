function mkdircd () { mkdir -p "$@" && cd "$@"; }

function ls-tree() {
    fd "$@" | as-tree;
}

function bckup() {
    date_suffix=$(date +'%Y-%m-%d')

    backup_name="${PWD}-${date_suffix}"
    if [[ $# -eq 1 ]]; then
        backup_name="${backup_name}-${1}"
    fi

    if [[ -d "${backup_name}" ]]; then
        echo "${backup_name} already exists"
        return 1
    fi

    echo "Make backup to ${backup_name}"
    cp -r $PWD $backup_name
}
