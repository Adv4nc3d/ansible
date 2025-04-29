#!/usr/bin/env bash
# DeleteUser.sh
# Deletes an existing user and removes them from the sudo group if necessary

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

# Check if user is in sudo group
if id -nG "$USERNAME" | grep -qw "sudo"; then
    echo "ℹ️ User '${USERNAME}' is in the sudo group. Proceeding with removal."
else
    echo "ℹ️ User '${USERNAME}' is not in the sudo group. Proceeding with removal."
fi

# Delete the user and their home directory
userdel -r "${USERNAME}"
echo "✅ User '${USERNAME}' has been deleted."

# Final message
cat <<EOF
✅ Done: '${USERNAME}' has been removed from the system.
EOF
