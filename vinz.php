#!/bin/bash
# Slackerc0de Family Present
# Apple Valid Checker
# 18 July 2K17
# By Malhadi Jr.
# Updated postfield

RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m' 
PUR='\033[0;35m'
GRN="\e[32m"
WHI="\e[37m"
NC='\033[0m'
echo ""
printf "$RED           ##########################   $GRN#\n"
printf "$RED           ########################    $GRN##\n"
printf "$RED           ####                       $GRN###\n"
printf "$RED           ####                      $GRN####\n"
printf "$RED           #######################   $GRN####\n"
printf "$RED           #######################   $GRN####\n"
printf "$RED                              ####   $GRN####\n"
printf "$RED                              ####   $GRN####\n"
printf "$WHI           ##########$RED     ########   $GRN####\n"
printf "$WHI           ############$RED     ######   $GRN####\n"
printf "$WHI           #####                     $GRN####\n"
printf "$WHI           #####                     $GRN####\n"
printf "$WHI           ##################    $GRN########\n"
printf "$WHI           ####################    $GRN######\n"
printf "$NC\n"
cat <<EOF
             - https://malhadijr.com -
          [+] malhadijr@slackerc0de.us [+]
        
---------------------------------------------------
    Slackerc0de Family - AppleID Validator 2017
---------------------------------------------------

EOF

usage() { 
  echo "Usage: ./myscript.sh COMMANDS: [-i <list.txt>] [-r <folder/>] [-l {1-1000}] [-t {1-10}] OPTIONS: [-d] [-c]

Command:
-i (20k-US.txt)     File input that contain email to check
-r (result/)        Folder to store the result live.txt and die.txt
-l (60|90|110)      How many list you want to send per delayTime
-t (3|5|8)          Sleep for -t when check is reach -l fold

Options:
-d                  Delete the list from input file per check
-c                  Compress result to compressed/ folder and
                    move result folder to haschecked/
-h                  Show this manual to screen

Report any bugs to: <Malhadi Jr> contact@malhadi.slackerc0de.us
"
  exit 1 
}

# Assign the arguments for each
# parameter to global variable
while getopts ":i:r:l:t:dch" o; do
    case "${o}" in
        i)
            inputFile=${OPTARG}
            ;;
        r)
            targetFolder=${OPTARG}
            ;;
        l)
            sendList=${OPTARG}
            ;;
        t)
            perSec=${OPTARG}
            ;;
        d)
            isDel='y'
            ;;
        c)
            isCompress='y'
            ;;
        h)
            usage
            ;;
    esac
done

# Assign false value boolean
# to both options when its null
if [ -z "${isDel}" ]; then
  isDel='n'
fi

if [ -z "${isCompress}" ]; then
  isCompress='n'
fi

SECONDS=0

# Asking user whenever the
# parameter is blank or null
if [[ $inputFile == '' ]]; then
  # Print available file on
  # current folder
  # clear
  tree
  read -p "Enter mailist file: " inputFile
fi

if [[ $targetFolder == '' ]]; then
  read -p "Enter target folder: " targetFolder
  # Check if result folder exists
  # then create if it didn't
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Creating $targetFolder/ folder"
    mkdir $targetFolder
  else
    read -p "$targetFolder/ folder are exists, append to them ? [y/n]: " isAppend
    if [[ $isAppend == 'n' ]]; then
      exit
    fi
  fi
else
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Creating $targetFolder/ folder"
    mkdir $targetFolder
  fi
fi

if [[ $isDel == '' ]]; then
  read -p "Delete list per check ? [y/n]: " isDel
fi

if [[ $isCompress == '' ]]; then
  read -p "Compress the result ? [y/n]: " isCompress
fi

if [[ $sendList == '' ]]; then
  read -p "How many list send: " sendList
fi

if [[ $perSec == '' ]]; then
  read -p "Delay time: " perSec
fi



malhadi_appleval() {
  SECONDS=0

  resp=`curl -s "https://appleid.apple.com/account"`
  scnt="$(echo "$resp" | grep "scnt:" | awk -F[:,] '{print $2}' | xargs)"
  sessionId="$(echo "$resp" | grep "sessionId:" | awk -F[:,] '{print $2}' | xargs)"

  check=`curl 'https://appleid.apple.com/account/validation/appleid' -H 'scnt: '$scnt'' -H 'Origin: https://appleid.apple.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'X-Apple-I-FD-Client-Info: {"U":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36","L":"en-US","Z":"GMT+08:00","V":"1.1","F":".Ga44j1e3NlY5BSo9z4ofjb75PaK4Vpjt3Q9cUVlOrXTAxw63UYOKES5jfzmkflKAmNzl998tp7ppfAaZ6m1CdC5MQjGejuTDRNziCvTDfWlVLwpS_0numypZHgfLMC7AeLd7FmrpwoNN5uQ4s5uQ3Q9cAxw63QuyPB94UXuGlfUm7qKFz0Xnj3wMvsD7z5meTuCUMz_WMXeMZlzXJJIneGffLMC7EZ3QHPBirTYKUowRslzRQqwSM2Y.htev92bp_xf7_OLgiPFMtrs1OeyjaY2_GGEQIgwe98vDdYejftckuyPBDjaY2ftckZZLQ084akJEMgbho0ApWurur.S9RdPQSzOy_Aw7UTlf_0pNA1OXuVqlriMfqjV2pNk0ug8D9ZtG1MSsMucMsHyxYMJ5tFSLDrOKq485CfUXtStKjE4PIDxO9sPrsiMTKQnlLZnjxFQUhkY5BSp.5BNlan0Os5Apw.BlQ"}' -H 'X-Apple-ID-Session-Id: '$sessionId'' -H 'Accept-Language: en-US,en;q=0.8,id;q=0.6,fr;q=0.4' -H 'X-Requested-With: XMLHttpRequest' -H 'Cookie: xp_ci=3z3dkNG7zFNPz56OzBfTzpMMBYG2Q; dssid2=35895652-613b-4b96-a7b7-00491c783170; dssf=1; as_sfa=Mnx1c3x1c3x8ZW5fVVN8Y29uc3VtZXJ8aW50ZXJuZXR8MHwwfDE=; optimizelySegments=%7B%22341793217%22%3A%22direct%22%2C%22341794206%22%3A%22false%22%2C%22341824156%22%3A%22gc%22%2C%22341932127%22%3A%22none%22%7D; optimizelyEndUserId=oeu1487308301869r0.5981164318032517; optimizelyBuckets=%7B%228188075923%22%3A%228189812274%22%7D; pxro=2; POD=us~en; ds01_a=efab5289f3bcb9c6476bc33b1338fe4bd6ec403b4e56e52784fc5bbdba9f5b95892b76474d6d8190b81dc8824078ed83273c4a645b52a6ec64dd14b4ae997ae178a1f8d8d8a29b73b5a35d35a620338cc6cee6e13bea5eb6961a459b8a71bb37GZVX; s_invisit_n2_us=0; s_vnum_n2_us=4%7C11%2C1%7C2%2C22%7C1%2C0%7C5%2C14%7C2%2C19%7C3; s_fid=77194A8BAF174694-1EA655D625C41E50; s_vi=[CS]v1|2C53286085013659-6000010B20013FDE[CE]; a=QQAVAAAACwA5tBEIMTAwMGw0UUoCMTQAAAAB; itscc=2%7C1489145361741%6014%601002; aid='$sessionId'; idclient=web; dslang=US-EN; site=USA' -H 'Connection: keep-alive' -H 'X-Apple-Api-Key: cbf64fd6843ee630b463f358ea0b707b' -H 'X-Apple-App-Id: 3810' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://appleid.apple.com/account?localang=en_US&appId=3810&returnURL=https%3A%2F%2Fidmsa.apple.com%2FIDMSWebAuth%2Flogin.html%3FappIdKey%3D95840e12d4ddf0b6b61fec49a60756ee3b89b7de8da9e2187cb9eaefca08ab1a%26path%3D%2FsignIn%26language%3DUS-EN' --data-binary '{"emailAddress":"'$1'"}' --compressed -D - -s`

  duration=$SECONDS
  header="`date +%H:%M:%S` from $inputFile to $targetFolder"
  footer="[Slackercode - AppleValid] $(($duration % 60))sec.\n"
  val="$(echo "$check" | grep -c 'used" : true')"
  inv="$(echo "$check" | grep -c 'used" : false')"
  icl="$(echo "$check" | grep -c 'appleOwnedDomain" : true')"

  if [[ $val > 0 || $icl > 0 ]]; then
    printf "[$header] $2/$3. ${ORANGE}LIVE => $1 ${NC} $footer"
    echo "LIVE => $1" >> $4/live.txt
  else
    if [[ $inv > 0 ]]; then
      printf "[$header] $2/$3. ${RED}DIE => $1 ${NC} $footer"
      echo "DIE => $1" >> $4/die.txt
    else
      printf "[$header] $2/$3. ${CYAN}UNKNOWN => $1 ${NC} $footer"
      echo "$1 => $check" >> reason.txt
      echo "UNKNOWN => $1" >> $inputFile
    fi
  fi

  printf "\r"
}



# Preparing file list 
# by using email pattern 
# every line in $inputFile
echo "[+] Cleaning your mailist file"
grep -Eiorh '([[:alnum:]_.-]+@[[:alnum:]_.-]+?\.[[:alpha:].]{2,6})' $inputFile | tr '[:upper:]' '[:lower:]' | sort | uniq > temp_list && mv temp_list $inputFile

# Finding match mail provider
echo "########################################"
# Print total line of mailist
totalLines=`grep -c "@" $inputFile`
echo "There are $totalLines of list."
echo " "
echo "Hotmail: `grep -c "@hotmail" $inputFile`"
echo "Yahoo: `grep -c "@yahoo" $inputFile`"
echo "Gmail: `grep -c "@gmail" $inputFile`"
echo "########################################"

# Extract email per line
# from both input file
IFS=$'\r\n' GLOBIGNORE='*' command eval  'mailist=($(cat $inputFile))'
con=1

echo "[+] Sending $sendList email per $perSec seconds"

for (( i = 0; i < "${#mailist[@]}"; i++ )); do
  username="${mailist[$i]}"
  indexer=$((con++))
  tot=$((totalLines--))
  fold=`expr $i % $sendList`
  if [[ $fold == 0 && $i > 0 ]]; then
    header="`date +%H:%M:%S`"
    duration=$SECONDS
    echo "[$header] Waiting $perSec second. $(($duration / 3600)) hours $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed, With $sendList req / $perSec seconds."
    sleep $perSec
  fi
  
  malhadi_appleval "$username" "$indexer" "$tot" "$targetFolder" "$inputFile" &

  if [[ $isDel == 'y' ]]; then
    grep -v -- "$username" $inputFile > "$inputFile"_temp && mv "$inputFile"_temp $inputFile
  fi
done 

# waiting the background process to be done
# then checking list from garbage collector
# located on $targetFolder/unknown.txt
echo "[+] Waiting background process to be done"
wait
wc -l $targetFolder/*

if [[ $isCompress == 'y' ]]; then
  tgl=`date`
  tgl=${tgl// /-}
  zipped="$targetFolder-$tgl.zip"

  echo "[+] Compressing result"
  zip -r "compressed/$zipped" "$targetFolder/die.txt" "$targetFolder/live.txt"
  echo "[+] Saved to compressed/$zipped"
  mv $targetFolder haschecked
  echo "[+] $targetFolder has been moved to haschecked/"
fi
#rm $inputFile
duration=$SECONDS
echo "$(($duration / 3600)) hours $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo "+==========+ Slackerc0de Family - Malhadi Jr +==========+"

