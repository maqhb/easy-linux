#!/bin/bash

HEIGHT=17
WIDTH=45
CHOICE_HEIGHT=8
BACKTITLE="OS Lab Project"
MENU="Select one of the following Options:"

split(){
IFS='|'
read -ra ADDR <<< "$1"
for i in "${ADDR[@]}"; do # access each element of array
    echo "$i" >> Playlist.m3u 
done
}

update(){
    TITLE="UPDATE"
dialog \
		  --title "$TITLE" \
		  --backtitle "$BACKTITLE / Upgrade" \
		  --yesno "do you want to Upgrade your System?" 6 35;
if [ "$?" -eq 0 ]; then 
		  clear;
		  printf "==========================================\n| Updating System                        |\n==========================================\n";
		  sudo apt-get update && sudo apt-get dist-upgrade;
		  printf "\nPress Enter to return to the program.\n";
		  read
		      elif [ "$?" -eq 1 ]; then
		  dialog \
		  --backtitle "$BACKTITLE / Upgrade" \
		  --infobox "cancelled..." 3 15;
		  sleep 1;
		      fi
		  
}

searchOrInstallSoftware(){
    while [[ 1 ]]
		  do
		    clear;
		    TITLE="Search & Install Software"
		    OPTIONS=(1 "Search for Software"
				 2 "Install Software")
			CHOICE=$(dialog --clear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty) 
		  if [ "$?" -eq 0 ]; then 
			clear;
		  case $CHOICE in
		    1) #Search Repository
			FILE=$(dialog --clear \
			--title "Search" \
			--stdout \
			--backtitle "$BACKTITLE / Search Repository" \
			--inputbox "Search the Repository for Programs:"  7 40) ;
		  if [ "$?" -eq 0 ]; then
			  printf "TIP! - Use the arrow keys 'up, down, left & right' to scroll,!\n------------------------------\n" > /tmp/space.txt;
			  apt-cache search $FILE >> /tmp/space.txt;
			  dialog --clear \
			  --backtitle "$BACKTITLE / Search Repository" \
			  --title "$TITLE" \
			  --textbox /tmp/space.txt 20 90;
		  elif [ "$?" -eq 1 ]; then
			  dialog \
			  --infobox "cancelled..." 3 15;
			  sleep 1;
		  fi
			;;
		    2) ##Install Software
			INSTL=$(dialog --clear \
			--title "Search" \
			--stdout \
			--backtitle "$BACKTITLE / Install Software" \
			--inputbox "Type in a Software Name to install something:"  7 40) ;
			if [ "$?" -eq 0 ]; then ##inputbox Okay
			    clear;
			    dialog \
			      --title "$TITLE" \
			      --backtitle "$BACKTITLE / Remove Software" \
			      --yesno "Do you really want to install\n$INSTL ?" 7 30 ;
			      if [ "$?" -eq 0 ]; then ##YESNO Install YES
				clear;
				sudo apt-get install $INSTL;
				printf "\nPress Enter to Return to the Program\n";
				read
			      elif [ "$?" -eq 1 ]; then ##YESNO Install NO
				dialog \
			      --infobox "cancelled..." 3 15;
			      sleep 1;
			      fi ##YESNO end 
			elif [ "$?" -eq 1 ]; then ##inputbox cancel
			    dialog \
			      --infobox "cancelled..." 3 15;
			    sleep 1;
			fi ##inputbox end
			;;
		    esac
		  elif [ "$?" -eq 1 ]; then ##inputbox Cancel
			  break;
		  fi
		  done
}

removeSoftware(){

    TITLE="Remove Software"
		  PROGRAM=$(dialog \
		  --title "$TITLE" \
		  --backtitle "$BACKTITLE / Remove Software" \
		  --stdout \
		  --inputbox "Type in a Software Name to remove something:" 7 40) ;
		  if [ "$?" -eq 0 ]; then 
		      dialog --clear \
			     --title "$TITLE" \
			     --backtitle "$BACKTITLE / Remove Software" \
			     --yesno "Do you really want to remove $PROGRAM ?" 6 30 ;
			  if [ "$?" -eq 0 ]; then 
			  clear;
			  sudo apt-get remove --purge $PROGRAM;
			  printf "\nPress Enter to Return to the Program\n";
			  read
			  elif [ "$?" -eq 1 ]; then
			  dialog \
			  --infobox "cancelled..." 3 15;
			  sleep 1;
			  fi
		  elif [ "$?" -eq 1 ]; then
		  dialog \
		      --infobox "cancelled..." 3 15;
		  sleep 1;
		  fi
}

runCommand(){
    TITLE="Run Command"
    while [[ 1 ]]
			  do
			  COMMAND=$(dialog --clear \
					   --title "$TITLE" \
					   --stdout \
					   --backtitle "$BACKTITLE / Run Command" \
					   --inputbox "Enter Command:"  7 40)
			  if [ "$?" -eq 0 ]; then 
			  clear;
			  $COMMAND
			  printf "\nPress Enter to return to the program.\n";
			  read
			  elif [ "$?" -eq 1 ]; then 
			    break;
			  fi
			  done
}

computerMaintenance(){
    TITLE="Computer Maintenance"
        while [[ 1 ]]
	do
	OPTIONS=(1 "Update"
                   2 "Search & Install Software"
                   3 "Remove Software"
                   4 "Run Command"
                   )

          CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)


if [ "$?" -eq 0 ]; then 
case $CHOICE in 
1) update
    ;;
2) searchOrInstallSoftware
;;
3) removeSoftware
;;
4) runCommand
;;
  esac
  elif [ "$?" -eq 1 ]; then 
			    break;
  fi
  done
}


music(){
    clear;
TITLE="Music Player"
	while [[ 1 ]]
do
OPTIONS=(1 "Add files to playlist"
         2 "Clear Playlist"
         3 "Play"
	 4 "List Playlist")

         CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

if [ "$?" -eq 0 ]
       	then 
	case $CHOICE in
1)
	selectedFile=$(zenity --file-selection --file-filter="MP3 Files | *.mp3" --multiple);
	split "$selectedFile";
	;;
2)	
	echo "" > Playlist.m3u;
	;;
3)
	if [ -s "Playlist.m3u" ] && [ "$( cat Playlist.m3u | wc -w )" != 0 ]
	then
		mplayer -noautosub -playlist Playlist.m3u
	else
	zenity --error --text="No Songs in playlist";
	fi
	;;
4)
	while IFS= read -r line;do
		echo "${line##*/}" >> list
	done < Playlist.m3u
	dialog --clear --textbox list 50 100
	echo "" > list
esac
elif [ "$?" -eq 1 ]; then
	break;
fi
done
}


systemMonitor(){
	while [[ 1 ]]
        do
            clear;
            HEIGHT=17
            WIDTH=45
            CHOICE_HEIGHT=10
            BACKTITLE="OS Lab Project / System Monitor"
            TITLE="System Monitor"
            MENU="Select one of the following Options:"

            OPTIONS=(1 "Disk Space"
                     2 "USB Devices"
                     3 "PCI / Graphics Card Info"
                     4 "RAM Info"
                     5 "Process Manager"
                     6 "Battery/Power Info"
                     7 "CPU Info"
                     8 "Network Info"
                     9 "Kernel Info"
                     10 "Next Page →")

	MENU=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
                if [ "$?" -eq 0 ]; then ##Okay System Monitor
                    case $MENU in
                    1) ##Disk Space
                    df -h > '/tmp/space.txt';
                    dialog --clear \
                    --backtitle "$BACKTITLE / Disk Space" \
                    --title "$TITLE" \
                    --textbox /tmp/space.txt 20 75;
                    clear;
                    ;;
                    2) ##USB Devices
                    lsusb > '/tmp/space.txt';
                    dialog --clear \
                    --backtitle "$BACKTITLE / Connected USB Devices" \
                    --title "USB Devices" \
                    --textbox /tmp/space.txt 20 85;
                    clear;
                    ;;

		    3) ##PCI
                    printf "TIP! - You can use the arrow keys 'up, down, left & right' to scroll!\n" > /tmp/space.txt;
                    lspci >> '/tmp/space.txt';
                    dialog --clear \
                    --backtitle "$BACKTITLE / PCI & Graphics Card Information" \
                    --title "PCI Devices" \
                    --textbox /tmp/space.txt 20 150;
                    clear;
                    ;;
                    4) ##RAM
                    free -h > '/tmp/space.txt';
                    dialog --clear \
                    --backtitle "$BACKTITLE / RAM Information" \
                    --title "Memory Information" \
                    --textbox /tmp/space.txt 10 84;
                    clear;
                    ;;
                    5) ##process Manager
                    while [[ 1 ]]
                    do
                    clear;
                    HEIGHT=12
                    WIDTH=40
                    CHOICE_HEIGHT=5
                    BACKTITLE="OS Lab Project / System Monitor / Process Manager"
                    TITLE="PMP - Process Manager 0.0.2"
                    MENU="Select one of the following Options:"

		    OPTIONS=(1 "List Processes by CPU Usage"
                            2 "List Processes by ID"
                            3 "Kill Process by ID"
                            4 "Kill Process by Name"
                            5 "Kill with Mouse cursor")


			  CHOICE=$(dialog --clear \
                                    --backtitle "$BACKTITLE" \
                                    --title "$TITLE" \
                                    --menu "$MENU" \
                                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                    "${OPTIONS[@]}" \
                                    2>&1 >/dev/tty)
                    if [ "$?" -eq 0 ]; then
                    case $CHOICE in
                      1)
                      dpkg -s htop &> /dev/null; #Check's if htop is installed
                      if [ "$?" -eq 0 ]; then #htop installed
                      clear
                      printf "Hit 'Q' to return to the Program...\n";
                      sleep 2.1
                      clear;
                      htop
                      elif [ "$?" -eq 1 ]; then #htop not installed
                dialog \
                --title "$TITLE" \
                --backtitle "$BACKTITLE" \
                --yesno "Htop is not installed.\nDo you want to install htop?" 6 33;
                    if [ "$?" -eq 0 ]; then #Yes Install htop
                        clear;
                        sudo apt-get install htop;
                    elif [ "$?" -eq 1 ]; then #No Install htop
                        clear;
                        dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
                        sleep 1.2;
                    fi
                      fi
                      ;;
		      2)
                      printf "TIP! - You can use the arrow keys 'up, down, left & right' to scroll!\n" > /tmp/space.txt;
                      ps -ef >> /tmp/space.txt;
                      dialog --clear \
                            --backtitle "$BACKTITLE / List Processes by ID" \
                            --title "Processes by ID" \
                            --textbox /tmp/space.txt 25 150;
                            clear;
                      ;;
                      3)
                      PID=$(dialog \
                            --title "$TITLE" \
                            --backtitle "$BACKTITLE / Kill Process by ID" \
                            --stdout \
                            --inputbox "Type in a valid PID to kill it:" 7 40)
                            if [ "$?" -eq 0 ]; then
                      kill $PID
                      dialog \
                      --backtitle "$BACKTITLE" \
                      --infobox "Process ID $PID killed" 3 32;
                      sleep 2;
                          elif [ "$?" -eq 1 ]; then
                          clear;
                          fi
                      ;;
                      4)
                      prc=$(dialog \
                            --title "$TITLE" \
                            --backtitle "$BACKTITLE / Kill Process by Name" \
                            --stdout \
                            --inputbox "Type in a Process you want to kill a.e 'firefox':" 7 40)
                            if [ "$?" -eq 0 ]; then
                      dialog --clear \
			      --title "$TITLE" \
                            --backtitle "$BACKTITLE / Kill Process by Name" \
                            --yesno "Do you really want to kill '$prc'?" 5 45;
                            if [ "$?" -eq 0 ]; then
                            killall $prc;
                            elif [ "$?" -eq 1 ]; then
                            dialog --infobox "cancelled..." 3 16;
                                sleep 1.2;
                            fi
                            elif [ "$?" -eq 1 ]; then
                            clear;
                            fi
                      ;;
                      5)
                      clear;
                      printf "Cancel Action with right Click!\n"
                      xkill
                      ;;
                    esac
                    elif [ "$?" -eq 1 ]; then
                    break;
                    fi
                    done
                    ;;
                    6)
                    dpkg -s acpi &> /dev/null; #Check's if Acpi is installed
                if [ "$?" -eq 0 ]; then #Acpi installed
                    while [[ 1 ]]
                    do
                    HEIGHT=12
                    WIDTH=40
CHOICE_HEIGHT=2
                    TITLE="Battery & Power"
                    BACKTITLE="OS Lab Project / System Monitor / Battery & Power Info"
                    MENU="Select one:"
                    OPTIONS=(1 "Power Status"
                             2 "Show more Info")
                    CHOICE=$(dialog --clear \
                                    --backtitle "$BACKTITLE" \
                                    --title "$TITLE" \
                                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)
                        if [ "$?" -eq 0 ]; then ##okay Battery & Power Info
                            case $CHOICE in
                            1) #Power Status
                            acpi > '/tmp/space.txt'
                            dialog --clear \
                                   --backtitle "OS Lab Project / System Monitor / Battery & Power Info / Power Status" \
                                   --title "$TITLE" \
                                   --textbox /tmp/space.txt 5 100;
                            clear;
                            ;;
                            2) #Show more Info
                            acpi -b -a -t > '/tmp/space.txt'
                            dialog --clear \
                                   --backtitle "OS Lab Project / System Monitor / Battery & Power Info / More Battery Information" \
                                  --title "$TITLE" \
                                  --textbox /tmp/space.txt 8 55;
                            clear;
                            ;;
                            esac
                        elif [ "$?" -eq 1 ]; then ##Cancel Battery & Power Info
break;
                            fi
                        done
                    elif [ "$?" -eq 1 ]; then #Acpi not installed
                        BACKTITLE="OS Lab Project / System Monitor / Battery & Power Info"
                            clear;
                        dialog --title "System Monitor" \
                               --backtitle "$BACKTITLE" \
                               --yesno "Acpi is not installed.\nDo you want to install Acpi?" 6 33;
                            if [ "$?" -eq 0 ]; then #Yes Install Acpi
                                clear;
                                sudo apt-get install acpi;
                            elif [ "$?" -eq 1 ]; then #No Install Acpi
                                dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
                                sleep 1.2;
                                clear;
                            fi
                fi
                    ;;
                    7) ##System Monitor / CPU INFO
                    while [[ 1 ]]
                      do
                    HEIGHT=12
                    WIDTH=40
                    CHOICE_HEIGHT=3
                    BACKTITLE="OS Lab Project / System Monitor / CPU Info"
                    TITLE="$TITLE"
                    MENU="Select one:"
                    OPTIONS=(1 "General CPU Info"
                            2 "Show Number of Cores"
                            3 "Processor Details")
                    CHOICE=$(dialog --clear \
			--backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)
                    if [ "$?" -eq 0 ]; then
                        case $CHOICE in
                            1)
                                  dialog --clear \
                                  --backtitle "$BACKTITLE / General CPU Information" \
                                  --title "$TITLE" \
                                  --yesno "INFO: Root privileges required!\nDo you want to use sudo?" 7 30;
                              if [ "$?" -eq 0 ]; then ##YES CPU privileges
                                clear;
                                  sudo lshw -class processor > '/tmp/space.txt'
                                  dialog --clear \
                                  --backtitle "$BACKTITLE / General CPU Information" \
                                  --title "$TITLE" \
                                  --textbox /tmp/space.txt 25 75;
                              elif [ "$?" -eq 1 ]; then ##NO CPU privileges
                                  dialog \
                                  --backtitle "$BACKTITLE" \
                                  --infobox "cancelled..." 3 20;
                                sleep 1.2;
                              fi
                        ;;
                        2)
                        cat /proc/cpuinfo | grep processor | wc -l > '/tmp/space.txt'
                              dialog --clear \
                              --backtitle "$BACKTITLE / Number of CPU Cores" \
                              --title "$TITLE" \
                              --textbox /tmp/space.txt 5 20;
clear;
                        ;;
                        3)
                        lscpu > '/tmp/space.txt'
                              dialog --clear \
                              --backtitle "$BACKTITLE / Processor Details" \
                              --title "Processor Details" \
                              --textbox /tmp/space.txt 20 49;
                              clear;
                        ;;
                        esac
                    elif [ "$?" -eq 1 ]; then ##Cancel CPU Info
                        clear;
                    break;
                    fi
                    done
                    ;;
                    8) ##Network Information
                    while [[ 1 ]]
                    do
                    HEIGHT=12
                    WIDTH=38
                    CHOICE_HEIGHT=3
                    BACKTITLE="OS Lab Project / System Monitor / Network Information"
                    TITLE="$TITLE"
                    MENU="Select one:"
                    OPTIONS=(1 "View IP and Mac Address"
                             2 "Display Connection info"
                             3 "Ethernet & Wifi Card Info")
                    MENU=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
--menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)
                    if [ "$?" -eq 0 ]; then ##okay Network Information
                        case $MENU in
                              1)
                                  printf "TIP - You can use arrow keys 'up, down, left & right' to scroll!\n" > /tmp/space.txt
                                  ifconfig >> '/tmp/space.txt'
                                  dialog --clear \
                                  --backtitle "$BACKTITLE / IP and Mac Address" \
                                  --title "$TITLE" \
                                  --textbox /tmp/space.txt 20 85;
                                clear;
                              ;;
                              2)
                                  iwconfig > '/tmp/space.txt'
                                  dialog --clear \
                                  --backtitle "$BACKTITLE / Connection Information" \
                                  --title "$TITLE" \
                                  --textbox /tmp/space.txt 20 85;
                                clear;
                              ;;
                              3)
                                printf "TIP - You can use arrow keys 'up, down, left & right' to scroll!\n" > /tmp/space.txt
                                  lspci | egrep -i --color 'network|ethernet' >> '/tmp/space.txt'
                                  dialog --clear \
                                  --backtitle "$BACKTITLE / Ethernet & Wifi Card Information" \
                                  --title "Network & Ethernet info" \
                                  --textbox /tmp/space.txt 10 100;
                                clear;
                              ;;
esac
                      elif [ "$?" -eq 1 ]; then ##cancel Network Information
                      break;
                      fi
                      done
                    ;;
                    9)
                      uname -r > '/tmp/space.txt' ##Kernel Information, current linux Kernel
                          dialog --clear \
                          --backtitle "$BACKTITLE / Kernel Information" \
                          --title "    Linux Kernel" \
                          --textbox /tmp/space.txt 5 30;
                      clear;
                    ;;
                    10)
                    while [[ 1 ]]
                      do
                      clear;
                      HEIGHT=17
                      WIDTH=45
                      CHOICE_HEIGHT=4
                      BACKTITLE="OS Lab Project / System Monitor"
                      TITLE="System Monitor"
                      MENU="Select one of the following Options:"

                      OPTIONS=(1 "Uptime"
                   2 "CPU Temperature"
                               3 "Distro Information"
                               4 "BIOS / UEFI Information")
                      CHOICE=$(dialog --clear \
--backtitle "$BACKTITLE" \
                                  --title "$TITLE" \
                                  --menu "$MENU" \
                      $HEIGHT $WIDTH $CHOICE_HEIGHT \
                      "${OPTIONS[@]}" \
                      2>&1 >/dev/tty) ##Main Menu
                      if [ "$?" -eq 0 ]; then ## Okay System Monitor
                        case $CHOICE in
                          1)
                          uptime -p > /tmp/space.txt;
                          dialog \
                          --title "Uptime" \
                          --backtitle "$BACKTITLE / Uptime" \
                          --textbox /tmp/space.txt 5 43;
                          ;;
                          2)
                          dpkg -s acpi &> /dev/null; #Check's if Acpi is installed
                if [ "$?" -eq 0 ]; then #Acpi installed
                acpi -t > /tmp/space.txt;
                dialog --title "CPU Temperature" \
                       --backtitle "OS Lab Project / System Monitor / CPU Temperature" \
                       --textbox /tmp/space.txt 5 43;
                elif [ "$?" -eq 1 ]; then #Acpi not installed
              BACKTITLE="OS Lab Project / System Monitor / CPU Temperature"
                clear;
                dialog --title "System Monitor 0.0.4" \
                       --backtitle "$BACKTITLE" \
                       --yesno "Acpi is not installed.\nDo you want to install Acpi?" 6 33;
                    if [ "$?" -eq 0 ]; then #Yes Install Acpi
                        clear;
                        sudo apt-get install acpi;
elif [ "$?" -eq 1 ]; then #No Install Acpi
                        dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
                        sleep 1.2;
                        clear;
                    fi
                fi
                          ;;
                          3)
                          uname -romi > /tmp/space.txt
                          lsb_release -a >> /tmp/space.txt;
                          dialog \
                          --title "Distro Information" \
                          --backtitle "$BACKTITLE / Distribution Details" \
                          --textbox /tmp/space.txt 10 55;
                          ;;
                          4)
                          clear;
                          sudo dmidecode -t bios > /tmp/space.txt;
                          dialog \
                          --title "BIOS / UEFI Info" \
                          --backtitle "$BACKTITLE / BIOS / UEFI Information" \
                          --textbox /tmp/space.txt 17 65;
                          ;;
                        esac
                      elif [ "$?" -eq 1 ]; then ## Cancel System Monitor
                      break;
                      fi
                      done
                    ;;
                    esac
                elif [ "$?" -eq 1 ]; then ##Cancel System Monitor
                break;
                fi
 done


}



shutdown(){
  while [[ 1 ]]
	do
	
	TITLE="Shut down"
	
	OPTIONS=(1 "Shut Down"
             2 "Restart"
             3 "Logout")
	CHOICE=$(dialog --clear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--menu "$MENU" \
	$HEIGHT $WIDTH $CHOICE_HEIGHT \
	"${OPTIONS[@]}" \
	2>&1 >/dev/tty)
	if [ "$?" -eq 0 ]; then
	  case $CHOICE in
        1)
        BACKTITLE="$BACKTITLE"
	    dialog --title "Shut Down" \
	    --backtitle "$BACKTITLE" \
	    --yesno "Do you want to turn off your computer?" 5 42;
	    if [ "$?" -eq 0 ]; then
        dialog --title "Shut down" \
               --backtitle "$BACKTITLE" \
               --pause "Shutting down in:" 8 30 20;
              if [ "$?" -eq 0 ]; then
                 systemctl poweroff
              elif [ "$?" -eq 1 ]; then
                dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
                sleep 1.5;
                clear;
              fi
	    elif [ "$?" -eq 1 ]; then
	    dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
	    sleep 2;
	    clear;
	    fi
        ;;
	    2)
	    BACKTITLE="$BACKTITLE / Restart"
	    dialog --title "Restart" \
	    --backtitle "$BACKTITLE" \
	    --yesno "Do you want to restart your computer?" 5 41;
	    if [ "$?" -eq 0 ]; then ##Yes Log out
         dialog --title "Restart" \
                --backtitle "$BACKTITLE" \
                --pause "Restarting in:" 8 30 20;
                if [ "$?" -eq 0 ]; then ##Yes Reboot
                    systemctl reboot
                elif [ "$?" -eq 1 ]; then ##Cancel Reboot
                 dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
                 sleep 1.5;
                 clear;
                fi
	     elif [ "$?" -eq 1 ]; then
	     dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
	     sleep 2;
	     clear;
	     fi
	    ;;
	    3)
	    dialog --title "Logout" \
               --backtitle "$BACKTITLE" \
               --yesno "Do you want to logout of the current session?" 6 33;
        if [ "$?" -eq 0 ]; then ##Yes Log out
        loginctl session-status > /tmp/space.txt;
        SESSION=$(awk '{print $1; exit}' /tmp/space.txt)
        dialog --title "Logout" \
               --backtitle "$BACKTITLE" \
               --pause "Logging out in:" 8 30 20;
               if [ "$?" -eq 0 ]; then ##Okay Logout
               loginctl terminate-session $SESSION;
               elif [ "$?" -eq 1 ]; then ##Cancel Logout
               dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
                sleep 1.5;
                clear;
               fi
        elif [ "$?" -eq 1 ]; then ##No Log output
        dialog --title "Cancel" --backtitle "$BACKTITLE" --infobox "cancelled..." 3 15;
        sleep 2;
        clear;
        fi
	    ;;
	  esac
	elif [ "$?" -eq 1 ]; then
	  break;
	fi
	done
	
	
}

about(){

	TITLE="About"

	dialog --clear \
	       --title "$TITLE" \
	       --backtitle "$BACKTITLE" \
	       --msgbox "OS Lab Project\n---------------------------\nGroup Members:\nM Abdul Qadir\nAli B Arshad\nAbdullah Nadeem\nMoeez Atlas" 19 70;
	clear;
        
}









while [[ 1 ]]
do
TITLE="Main Menu"

OPTIONS=(1 "Music Player"
	 2 "Computer Maintenance"
         3 "System Monitor"
         4 "Clock"
         5 "Shut Down"
         6 "About"
         ) ##Main Menu

	 CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
if [ "$?" -eq 0 ]; then
 case $CHOICE in
	 1)
		music	
		;;

2) computerMaintenance
	;;
3) systemMonitor
	;;
4)	color=$(( ( RANDOM % 7 ) ))
	tty-clock -rsC $color
  ;;
5)
  shutdown
  ;;
6) 
  about
  ;;
esac
elif [ "$?" -eq 1 ]; then ##MAIN MENU IF USER PRESSED CANCEL
          dialog --title "Exit" \
                 --backtitle "$BACKTITLE / Exit" \
                 --infobox "Goodbye!" 3 20;
                 sleep 1.2;
                 clear;
                 exit 0;
        fi
done


