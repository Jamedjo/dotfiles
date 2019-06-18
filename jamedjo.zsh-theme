ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}|%{$fg_no_bold[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_no_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="➦"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}✘ %{$fg_no_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_RENAMED="ᐅ "
ZSH_THEME_GIT_PROMPT_MODIFIED="±"
ZSH_THEME_GIT_PROMPT_ADDED="⚡"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_STAGED="s"
ZSH_THEME_GIT_PROMPT_UNSTAGED="u"
ZSH_THEME_GIT_PROMPT_UNTRACKED="?"
ZSH_THEME_GIT_PROMPT_SUFFIX=""

prompt_colour_from_return_status="%(?:%{$fg_bold[green]%}:%{$fg_no_bold[red]%})"
PROMPT='%{$fg_no_bold[white]%}%1~$(git_prompt_info)$(git_prompt_status)${prompt_colour_from_return_status}»%{$reset_color%} '

#●●  ›  ⚡✔"
#%{$fg_bold[red]%}⇒ %{$fg_bold[red]%} ➜ " 
#RPROMPT='<right prompt'

