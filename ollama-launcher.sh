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
