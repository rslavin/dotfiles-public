#/bin/bash

# Check if zsh is installed
if [[ $* != *-z* ]] && ! which zsh > /dev/null; then
    echo "ERROR: zsh is not installed. Run with -z to skip oh-my-zsh installation." >&2
    exit 1
fi

if ! which git > /dev/null; then 
    echo "ERROR: git is not installed. Install it first and re-run this script." >&2
    exit 1
fi

# directory in which this script resides 
dotdir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd $dotdir > /dev/null

# install oh-my-zsh
if [[ $* != *-z* ]]; then
    if [[ -e $HOME/.oh-my-zsh ]] || [[ -e $HOME/.ohmyzsh ]]; then
        echo "WARNING: Previous oh-my-zsh installation detected - skipping installation"
    else
        echo "Installing oh-my-zsh"
        ZSH="$dotdir/.oh-my-zsh" RUNZSH=no KEEP_ZSHRC=yes CHSH=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

        # install af-magic-dynamic theme for oh-my-zsh
        echo "Installing af-magic-dynamic theme"
        curl https://raw.githubusercontent.com/rslavin/af-magic-dynamic/master/af-magic-dynamic.zsh-theme \
        -o .oh-my-zsh/custom/themes/af-magic-dynamic.zsh-theme || echo "ERROR: Failed to install af-magic-dynamic theme" >&2
	    rm .shell.pre-oh-my-zsh > /dev/null 2>&1

        # remove newly-installed zshrc since it will be copied from $dotdir 
        rm "$HOME/.zshrc"
	    ln -s "$dotdir/.oh-my-zsh" "$HOME/.oh-my-zsh"
    fi
fi

# create empty dotfiles in home directory for those that don't already exist
# add line to load global dot file
for file in .*; do
    if [[ $file == "." || $file == ".." || $file == ".git" || $file == ".gitignore" || $file == ".zshrc.default" ]]; then
        continue
    fi

    # remove links if they exist (from implementation)
    if [[ ! -d "$HOME/$file" && -L "$HOME/$file" ]]; then
        rm "$HOME/$file" && echo "Removed '$HOME/$file' symlink"
    fi

    if [[ -d "$file" && ! -e "$HOME/$file" ]]; then
        ln -s "$dotdir/$file" "$HOME/$file"
    fi

    # move any old local files from .local to home directory
    if [[ -e "$dotdir/.local/$file" && ! -e "$HOME/$file" ]]; then
        mv "$dotdir/.local/$file" "$HOME/$file" && echo "Moved local $file to '$HOME/$file'"
    fi

    if [[ ! -e "$HOME/$file" && ! -d "$file" ]]; then
        touch "$HOME/$file"
	    #mv "$HOME/$file" "$HOME/$file.old" && echo "Backed up existing '$HOME/$file' to '$HOME/$file.old'"
    fi

    # insert line to include dotfile at the beginning of the local dotfile
    install_line="source $dotdir/$file"
    if [[ ! -d "$HOME/$file" ]]; then
        if [[ ! -s "$HOME/$file" ]]; then
            echo "$install_line" > "$HOME/$file"
        elif ! grep "$install_line" "$HOME/$file" > /dev/null; then
            sed -i "1i $install_line" "$HOME/$file" && echo "Added '$install_line' to $HOME/$file"
        fi

    fi

    if [[ -e "$dotdir/.local" && $(find "$dotdir/.local" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l) -eq 0 ]]; then
        rmdir "$dotdir/.local" && echo "Removed empty '$dotdir/.local' directory"
    fi

done

# install vim plugins
echo "Installing vim plugins"
if [[ ! -e .vim/bundle/Vundle.vim ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
fi
sed -Ei "s/^(colorscheme.*)/silent! \1/" .vimrc
vim +PluginInstall +qall
sed -Ei "s/^silent! (colorscheme.*)/\1/" .vimrc

popd >/dev/null

echo "NOTE: DejaVu Sans Mono for Powerline.ttf must be installed on the machine or ssh client machine"
echo "https://github.com/powerline/fonts/raw/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf"
echo "Done!"
