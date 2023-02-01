#!/usr/bin/env bash
# Pretty ugly script to quickly configure
# my installation of Kubuntu 22.04 LTS

echo -e "\e[32;1mSay goodbye to all snaps...\e[m\n"

sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service
sudo snap remove firefox
sudo snap remove gtk-common-themes
sudo snap remove gnome-3-38-2004
sudo snap remove bare
sudo snap remove core20
sudo snap remove snapd
sudo apt autoremove --purge -y snapd plasma-discover-backend-snap

# Block snapd from reinstalling
sudo apt-mark hold snapd

# Removal of useless software
# sudo apt autoremove --purge thunderbird apport -y

# Add Firefox ppa
echo -e "\n\e[32;1mInstalling Firefox from Mozilla's ppa...\e[m\n"
sudo tee -a /etc/apt/preferences.d/firefox-no-snap &>/dev/null << 'EOF'
Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1
EOF

sudo add-apt-repository -y ppa:mozillateam/ppa
sudo apt update
sudo apt install -y firefox firefox-locale-fr

# Bare minimum
echo -e "\n\e[32;1mInstalling essential apps...\e[m\n"
sudo apt install -y curl git vim emacs ripgrep fd-find fzf nextcloud-desktop ffmpeg cherrytree virtualbox steam shotwell qbittorrent
# Maybe later
# lm-sensors krita krita-l10n

# Libreoffice + French-specific packages - Not relevant, switch to Flatpak
#sudo apt install libreoffice-kf5 libreoffice-plasma libreoffice-calc libreoffice-writer libreoffice-impress libreoffice-l10n-fr hyphen-fr mythes-fr hunspell-fr-classical

# Spotify - Official deb package
echo -e "\n\e[32;1mInstalling Spotify...\e[m\n"
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install -y spotify-client

# Add Flatpak and Flathub
echo -e "\n\e[32;1mAdding Flatpak and Flathub...\e[m\n"
sudo apt install -y flatpak plasma-discover-backend-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak install flathub md.obsidian.Obsidian -y
# flatpak install flathub com.discordapp.Discord -y

# Fix DPI problem with Plasma
echo -e "\n\e[32;1mFixing SDDM...\e[m\n"
sudo tee -a /etc/sddm.conf &>/dev/null << 'EOF'
[X11]
ServerArguments=-nolisten tcp -dpi 96
EOF

# Install yt-dlp standalone
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+x /usr/local/bin/yt-dlp

# Add relevant modules for my motherboard
# sudo tee -a /etc/modules-load.d/intel.conf &>/dev/null << 'EOF'
# coretemp
# it87
# EOF

echo -e "\n\e[32;1mAll done! (hopefully)\e[m\n"
