#!/usr/bin/env bash
# user-modify.sh - Modify users and group membership

set -euo pipefail

modify_user() {
    local username="$1"
    local action="$2"
    local value="$3"
    
    if ! id "${username}" &>/dev/null; then
        echo "User ${username} does not exist"
        return 1
    fi
    
    case "${action}" in
        add_group)
            usermod -aG "${value}" "${username}"
            echo "Added ${username} to group ${value}"
            ;;
        remove_group)
            gpasswd -d "${username}" "${value}"
            echo "Removed ${username} from group ${value}"
            ;;
        lock)
            usermod -L "${username}"
            echo "Locked user ${username}"
            ;;
        unlock)
            usermod -U "${username}"
            echo "Unlocked user ${username}"
            ;;
        set_shell)
            usermod -s "${value}" "${username}"
            echo "Changed shell for ${username} to ${value}"
            ;;
        expire)
            usermod -e "${value}" "${username}"
            echo "Set expiration for ${username} to ${value}"
            ;;
        *)
            echo "Unknown action: ${action}"
            return 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 <username> <action> [value]"
        echo "Actions: add_group, remove_group, lock, unlock, set_shell, expire"
        exit 1
    fi
    
    modify_user "$1" "$2" "${3:-}"
fi