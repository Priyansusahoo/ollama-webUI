# About:
- The ollama-webUI repository provides automated scripts to simplify the installation of Ollama and its WebUI on Ubuntu 24.04.1 LTS (Gnome). 

- It guides users through installing Ollama, setting up a Large Language Model (LLM) like DeepSeek-r1 with 8 billion parameters, and creating a desktop entry for easy access to the WebUI. 

- This streamlined approach ensures a seamless setup experience for users interested in deploying local LLMs with a user-friendly interface.

[![Sponsor Priyansusahoo](https://img.shields.io/badge/Sponsor-Priyansusahoo-blue?logo=github&style=for-the-badge)](https://github.com/sponsors/Priyansusahoo)

# INSTALLATION:
## Ollama & Ollama-WebUI Installation and Creating Desktop Entry:

### UBUNTU 24.04.1 LTS (Gnome) (TESTED)

## Install Ollama:
  
    $ curl -fsSL https://ollama.com/install.sh | sh

    $ sudo systemctl enable ollama
    $ sudo systemctl start ollama

## Install an LLM of your choice (For demonstration I will install DeepSeek-r1 8 billion parameters):
### Select an LLM of your choice from [here](https://ollama.com/search).
   
    $ ollama run deepseek-r1:8b
- This will take some time, after successfully installing

      $ /bye

## Install Ollama-WebUI:

- prerequisites:

      $ sudo apt update
      $ sudo apt install snapd
  
- Ollama-WebUI:
  
      $ sudo snap install ollama-webui --beta

## Creating a Desktop Entry for Ollama-WebUI to access it from the app drawer

- Save this [script](https://raw.githubusercontent.com/Priyansusahoo/ollama-webUI/refs/heads/main/ollama-launcher.sh) to ~/.scripts folder as mentioned below

      $HOME/scripts/ollama-launcher.sh
- STEPS:

      $ mkdir -p ~/.scripts/

      $ cd scripts/

      $ touch ollama-launcher.sh

- Copy the content from [this script](https://raw.githubusercontent.com/Priyansusahoo/ollama-webUI/refs/heads/main/ollama-launcher.sh) to ollama-launcher.sh and give the required permissions

      $ chmod +x ollama-launcher.sh

- Download [this file](https://github.com/Priyansusahoo/ollama-webUI/blob/main/ollama-WebUI-Create-desktop-entry.sh) and save it in ~/.scripts folder in the users HOME directory and give the required permissions

      $ chmod +x ollama-WebUI-Create-desktop-entry.sh

- After successfully executing the script check your app drawer and you will find the "Ollama WebUI" icon.

  ![image](https://github.com/user-attachments/assets/93155439-f43b-4817-be9c-8306085f9135)

## After Installation:

- Create an account. Select a LLM for your choice

  ![image](https://github.com/user-attachments/assets/c5a0a208-dfca-4a0e-985b-0c0d1980f0cc)

- And ENJOY!

  ![image](https://github.com/user-attachments/assets/97f567f8-72d3-4783-b816-9fdb4cb37566)


[![Sponsor Priyansusahoo](https://img.shields.io/badge/Sponsor-Priyansusahoo-blue?logo=github&style=for-the-badge)](https://github.com/sponsors/Priyansusahoo)
  
