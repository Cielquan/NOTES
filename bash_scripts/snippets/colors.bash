#!/usr/bin/env bash

# Color escape codes:
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m' # or orange - depending on termianl
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'

LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'

NC='\033[0m' # No Color

# Usage:
printf "I ${RED}love${NC} Stack Overflow\n"
echo -e "I ${RED}love${NC} Stack Overflow"

###################################################################################################

BOLD="$(tput bold 2> /dev/null || printf '')"
UNDERLINE="$(tput smul 2> /dev/null || printf '')"
BLINK="$(tput blink 2> /dev/null || printf '')"
REVERSE="$(tput rev 2> /dev/null || printf '')"

BLACK="$(tput setaf 0 2> /dev/null || printf '')"
RED="$(tput setaf 1 2> /dev/null || printf '')"
GREEN="$(tput setaf 2 2> /dev/null || printf '')"
YELLOW="$(tput setaf 3 2> /dev/null || printf '')"
BLUE="$(tput setaf 4 2> /dev/null || printf '')"
MAGENTA="$(tput setaf 5 2> /dev/null || printf '')"  # often violet
CYAN="$(tput setaf 6 2> /dev/null || printf '')"
WHITE="$(tput setaf 7 2> /dev/null || printf '')"

BLACK_BG="$(tput setab 0 2> /dev/null || printf '')"
RED_BG="$(tput setab 1 2> /dev/null || printf '')"
GREEN_BG="$(tput setab 2 2> /dev/null || printf '')"
YELLOW_BG="$(tput setab 3 2> /dev/null || printf '')"
BLUE_BG="$(tput setab 4 2> /dev/null || printf '')"
MAGENTA_BG="$(tput setab 5 2> /dev/null || printf '')"  # often violet
CYAN_BG="$(tput setab 6 2> /dev/null || printf '')"
WHITE_BG="$(tput setab 7 2> /dev/null || printf '')"

NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

print_base_colors() {
    for fg_color in {0..7}; do
        set_foreground=$(tput setaf $fg_color)
        for bg_color in {0..7}; do
            set_background=$(tput setab $bg_color)
            echo -n $set_background$set_foreground
            printf ' F:%s B:%s ' $fg_color $bg_color
        done
        echo $(tput sgr0)
    done
}
