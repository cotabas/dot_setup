# BROKE! needs cmake to build neovim
# and it echos PATH in .bashrc incorrectly
# and lk doesn't take a variable for the path
# and starship doesn't work on fedora
# and 
cd
# Install neovim
git clone https://github.com/neovim/neovim.git
cd neovim/
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$HOME/.local/nvim
make install
cd ..
rm -rf neovim/
echo "$PATH="$PATH:$HOME/.local/nvim/bin/"" >> .bashrc

cd .config/
git clone https://github.com/cotabas/nvim_lazy.git
mv nvim_lazy/ nvim/
cd

# Setup eza
mkdir eza
cd eza
wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz

mkdir ~/.local/bin/
cp eza ~/.local/bin/
cd ..
rm -rf eza/

echo "eza --icons --git -l $1 $2" >> .local/bin/lk
chmod +x .local/bin/lk


# Starship

cd .config/
# Seems dumb.. but it worx
echo "format = \"\"\"" >> starship.toml
echo "\$time\\" >> starship.toml
echo "[](#504B47 bg:#1D2021)\\" >> starship.toml
echo "\$directory\\" >> starship.toml
echo "[ ](#1D2021 bg:#EBDCB3)\\" >> starship.toml
echo "\$git_branch\\" >> starship.toml
echo "[ ](#EBDCB3 bg:#504B47)\\" >> starship.toml
echo "\$git_status\\" >> starship.toml
echo "[](#504B47)\\" >> starship.toml
echo "\\n\$character\"\"\"" >> starship.toml
echo "" >> starship.toml
echo "[directory]" >> starship.toml
echo "style = \"fg:#FAC04B bg:#1D2021\"" >> starship.toml
echo "format = \"🐏[ \$path ](\$style)\"" >> starship.toml
echo "truncation_length = 3" >> starship.toml
echo "truncation_symbol = \"…/\"" >> starship.toml
echo "" >> starship.toml
echo "[character]" >> starship.toml
echo "success_symbol = \"[❯](#969833) \"" >> starship.toml
echo "error_symbol = \"[❯](#CF2B2A) \"" >> starship.toml
echo "" >> starship.toml
echo "[time]" >> starship.toml
echo "style = \"fg:#EBDCB3 bg:#504B47\"" >> starship.toml
echo "disabled = false " >> starship.toml
echo "time_format = '%I:%M:%S'" >> starship.toml
echo "format = '[ \$time ](\$style)'" >> starship.toml
echo "" >> starship.toml
echo "[git_status]" >> starship.toml
echo "style = \"fg:#EBDCB3 bg:#504B47\"" >> starship.toml
echo "up_to_date = \"👍\"" >> starship.toml
echo "conflicted = \"🚩\"" >> starship.toml
echo "ahead = \"💨\"" >> starship.toml
echo "behind = \"😰\"" >> starship.toml
echo "diverged = \"😵\"" >> starship.toml
echo "untracked = \"🤷\"" >> starship.toml
echo "stashed = \"📦\"" >> starship.toml
echo "modified = \"📝\"" >> starship.toml
echo "staged = '[++\(\$count\)](fg:#969833 bg:#504B47)'" >> starship.toml
echo "renamed = \"👅\"" >> starship.toml
echo "deleted = \"💥\"" >> starship.toml
echo "format = '([\$all_status\$ahead_behind](\$style))'" >> starship.toml
echo "" >> starship.toml
echo "[git_branch]" >> starship.toml
echo "style = \"fg:#1D2021 bg:#EBDCB3\"" >> starship.toml
echo "symbol = \"⌥\"" >> starship.toml
echo "format = '[\$symbol \$branch](\$style)'" >> starship.toml

cd
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin
echo "eval "$(starship init bash)"" >> .bashrc

# Setup bat
# todo


# Do this last..
source .bashrc

