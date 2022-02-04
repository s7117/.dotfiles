HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/s7117.omp.json)"
source ~/.dotfiles/.zshrc_custom

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/psc/.miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/psc/.miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/psc/.miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/psc/.miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Exports
export fpath=(/home/psc/.cli_tools/zsh-completions/src $fpath)

# CLI Tools
source ~/.cli_tools/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.cli_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.cli_tools/zsh-completions/zsh-completions.plugin.zsh
