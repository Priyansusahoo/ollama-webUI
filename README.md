# About:
- Automated scripts to simplify the process of Ollama and its WebUI Launch in one click on Ubuntu 24.04.1 LTS (Gnome). 

- Setting up a Large Language Model (LLM) like DeepSeek-r1 with 8 billion parameters, and

- Creating a desktop entry for easy access to the WebUI (Auto start ollama server and Validations)

# SUPPORT:
Star this repo 😉

[![Sponsor Priyansusahoo](https://img.shields.io/badge/Sponsor-Priyansusahoo-blue?logo=github&style=for-the-badge)](https://github.com/sponsors/Priyansusahoo)



# INSTALLATION:
## Ollama & Ollama-WebUI Installation and Creating Desktop Entry:

### UBUNTU 24.04.1 LTS (Gnome) (TESTED)

## 1. Install Ollama:
  
    $ curl -fsSL https://ollama.com/install.sh | sh

    $ sudo systemctl enable ollama
    $ sudo systemctl start ollama

## 2. Install an LLM of your choice 
### Select an LLM of your choice from [here](https://ollama.com/search).
- For demonstration I will install DeepSeek-r1 8 billion parameters (4.9 GB):
   
      $ ollama run deepseek-r1:8b
- This will take some time, after successfully installing

      >>> /bye

## 3. [Install Ollama-WebUI](https://snapcraft.io/install/ollama-webui/ubuntu):

- prerequisites (SNAP):

      $ sudo apt update
      $ sudo apt install snapd
  
- Ollama-WebUI:
  
      $ sudo snap install ollama-webui --beta

## 4. Creating a Desktop Entry for Ollama-WebUI to access it from the app drawer

- Save this `ollama-launcher.sh` to ~/.scripts folder as mentioned `$HOME/scripts/ollama-launcher.sh`

      $ cd

      $ mkdir -p ~/.scripts/

      $ cd scripts/

      $ touch ollama-launcher.sh

      $ vim ollama-launcher.sh

- `ollama-launcher.sh` :
  
  ```bash
    #!/bin/bash

    # Configuration
    OLLAMA_HOST="127.0.0.1:11434"
    OLLAMA_WEBUI_PORT=8080  # Changed to match your actual web UI port
    
    # Check for required commands
    check_commands() {
        if ! command -v ollama &> /dev/null; then
            echo "Error: Ollama is not installed. Please install Ollama first."
            exit 1
        fi
        
        if ! command -v ollama-webui &> /dev/null; then
            echo "Error: ollama-webui command not found. Please install it first."
            exit 1
        fi
    }
    
    # Function to check/start Ollama
    start_ollama() {
        if curl -s $OLLAMA_HOST >/dev/null; then
            echo "✓ Ollama is already running"
            return 0
        fi
    
        echo "⚠️  Ollama is not running. Starting now..."
        
        # Try systemd service first
        if command -v systemctl >/dev/null && systemctl start ollama 2>/dev/null; then
            echo "✓ Ollama started via system service"
        else
            echo "✓ Starting Ollama in background..."
            nohup ollama serve > /dev/null 2>&1 &
        fi
    
        # Wait for Ollama to become available
        echo -n "⏳ Waiting for Ollama to start"
        local max_attempts=15
        for ((i=1; i<=$max_attempts; i++)); do
            if curl -s $OLLAMA_HOST >/dev/null; then
                echo -e "\n✓ Ollama is ready!"
                return 0
            fi
            echo -n "."
            sleep 1
        done
    
        echo -e "\n❌ Failed to start Ollama after $max_attempts attempts"
        exit 1
    }
    
    # Function to handle port conflicts
    handle_port_conflict() {
        echo "🛑 Port $OLLAMA_WEBUI_PORT is already in use"
        
        # Find PID using the port
        pid=$(ss -tulpn | grep ":$OLLAMA_WEBUI_PORT" | awk '{print $7}' | cut -d= -f2 | cut -d, -f1)
        
        if [ -n "$pid" ]; then
            echo "🔍 Found existing process (PID: $pid)"
            read -p "❓ Do you want to kill this process and continue? [y/N] " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                kill -9 $pid
                echo "✅ Killed process $pid"
                return 0
            else
                echo "❎ Exiting script"
                exit 1
            fi
        else
            echo "⚠️  Port in use but no process found - check your system"
            exit 1
        fi
    }
    
    # Function to start web UI
    start_webui() {
        if ss -tuln | grep -q ":$OLLAMA_WEBUI_PORT"; then
            echo "✓ Web UI already running"
            return 0
        fi
    
        echo "🚀 Starting Ollama Web UI..."
        if ! nohup ollama-webui --port $OLLAMA_WEBUI_PORT > /dev/null 2>&1 & then
            handle_port_conflict
            nohup ollama-webui --port $OLLAMA_WEBUI_PORT > /dev/null 2>&1 &
        fi
        
        echo -n "⏳ Waiting for Web UI"
        local max_attempts=10
        for ((i=1; i<=$max_attempts; i++)); do
            if ss -tuln | grep -q ":$OLLAMA_WEBUI_PORT"; then
                echo -e "\n✓ Web UI is ready!"
                return 0
            fi
            echo -n "."
            sleep 1
        done
        
        echo -e "\n❌ Failed to start Web UI after $max_attempts attempts"
        exit 1
    }
    
    # Open browser function
    open_browser() {
        echo "🌐 Opening browser at http://localhost:$OLLAMA_WEBUI_PORT"
        xdg-open "http://localhost:$OLLAMA_WEBUI_PORT"
    }
    
    # Main script execution
    check_commands
    start_ollama
    start_webui
    open_browser
  ```
      

- After copying the content to `ollama-launcher.sh`, give the required permissions

      $ chmod +x ollama-launcher.sh

- Copy `ollama-WebUI-Create-desktop-entry.sh` and save it in ~/.scripts folder which we previously created in the User's HOME directory and give the required permissions

      $ cd

      $ cd scripts/

      $ touch ollama-WebUI-Create-desktop-entry.sh

      $ vim ollama-WebUI-Create-desktop-entry.sh
  

- `ollama-WebUI-Create-desktop-entry.sh` :
  ```bash
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
  ```

- Permission:
  
      $ chmod +x ollama-WebUI-Create-desktop-entry.sh

- Execute the Script:
  
      $ ./ollama-WebUI-Create-desktop-entry.sh

- After successfully executing the script check your app drawer and you will find the "Ollama WebUI" icon.

  ![image](https://github.com/user-attachments/assets/93155439-f43b-4817-be9c-8306085f9135)

## 5. After Installation:

- Create an account. Select a LLM for your choice

  ![image](https://github.com/user-attachments/assets/c5a0a208-dfca-4a0e-985b-0c0d1980f0cc)

- And ENJOY!

  ![image](https://github.com/user-attachments/assets/97f567f8-72d3-4783-b816-9fdb4cb37566)


[![Sponsor Priyansusahoo](https://img.shields.io/badge/Sponsor-Priyansusahoo-blue?logo=github&style=for-the-badge)](https://github.com/sponsors/Priyansusahoo)
  
