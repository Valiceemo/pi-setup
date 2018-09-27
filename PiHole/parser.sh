#!/bin/bash

VERSION = 001

TICK="[\e[32m ? \e[0m]"
INFO="[i]"

## CHECK IF GAWK INSTALLED, IF NOT INSTALL
if [ "$(dpkg-query -W -f='${Status}' gawk 2>/dev/null |  grep -c "ok installed")" -eq 0 ];
then
  echo -e " [...] \e[32m Installing gawk... \e[0m"
  apt-get install gawk -qq > /dev/null
  wait
  echo -e " ${TICK} \e[32m Finished \e[0m"  
fi

# download adblock lists
echo -e " ${INFO} \e[32m Downloading adblockplus easylist over https \e[0m"
curl -s -L https://easylist-downloads.adblockplus.org/easylist.txt > easylist.unsorted
echo -e " ${TICK} \e[32m List downloaded to ./easylist.unsorted  \e[0m"

# curl -s -L https://easylist-downloads.adblockplus.org/easyprivacy.txt > easyprivacy.unsorted
# curl -s -L https://easylist-downloads.adblockplus.org/malwaredomains_full.txt > easymalware.unsorted

# look for: ||domain.tld^
echo -e " ${INFO} \e[32m Looking for domains & sorting... \e[0m"
sort -u easylist.unsorted | grep ^\|\|.*\^$ | grep -v \/ > easylist.sorted
echo -e " ${TICK} \e[32m Done > ./easylist.sorted  \e[0m"

# remove extra chars
echo -e " ${TICK} \e[32m Done > ./easylist.sorted  \e[0m"
sed 's/[\|^]//g' < easylist.sorted > easylist.parsed
echo -e " ${TICK} \e[32m Done. List available at ./easylist.parsed  \e[0m"

# remove duplicates and files no longer needed
echo -e " ${TICK} \e[32m Tidying up and removing duplicates...  \e[0m"
gawk -i inplace '!a[$0]++' easylist.parsed
rm easylist.unsorted easylist.sorted

echo -e " ${TICK} \e[32m All clean!  \e[0m"
