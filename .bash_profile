eval "$(chef shell-init bash)"
#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.  Environment Configuration
#  2.  Make Terminal Better (remapping defaults and adding functionality)
#  3.  File and Folder Management
#  4.  Searching
#  5.  Process Management
#  6.  Networking
#  7.  System Operations & Information
#  8.  Web Development
#  9.  Bash Completion
#
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1. ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Change Prompt
#   ------------------------------------------------------------
    export PS1="________________________________________________________________________________\n| \w @ \h (\[\033[36m\]\u\[\033[m\]) \n| => "
    export PS2="| => "

#   Set Paths
#   ------------------------------------------------------------
    export PATH="$PATH:/usr/local/bin/"
    export PATH="/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
    export EDITOR=/usr/bin/vim

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
    export BLOCKSIZE=1k

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
#   export CLICOLOR=1
#   export LSCOLORS=ExFxBxDxCxegedabagacad


#   -----------------------------
#   2. MAKE TERMINAL BETTER
#   -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
#alias edit='sublime'                       # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.            Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }


#   -------------------------------
#   3. FILE AND FOLDER MANAGEMENT
#   -------------------------------

zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }


#   ---------------------------
#   4. SEARCHING
#   ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


#   ---------------------------
#   5. PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


#   ---------------------------
#   6. NETWORKING
#   ---------------------------

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }


#   ---------------------------------------
#   7. SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

#   ---------------------------------------
#   8. WEB DEVELOPMENT
#   ---------------------------------------

alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
    httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

#   ---------------------------------------
#   9.  Bash Completion
#   --------------------------------------
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#   ---------------------------------------
#   10. STS
#   ---------------------------------------

#   sts: Base2 Magic
#   ------------------------------------------
sts() {
    if [ $# -lt 2 ]; then
        echo "usage: sts <profile> <aws_account_id> <region (optional)>"
        return 1
    fi

    local date_time=`date +'%Y%m%d-%H%M%S'`
    local new_profile="[profile ${1}]"

    local sts_token=`aws --profile base2 \
        sts assume-role \
        --role-arn arn:aws:iam::${2}:role/base2Master \
        --role-session-name ${1} \
        --duration-seconds 3600`
    new_profile="[profile ${1}]"
    new_profile="$new_profile\naws_access_key_id=`echo $sts_token | jq -r .Credentials.AccessKeyId`"
    new_profile="$new_profile\naws_secret_access_key=`echo $sts_token | jq -r .Credentials.SecretAccessKey`"
    new_profile="$new_profile\naws_session_token=`echo $sts_token | jq -r .Credentials.SessionToken`"

    if [ $3 ]; then
        new_profile="$new_profile\nregion=$3"
    fi

    mv ~/.aws/config ~/.aws/config.$date_time.bck
    awk "
        BEGIN {found=0}
        /^ *\[(profile +)?${1} *\] *$/ {print \"$new_profile\n\"; banner=1; found=1; next}
        /^ *\[/ {banner=0}
        banner {next}
        {print}
        END {if (! found) {print \"\n$new_profile\"}}
    " ~/.aws/config.$date_time.bck | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' > ~/.aws/config
    echo "aws configuration file (~/.aws/config) is updated, previous version is backed up at ${txtpur}~/.aws/config.$date_time.bck${txtrst}"
    echo "showing the diff between previous version (${txtpur}~/.aws/config.$date_time.bck${txtrst}) and new version (~/.aws/confg)"
    echo "===================================================================================="
    git diff ~/.aws/config.$date_time.bck ~/.aws/config
    if [ $? -eq 0 ]; then
        echo "no difference between new version (~/.aws/config) and previous version (${txtpur}~/.aws/config.$date_time.bck${txtrst})"
    fi
    echo "===================================================================================="
    echo "------------------------------------------------------------------------------------"

    local record="$1,$2"
    if [ $3 ]; then
        record="$record,$3"
    fi

    if [ ! -f ~/.aws/sts ]; then
        echo "no existing ~/.aws/sts index file found, creating new ~/.aws/sts index file" && echo "$record" > ~/.aws/sts
    return 0
    fi
    mv ~/.aws/sts ~/.aws/sts.$date_time.bck
    (grep -q -E "^$1(,.+)?$" ~/.aws/sts.$date_time.bck && sed -E "s/^$1(,.+)?$/$record/" ~/.aws/sts.$date_time.bck > ~/.aws/sts) || (cat ~/.aws/sts.$date_time.bck > ~/.aws/sts && echo "$record" >> ~/.aws/sts)
    echo "sts index file (~/.aws/sts is updated, previous version is backed up at ${txtpur}~/.aws/sts.$date_time.bck${txtrst}"
    echo "showing the diff between previous version (${txtpur}~/.aws/sts.$date_time.bck${txtrst}) and new version (~/.sts/confg)"
    echo "===================================================================================="
    git diff ~/.aws/sts.$date_time.bck ~/.aws/sts
    if [ $? -eq 0 ]; then
        echo "no difference between new version (~/.aws/sts) and previous version (${txtpur}~/.aws/sts.$date_time.bck${txtrst})"
    fi
    echo "===================================================================================="

    local bckups=`ls ~/.aws/config.*.bck ~/.aws/sts.*.bck 2>/dev/null | wc -l`
    if [ $bckups -gt 100 ]; then
        echo "$bckups backups detected, you can use sts_clean to clean these if you are sure current ~/.aws/config is correct"
    fi
}

_sts()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD - 1]}
    local file=~/.aws/sts
    local profiles=$(grep -E '^\[' ~/.aws/config | awk '{print $NF}' | sed -n -e 's/^\[*\(.*\)\]$/\1/p')

    case $COMP_CWORD in
        1)
            COMPREPLY=( $(compgen -W "$profiles" -- $cur) )
            ;;
        2)
            local ids=$([[ `grep -E "^$prev( *, *[0-9]+)( *,.*)*$" $file | awk -F',' '{print NF; exit}' 2>/dev/null` > 1 ]] && (grep -E "^$prev( *, *[0-9]+)( *,.*)*$" ~/.aws/sts | cut -f2 -d"," 2>/dev/null))
            COMPREPLY=( $(compgen -W "$ids" -- $cur) )
            ;;
        3)
            local regions=$([[ `grep -E "^${COMP_WORDS[1]}( *, *[0-9]+)( *,.*)*$" $file | awk -F',' '{print NF; exit}' 2>/dev/null` > 2 ]] && (grep -E "^${COMP_WORDS[1]}( *, *[0-9]+)( *,.*)*$" ~/.aws/sts | cut -f3 -d"," 2>/dev/null))
            COMPREPLY=( $(compgen -W "$regions" -- $cur) )
            ;;
        *)
            ;;
    esac

    return 0
}

complete -F _sts sts

#   sts_clean: Base2 Magic, Cleans Up Backups
#   ------------------------------------------
sts_clean() {
    ls ~/.aws/config.*.bck 1> /dev/null 2>&1 && rm ~/.aws/config.*.bck
    ls ~/.aws/sts.*.bck 1> /dev/null 2>&1 && rm ~/.aws/sts.*.bck
}
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # Load RVM into a shell session *as a function*
