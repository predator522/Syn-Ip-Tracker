#!/data/data/com.termux/files/usr/bin/bash

# Syn IP-Tracker
# Developed by: Kwesi
# WhatsApp Channel: https://whatsapp.com/channel/0029VbB4AeoF1YlZVNDXUe2v
# WhatsApp Group: https://chat.whatsapp.com/Lr2Tzrf19kaJgWg5ODKzq6

# Colors 
BLOOD_RED='\033[1;31m'
DARK_RED='\033[0;31m'
GRAY='\033[1;90m'
WHITE='\033[1;37m'
NC='\033[0m'

#  typing effect
type_text() {
    local color="$1"
    local text="$2"
    local delay=0.05
    echo -ne "$color"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo -e "$NC"
}

# Clear 
clear_screen() {
    clear
}

# Usage 
usage() {
    clear_screen
    echo -e "${BLOOD_RED}[-] Syn_IP_Tracker: Error [-]${NC}"
    type_text "${DARK_RED}" "Usage: $0 [IP_ADDRESS]"
    type_text "${GRAY}" "  - Example: $0 8.8.8.8"
    type_text "${GRAY}" "  - Enter a valid IPv4 or IPv6 address when prompted."
    exit 1
}

# Welcome 
clear_screen
echo -e "${BLOOD_RED}"
cat << 'EOF'
  ____  _      _  ______   _        
 |  _ \| |    (_) |  _ \ \ | |       
 | |_) | |     _  | |_) |\| |       
 |  _ <| |    | | |  _ <| | |       
 | |_) | |____| | | |_) |_| |       
 |____/|______|_| |____/(_|_)      
  _      _           _            
 | |    (_)         (_)           
 | |     _ _ __ ___  _ _ __   __ _ 
 | |    | | '_ ` _ \| | '_ \ / _` |
 | |____| | | | | | | | | | | (_| |
 |______|_|_| |_| |_|_|_| |_| \__, |
                             __/ |
                            |___/ 
EOF
echo -e "${DARK_RED}   |~  |~  |~  |~  |~   ${NC}"
echo -e "${DARK_RED}   |   |   |   |   |    ${NC}"
echo -e "${BLOOD_RED}=============================${NC}"
type_text "${WHITE}" "Welcome to Syn_IP_Tracker"
type_text "${GRAY}" "Forged in Code by: Kwesi"
type_text "${GRAY}" "WhatsApp Channel: https://whatsapp.com/channel/0029VbB4AeoF1YlZVNDXUe2v"
type_text "${GRAY}" "WhatsApp Group: https://chat.whatsapp.com/Lr2Tzrf19kaJgWg5ODKzq6"
echo
type_text "${DARK_RED}" "[-] Stay Ethical: Track only IPs you have permission for."
type_text "${DARK_RED}" "[-] Unauthorized use may violate laws like GDPR."
echo -e "${BLOOD_RED}=============================${NC}"
type_text "${WHITE}" "Press Enter to continue or 'q' to quit..."
read -p "" choice
if [ "$choice" = "q" ]; then
    exit 0
fi

# Usage 
clear_screen
echo -e "${BLOOD_RED}"
cat << 'EOF'
[-] HOW TO USE SYN_IP_TRACKER [-]
EOF
echo -e "${DARK_RED}   |~  |~  |~  ${NC}"
echo -e "${DARK_RED}   |   |   |   ${NC}"
echo -e "${BLOOD_RED}=============================${NC}"
type_text "${WHITE}" "1. Enter a valid IPv4 or IPv6 address (e.g., 8.8.8.8)."
type_text "${WHITE}" "2. Get geolocation: country, city, coords, timezone."
type_text "${WHITE}" "3. See ISP and network details: ISP, org, ASN."
type_text "${WHITE}" "4. Open a blood-stained map pinpointing the location."
type_text "${GRAY}" "   - Run: ./syn_ip_tracker.sh [IP] or enter IP when prompted."
type_text "${GRAY}" "   - Example: ./syn_ip_tracker.sh 8.8.8.8"
echo -e "${BLOOD_RED}=============================${NC}"
type_text "${WHITE}" "Press Enter to start tracking or 'q' to quit..."
read -p "" choice
if [ "$choice" = "q" ]; then
    exit 0
fi

# Input 
clear_screen
echo -e "${BLOOD_RED}[-] Syn_IP_Tracker: Ready to Hunt [-]${NC}"
if [ $# -eq 1 ]; then
    IP=$1
else
    type_text "${BLOOD_RED}" "Enter the IP address to track (e.g., 8.8.8.8):"
    echo -n "IP: "
    read IP
    if [ -z "$IP" ]; then
        usage
    fi
fi

#  IP validation
if ! [[ $IP =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]] && ! [[ $IP =~ ^[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}:[0-9a-fA-F]{1,4}$ ]]; then
    usage
fi
if [[ $IP =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
    if [ ${BASH_REMATCH[1]} -gt 255 ] || [ ${BASH_REMATCH[2]} -gt 255 ] || [ ${BASH_REMATCH[3]} -gt 255 ] || [ ${BASH_REMATCH[4]} -gt 255 ]; then
        usage
    fi
fi

echo -e "\n${BLOOD_RED}Tracking IP: $IP${NC}\n"

#  dependencies
if ! command -v jq &> /dev/null || ! command -v curl &> /dev/null; then
    echo -e "${DARK_RED}Error: Install curl and jq first: pkg install curl jq${NC}"
    exit 1
fi

# geolocation data
RESPONSE=$(curl -s "http://ip-api.com/json/$IP?fields=status,message,continent,continentCode,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,query")
if [ $? -ne 0 ]; then
    echo -e "${DARK_RED}Error: API request failed. Check connection or IP validity.${NC}"
    exit 1
fi

#  JSON parsing
STATUS=$(echo "$RESPONSE" | jq -r '.status' 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$STATUS" ]; then
    echo -e "${DARK_RED}Error: Failed to parse API response.${NC}"
    exit 1
fi
if [ "$STATUS" != "success" ]; then
    echo -e "${DARK_RED}Error: $(echo "$RESPONSE" | jq -r '.message')${NC}"
    exit 1
fi

# results
echo -e "${BLOOD_RED}=== Geolocation Data ===${NC}"
echo -e "${WHITE}Country: ${GRAY}$(echo "$RESPONSE" | jq -r '.country')${NC}"
echo -e "${WHITE}Region: ${GRAY}$(echo "$RESPONSE" | jq -r '.regionName')${NC}"
echo -e "${WHITE}City: ${GRAY}$(echo "$RESPONSE" | jq -r '.city')${NC}"
echo -e "${WHITE}ZIP: ${GRAY}$(echo "$RESPONSE" | jq -r '.zip')${NC}"
echo -e "${WHITE}Latitude: ${GRAY}$(echo "$RESPONSE" | jq -r '.lat')${NC}"
echo -e "${WHITE}Longitude: ${GRAY}$(echo "$RESPONSE" | jq -r '.lon')${NC}"
echo -e "${WHITE}Timezone: ${GRAY}$(echo "$RESPONSE" | jq -r '.timezone')${NC}"

echo -e "\n${BLOOD_RED}=== Network Intel ===${NC}"
echo -e "${WHITE}ISP: ${GRAY}$(echo "$RESPONSE" | jq -r '.isp')${NC}"
echo -e "${WHITE}Organization: ${GRAY}$(echo "$RESPONSE" | jq -r '.org')${NC}"
echo -e "${WHITE}ASN: ${GRAY}$(echo "$RESPONSE" | jq -r '.as')${NC}"

# Google Maps link
echo -e "\n${BLOOD_RED}=== Blood Map Target ===${NC}"
LAT=$(echo "$RESPONSE" | jq -r '.lat')
LON=$(echo "$RESPONSE" | jq -r '.lon')
CITY=$(echo "$RESPONSE" | jq -r '.city')
ISP=$(echo "$RESPONSE" | jq -r '.isp')
MAP_URL="https://www.google.com/maps/place/$LAT,$LON/@$LAT,$LON,14z/data=!3m1!1e3?entry=ttu&q=$CITY+$ISP"
echo -e "${WHITE}Open in browser: ${GRAY}$MAP_URL${NC}"

# Browser options
if command -v termux-open-url &> /dev/null; then
    type_text "${BLOOD_RED}" "Open map in default browser? (y/n):"
    echo -n " "
    read -p "" choice
    if [ "$choice" = "y" ]; then
        termux-open-url "$MAP_URL"
    fi
elif command -v lynx &> /dev/null; then
    type_text "${BLOOD_RED}" "Open map in lynx? (y/n):"
    echo -n " "
    read -p "" choice
    if [ "$choice" = "y" ]; then
        lynx "$MAP_URL"
    fi
else
    echo -e "${DARK_RED}Install termux-api or lynx to open URLs directly: pkg install termux-api lynx${NC}"
fi
