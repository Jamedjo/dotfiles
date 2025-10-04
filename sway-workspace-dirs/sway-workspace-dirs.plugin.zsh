# Sway workspace-aware directory tracking
# Remembers the last directory used in each Sway workspace

function save_workspace_directory() {
    workspace=$(swaymsg -t get_workspaces 2>/dev/null | jq -r '.[] | select(.focused==true).name')
    if [[ -n "$workspace" ]]; then
        workspace_dir="$HOME/.config/sway-workspaces/$workspace"
        mkdir -p "$workspace_dir"
        echo "$PWD" > "$workspace_dir/last-folder"
    fi
}

function restore_workspace_directory() {
    workspace=$(swaymsg -t get_workspaces 2>/dev/null | jq -r '.[] | select(.focused==true).name')
    if [[ -n "$workspace" ]]; then
        last_folder_file="$HOME/.config/sway-workspaces/$workspace/last-folder"
        if [[ -f "$last_folder_file" ]]; then
            saved_dir=$(cat "$last_folder_file")
            if [[ -d "$saved_dir" ]]; then
                cd "$saved_dir"
            fi
        fi
    fi
}

# Hook into directory changes
chpwd_functions+=(save_workspace_directory)

# Restore on shell startup (but not in subshells)
if [[ -o interactive ]] && [[ -z "$SWAY_WS_RESTORE_DONE" ]]; then
    export SWAY_WS_RESTORE_DONE=1
    restore_workspace_directory
fi
