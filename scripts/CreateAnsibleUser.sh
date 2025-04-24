#!/usr/bin/env bash
# CreateAnsibleUser.sh
# Creates a new user with rsa2048 certificate called 'ansible'


# Setup error pipeline
set -euo pipefail

# Globals
USERNAME="ansible"
KEY_TYPE="rsa"
KEY_BITS=2048
HOME_DIR="/home/${USERNAME}"
SSH_DIR="${HOME_DIR}/.ssh"
KEY_NAME="${USERNAME}_rsa2048"

# Create user 'ansible' and disable password login
if id "${USERNAME}" &>/dev/null; then
  echo "Error: ${USERNAME} exists already."
else
  useradd --create-home --shell /bin/bash --password '*' "${USERNAME}"
  echo "Success: ${USERNAME} created and password login disabled."
fi

# Create 'ssh' folder and mod permission
mkdir -p "${SSH_DIR}"
chmod 700 "${SSH_DIR}"
chown "${USERNAME}:${USERNAME}" "${SSH_DIR}"

# Create ssh-key-pair without passphrase
echo "Generating SSH-Key-Pair: RSA ${KEY_BITS} for ${USERNAME}"
sudo -u "${USERNAME}" ssh-keygen -t "${KEY_TYPE}" -b "${KEY_BITS}" -f "${SSH_DIR}/${KEY_NAME}" -C "${USERNAME}" -N ""
echo "Private Key: ${SSH_DIR}/${KEY_NAME}"
echo "Public  Key: ${SSH_DIR}/${KEY_NAME}.pub"

# Add public key to authorized_keys
cp "${SSH_DIR}/${KEY_NAME}.pub" "${SSH_DIR}/authorized_keys"
chmod 600 "${SSH_DIR}/authorized_keys"
chown "${USERNAME}:${USERNAME}" "${SSH_DIR}/authorized_keys"

# Change key files mod
chmod 600 "${SSH_DIR}/${KEY_NAME}"
chmod 644 "${SSH_DIR}/${KEY_NAME}.pub"
chown "${USERNAME}:${USERNAME}" "${SSH_DIR}/${KEY_NAME}" "${SSH_DIR}/${KEY_NAME}.pub"

# Abschlussmeldung
cat <<EOF
✅ Ready: '${USERNAME}' is able to login with the generated ssh-key now.
   Generated Keytype: RSA ${KEY_BITS}
   Private Key folder:
     ${SSH_DIR}/${KEY_NAME}
EOF
