#!/usr/bin/env bash
# Pretty ugly script to quickly configure
# Ubuntu 22.04 LTS

echo -e "\e[32;1mSay goodbye to all snaps...\e[m\n"

sudo pkill snap-store
sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service
sudo snap remove snapd-desktop-integration
sudo snap remove snap-store
sudo snap remove firefox
sudo snap remove gtk-common-themes
sudo snap remove gnome-3-38-2004
sudo snap remove bare
sudo snap remove core20
sudo snap remove snapd
sudo apt autoremove --purge snapd -y

# Block snapd from reinstalling
sudo apt-mark hold snapd

echo -e "\e[32;1mInstalling Firefox from the mozillateam ppa...\e[m\n"
# Add Firefox ppa
sudo tee -a /etc/apt/preferences.d/firefox-no-snap &>/dev/null << 'EOF'
Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1
EOF

sudo add-apt-repository -y ppa:mozillateam/ppa
sudo apt install -y firefox firefox-locale-fr

# Install all the useful applications for every computer I use
echo -e "\e[32;1mInstalling all the other applications...\e[m\n"

# Libreoffice + French-specific packages
sudo apt install -y libreoffice-style-yaru libreoffice-writer libreoffice-calc libreoffice-gnome libreoffice-impress libreoffice-l10n-fr hyphen-fr mythes-fr hunspell-fr-classical

# Useful tools for GNOME
sudo apt install -y gnome-tweaks gnome-shell-extension-manager

# Bare minimum
sudo apt install -y ffmpeg ffmpegthumbnailer emacs vim vlc yt-dlp deja-dup git curl fd-find fzf ripgrep cherrytree nextcloud-desktop virtualbox steam shotwell qbittorrent

# I have no use for mpv which is pulled with yt-dlp
sudo apt autoremove --purge -y mpv

# Spotify deb with correct instructions
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install -y spotify-client

# Extra applications
# I like everything to be a deb package
# To be improved to get the latest release...

mkdir extradebs
cd extradebs
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.0.3/obsidian_1.0.3_amd64.deb
wget https://mullvad.net/media/app/MullvadVPN-2022.5_amd64.deb
sudo dpkg -i ./*.deb

# Dash to Dock, at the bottom, auto-hide
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position "BOTTOM"
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
# gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
# gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

echo -e "\e[32;1mAll done! Hopefully :)\e[m\n"
