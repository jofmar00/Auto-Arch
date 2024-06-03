#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias ls='exa --group-directories-first'
alias grep='grep --color=auto'
alias cat='bat --style plain --paging=never'
alias tree='exa -T'
PS1='[\u@\h \W]\$ '


export PATH=$PATH:/home/${USER}/.local/bin
neofetch --colors 5 7 7 2 7 7 --ascii_colors 2 2
eval "$(starship init bash)"
