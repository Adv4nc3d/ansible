#!/usr/bin/env bash
# AddUserToSudoGroup.sh
# Adds an existing user to the sudo group

# Setup error pipeline
set -euo pipefail

# Set usage for 'username'
USAGE="Usage: $0 <username>"
if [[ $# -ne 1 ]]; then
    echo "$USAGE"
    exit 1
fi

# Globals
USERNAME="$1"

# Check if user exists
if ! id "${USERNAME}" &>/dev/null; then
    echo "❗ Error: User '${USERNAME}' does not exist."
    exit 1
fi

# Check if user is already in sudo group
if id -nG "$USERNAME" | grep -qw "sudo"; then
    echo "ℹ️ User '${USERNAME}' is already in the sudo group."
else
    usermod -aG sudo "${USERNAME}"
    echo "✅ User '${USERNAME}' has been added to the sudo group."
fi

# Final message
cat <<EOF
✅ Done: '${USERNAME}' can now use sudo privileges.
EOF
