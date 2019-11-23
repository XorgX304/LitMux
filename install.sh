#!/data/data/com.termux/files/usr/bin/bash
clear
echo "██╗     ██╗████████╗███╗   ███╗██╗   ██╗██╗  ██╗";
echo "██║     ██║╚══██╔══╝████╗ ████║██║   ██║╚██╗██╔╝";
echo "██║     ██║   ██║   ██╔████╔██║██║   ██║ ╚███╔╝ ";
echo "██║     ██║   ██║   ██║╚██╔╝██║██║   ██║ ██╔██╗ ";
echo "███████╗██║   ██║   ██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗";
echo "╚══════╝╚═╝   ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝";
echo "";
echo "      Ditch the boring BASH and get LIT !!      ";
sleep 3

git_force_clone_shallow () {
   if [ -d "$2" ]; then
   rm -rf "$2"
   fi
   git clone --depth 1 "$1" "$2"
}

sed_handle_plugin_zshrc () {
   if  grep "^plugins=*$1*" ~/.zshrc ; then
   true
   else
   sed -i "s/\(^plugins=([^)]*\)/\1 $1/" ~/.zshrc
   fi
}

sed_handle_alias_zshrc () {
   if  grep "^alias $1=*" ~/.zshrc ; then
   true
   else
   echo "alias $1=$2" >> ~/.zshrc
   fi
}

# Giving Storage permision to Termux App.
termux-setup-storage

# Updating package repositories and installing requirements.
pkg update
pkg install -y git zsh

# Installing Oh My ZSH as a replacement of BASH.
echo "Installing oh-my-ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"

# Changing default shell to ZSH, goodbye boring BASH.
chsh -s zsh

# Adding aliases for LITMUX stuff.
sed_handle_alias_zshrc "litmux-color" "'$HOME/.oh-my-zsh/custom/misc/LitMux/.termux/litmux_colors.sh'"
sed_handle_alias_zshrc "litmux-style" "'p10k configure'"
sed_handle_alias_zshrc "litmux-update" "'upgrade_oh_my_zsh'"
sed_handle_alias_zshrc "litmux-remove" "'rm -f ~/.termux/font.ttf; rm -f ~/.termux/colors.properties; termux-reload-settings; uninstall_oh_my_zsh'"

# Installing "Syntax Highlighting" addon for ZSH, and appending that to the plugins list.
git_force_clone_shallow https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
sed_handle_plugin_zshrc "zsh-syntax-highlighting"

# Installing "Custom Plugins Updater" addon for ZSH, and appending that to the plugins list.
git_force_clone_shallow https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "$HOME/.oh-my-zsh/custom/plugins/autoupdate"
sed_handle_plugin_zshrc "autoupdate"

# Cloning the LITMUX repo, to be handled by the Oh-My-ZSH updater.
git_force_clone_shallow https://github.com/AvinashReddy3108/LitMux.git "$HOME/.oh-my-zsh/custom/misc/LitMux"

# Installing powerlevel10k theme for ZSH, and making it the current theme in .zshrc file.
git_force_clone_shallow https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
sed -i 's~\(ZSH_THEME="\)[^"]*\(".*\)~\1powerlevel10k/powerlevel10k\2~' ~/.zshrc

# Installing the Powerline font for Termux.
curl -fsSL -o ~/.termux/font.ttf 'https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf'

# Set 'Tango' as the default color scheme for the shell.
cp -fr "$HOME/.oh-my-zsh/custom/misc/LitMux/.termux/colors.properties" ~/.termux/colors.properties
termux-reload-settings

# Replace the default welcome text with a customized one.
cp -fr "$HOME/.oh-my-zsh/custom/misc/LitMux/motd" "$PREFIX/etc/motd"

# Run a ZSH shell, opens the p10k config wizard if not set up already.
exec zsh -l
