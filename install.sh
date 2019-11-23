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

# Giving Storage permision to Termux App.
termux-setup-storage

# Updating package repositories 
# and installing requirements.
pkg update
pkg install -y git zsh

if [ -d "$HOME/.LitMux" ]; then
rm -rf "$HOME/.LitMux"
fi

git clone https://github.com/AvinashReddy3108/LitMux.git "$HOME/.LitMux" --depth 1

# Making a backup of Termux config directory,
# just in case you want to revert.
mv -f "$HOME/.termux" "$HOME/.termux.bak"
cp -R "$HOME/.LitMux/.termux" "$HOME/.termux"

# Installing Oh My ZSH as a replacement of BASH.
echo "Installing oh-my-ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended" > /dev/null

# Changing default shell to ZSH, goodbye boring BASH.
chsh -s zsh

# Adding aliases for stuff
echo "alias chcolor='$HOME/.termux/litmux_colors.sh'" >> "$HOME/.zshrc"

# Installing Syntax Highlighting addon for ZSH,
# and sourcing it in the .zshrc file.

if [ -d "$HOME/.zsh-syntax-highlighting" ]; then
rm -rf "$HOME/.zsh-syntax-highlighting"
fi

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

# Installing powerlevel10k theme for ZSH,
# and sourcing it in the .zshrc file.

if [ -d "$HOME/.powerlevel10k" ]; then
rm -rf "$HOME/.powerlevel10k"
fi

git clone https://github.com/romkatv/powerlevel10k.git "$HOME/.powerlevel10k" --depth 1
echo "source $HOME/.powerlevel10k/powerlevel10k.zsh-theme" >> "$HOME/.zshrc"
sed -i 's~\(ZSH_THEME="\)[^"]*\(".*\)~\1powerlevel10k/powerlevel10k\2~' "$HOME/.zshrc"

# Installing the Powerline font for Termux.
curl -fsSL -o ~/.termux/font.ttf 'https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf'

# Choosing a cool color scheme for ZSH.
clear
echo "Let's choose a good color scheme for the shell, shall we ?"
echo "NOTE: use 'chcolor' to change shell colors anytime later."
echo ""
$HOME/.termux/litmux_colors.sh

clear
termux-reload-settings
echo "LitMux Installed successfully, gimme cookies !"
echo "Restart the Termux app to enjoy the LIT experience."
echo "NOTE: use 'p10k configure' to configure your terminal prompt anytime later."
exit
