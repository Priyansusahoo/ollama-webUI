#!/bin/bash

# Create desktop entry
cat > ~/.local/share/applications/ollama-webui.desktop <<EOL
[Desktop Entry]
Version=1.0
Name=Ollama WebUI
Comment=Launch Ollama Web Interface
Exec=/bin/bash -c "$HOME/scripts/ollama-launcher.sh"
Icon=$HOME/.icons/ollama-webui.png
Terminal=false
Type=Application
Categories=Utility;Application;
Keywords=Ollama;AI;LLM;
StartupNotify=true
EOL

# Download specified icon
mkdir -p ~/.icons
if [ ! -f ~/.icons/ollama-webui.png ]; then
    wget https://raw.githubusercontent.com/Priyansusahoo/ollama-webUI/refs/heads/main/ollama-webUI.png -O ~/.icons/ollama-webui.png
fi

# Set permissions
chmod +x ~/.local/share/applications/ollama-webui.desktop
update-desktop-database ~/.local/share/applications/

echo "Desktop entry created with custom icon!"
echo "Look for 'Ollama WebUI' in your application menu."
