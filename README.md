# 👻 GhostFrame

> *An educational security research tool for demonstrating webcam permission phishing techniques.*

GhostFrame is a tool that captures images from
a target's front camera or webcam. It uses a fake website
hosted on an in-built PHP server and a tunneling service
like CloudFlared to create a masked, public link.
When the target clicks the link and allows camera permission,
GhostFrame grabs the cam shots remotely.

<p align="center">
  <img src="https://img.shields.io/badge/Status-Active-success" />
  <img src="https://img.shields.io/badge/Language-Bash-orange" />
  <img src="https://img.shields.io/badge/License-MIT-blue" />
</p>

## Disclaimer
This project is created for **Educational and Ethical Testing purposes only**.  
Misuse of this tool for unauthorized access to systems, devices, or personal data is illegal.  
The author and contributors are **not responsible for any unethical or unlawful activities** performed with GhostFrame.

---

## Features

- Hosts a fake website via an in‑built PHP server.  
- Uses Cloudflared to generate a masked, shareable public URL.  
- Captures webcam frames once permission is granted.  
- Tested environments: **Termux** and **Debian 13**.  
- Compatible with Debian‑based distros: Ubuntu, Kali Linux, Parrot OS, etc.  

---

## 📦 Installation & Usage

```bash
# Clone the repository
git clone https://github.com/iamjinx/ghostframe.git

cd ghostframe

chmod +x ghostframe.sh

# Launch the tool
bash ghostframe.sh
```