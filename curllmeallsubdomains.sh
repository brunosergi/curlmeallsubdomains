#!/bin/bash
################INFO#################
# Title: cURL me all Subdomains 
# Author: Bruno Sergio
############REQUIREMENTS#############
# Anew: go install -v github.com/tomnomnom/anew@latest
# Jq:   apt-get install -y jq
################USAGE################
# Eg.: ./curlmeallsubdomains.sh google.com

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
purple=`tput setaf 5`
reset=`tput sgr0`

tput civis

function ctrl_c(){
  echo -e "${red}\n[!] Ctrl + C pressed. Script ended...${reset}\n"
  tput cnorm; exit 1
}
trap ctrl_c INT

function banner(){
echo "${purple}                                                                              
 ▄▄· ▄• ▄▌▄▄▄  ▄▄▌      • ▌ ▄ ·. ▄▄▄ .     ▄▄▄· ▄▄▌  ▄▄▌  
▐█ ▌▪█▪██▌▀▄ █·██•      ·██ ▐███▪▀▄.▀·    ▐█ ▀█ ██•  ██•  
██ ▄▄█▌▐█▌▐▀▀▄ ██▪      ▐█ ▌▐▌▐█·▐▀▀▪▄    ▄█▀▀█ ██▪  ██▪  
▐███▌▐█▄█▌▐█•█▌▐█▌▐▌    ██ ██▌▐█▌▐█▄▄▌    ▐█ ▪▐▌▐█▌▐▌▐█▌▐▌
·▀▀▀  ▀▀▀ .▀  ▀.▀▀▀     ▀▀  █▪▀▀▀ ▀▀▀      ▀  ▀ .▀▀▀ .▀▀▀ 
.▄▄ · ▄• ▄▌▄▄▄▄· ·▄▄▄▄       • ▌ ▄ ·.  ▄▄▄· ▪   ▐ ▄ .▄▄ · 
▐█ ▀. █▪██▌▐█ ▀█▪██▪ ██▪     ·██ ▐███▪▐█ ▀█ ██ •█▌▐█▐█ ▀. 
▄▀▀▀█▄█▌▐█▌▐█▀▀█▄▐█· ▐█▌▄█▀▄ ▐█ ▌▐▌▐█·▄█▀▀█ ▐█·▐█▐▐▌▄▀▀▀█▄
▐█▄▪▐█▐█▄█▌██▄▪▐███. ██▐█▌.▐▌██ ██▌▐█▌▐█ ▪▐▌▐█▌██▐█▌▐█▄▪▐█
 ▀▀▀▀  ▀▀▀ ·▀▀▀▀ ▀▀▀▀▀• ▀█▄▀▪▀▀  █▪▀▀▀ ▀  ▀ ▀▀▀▀▀ █▪ ▀▀▀▀                                                                
${reset}"
echo -e "\t\t${yellow}  created by bruno sergio${reset}\n\n"
}

function modules(){
  discover
  echo
}

function discover(){
  echo "${green}[+] cURL subdomains from BufferOver.run...${reset}"
  curl -s https://dns.bufferover.run/dns?q=.$domain | jq -r .FDNS_A[] | cut -d',' -f2 | grep "$domain" | grep -v "*" | sed -e 's/^[[:punct:]]//g' | sed -r '/^\s*$/d' | anew $subdomains

  echo "${green}[+] cURL subdomains from Crt.sh...${reset}"
  curl -s "https://crt.sh/?q=%.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | grep "$domain" | grep -v "*" | sed -e 's/^[[:punct:]]//g' | sed -r '/^\s*$/d' | anew $subdomains

  echo "${green}[+] cURL subdomains from CertSpotter...${reset}"
  curl -s "https://certspotter.com/api/v1/issuances?domain=$domain&include_subdomains=true&expand=dns_names" | jq .[].dns_names | tr -d '[]"\n ' | tr ',' '\n' | grep "$domain" | grep -v "*" | sed -e 's/^[[:punct:]]//g' | sed -r '/^\s*$/d' | anew $subdomains

  echo "${green}[+] cURL subdomains from JLDC...${reset}"
  curl -s "https://jldc.me/anubis/subdomains/$domain" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | grep "$domain" | grep -v "*" | sed -e 's/^[[:punct:]]//g' | sed -r '/^\s*$/d' | anew $subdomains

  echo "${green}[+] cURL subdomains from RapidDNS.io...${reset}"
  curl -s "https://rapiddns.io/subdomain/$domain?full=1#result" | grep -v "RapidDNS" | grep -v "<td><a" | cut -d '>' -f 2 | cut -d '<' -f 1 | grep "$domain" | grep -v "*" | sed -e 's/^[[:punct:]]//g' | sed -r '/^\s*$/d' | anew $subdomains

  echo "${green}[+] cURL subdomains from Riddler.io...${reset}"
  curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | grep "$domain" | grep -v "*" | sed -e 's/^[[:punct:]]//g' | sed -r '/^\s*$/d' | anew $subdomains

  echo "${green}[+] cURL subdomains from sonar.omnisint.io...${reset}"
  curl --silent https://sonar.omnisint.io/subdomains/$domain | grep -oE "[a-zA-Z0-9._-]+\.$domain" | grep "$domain" | grep -v "*" | sed -e 's/^[[:punct:]]//g' | sed -r '/^\s*$/d' | anew $subdomains

  echo "${green}[+] cURL subdomains from synapsint.com...${reset}"
  curl -s -X POST https://synapsint.com/report.php -d "search=$domain&btnradio=1" | grep -oE "[a-zA-Z0-9._-]+\.$domain" | grep "$domain" | grep -v "*" | sed -e 's/^[[:punct:]]//g' | sed -r '/^\s*$/d' | anew $subdomains
}

main(){
  if [ -f "./curlme-$domain.txt" ]; then
    echo -e "${red}[!] Apparently you've already searched subdomains on this target.${reset}"
    echo -e "${red}[!] File '$(pwd)/curlme-$domain.txt' already exists.\n"
    tput cnorm; exit 1
  else
    touch ./curlme-$domain.txt
  fi
  subdomains="./curlme-$domain.txt"

  modules

  echo "[~] The process was done. A total of ${yellow}$(wc -l $subdomains | awk '{print $1}')${reset} subdomains were found."
  echo "[~] You can access the results at: ${yellow}$subdomains${reset}"
  tput cnorm; exit 0
}

banner
rawdomain=$1
domain=$(sed -e s/'http[s]\?:\/\/'// -e "s/\/$//" <<< $rawdomain)

if [ $# -lt 1 ]; then
  echo -e "${red}[!] You need to enter a target domain.${reset}"
  echo "Usage: ./curlmeallsubdomains.sh <domain>"
  tput cnorm; exit 1
else
  if [ $# -ge 2 ]; then
    echo -e "${red}[!] You supplied more than 2 arguments.${reset}"
    echo "Usage: ./curlmeallsubdomains.sh <domain>"
    tput cnorm; exit 1
  fi
fi

main $domain
