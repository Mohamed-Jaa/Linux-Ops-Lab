# Implementation Report: SSH Key Transition
**Status:** Successfully Implemented ✅

---

## Step 1: Key Generation (Client-Side)
On the local Windows machine, a new SSH key pair was generated using the Ed25519 algorithm for superior security and performance.
**Command:**
`ssh-keygen -t ed25519 -C "My-PC"`

## Step 2: Server-Side Preparation
Accessed the Ubuntu server to prepare the environment for the public key.
* **Directory Creation:** `mkdir -p ~/.ssh`
* **Key Deployment:** The content of `id_ed25519.pub` was manually appended to `/home/webadmin/.ssh/authorized_keys`.

## Step 3: Critical Permission Configuration
Applied the "Principle of Least Privilege" to the SSH configuration files to ensure the SSH daemon accepts the keys:
* `chmod 700 ~/.ssh`
* `chmod 600 ~/.ssh/authorized_keys`
* `chown -R webadmin:webadmin ~/.ssh`

## Step 4: System Hardening (Disabling Passwords)
Modified the SSH daemon configuration file `/etc/ssh/sshd_config` with the following parameters:
* `PubkeyAuthentication yes`
* `PasswordAuthentication no`
* `KbdInteractiveAuthentication no`

---

## Troubleshooting & Resolution
During the implementation, two major hurdles were encountered and resolved:
1. **Disabled Key Auth:** The `PubkeyAuthentication` directive was originally commented out with a `#`. Enabling it allowed the key handshake to proceed.
2. **Persistence of Password Prompts:** Even after modifying the main config, password prompts persisted. This was traced to overrides in `/etc/ssh/sshd_config.d/`. Using `sudo sshd -T | grep passwordauthentication` helped identify the active configurations and successfully disable them.

---

## Verification Result
* **Authorized Device (Windows PC):** Logged in successfully without a password prompt.
* **Unauthorized Device (Mobile/Other):** Connection rejected with `Permission denied (publickey)`. Access is now impossible without the private key.
