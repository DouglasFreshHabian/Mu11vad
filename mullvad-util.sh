#!/bin/bash

# Define color escape codes
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
RESET='\e[0m'
CYAN='\e[1;36m'
PURPLE='\e[1;35m'
WHITE='\e[1;37m'

# Array of color names
allcolors=("RED" "GREEN" "YELLOW" "BLUE" "CYAN" "PURPLE" "WHITE")

# Function to print banner with a random color
ascii_banner() {

    # Pick a random color from the allcolors array
    random_color="${allcolors[$((RANDOM % ${#allcolors[@]}))]}"

    # Convert the color name to the actual escape code
    case $random_color in
        "RED") color_code=$RED ;;
        "GREEN") color_code=$GREEN ;;
        "YELLOW") color_code=$YELLOW ;;
        "BLUE") color_code=$BLUE ;;
        "CYAN") color_code=$CYAN ;;
        "PURPLE") color_code=$PURPLE ;;
        "WHITE") color_code=$WHITE ;;
    esac


##########################################
#--------) Display ASCII banner (--------#
##########################################
   # Print the banner in the chosen color
    echo -e "${color_code}"
    cat << "EOF"


          ...............................        
         .................................        
       ....................................       
      ....................,:cc:;'...........      
     .................'cOd0KKKKKK0d;.........     
     ..............,;;lOKx0KKKKKKKKKx........     
     ....lxolllllllcclox0KKKKKKKKKKKK........     
     ....'codddddddddddlcld0KKKKKKKKl........     
     .......;dddddddddddddocloodk0K:.........     
     .........,lddddddddddddddddoc,..........     
     ............;ldddollcloddddddl..........     
     .............,dooodddddddddddd..........     
     ............,lddddddddddddddddl'........     
      ..........'lddddddddddddddddddc........     
      .............,:clodddddool:;'.........      
         .................................        
                                            
                   _ _                _       _     
   _ __ ___  _   _| | |_   ____ _  __| |  ___| |__  
  | '_ ` _ \| | | | | \ \ / / _` |/ _` | / __| '_ \ 
  | | | | | | |_| | | |\ V / (_| | (_| |_\__ \ | | |
  |_| |_| |_|\__,_|_|_| \_/ \__,_|\__,_(_)___/_| |_|
        https://github.com/DouglasFreshHabian          
                                                                     

EOF
    echo -e "${RESET}"  # Reset color
}

# 

# Function to log output
log_output() {
  if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
  fi
  echo "$1" >> "$LOG_FILE"
}

# Function to spawn Xterm window with nmcli monitor and lolcat                                                                                  
spawn_xterm() {                                                                                                                                 
  # Spawn Xterm with nmcli monitor | lolcat -a                                                                                                                           
  xterm -bg black -fg white -e "mullvad status listen | lolcat -a" &                                                                                                                                 
  sleep 2  # Give Xterm some time to start                                                                                                                               
                                                                                                                                                                              
  # Use wmctrl to resize and position the window (quarter of screen)                                                                                                          
  wmctrl -r :ACTIVE: -e 1,600,600,400,400  # Adjust values as needed (800x600 for 1/4 screen)                                                                                     
}               


# Display Help Menu
help_menu() {
  # Display the ASCII banner first
  ascii_banner

  # Display the help information
  echo -e "\e[1;34mUsage\e[0m: \e[1;36m./mullvad-util.sh\e[0m \e[1;33m[OPTION]\e[0m"
  echo -e "\e[0;31m\nOptions:\e[0m"
  echo -e "\e[1;37m\t-h, --help\t\t\tShow this help menu."
  echo -e "\e[1;37m\t-a, --any\t\t\tRandomnize the new relay using any available in the world."
  echo -e "\e[1;37m\t-s, --specific\t\t        Switch to any relay in country of choosing."
  echo -e "\e[1;37m\t-c, --codes\t\t\tFetch all available country codes for mullvad servers."
  echo -e "\e[1;37m\t-v, --about\t\t\tDisplay script information.\e[0m"
  echo -e "\e[1;37m\t-l, --log\t\t\tDisplay information about the mullvad-util.sh utility."
  echo -e "\e[1;37m\t-i, --ascii\t\t\tDisplay the ASCII banner.\e[0m"
  echo
  echo -e "\e[1;33m*****************************************************************\e[0m"
  echo -e "\e[1;34m**********************************\e[0m"
  echo -e "\e[1;32m*****************************************************************************\e[0m"
  echo -e "\e[1;35m*********************************************\e[0m"
  echo -e "\e[1;31m****************************************************************\e[0m"

  # Display dependencies
  echo -e "\e[1;34mDependencies required for this script:\e[0m"
  echo -e "\e[1;31m1.${RESET} ${GREEN}mullvad${RESET}  ${YELLOW}(${RESET}${WHITE}Mullvad VPN client${RESET}${YELLOW})\e[0m"
  echo -e "\e[1;31m2.${RESET} ${GREEN}wmctrl${RESET}  ${YELLOW}(${RESET}${WHITE}Window manager utility${RESET}${YELLOW})\e[0m"
  echo -e "\e[1;31m3.${RESET} ${GREEN}lolcat${RESET}  ${YELLOW}(${RESET}${WHITE}For entertaining output${RESET}${YELLOW})\e[0m"
  echo -e "\e[1;31m4.${RESET} ${GREEN}jp2a${RESET}  ${YELLOW}(${RESET}${WHITE}For displaying ASCII images${RESET}${YELLOW})\e[0m"
  echo -e "\e[1;31m5.${RESET} ${GREEN}xterm${RESET}  ${YELLOW}(${RESET}${WHITE}For displaying ASCII images${RESET}${YELLOW})\e[0m"

  exit 0
}

# Function for any_relay
any_relay() {

spawn_xterm

 echo -e "${GREEN}Setting mullvad relay location to any server in the world.${RESET}"
 echo -e "${WHITE}"
 mullvad relay set location any
 echo -e "${RESET}"
 echo
 echo -e "${GREEN}Running mullvad relay get to list all constraints${RESET}"
 echo -e "${WHITE}"
 mullvad relay get
 echo
 echo -e "${RESET}"
 echo -e "${GREEN}Running 'mullvad status -v' to get the current status.${RESET}"
 mullvad status -v | lolcat -a
 echo
 echo -e "${GREEN}Running 'mullvad status -j' to print the current status in JSON.${RESET}"
 mullvad status -j | lolcat -a
 echo

# Display ASCII art after successfull relay randomization
jp2a --height=20 --width=40  --colors /home/douglas/Mu11v@d/mullvad.png

 exit 0
}

# function to fetch all country codes
codes() {

echo -e "${RED}Fetching All Availble Country Codes...${RESET}"
echo
cat codes.txt | lolcat

echo
echo -e "${BLUE}Run${RESET} ./${YELLOW}mullvad-util.sh${RESET} ${CYAN}--specific${RESET} & ${WHITE}when prompted, ${GREEN}enter${RESET} the ${RED}country code${RESET} ${WHITE}of your choice.${RESET}"
echo
echo -e "${BLUE}For Example${RESET}: ${PURPLE}./mullvad-util.sh${RESET} ${CYAN}--specific ${WHITE}[${RESET}${CYAN}se${WHITE}] ${RESET}"
exit 0
}

# Function for specific_relay
specific_relay() {
 
spawn_xterm
 echo -e "${WHITE}"
 read -p  "Please specify a country code: " COUNTRY
 echo -e "${RESET}"
 echo -e "${GREEN}Setting mullvad relay location to any server in the country of $COUNTRY.${RESET}"
 echo -e "${WHITE}"
 mullvad relay set location $COUNTRY || { log_error "Error: Failed to set Mullvad relay location to $COUNTRY."; echo -e "${RED}Error: Failed to set relay location.${RESET}"; exit 1; }
 echo -e "${RESET}"
 echo
 echo -e "${GREEN}Running mullvad relay get to list all constraints${RESET}"
 echo -e "${WHITE}"
 mullvad relay get
 echo
 echo -e "${RESET}"
 echo -e "${GREEN}Running 'mullvad status -v' to get the current status.${RESET}"
 mullvad status -v | lolcat -a
 echo
 echo -e "${GREEN}Running 'mullvad status -j' to print the current status in JSON.${RESET}"
 mullvad status -j | lolcat -a
 echo

 exit 0
}

# Function to display script info
about_menu() {
  echo -e "${BLUE}Script Name:${RESET}   ${YELLOW}mullvad-util.sh${RESET}"
  echo -e "${RED}Version:${RESET}       ${WHITE}1.1${RESET}"
  echo -e "${PURPLE}Author:${RESET}        ${YELLOW}Douglas Habian${RESET}"
  echo -e "${GREEN}Repo:${RESET}          ${WHITE}https://github.com/DouglasFreshHabian/Mu11vad.git${RESET}"
  exit 0
}


# Set logging file with date
LOG_FILE="mullvad_log_$(date +'%Y-%m-%d').log"

# Initialize LOGGING as false by default
LOGGING=false

# Parse command-line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--any)
      any_relay
      shift
      ;;
    -s|--specific)
      specific_relay
      shift
      ;;
    -c|--codes)
      codes
      shift
      ;;
    -l|--log)
      LOGGING=true
      echo -e "\e[1;34mLogging enabled. Logs will be saved to $LOG_FILE.\e[0m"
      shift
      ;;
    -i|--ascii)
      ascii_banner
      shift
      ;;
    -h|--help)
      help_menu
      ;;
    -v|--about)
      about_menu
      shift
      ;;
    *)
      echo -e "\e[1;31mInvalid option: $1\e[0m"
      exit 1
      ;;
  esac
done
