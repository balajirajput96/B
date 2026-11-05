# Antigravity Always-Online 🚀

This repository provides everything you need to run the **Google Antigravity CLI's Remote Control daemon 24/7 on a free cloud VM**, managed entirely from your Android phone!

No PC required. All steps can be completed directly from your mobile device using apps like Termius or JuiceSSH.

## Prerequisites (Phone Setup)

1. **Get an SSH Client:** Download **Termius** or **JuiceSSH** from the Google Play Store.
2. **Create a Cloud Account:** Sign up for an [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/) account (or Google Cloud for the e2-micro).

## Step-by-Step Guide

### 1. Create the Cloud VM
* Log in to Oracle Cloud on your phone's browser.
* Go to **Instances** -> **Create Instance**.
* Choose **Ubuntu 24.04 LTS** as the image.
* Select the **VM.Standard.A1.Flex** shape (ARM64, always free eligible).
* **Important:** Before clicking create, look for the "Add SSH keys" section. Choose "Generate a key pair for me" and download the private key to your phone.
* Create the instance and wait for it to show "Running". Note the **Public IP Address**.

### 2. Configure Firewall
* By default, SSH (port 22) is open. We don't need any other ports open for the Antigravity daemon! It connects outwards to Google.

### 3. Connect via SSH
* Open **Termius**.
* Add a new Host.
* Address: Enter your VM's **Public IP Address**.
* SSH Username: `ubuntu` (for Oracle Cloud).
* Keys: Import the private key you downloaded in Step 1.
* Connect!

### 4. Installation
Once connected to the terminal, copy and paste this command block to download the repository and start setup:

```bash
git clone https://github.com/your-username/antigravity-always-online.git
cd antigravity-always-online
./setup.sh
```

During `./setup.sh`:
1. It will install the CLI and prerequisites.
2. **Important:** It will pause and show an authentication link (`https://antigravity.google/auth`).
3. Tap or copy the link, open it in your phone's browser, and sign in with your Google account.
4. Go back to Termius and type `yes` to confirm.

### 5. Start the Service
After setup finishes, start the background daemon:

```bash
./enable-service.sh
```

### 6. PWA Setup
You can manage the Antigravity instance like a native app on your phone:
1. Open Chrome on your Android phone and go to `https://antigravity.google.com`.
2. Tap the three-dot menu and select **"Add to Home screen"** or **"Install app"**.
3. Open the newly installed app from your home screen.
4. Select your new instance (default name: `phone-cloud-vm`) to control it remotely!

## Management Commands

To check on your instance anytime, SSH in and run:

```bash
cd antigravity-always-online
./status.sh
```

To uninstall and clean up:
```bash
./uninstall.sh
```

## Troubleshooting & FAQ

| Problem | Solution |
| :--- | :--- |
| **Instance shows "Offline" in app** | SSH in and run `./status.sh` to check if the daemon is running. If it crashed, `./healthcheck.sh` should restart it within 5 minutes automatically. |
| **Authentication expired** | SSH in, stop the service (`systemctl --user stop antigravity-remote.service`), re-run `./setup.sh` to authenticate again, then `./enable-service.sh`. |
| **Service won't start after reboot** | Linger should handle this. Check if it's enabled: `loginctl show-user $USER`. If not, run `sudo loginctl enable-linger $USER`. |
| **Out of memory** | The A1 Flex instance has up to 24GB RAM, so this is rare. Check `./status.sh`. If using GCP e2-micro, consider adding a swapfile. |
| **VM reclaimed by provider** | Oracle reclaims inactive idle VMs. Ensure the daemon is running and generating some activity to prevent reclamation. |

### FAQ
**Q: Does my phone need to stay connected to SSH?**
A: No! Once you run `./enable-service.sh`, the systemd user service and `linger` ensure the daemon runs 24/7 in the background on the cloud VM.

**Q: Do I need to keep the cloud VM running?**
A: **Yes**. For the instance to appear "Online" in your Antigravity app, the cloud VM must remain powered on and connected to the internet.
