export HISTFILE=~/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export HISTTIMEFORMAT="[%F %T] "
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

export XDG_CACHE_HOME=~/.oh-my-posh
export PATH=$PATH:~/.oh-my-posh/bin
eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/s7117.omp.json)"
source ~/.dotfiles/.zshrc_custom
# CLI Tools
source ~/.cli_tools/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.cli_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/s7117/.miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/s7117/.miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/s7117/.miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/s7117/.miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

