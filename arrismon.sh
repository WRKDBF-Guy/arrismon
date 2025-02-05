#!/bin/sh

############################################################
##                                                        ##
##                      arrismon.sh                       ##
##                                                        ##
##           https://github.com/JGrana01/arrismon         ##
##          https://github.com/WRKDBF-Guy/arrismon        ##
##                  forked from @JackYaz                  ##
##                                                        ##
############################################################

##############        Shellcheck directives      ###########
# shellcheck disable=SC2009
# shellcheck disable=SC2012
# shellcheck disable=SC2016
# shellcheck disable=SC2018
# shellcheck disable=SC2019
# shellcheck disable=SC2059
# shellcheck disable=SC2155
############################################################

### Start of script variables ###
readonly SCRIPT_NAME="arrismon"
readonly SCRIPT_VERSION="v0.4.1-beta"
SCRIPT_BRANCH="Credentials"
SCRIPT_REPO="https://raw.githubusercontent.com/WRKDBF-Guy/$SCRIPT_NAME/$SCRIPT_BRANCH"
readonly SCRIPT_DIR="/jffs/addons/$SCRIPT_NAME.d"
readonly SCRIPT_WEBPAGE_DIR="$(readlink /www/user)"
readonly SCRIPT_WEB_DIR="$SCRIPT_WEBPAGE_DIR/$SCRIPT_NAME"
readonly SHARED_DIR="/jffs/addons/shared-jy"
readonly SHARED_REPO="https://raw.githubusercontent.com/jackyaz/shared-jy/master"
readonly SHARED_WEB_DIR="$SCRIPT_WEBPAGE_DIR/shared-jy"
[ -z "$(nvram get odmpid)" ] && ROUTER_MODEL=$(nvram get productid) || ROUTER_MODEL=$(nvram get odmpid)
[ -f /opt/bin/sqlite3 ] && SQLITE3_PATH=/opt/bin/sqlite3 || SQLITE3_PATH=/usr/sbin/sqlite3

# useful debug output when necessary
# Do NOT enable when invoked by cru - it will block
debug="false"

### End of script variables ###

### Start of output format variables ###
readonly CRIT="\\e[41m"
readonly ERR="\\e[31m"
readonly WARN="\\e[33m"
readonly PASS="\\e[32m"
readonly BOLD="\\e[1m"
readonly SETTING="${BOLD}\\e[36m"
readonly CLEARFORMAT="\\e[0m"
### End of output format variables ###

# $1 = print to syslog, $2 = message to print, $3 = log level
Print_Output(){
	if [ "$1" = "true" ]; then
		logger -t "$SCRIPT_NAME" "$2"
	fi
	printf "${BOLD}${3}%s${CLEARFORMAT}\\n\\n" "$2"
}

Firmware_Version_Check(){
	if nvram get rc_support | grep -qF "am_addons"; then
		return 0
	else
		return 1
	fi
}

### Code for these functions inspired by https://github.com/Adamm00 - credit to @Adamm ###
Check_Lock(){
	if [ -f "/tmp/$SCRIPT_NAME.lock" ]; then
		ageoflock=$(($(date +%s) - $(date +%s -r /tmp/$SCRIPT_NAME.lock)))
		if [ "$ageoflock" -gt 600 ]; then
			Print_Output true "Stale lock file found (>600 seconds old) - purging lock" "$ERR"
			kill "$(sed -n '1p' /tmp/$SCRIPT_NAME.lock)" >/dev/null 2>&1
			Clear_Lock
			echo "$$" > "/tmp/$SCRIPT_NAME.lock"
			return 0
		else
			Print_Output true "Lock file found (age: $ageoflock seconds) - cable modem stat generation likely in progress" "$ERR"
			if [ -z "$1" ]; then
				exit 1
			else
				if [ "$1" = "webui" ]; then
					echo 'var arrismonstatus = "LOCKED";' > /tmp/detect_arrismon.js
					exit 1
				fi
				return 1
			fi
		fi
	else
		echo "$$" > "/tmp/$SCRIPT_NAME.lock"
		return 0
	fi
}

Clear_Lock(){
	rm -f "/tmp/$SCRIPT_NAME.lock" 2>/dev/null
	return 0
}

############################################################################

Set_Version_Custom_Settings(){
	SETTINGSFILE="/jffs/addons/custom_settings.txt"
	case "$1" in
		local)
			if [ -f "$SETTINGSFILE" ]; then
				if [ "$(grep -c "arrismon_version_local" $SETTINGSFILE)" -gt 0 ]; then
					if [ "$2" != "$(grep "arrismon_version_local" /jffs/addons/custom_settings.txt | cut -f2 -d' ')" ]; then
						sed -i "s/arrismon_version_local.*/arrismon_version_local $2/" "$SETTINGSFILE"
					fi
				else
					echo "arrismon_version_local $2" >> "$SETTINGSFILE"
				fi
			else
				echo "arrismon_version_local $2" >> "$SETTINGSFILE"
			fi
		;;
		server)
			if [ -f "$SETTINGSFILE" ]; then
				if [ "$(grep -c "arrismon_version_server" $SETTINGSFILE)" -gt 0 ]; then
					if [ "$2" != "$(grep "arrismon_version_server" /jffs/addons/custom_settings.txt | cut -f2 -d' ')" ]; then
						sed -i "s/arrismon_version_server.*/arrismon_version_server $2/" "$SETTINGSFILE"
					fi
				else
					echo "arrismon_version_server $2" >> "$SETTINGSFILE"
				fi
			else
				echo "arrismon_version_server $2" >> "$SETTINGSFILE"
			fi
		;;
	esac
}

Update_Check(){
	echo 'var updatestatus = "InProgress";' > "$SCRIPT_WEB_DIR/detect_update.js"
	doupdate="false"
	localver=$(grep "SCRIPT_VERSION=" "/jffs/scripts/$SCRIPT_NAME" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
	/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" | grep -qF "waluwaz" || { Print_Output true "404 error detected - stopping update" "$ERR"; return 1; }
	serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" | grep "SCRIPT_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
	if [ "$localver" != "$serverver" ]; then
		doupdate="version"
		Set_Version_Custom_Settings server "$serverver"
		echo 'var updatestatus = "'"$serverver"'";'  > "$SCRIPT_WEB_DIR/detect_update.js"
	else
		localmd5="$(md5sum "/jffs/scripts/$SCRIPT_NAME" | awk '{print $1}')"
		remotemd5="$(curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" | md5sum | awk '{print $1}')"
		if [ "$localmd5" != "$remotemd5" ]; then
			doupdate="md5"
			Set_Version_Custom_Settings server "$serverver-hotfix"
			echo 'var updatestatus = "'"$serverver-hotfix"'";'  > "$SCRIPT_WEB_DIR/detect_update.js"
		fi
	fi
	if [ "$doupdate" = "false" ]; then
		echo 'var updatestatus = "None";'  > "$SCRIPT_WEB_DIR/detect_update.js"
	fi
	echo "$doupdate,$localver,$serverver"
}

Update_Version(){
	if [ -z "$1" ]; then
		updatecheckresult="$(Update_Check)"
		isupdate="$(echo "$updatecheckresult" | cut -f1 -d',')"
		localver="$(echo "$updatecheckresult" | cut -f2 -d',')"
		serverver="$(echo "$updatecheckresult" | cut -f3 -d',')"
		
		if [ "$isupdate" = "version" ]; then
			Print_Output true "New version of $SCRIPT_NAME available - $serverver" "$PASS"
		elif [ "$isupdate" = "md5" ]; then
			Print_Output true "MD5 hash of $SCRIPT_NAME does not match - hotfix available - $serverver" "$PASS"
		fi
		
		if [ "$isupdate" != "false" ]; then
			printf "\\n${BOLD}Do you want to continue with the update? (y/n)${CLEARFORMAT}  "
			read -r confirm
			case "$confirm" in
				y|Y)
					printf "\\n"
					Update_File shared-jy.tar.gz
					Update_File arrismonstats_www.asp
					/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" -o "/jffs/scripts/$SCRIPT_NAME" && Print_Output true "$SCRIPT_NAME successfully updated"
					chmod 0755 "/jffs/scripts/$SCRIPT_NAME"
					Set_Version_Custom_Settings local "$serverver"
					Set_Version_Custom_Settings server "$serverver"
					Clear_Lock
					PressEnter
					exec "$0"
					exit 0
				;;
				*)
					printf "\\n"
					Clear_Lock
					return 1
				;;
			esac
		else
			Print_Output true "No updates available - latest is $localver" "$WARN"
			Clear_Lock
		fi
	fi
	
	if [ "$1" = "force" ]; then
		serverver=$(/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" | grep "SCRIPT_VERSION=" | grep -m1 -oE 'v[0-9]{1,2}([.][0-9]{1,2})([.][0-9]{1,2})')
		Print_Output true "Downloading latest version ($serverver) of $SCRIPT_NAME" "$PASS"
		Update_File shared-jy.tar.gz
		Update_File arrismonstats_www.asp
		/usr/sbin/curl -fsL --retry 3 "$SCRIPT_REPO/$SCRIPT_NAME.sh" -o "/jffs/scripts/$SCRIPT_NAME" && Print_Output true "$SCRIPT_NAME successfully updated"
		chmod 0755 "/jffs/scripts/$SCRIPT_NAME"
		Set_Version_Custom_Settings local "$serverver"
		Set_Version_Custom_Settings server "$serverver"
		Clear_Lock
		if [ -z "$2" ]; then
			PressEnter
			exec "$0"
		elif [ "$2" = "unattended" ]; then
			exec "$0" postupdate
		fi
		exit 0
	fi
}

Update_MdmErrors(){
		if [ ! -f $SCRIPT_DIR/modem$1 ]; then
			touch $SCRIPT_DIR/modem$1
		fi

		grep -q "^$3," "$SCRIPT_DIR/modem$1" || echo "$3,0" >> "$SCRIPT_DIR/modem$1"

		oldcorr="$(grep "^$3," "$SCRIPT_DIR/modem$1" | awk -F "," '{print $2}')"

# carefull - arris reset counters! So, subtract the old value to reset

		if [ "$2" == 0 ]; then
			newcorr=0
		else
			newcorr=$(($2-oldcorr))	
		fi
		sed -i "s/^$3,.*/$3,$2,$newcorr/g" "$SCRIPT_DIR/modem$1"

if [ "$debug" = "true" ]; then
		echo "Stats: "
		echo -n "Channel $3  Oldcorr  $oldcorr  Newcorr  $newcorr  Modem  $2"
		echo
fi

}

Display_MdmErrors(){


# First display correctables


	printf "\\n${BOLD}Correctable Errors\\n${CLEARFORMAT} "
	printf "\\n${BOLD}Channel     Latest      Historic\\n${CLEARFORMAT}"
	fmt="   %-12s%-12s%-12s\\n"
	channelcnt="$(wc -l < "$SCRIPT_DIR/modemRxCorr" )"
 	counter=1
		until [ $counter -gt "$channelcnt" ]; do
			latest="$(grep "^$counter," "$SCRIPT_DIR/modemRxCorr" | awk -F "," '{print $3}')"
			historic="$(grep "^$counter," "$SCRIPT_DIR/modemRxCorr" | awk -F "," '{print $2}')"
			printf "$fmt" "$counter" "$latest" "$historic"
			counter=$((counter + 1))	
		done
	printf "\\n\\n"
        printf "\\n${BOLD}UnCorrectable Errors\\n${CLEARFORMAT} "
        printf "\\n${BOLD}Channel     Latest      Historic\\n${CLEARFORMAT}"
        channelcnt="$(wc -l < "$SCRIPT_DIR/modemRxUncor" )"
        counter=1
                until [ $counter -gt "$channelcnt" ]; do
                        latest="$(grep "^$counter," "$SCRIPT_DIR/modemRxUncor" | awk -F "," '{print $3}')"
                        historic="$(grep "^$counter," "$SCRIPT_DIR/modemRxUncor" | awk -F "," '{print $2}')"
			printf "$fmt" "$counter" "$latest" "$historic"
                        counter=$((counter + 1))
                done
        printf "\\n\\n"
	PressEnter
}



Update_File(){
	if [ "$1" = "arrismonstats_www.asp" ]; then
		tmpfile="/tmp/$1"
		Download_File "$SCRIPT_REPO/$1" "$tmpfile"
		if [ -f "$SCRIPT_DIR/$1" ]; then
			if ! diff -q "$tmpfile" "$SCRIPT_DIR/$1" >/dev/null 2>&1; then
				Get_WebUI_Page "$SCRIPT_DIR/$1"
				sed -i "\\~$MyPage~d" /tmp/menuTree.js
				rm -f "$SCRIPT_WEBPAGE_DIR/$MyPage" 2>/dev/null
				Download_File "$SCRIPT_REPO/$1" "$SCRIPT_DIR/$1"
				Print_Output true "New version of $1 downloaded" "$PASS"
				Mount_WebUI
			fi
		else
			Download_File "$SCRIPT_REPO/$1" "$SCRIPT_DIR/$1"
			Print_Output true "New version of $1 downloaded" "$PASS"
			Mount_WebUI
		fi
		rm -f "$tmpfile"
	elif [ "$1" = "shared-jy.tar.gz" ]; then
		if [ ! -f "$SHARED_DIR/$1.md5" ]; then
			Download_File "$SHARED_REPO/$1" "$SHARED_DIR/$1"
			Download_File "$SHARED_REPO/$1.md5" "$SHARED_DIR/$1.md5"
			tar -xzf "$SHARED_DIR/$1" -C "$SHARED_DIR"
			rm -f "$SHARED_DIR/$1"
			Print_Output true "New version of $1 downloaded" "$PASS"
		else
			localmd5="$(cat "$SHARED_DIR/$1.md5")"
			remotemd5="$(curl -fsL --retry 3 "$SHARED_REPO/$1.md5")"
			if [ "$localmd5" != "$remotemd5" ]; then
				Download_File "$SHARED_REPO/$1" "$SHARED_DIR/$1"
				Download_File "$SHARED_REPO/$1.md5" "$SHARED_DIR/$1.md5"
				tar -xzf "$SHARED_DIR/$1" -C "$SHARED_DIR"
				rm -f "$SHARED_DIR/$1"
				Print_Output true "New version of $1 downloaded" "$PASS"
			fi
		fi
	else
		return 1
	fi
}

Validate_Number(){
	if [ "$1" -eq "$1" ] 2>/dev/null; then
		return 0
	else
		return 1
	fi
}

Conf_FromSettings(){
	SETTINGSFILE="/jffs/addons/custom_settings.txt"
	TMPFILE="/tmp/arrismon_settings.txt"
	if [ -f "$SETTINGSFILE" ]; then
		if [ "$(grep "arrismon_" $SETTINGSFILE | grep -v "version" -c)" -gt 0 ]; then
			Print_Output true "Updated settings from WebUI found, merging into $SCRIPT_CONF" "$PASS"
			cp -a "$SCRIPT_CONF" "$SCRIPT_CONF.bak"
			grep "arrismon_" "$SETTINGSFILE" | grep -v "version" > "$TMPFILE"
			sed -i "s/arrismon_//g;s/ /=/g" "$TMPFILE"
			while IFS='' read -r line || [ -n "$line" ]; do
				SETTINGNAME="$(echo "$line" | cut -f1 -d'=' | awk '{ print toupper($1) }')"
				SETTINGNAMELEN=$(echo "$SETTINGNAME" | wc -c)
				LINELEN=$(echo "$line" | wc -c)
				SETTINGVALUE="$(echo "$line" | cut -c$(($SETTINGNAMELEN+1))-$(($LINELEN-1)))"
				case $SETTINGNAME in
					LOGINNAME)
					if [ "$SETTINGVALUE" = "*na" ]; then
						SETTINGVALUE="*NA"
					fi
						LOGINNAME=$SETTINGVALUE
					;;
					PASSWORD)
						if [ "$LOGINNAME" != "*NA" ]; then
							if [ "$SETTINGVALUE" != "" ]; then
								Encrypt_Password "$SETTINGVALUE"
							fi
						else
							sed -i 's_^ENCRYPTED.*$_ENCRYPTED=*NA_' "$SCRIPT_CONF"
						fi
							SETTINGVALUE=""
					;;
				esac
				sed -i "s~$SETTINGNAME=.*~$SETTINGNAME=$SETTINGVALUE~" "$SCRIPT_CONF"
			done < "$TMPFILE"
			grep 'arrismon_version' "$SETTINGSFILE" > "$TMPFILE"
			sed -i "\\~arrismon_~d" "$SETTINGSFILE"
			mv "$SETTINGSFILE" "$SETTINGSFILE.bak"
			cat "$SETTINGSFILE.bak" "$TMPFILE" > "$SETTINGSFILE"
			rm -f "$TMPFILE"
			rm -f "$SETTINGSFILE.bak"
			
			ScriptStorageLocation "$(ScriptStorageLocation check)"
			Create_Symlinks
			Generate_CSVs
			
			Print_Output true "Merge of updated settings from WebUI completed successfully" "$PASS"
		else
			Print_Output false "No updated settings from WebUI found, no merge into $SCRIPT_CONF necessary" "$PASS"
		fi
	fi
}

Create_Dirs(){
	if [ ! -d "$SCRIPT_DIR" ]; then
		mkdir -p "$SCRIPT_DIR"
	fi
	
	if [ ! -d "$SCRIPT_STORAGE_DIR" ]; then
		mkdir -p "$SCRIPT_STORAGE_DIR"
	fi
	
	if [ ! -d "$CSV_OUTPUT_DIR" ]; then
		mkdir -p "$CSV_OUTPUT_DIR"
	fi
	
	if [ ! -d "$SHARED_DIR" ]; then
		mkdir -p "$SHARED_DIR"
	fi
	
	if [ ! -d "$SCRIPT_WEBPAGE_DIR" ]; then
		mkdir -p "$SCRIPT_WEBPAGE_DIR"
	fi
	
	if [ ! -d "$SCRIPT_WEB_DIR" ]; then
		mkdir -p "$SCRIPT_WEB_DIR"
	fi
}

Create_Symlinks(){
	rm -rf "${SCRIPT_WEB_DIR:?}/"* 2>/dev/null
	
	ln -s /tmp/detect_arrismon.js "$SCRIPT_WEB_DIR/detect_arrismon.js" 2>/dev/null
	ln -s "$SCRIPT_STORAGE_DIR/modlogs.csv"  "$SCRIPT_WEB_DIR/modlogs.htm" 2>/dev/null
	ln -s "$SCRIPT_STORAGE_DIR/modstatstext.js" "$SCRIPT_WEB_DIR/modstatstext.js" 2>/dev/null
	
	ln -s "$SCRIPT_CONF" "$SCRIPT_WEB_DIR/config.htm" 2>/dev/null
	
	ln -s "$CSV_OUTPUT_DIR" "$SCRIPT_WEB_DIR/csv" 2>/dev/null
	
	if [ ! -d "$SHARED_WEB_DIR" ]; then
		ln -s "$SHARED_DIR" "$SHARED_WEB_DIR" 2>/dev/null
	fi
}

Conf_Exists(){
	if [ -f "$SCRIPT_CONF" ]; then
		dos2unix "$SCRIPT_CONF"
		chmod 0644 "$SCRIPT_CONF"
		sed -i -e 's/"//g' "$SCRIPT_CONF"
		if ! grep -q "DAYSTOKEEP" "$SCRIPT_CONF"; then
			echo "DAYSTOKEEP=30" >> "$SCRIPT_CONF"
		fi
		if ! grep -q "LOGINNAME" "$SCRIPT_CONF"; then
			echo "LOGINNAME=*NA" >> "$SCRIPT_CONF"
		fi
		if ! grep -q "PASSWORD" "$SCRIPT_CONF"; then
			echo "PASSWORD=" >> "$SCRIPT_CONF"
		fi
		if ! grep -q "RESETERRORCT" "$SCRIPT_CONF"; then
			echo "RESETERRORCT=Y" >> "$SCRIPT_CONF"
		fi		
		if ! grep -q "ENCRYPTED" "$SCRIPT_CONF"; then
			echo "ENCRYPTED=*NA" >> "$SCRIPT_CONF"
		fi

		return 0
	else
		{ echo "OUTPUTDATAMODE=average"; echo "OUTPUTTIMEMODE=unix"; echo "STORAGELOCATION=jffs"; echo "SHOWNOTICE=false"; echo "DAYSTOKEEP=30"; echo "LOGINNAME=*NA"; echo "PASSWORD="; echo "RESETERRORCT=Y"; echo "ENCRYPTED=*NA"; } > "$SCRIPT_CONF"                                                                         

		return 1
	fi
}

Auto_ServiceEvent(){
	case $1 in
		create)
			if [ -f /jffs/scripts/service-event ]; then
				STARTUPLINECOUNT=$(grep -c '# '"$SCRIPT_NAME" /jffs/scripts/service-event)
				STARTUPLINECOUNTEX=$(grep -cx 'if echo "$2" | /bin/grep -q "'"$SCRIPT_NAME"'"; then { /jffs/scripts/'"$SCRIPT_NAME"' service_event "$@" & }; fi # '"$SCRIPT_NAME" /jffs/scripts/service-event)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/service-event
				fi
				
				if [ "$STARTUPLINECOUNTEX" -eq 0 ]; then
					echo 'if echo "$2" | /bin/grep -q "'"$SCRIPT_NAME"'"; then { /jffs/scripts/'"$SCRIPT_NAME"' service_event "$@" & }; fi # '"$SCRIPT_NAME" >> /jffs/scripts/service-event
				fi
			else
				echo "#!/bin/sh" > /jffs/scripts/service-event
				echo "" >> /jffs/scripts/service-event
				echo 'if echo "$2" | /bin/grep -q "'"$SCRIPT_NAME"'"; then { /jffs/scripts/'"$SCRIPT_NAME"' service_event "$@" & }; fi # '"$SCRIPT_NAME" >> /jffs/scripts/service-event
				chmod 0755 /jffs/scripts/service-event
			fi
		;;
		delete)
			if [ -f /jffs/scripts/service-event ]; then
				STARTUPLINECOUNT=$(grep -c '# '"$SCRIPT_NAME" /jffs/scripts/service-event)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/service-event
				fi
			fi
		;;
	esac
}

Auto_Startup(){
	case $1 in
		create)
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -c '# '"$SCRIPT_NAME" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/services-start
				fi
			fi
			if [ -f /jffs/scripts/post-mount ]; then
				STARTUPLINECOUNT=$(grep -c '# '"$SCRIPT_NAME" /jffs/scripts/post-mount)
				STARTUPLINECOUNTEX=$(grep -cx "/jffs/scripts/$SCRIPT_NAME startup"' "$@" & # '"$SCRIPT_NAME" /jffs/scripts/post-mount)
				
				if [ "$STARTUPLINECOUNT" -gt 1 ] || { [ "$STARTUPLINECOUNTEX" -eq 0 ] && [ "$STARTUPLINECOUNT" -gt 0 ]; }; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/post-mount
				fi
				
				if [ "$STARTUPLINECOUNTEX" -eq 0 ]; then
					echo "/jffs/scripts/$SCRIPT_NAME startup"' "$@" & # '"$SCRIPT_NAME" >> /jffs/scripts/post-mount
				fi
			else
				echo "#!/bin/sh" > /jffs/scripts/post-mount
				echo "" >> /jffs/scripts/post-mount
				echo "/jffs/scripts/$SCRIPT_NAME startup"' "$@" & # '"$SCRIPT_NAME" >> /jffs/scripts/post-mount
				chmod 0755 /jffs/scripts/post-mount
			fi
		;;
		delete)
			if [ -f /jffs/scripts/services-start ]; then
				STARTUPLINECOUNT=$(grep -c '# '"$SCRIPT_NAME" /jffs/scripts/services-start)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/services-start
				fi
			fi
			if [ -f /jffs/scripts/post-mount ]; then
				STARTUPLINECOUNT=$(grep -c '# '"$SCRIPT_NAME" /jffs/scripts/post-mount)
				
				if [ "$STARTUPLINECOUNT" -gt 0 ]; then
					sed -i -e '/# '"$SCRIPT_NAME"'/d' /jffs/scripts/post-mount
				fi
			fi
		;;
	esac
}


# The modmon of JackYaz monitored the modem every 30 minutes. belmon triggered every 15 minutes. I arrismon uses 30 since it does tend to do
# quite a bit of sed/awk/grep stuff.

Auto_Cron(){
	case $1 in
		create)
			STARTUPLINECOUNT=$(cru l | grep -c "$SCRIPT_NAME")
			
			if [ "$STARTUPLINECOUNT" -eq 0 ]; then
				cru a "$SCRIPT_NAME" "1,31 * * * *  /jffs/scripts/$SCRIPT_NAME generate"
			fi
		;;
		delete)
			STARTUPLINECOUNT=$(cru l | grep -c "$SCRIPT_NAME")
			
			if [ "$STARTUPLINECOUNT" -gt 0 ]; then
				cru d "$SCRIPT_NAME"
			fi
		;;
	esac
}

Download_File(){
	/usr/sbin/curl -fsL --retry 3 "$1" -o "$2"
}

Get_WebUI_Page(){
	MyPage="none"
	for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
		page="/www/user/user$i.asp"
		if [ -f "$page" ] && [ "$(md5sum < "$1")" = "$(md5sum < "$page")" ]; then
			MyPage="user$i.asp"
			return
		elif [ "$MyPage" = "none" ] && [ ! -f "$page" ]; then
			MyPage="user$i.asp"
		fi
	done
}

### function based on @dave14305's FlexQoS webconfigpage function ###
Get_WebUI_URL(){
	urlpage=""
	urlproto=""
	urldomain=""
	urlport=""

	urlpage="$(sed -nE "/$SCRIPT_NAME/ s/.*url\: \"(user[0-9]+\.asp)\".*/\1/p" /tmp/menuTree.js)"
	if [ "$(nvram get http_enable)" -eq 1 ]; then
		urlproto="https"
	else
		urlproto="http"
	fi
	if [ -n "$(nvram get lan_domain)" ]; then
		urldomain="$(nvram get lan_hostname).$(nvram get lan_domain)"
	else
		urldomain="$(nvram get lan_ipaddr)"
	fi
	if [ "$(nvram get ${urlproto}_lanport)" -eq 80 ] || [ "$(nvram get ${urlproto}_lanport)" -eq 443 ]; then
		urlport=""
	else
		urlport=":$(nvram get ${urlproto}_lanport)"
	fi

	if echo "$urlpage" | grep -qE "user[0-9]+\.asp"; then
		echo "${urlproto}://${urldomain}${urlport}/${urlpage}" | tr "A-Z" "a-z"
	else
		echo "WebUI page not found"
	fi
}
### ###

### locking mechanism code credit to Martineau (@MartineauUK) ###
Mount_WebUI(){
	Print_Output true "Mounting WebUI tab for $SCRIPT_NAME" "$PASS"
	LOCKFILE=/tmp/addonwebui.lock
	FD=386
	eval exec "$FD>$LOCKFILE"
	flock -x "$FD"
	Get_WebUI_Page "$SCRIPT_DIR/arrismonstats_www.asp"
	if [ "$MyPage" = "none" ]; then
		Print_Output true "Unable to mount $SCRIPT_NAME WebUI page, exiting" "$CRIT"
		flock -u "$FD"
		return 1
	fi
	cp -f "$SCRIPT_DIR/arrismonstats_www.asp" "$SCRIPT_WEBPAGE_DIR/$MyPage"
	echo "$SCRIPT_NAME" > "$SCRIPT_WEBPAGE_DIR/$(echo $MyPage | cut -f1 -d'.').title"
	
	if [ "$(uname -o)" = "ASUSWRT-Merlin" ]; then
		if [ ! -f /tmp/index_style.css ]; then
			cp -f /www/index_style.css /tmp/
		fi
		
		if ! grep -q '.menu_Addons' /tmp/index_style.css ; then
			echo ".menu_Addons { background: url(ext/shared-jy/addons.png); }" >> /tmp/index_style.css
		fi
		
		umount /www/index_style.css 2>/dev/null
		mount -o bind /tmp/index_style.css /www/index_style.css
		
		if [ ! -f /tmp/menuTree.js ]; then
			cp -f /www/require/modules/menuTree.js /tmp/
		fi
		
		sed -i "\\~$MyPage~d" /tmp/menuTree.js
		
		if ! grep -q 'menuName: "Addons"' /tmp/menuTree.js ; then
			lineinsbefore="$(( $(grep -n "exclude:" /tmp/menuTree.js | cut -f1 -d':') - 1))"
			sed -i "$lineinsbefore"'i,\n{\nmenuName: "Addons",\nindex: "menu_Addons",\ntab: [\n{url: "javascript:var helpwindow=window.open('"'"'/ext/shared-jy/redirect.htm'"'"')", tabName: "Help & Support"},\n{url: "NULL", tabName: "__INHERIT__"}\n]\n}' /tmp/menuTree.js
		fi
		
		sed -i "/url: \"javascript:var helpwindow=window.open('\/ext\/shared-jy\/redirect.htm'/i {url: \"$MyPage\", tabName: \"$SCRIPT_NAME\"}," /tmp/menuTree.js
		
		umount /www/require/modules/menuTree.js 2>/dev/null
		mount -o bind /tmp/menuTree.js /www/require/modules/menuTree.js
	fi
	flock -u "$FD"
	Print_Output true "Mounted $SCRIPT_NAME WebUI page as $MyPage . Harvesting stats for a few minutes, please be patient..." "$PASS"
}

ScriptStorageLocation(){
	case "$1" in
		usb)
			sed -i 's/^STORAGELOCATION.*$/STORAGELOCATION=usb/' "$SCRIPT_CONF"
			mkdir -p "/opt/share/$SCRIPT_NAME.d/"
			mv "/jffs/addons/$SCRIPT_NAME.d/csv" "/opt/share/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/jffs/addons/$SCRIPT_NAME.d/config" "/opt/share/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/jffs/addons/$SCRIPT_NAME.d/config.bak" "/opt/share/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/jffs/addons/$SCRIPT_NAME.d/modstatstext.js" "/opt/share/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/jffs/addons/$SCRIPT_NAME.d/modstats.db" "/opt/share/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/jffs/addons/$SCRIPT_NAME.d/.indexcreated" "/opt/share/$SCRIPT_NAME.d/" 2>/dev/null
			SCRIPT_CONF="/opt/share/$SCRIPT_NAME.d/config"
			ScriptStorageLocation load
		;;
		jffs)
			sed -i 's/^STORAGELOCATION.*$/STORAGELOCATION=jffs/' "$SCRIPT_CONF"
			mkdir -p "/jffs/addons/$SCRIPT_NAME.d/"
			mv "/opt/share/$SCRIPT_NAME.d/csv" "/jffs/addons/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/opt/share/$SCRIPT_NAME.d/config" "/jffs/addons/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/opt/share/$SCRIPT_NAME.d/config.bak" "/jffs/addons/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/opt/share/$SCRIPT_NAME.d/modstatstext.js" "/jffs/addons/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/opt/share/$SCRIPT_NAME.d/modstats.db" "/jffs/addons/$SCRIPT_NAME.d/" 2>/dev/null
			mv "/opt/share/$SCRIPT_NAME.d/.indexcreated" "/jffs/addons/$SCRIPT_NAME.d/" 2>/dev/null
			SCRIPT_CONF="/jffs/addons/$SCRIPT_NAME.d/config"
			ScriptStorageLocation load
		;;
		check)
			STORAGELOCATION=$(grep "STORAGELOCATION" "$SCRIPT_CONF" | cut -f2 -d"=")
			echo "$STORAGELOCATION"
		;;
		load)
			STORAGELOCATION=$(grep "STORAGELOCATION" "$SCRIPT_CONF" | cut -f2 -d"=")
			if [ "$STORAGELOCATION" = "usb" ]; then
				SCRIPT_STORAGE_DIR="/opt/share/$SCRIPT_NAME.d"
			elif [ "$STORAGELOCATION" = "jffs" ]; then
				SCRIPT_STORAGE_DIR="/jffs/addons/$SCRIPT_NAME.d"
			fi
			
			CSV_OUTPUT_DIR="$SCRIPT_STORAGE_DIR/csv"
		;;
	esac
}

OutputDataMode(){
	case "$1" in
		raw)
			sed -i 's/^OUTPUTDATAMODE.*$/OUTPUTDATAMODE=raw/' "$SCRIPT_CONF"
			Generate_CSVs
		;;
		average)
			sed -i 's/^OUTPUTDATAMODE.*$/OUTPUTDATAMODE=average/' "$SCRIPT_CONF"
			Generate_CSVs
		;;
		check)
			OUTPUTDATAMODE=$(grep "OUTPUTDATAMODE" "$SCRIPT_CONF" | cut -f2 -d"=")
			echo "$OUTPUTDATAMODE"
		;;
	esac
}

OutputTimeMode(){
	case "$1" in
		unix)
			sed -i 's/^OUTPUTTIMEMODE.*$/OUTPUTTIMEMODE=unix/' "$SCRIPT_CONF"
			Generate_CSVs
		;;
		non-unix)
			sed -i 's/^OUTPUTTIMEMODE.*$/OUTPUTTIMEMODE=non-unix/' "$SCRIPT_CONF"
			Generate_CSVs
		;;
		check)
			OUTPUTTIMEMODE=$(grep "OUTPUTTIMEMODE" "$SCRIPT_CONF" | cut -f2 -d"=")
			echo "$OUTPUTTIMEMODE"
		;;
	esac
}

ShowNotice(){
	case "$1" in
		true)
			sed -i 's/^SHOWNOTICE.*$/SHOWNOTICE=true/' "$SCRIPT_CONF"
			Generate_CSVs
		;;
		false)
			sed -i 's/^SHOWNOTICE.*$/SHOWNOTICE=false/' "$SCRIPT_CONF"
			Generate_CSVs
		;;
		check)
			SHOWNOTICE=$(grep "SHOWNOTICE" "$SCRIPT_CONF" | cut -f2 -d"=")
			echo "$SHOWNOTICE"
		;;
		toggle)
			SHOWNOTICE=$(grep "SHOWNOTICE" "$SCRIPT_CONF" | cut -f2 -d"=")
			if [ "$SHOWNOTICE" = "false" ]; then
				sed -i 's/^SHOWNOTICE.*$/SHOWNOTICE=true/' "$SCRIPT_CONF"
                        	Generate_CSVs
			else
                        	sed -i 's/^SHOWNOTICE.*$/SHOWNOTICE=false/' "$SCRIPT_CONF"
                        	Generate_CSVs
			fi
		;;
	esac
}

DaysToKeep(){
	case "$1" in
		update)
			daystokeep=30
			exitmenu=""
			ScriptHeader
			while true; do
				printf "\\n${BOLD}Please enter the desired number of days\\nto keep data for (10-365 days):${CLEARFORMAT}  "
				read -r daystokeep_choice
				
				if [ "$daystokeep_choice" = "e" ]; then
					exitmenu="exit"
					break
				elif ! Validate_Number "$daystokeep_choice"; then
					printf "\\n${ERR}Please enter a valid number (30-365)${CLEARFORMAT}\\n"
				elif [ "$daystokeep_choice" -lt 10 ] || [ "$daystokeep_choice" -gt 365 ]; then
						printf "\\n${ERR}Please enter a number between 10 and 365${CLEARFORMAT}\\n"
				else
					daystokeep="$daystokeep_choice"
					printf "\\n"
					break
				fi
			done
			
			if [ "$exitmenu" != "exit" ]; then
				sed -i 's/^DAYSTOKEEP.*$/DAYSTOKEEP='"$daystokeep"'/' "$SCRIPT_CONF"
				return 0
			else
				printf "\\n"
				return 1
			fi
		;;
		check)
			DAYSTOKEEP=$(grep "DAYSTOKEEP" "$SCRIPT_CONF" | cut -f2 -d"=")
			echo "$DAYSTOKEEP"
		;;
	esac
}

Credentials(){
	case "$1" in
		update)
			ScriptHeader
			LOGINNAME="*NA"
			UNENCRYPTED_PWD=""
			exitmenu=""
			
			while true; do
				LOGINNAME_INP=""
				PASSWORD_INP=""

				printf "\\n${BOLD}Please enter the login name for your cable modem:${CLEARFORMAT}  "
			
				read -r LOGINNAME_INP
				if [ "$LOGINNAME_INP" = "e" ]; then
					exitmenu="exit"
					break
				fi
				if [ "$LOGINNAME_INP" = "*na" ]; then
					LOGINNAME_INP="*NA"
				fi
				
				LOGINNAME="$LOGINNAME_INP"
				printf "\\n"	
				printf "\\n${BOLD}Please enter the password for your cable modem:${CLEARFORMAT}  "
				
				stty -echo
				read -r PASSWORD_INP
				stty echo
				if [ "$PASSWORD_INP" = "e" ]; then
					exitmenu="exit"
					break
				fi
				UNENCRYPTED_PWD="$PASSWORD_INP"
				printf "\\n"
				
				rm -f "/tmp/checkcreds.txt" 2>/dev/null
				/usr/sbin/curl -v "http://192.168.100.1/goform/login" --data "loginUsername=$LOGINNAME&loginPassword=$UNENCRYPTED_PWD" 2> /tmp/checkcreds.txt
				if [ "$(grep -c "home.asp" "/tmp/checkcreds.txt")" -eq 0 ]; then
					printf "\\n"	
					printf "\\n${ERR}Login name and/or password is invalid.  Please retry.${CLEARFORMAT}  "
				else
					break
				fi
			done
			
			if [ "$exitmenu" != "exit" ]; then
				sed -i 's/^LOGINNAME.*$/LOGINNAME='"$LOGINNAME"'/' "$SCRIPT_CONF"
				if [ "$LOGINNAME" != "*NA" ]; then
					Encrypt_Password "$UNENCRYPTED_PWD"
				else
					sed -i 's_^ENCRYPTED.*$_ENCRYPTED=*NA_' "$SCRIPT_CONF"
				fi
				return 0
			else
				printf "\\n"
				return 1
			fi
		;;
		check)
			LOGINNAME=$(grep "LOGINNAME" "$SCRIPT_CONF" | cut -f2 -d"=")
			if [ "$LOGINNAME" != "*NA" ]; then
				Decrypt_Password
			fi	
			echo "$LOGINNAME"
		;;
	esac
}

Encrypt_Password(){
	ENCRYPTED_PWD=$(echo "$1" | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'RMerlin.iza.Wizard!')
	sed -i 's_^ENCRYPTED.*$_ENCRYPTED='"$ENCRYPTED_PWD"'_' "$SCRIPT_CONF"
}

Decrypt_Password(){
	STRINGVAR=$(grep "ENCRYPTED" "$SCRIPT_CONF")
	LEN=$(echo $STRINGVAR | wc -c)
	ENCRYPTED_PWD=$(grep "ENCRYPTED" "$SCRIPT_CONF" | cut -c11-$(($LEN-1)))
	UNENCRYPTED_PWD=$(echo "$ENCRYPTED_PWD" | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:'RMerlin.iza.Wizard!')
}

WriteStats_ToJS(){
	echo "function $3(){" > "$2"
	html='document.getElementById("'"$4"'").innerHTML="'
	while IFS='' read -r line || [ -n "$line" ]; do
		html="${html}${line}\r\\n"
	done < "$1"
	html="$html"'"'
	printf "%s\\r\\n}\\r\\n" "$html" >> "$2"
}

#$1 fieldname $2 tablename $3 frequency (hours) $4 length (days) $5 outputfile $6 outputfrequency $7 sqlfile $8 timestamp
WriteSql_ToFile(){
	timenow="$8"
	maxcount="$(echo "$3" "$4" | awk '{printf ((24*$2)/$1)}')"
	multiplier="$(echo "$3" | awk '{printf (60*60*$1)}')"
	
	{
		echo ".mode csv"
		echo ".headers on"
		echo ".output ${5}_${6}.htm"
	} > "$7"
	
	dividefactor=1

# Arris reports RxFreq in Hz. Convert to MHz
	
	if echo "$2" | grep -qF "RxFreq" ; then
		dividefactor=1000000
	fi
	

	echo "SELECT ('Ch. ' || [ChannelNum]) Channel,Min([Timestamp]) Time,IFNULL(Avg([$1])/$dividefactor,'NaN') Value FROM $2 WHERE ([Timestamp] >= $timenow - ($multiplier*$maxcount)) GROUP BY Channel,([Timestamp]/($multiplier)) ORDER BY [ChannelNum] ASC,[Timestamp] DESC;" >> "$7"
}

Get_Modem_Stats(){
	if [ ! -f /opt/bin/xargs ]; then
		Print_Output true "Installing findutils from Entware"
		opkg update
		opkg install findutils
	fi
	if [ -n "$PPID" ]; then
		ps | grep -v grep | grep -v $$ | grep -v "$PPID" | grep -i "$SCRIPT_NAME" | grep generate | awk '{print $1}' | xargs kill -9 >/dev/null 2>&1
	else
		ps | grep -v grep | grep -v $$ | grep -i "$SCRIPT_NAME" | grep generate | awk '{print $1}' | xargs kill -9 >/dev/null 2>&1
	fi
	Create_Dirs
	Conf_Exists
	ScriptStorageLocation load
	Create_Symlinks
	Auto_Startup create 2>/dev/null
	Auto_Cron create 2>/dev/null
	Auto_ServiceEvent create 2>/dev/null
	Shortcut_Script create
	reseterrorct=$(grep "RESETERRORCT" "$SCRIPT_CONF" | cut -f2 -d"=")
	TZ=$(cat /etc/TZ)
	export TZ
	timenow="$(date '+%s')"
	timenowfriendly="$(date +"%c")"
	shstatsfile="/tmp/shstats.csv"

	# additional temp files used to generate the $shstatsfile as expected by the rest of the code
	shstatsfile_curl="/tmp/shstats_curl.csv"
	shstatsfile_dsttmp="/tmp/shstats_dsttmp.csv"
	shstatsfile_dst="/tmp/shstats_dst.csv"
	shstatsfile_usttmp="/tmp/shstats_usttmp.csv"
	shstatsfile_ust="/tmp/shstats_ust.csv"

# The original version tracks 6 metrics, arrismon does 7. Note that the Rx/Tx prefix is later used to group metrics.
# Every metrics gets a dedicated SQL table
# Each table has the same structure
# Metrics are processed one at a time: a file is created with all INSERT SQL statements for that metric (/tmp/arrismon-stats.sql). 
# When the file for one metric is ready, it is executed as SQL to actually populate the relevant table.
# Subsequently, the same table is "purged" from old records, based on the retention period
# Finally, the text file with the INSERT statements is deleted

	metriclist="RxPwr RxSnr RxFreq RxCorr RxUncor SymRate TxPwr"

# FYI: It appears that those very metric's name might be expected by other parts of modmon:
# for instance: SELECT [Timestamp] FROM modstats_RxPwr
# Similarly, for arrismon, e.g. the chart appearance is different for the metric RxFreq
	
	echo 'var arrismonstatus = "InProgress";' > /tmp/detect_arrismon.js
	
	Process_Upgrade

# See https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html
# The original target modem for modmon produces a file with one value per line, like
#	"1.3.6.1.2.1.10.127.1.1.4.1.3.2":"1791416",
# The values in the file are identified by numbers, as per the concept of OIDs in SNMP (https://www.dpstele.com/snmp/what-does-oid-network-elements.php)
# Arrismon code replaced the OID numbers by the name of the metrics (among the 7 defined above, plus some more which are not used any further)
# It then only keeps the lines that start with letters, i.e. the ones that have received a metric name (with letters) instead of the SNMP OID (with digits).
# The processing also does additional processing to globally prepare the text 
# Ultimately, that produced a file, $shstatsfile
#
# With arrismon, the Arris modem presents an html file that uses tables.
#  In this case, arrismon filters out the <td> <tr> stuff and replaces with ","
# 
# it then creates 2 files - one for upstream (.ust) and downstream (.dst)
# sorry about the intermediate tmp files - fear of lines to long
# todo for another day

	LOGINNAME=$(grep "LOGINNAME" "$SCRIPT_CONF" | cut -f2 -d"=")
	
	if [ "$LOGINNAME" != "*NA" ]; then
		Decrypt_Password
		rm -f "/tmp/checkcreds.txt" 2>/dev/null
		/usr/sbin/curl -v "http://192.168.100.1/goform/login" --data "loginUsername=$LOGINNAME&loginPassword=$UNENCRYPTED_PWD" 2> /tmp/checkcreds.txt
	fi
	
	/usr/sbin/curl -fs --retry 3 --connect-timeout 20 'http://192.168.100.1/RgConnect.asp' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:98.0) Gecko/20100101 Firefox/98.0' -H 'Accept: */*' -H 'X-CSRF-TOKEN: 7d298d27f7ede0df78c9292cdca2cd57' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cookie: lang=fr; PHPSESSID=9csugaomqu52rqc6vgul600b91; auth=7d298d27f7ede0df78c9292cdca2cd57'  > "$shstatsfile_curl"

# sed and awk away...(btw, need the strings pipe so grep believes its simply a text file)

# Processing the Rx, DownStream

sed 's/\r//g' "$shstatsfile_curl" | strings | grep QAM | sed 's%<tr><td>%%g' | sed 's%</td><t[dr]>%,%g' | sed 's%</td></tr>%%g' > "$shstatsfile_dsttmp"
awk -F, '{printf("%d,%d,%d,RxChannelID,%d,RxFreq,%d,RxPwr,%d,RxSnr,%d,RxCorr,%d,RxUncor,%d\n", $1, $2, $3, $4, $5, $6, $7, $8, $9)}' "$shstatsfile_dsttmp" > "$shstatsfile_dst"

# Processing the TX, UpStream

sed 's/\r//g' "$shstatsfile_curl" | strings | grep ATDMA | sed 's%<tr><td>%%g' | sed 's%</td><t[dr]>%,%g' | sed 's%</td></tr>%%g' > "$shstatsfile_usttmp"
awk -F, '{printf("%d,%d,%d,TxChannelID,%d,SymRate,%d,TxFreq,%d,TxPwr,%d\n", $1, $2, $3, $4, $5, $6, $7 )}' "$shstatsfile_usttmp" > "$shstatsfile_ust"

# final filtering of text

cat "$shstatsfile_ust" "$shstatsfile_dst" | sed 's%Ksym/sec%%' | sed 's/dBmV//' | sed 's/dB//' | sed 's/Hz//' | sed 's/ //g' > "$shstatsfile"


if [ "$debug" = "true" ]; then
echo "UST is"
cat "$shstatsfile_ust"
echo
echo "DST is"
cat "$shstatsfile_dst"
echo
echo "shatsfile is"
cat "$shstatsfile"
echo
echo "Processsed"
read a
fi
rm -f "$shstatsfile_curl"
rm -f "$shstatsfile_dst"
rm -f "$shstatsfile_ust"


if [ "$debug" = "true" ]; then
echo "Processsed"
#wait for input to look around
read a
fi

# If the file is not empty, it is processed, each of the 6 or 7 metric in turn	
	if [ "$(wc -l < "$shstatsfile" )" -gt 1 ]; then
		for metric in $metriclist; do
			echo "CREATE TABLE IF NOT EXISTS [modstats_$metric] ([StatID] INTEGER PRIMARY KEY NOT NULL,[Timestamp] NUMERIC NOT NULL,[ChannelNum] INTEGER NOT NULL,[Measurement] REAL NOT NULL);" > /tmp/arrismon-stats.sql
			"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql

			rm -f /tmp/arrismon-stats.sql
			
			channelcount="$(grep -c "$metric" $shstatsfile)"    # one counts the number of lines for the current metric
if [ "$debug" = "true" ]; then
echo -n "channel count: "
echo $channelcount
fi
			
			counter=1
			until [ $counter -gt "$channelcount" ]; do
				# case limits the processing to only the target metric
				# sed/cut takes the Nth value

				case $metric in
					"RxPwr")
									   measurement="$(grep "$metric"   $shstatsfile | sed "$counter!d" | cut -d',' -f9)"
					;;
					"RxSnr")
									   measurement="$(grep "$metric"   $shstatsfile | sed "$counter!d" | cut -d',' -f11)"
					;;
					"RxFreq")
									   measurement="$(grep "$metric"   $shstatsfile | sed "$counter!d" | cut -d',' -f7)"
					;;
					"RxCorr")
									   modemcorr="$(grep "$metric"   $shstatsfile | sed "$counter!d" | cut -d',' -f13)"
									   Update_MdmErrors RxCorr $modemcorr $counter
									   measurement=$newcorr
					;;
					"RxUncor")
									   modemcorr="$(grep "$metric"   $shstatsfile | sed "$counter!d" | cut -d',' -f15)"
									   Update_MdmErrors RxUncor $modemcorr $counter
									   measurement=$newcorr
					;;
					"SymRate")
									   measurement="$(grep "$metric"   $shstatsfile | sed "$counter!d" | cut -d',' -f7)"
					;;
					"TxPwr")
									   measurement="$(grep "$metric"   $shstatsfile | sed "$counter!d" | cut -d',' -f11)"
					;;

				esac
				channel="$(grep "$metric"   $shstatsfile | sed "$counter!d" | cut -d',' -f5)"

if [ "$debug" = "true" ]; then
echo -n "Measurement: "
echo $measurement
echo -n "Channel: "
echo $channel
fi

				# In modmon, the tables receive values for the SQL ChannelNum SQL field. The values range from 1 to the count of channels 
				# This is not very suitable for my case where the modem reports values for a varying set of 16 channels; 
				# among a total of 20 physical channels (from 1 to 22, not including 17 and 18)

				if [ $channel -ge 1 ]; then echo "INSERT INTO modstats_$metric ([Timestamp],[ChannelNum],[Measurement]) values($timenow,$channel,$measurement);" >> /tmp/arrismon-stats.sql
				fi
				counter=$((counter + 1))	
			done

if [ "$debug" = "true" ]; then
echo "Done"
read a
fi
			"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql

if [ "$debug" = "true" ]; then
cp /tmp/arrismon-stats.sql /tmp/arrismon-stats.save
cat /tmp/arrismon-stats.save
echo "stats copied"
fi
			
			{
				echo "DELETE FROM [modstats_$metric] WHERE [Timestamp] < strftime('%s',datetime($timenow,'unixepoch','-$(DaysToKeep check) day'));"
				echo "PRAGMA analysis_limit=0;"
				echo "PRAGMA cache_size=-20000;"
				echo "ANALYZE modstats_$metric;"
			} > /tmp/arrismon-stats.sql

if [ "$debug" = "true" ]; then
echo "Done2 created arrismon_stats.sql"
read a
fi
			"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql >/dev/null 2>&1

if [ "$debug" = "true" ]; then
echo "Done3 sqlight"
cat /tmp/arrismon-stats.sql
read a
fi
			rm -f /tmp/arrismon-stats.sql
		done
		
		echo 'var arrismonstatus = "GenerateCSV";' > /tmp/detect_arrismon.js
		Generate_CSVs
		Generate_Modem_Logs
		
		
		echo "Stats last updated: $timenowfriendly" > "/tmp/modstatstitle.txt"
		WriteStats_ToJS /tmp/modstatstitle.txt "$SCRIPT_STORAGE_DIR/modstatstext.js" SetModStatsTitle statstitle
		rm -f /tmp/modstatstitle.txt
		Print_Output true "Cable modem stats successfully retrieved" "$PASS"
		
		echo 'var arrismonstatus = "Done";' > /tmp/detect_arrismon.js
	else
		Print_Output true "Something went wrong trying to retrieve cable modem stats" "$ERR"
		echo 'var arrismonstatus = "ERROR";' > /tmp/detect_arrismon.js
	fi
#	
if [ "$debug" != "true" ]; then
	rm -f "$shstatsfile"
	rm -f "$shstatsfile_curl"
	rm -f "$shstatsfile_dst"
	rm -f "$shstatsfile_ust"
fi
}

Generate_CSVs(){
	Process_Upgrade
	renice 15 $$
	OUTPUTDATAMODE="$(OutputDataMode check)"
	OUTPUTTIMEMODE="$(OutputTimeMode check)"
	TZ=$(cat /etc/TZ)
	export TZ
	timenow="$(date '+%s')"
	timenowfriendly="$(date +"%c")"
	
	metriclist="RxPwr RxSnr RxFreq RxCorr RxUncor SymRate TxPwr"
	
	for metric in $metriclist; do
	{
		dividefactor=1

		# For the Arris modem, RxFreq needs adjusting
		
		if echo "$metric" | grep -qF "RxFreq" ; then
			dividefactor=1000000
		fi


		{
			echo ".mode csv"
			echo ".headers on"
			echo ".output $CSV_OUTPUT_DIR/${metric}_daily.htm"
			echo "SELECT ('Ch. ' || [ChannelNum]) Channel,[Timestamp] Time,([Measurement]/$dividefactor) Value FROM modstats_$metric WHERE ([Timestamp] >= strftime('%s',datetime($timenow,'unixepoch','-1 day'))) ORDER BY [ChannelNum] ASC,[Timestamp] DESC;"
		} > /tmp/arrismon-stats.sql
		"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql
		
		if [ "$OUTPUTDATAMODE" = "raw" ]; then
			{
				echo ".mode csv"
				echo ".headers on"
				echo ".output $CSV_OUTPUT_DIR/${metric}_weekly.htm"
				echo "SELECT ('Ch. ' || [ChannelNum]) Channel,[Timestamp] Time,([Measurement]/$dividefactor) Value FROM modstats_$metric WHERE ([Timestamp] >= strftime('%s',datetime($timenow,'unixepoch','-7 day'))) ORDER BY [ChannelNum] ASC,[Timestamp] DESC;"
			} > /tmp/arrismon-stats.sql
			"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql
			
			{
				echo ".mode csv"
				echo ".headers on"
				echo ".output $CSV_OUTPUT_DIR/${metric}_monthly.htm"
				echo "SELECT ('Ch. ' || [ChannelNum]) Channel,[Timestamp] Time,([Measurement]/$dividefactor) Value FROM modstats_$metric WHERE ([Timestamp] >= strftime('%s',datetime($timenow,'unixepoch','-30 day'))) ORDER BY [ChannelNum] ASC,[Timestamp] DESC;"
			} > /tmp/arrismon-stats.sql
			"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql
		elif [ "$OUTPUTDATAMODE" = "average" ]; then
			WriteSql_ToFile Measurement "modstats_$metric" 3 7 "$CSV_OUTPUT_DIR/$metric" weekly /tmp/arrismon-stats.sql "$timenow"
			"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql
			
			WriteSql_ToFile Measurement "modstats_$metric" 12 30 "$CSV_OUTPUT_DIR/$metric" monthly /tmp/arrismon-stats.sql "$timenow"
			"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql
		fi
		rm -f "$CSV_OUTPUT_DIR/${metric}daily.htm"
		rm -f "$CSV_OUTPUT_DIR/${metric}weekly.htm"
		rm -f "$CSV_OUTPUT_DIR/${metric}monthly.htm"
	}
	done
	
	rm -f /tmp/arrismon-stats.sql
	
	{
		echo ".mode csv"
		echo ".headers on"
		echo ".output /tmp/CompleteResults_RxTimes.htm"
		echo "SELECT [Timestamp] FROM modstats_RxPwr WHERE ([Timestamp] >= strftime('%s',datetime($timenow,'unixepoch','-$(DaysToKeep check) day'))) ORDER BY [Timestamp] DESC;"
	} > /tmp/arrismon-complete.sql
	"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-complete.sql
	
	{
		echo ".mode csv"
		echo ".headers on"
		echo ".output /tmp/CompleteResults_TxTimes.htm"
		echo "SELECT [Timestamp] FROM modstats_TxPwr WHERE ([Timestamp] >= strftime('%s',datetime($timenow,'unixepoch','-$(DaysToKeep check) day'))) ORDER BY [Timestamp] DESC;"
	} > /tmp/arrismon-complete.sql
	"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-complete.sql
	
	{
		echo ".mode csv"
		echo ".headers on"
		echo ".output /tmp/CompleteResults_RxChannels.htm"
		echo "SELECT ('Ch. ' || [ChannelNum]) Channel FROM modstats_RxPwr WHERE ([Timestamp] >= strftime('%s',datetime($timenow,'unixepoch','-$(DaysToKeep check) day'))) ORDER BY [Timestamp] DESC;"
	} > /tmp/arrismon-complete.sql
	"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-complete.sql
	
	{
		echo ".mode csv"
		echo ".headers on"
		echo ".output /tmp/CompleteResults_TxChannels.htm"
		echo "SELECT ('Ch. ' || [ChannelNum]) Channel FROM modstats_TxPwr WHERE ([Timestamp] >= strftime('%s',datetime($timenow,'unixepoch','-$(DaysToKeep check) day'))) ORDER BY [Timestamp] DESC;"
	} > /tmp/arrismon-complete.sql
	"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-complete.sql
	
	metriclist="RxPwr RxSnr RxFreq RxCorr RxUncor SymRate TxPwr"
	for metric in $metriclist; do
	{
		echo ".mode csv"
		echo ".headers on"
		echo ".output /tmp/CompleteResults_$metric.htm"
		echo "SELECT [Measurement] $metric FROM modstats_$metric WHERE ([Timestamp] >= strftime('%s',datetime($timenow,'unixepoch','-$(DaysToKeep check) day'))) ORDER BY [Timestamp] DESC;"
	} > /tmp/arrismon-complete.sql
	"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-complete.sql
	done
	
	rm -f /tmp/arrismon-complete.sql
	
	dos2unix /tmp/*.htm
	
	if [ ! -f /opt/bin/paste ]; then
		opkg update
		opkg install coreutils-paste
	fi
	paste -d ',' /tmp/CompleteResults_RxTimes.htm /tmp/CompleteResults_RxChannels.htm /tmp/CompleteResults_RxPwr.htm /tmp/CompleteResults_RxSnr.htm /tmp/CompleteResults_RxFreq.htm /tmp/CompleteResults_RxCorr.htm /tmp/CompleteResults_RxUncor.htm > "$CSV_OUTPUT_DIR/CompleteResults_Rx.htm"
	paste -d ',' /tmp/CompleteResults_TxTimes.htm /tmp/CompleteResults_TxChannels.htm /tmp/CompleteResults_TxPwr.htm  > "$CSV_OUTPUT_DIR/CompleteResults_Tx.htm"
	
	rm -f /tmp/CompleteResults*.htm
	
	dos2unix "$CSV_OUTPUT_DIR/"*.htm
	
	tmpoutputdir="/tmp/${SCRIPT_NAME}results"
	mkdir -p "$tmpoutputdir"
	mv "$CSV_OUTPUT_DIR/CompleteResults"*.htm "$tmpoutputdir/."
	
	if [ "$OUTPUTTIMEMODE" = "unix" ]; then
		find "$tmpoutputdir/" -name '*.htm' -exec sh -c 'i="$1"; mv -- "$i" "${i%.htm}.csv"' _ {} \;
	elif [ "$OUTPUTTIMEMODE" = "non-unix" ]; then
		for i in "$tmpoutputdir/"*".htm"; do
			awk -F"," 'NR==1 {OFS=","; print} NR>1 {OFS=","; $1=strftime("%Y-%m-%d %H:%M:%S", $1); print }' "$i" > "$i.out"
		done
		
		find "$tmpoutputdir/" -name '*.htm.out' -exec sh -c 'i="$1"; mv -- "$i" "${i%.htm.out}.csv"' _ {} \;
		rm -f "$tmpoutputdir/"*.htm
	fi
	
	if [ ! -f /opt/bin/7za ]; then
		opkg update
		opkg install p7zip
	fi
	/opt/bin/7za a -y -bsp0 -bso0 -tzip "/tmp/${SCRIPT_NAME}data.zip" "$tmpoutputdir/*"
	mv "/tmp/${SCRIPT_NAME}data.zip" "$CSV_OUTPUT_DIR"
	rm -rf "$tmpoutputdir"
	renice 0 $$
}

Generate_Modem_Logs(){
	rm -f "$SCRIPT_STORAGE_DIR/modlogs.js"
	rm -f "$SCRIPT_STORAGE_DIR/modlogs.htm"
	rm -f /tmp/modlogs.csv

	shstatsfile_logtbl="/tmp/shstats_logtbl.csv"
	shstatsfile_logtmp="/tmp/shstats_logtmp.csv"
	rm -f "$shstatsfile_logtmp"

	/usr/sbin/curl -fs --retry 3 --connect-timeout 15 'http://192.168.100.1/RgEventLog.asp' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:98.0) Gecko/20100101 Firefox/98.0' -H 'Accept: */*' -H 'X-CSRF-TOKEN: 7d298d27f7ede0df78c9292cdca2cd57' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cookie: lang=fr; PHPSESSID=9csugaomqu52rqc6vgul600b91; auth=7d298d27f7ede0df78c9292cdca2cd57' > "$shstatsfile_logtbl"


	SHOWNOTICE=$(grep "SHOWNOTICE" "$SCRIPT_CONF" | cut -f2 -d"=")

	if [ "$SHOWNOTICE" = "true" ]; then
		loglist="Critical Error Notice"
	else
		loglist="Critical Error"
	fi

	for i in $loglist ; do
		sed 's/\r//g' "$shstatsfile_logtbl" | strings | grep $i | sed 's%</td><td width="87">%%g' | sed 's%<td width="169">%%g' | sed 's%</td><td width="450">%,%g' | sed 's%</td>%%g' >> "$shstatsfile_logtmp"
	done

# annoyningly Arris doesn't timestamp each log messages. They are clustered and Im still trying to figure out how to deal with this
# so, I simply (and wrongly) use the present system time...

	logtime="$(date)"
	while IFS=  read -r line
	do
		logprio="$(echo $line | cut -d',' -f1)"
		logmessage="$(echo $line | cut -d',' -f2)"
		echo "$logtime,$logprio,$logmessage" >> /tmp/modlogs.csv
	done < "$shstatsfile_logtmp"

	mv /tmp/modlogs.csv "$SCRIPT_STORAGE_DIR/modlogs.csv"

if [ "$debug" != "true" ]; then
	rm -f "$shstatsfile_logtbl"
	rm -f "$shstatsfile_logtmp"
fi
}

Reset_DB(){
	SIZEAVAIL="$(df -P -k "$SCRIPT_STORAGE_DIR" | awk '{print $4}' | tail -n 1)"
	SIZEDB="$(ls -l "$SCRIPT_STORAGE_DIR/modstats.db" | awk '{print $5}')"
	if [ "$SIZEDB" -gt "$((SIZEAVAIL*1024))" ]; then
		Print_Output true "Database size exceeds available space. $(ls -lh "$SCRIPT_STORAGE_DIR/modstats.db" | awk '{print $5}')B is required to create backup." "$ERR"
		return 1
	else
		Print_Output true "Sufficient free space to back up database, proceeding..." "$PASS"
		if ! cp -a "$SCRIPT_STORAGE_DIR/modstats.db" "$SCRIPT_STORAGE_DIR/modstats.db.bak"; then
			Print_Output true "Database backup failed, please check storage device" "$WARN"
		fi
		
		metriclist="RxPwr RxSnr RxFreq RxCorr RxUncor SymRate TxPwr"
		for metric in $metriclist; do
			echo "DELETE FROM [modstats_$metric];" > /tmp/arrismon-stats.sql
			"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql
		done
		rm -f /tmp/arrismon-stats.sql
			
		Print_Output true "Database reset complete" "$WARN"
	fi
}

Process_Upgrade(){
	if [ ! -f "$SCRIPT_STORAGE_DIR/.indexcreated" ]; then
		renice 15 $$
		Print_Output true "Creating database table indexes..." "$PASS"
		
		metriclist="RxPwr RxSnr RxFreq RxCorr RxUncor SymRate TxPwr"		
		for metric in $metriclist; do
			echo "CREATE INDEX IF NOT EXISTS idx_${metric}_time_measurement ON [modstats_$metric] (Timestamp,Measurement);" > /tmp/arrismon-upgrade.sql
			while ! "$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-upgrade.sql >/dev/null 2>&1; do
				sleep 1
			done
			echo "CREATE INDEX IF NOT EXISTS idx_${metric}_channel_measurement ON [modstats_$metric] (ChannelNum,Measurement);" > /tmp/arrismon-upgrade.sql
			while ! "$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-upgrade.sql >/dev/null 2>&1; do
				sleep 1
			done
		done
		rm -f /tmp/arrismon-upgrade.sql
		touch "$SCRIPT_STORAGE_DIR/.indexcreated"
		Print_Output true "Database ready, continuing..." "$PASS"
		renice 0 $$
	fi
	if [ ! -f "$SCRIPT_STORAGE_DIR/modlogs.csv" ]; then
		touch "$SCRIPT_STORAGE_DIR/modlogs.csv"
		Get_Modem_Stats
	fi
}

Shortcut_Script(){
	case $1 in
		create)
			if [ -d /opt/bin ] && [ ! -f "/opt/bin/$SCRIPT_NAME" ] && [ -f "/jffs/scripts/$SCRIPT_NAME" ]; then
				ln -s "/jffs/scripts/$SCRIPT_NAME" /opt/bin
				chmod 0755 "/opt/bin/$SCRIPT_NAME"
			fi
		;;
		delete)
			if [ -f "/opt/bin/$SCRIPT_NAME" ]; then
				rm -f "/opt/bin/$SCRIPT_NAME"
			fi
		;;
	esac
}

PressEnter(){
	while true; do
		printf "Press enter to continue..."
		read -r key
		case "$key" in
			*)
				break
			;;
		esac
	done
	return 0
}

ScriptHeader(){
	clear
	printf "\\n"
	printf "${BOLD}#########################################################${CLEARFORMAT}\\n"
	printf "${BOLD}##                   arrismon                          ##${CLEARFORMAT}\\n"
	printf "${BOLD}##                                                     ##${CLEARFORMAT}\\n"
	printf "${BOLD}##        https://github.com/JGrana01/arrismon         ##${CLEARFORMAT}\\n"
	printf "${BOLD}##        https://github.com/WRKDBF-Guy/arrismon       ##${CLEARFORMAT}\\n"
	printf "${BOLD}##                                                     ##${CLEARFORMAT}\\n"
	printf "${BOLD}##                                                     ##${CLEARFORMAT}\\n"
	printf "${BOLD}##    Forked from https://github.com/jackyaz/modmon    ##${CLEARFORMAT}\\n"
	printf "${BOLD}##                $SCRIPT_VERSION                          ##${CLEARFORMAT}\\n"
	printf "${BOLD}#########################################################${CLEARFORMAT}\\n"
	printf "\\n"
}

MainMenu(){
	printf "WebUI for %s Arris is available at:\\n${SETTING}%s${CLEARFORMAT}\\n\\n" "$SCRIPT_NAME" "$(Get_WebUI_URL)"
	printf "1.    Check stats now\\n\\n"
	printf "2.    Toggle data output mode\\n      Currently ${SETTING}%s${CLEARFORMAT} values will be used for weekly and monthly charts\\n\\n" "$(OutputDataMode check)"
	printf "3.    Toggle time output mode\\n      Currently ${SETTING}%s${CLEARFORMAT} time values will be used for CSV exports\\n\\n" "$(OutputTimeMode check)"
	printf "4.    Set number of days data to keep in database\\n      Currently: ${SETTING}%s days data will be kept${CLEARFORMAT}\\n\\n" "$(DaysToKeep check)"
	printf "s.    Toggle storage location for stats and config\\n      Current location is ${SETTING}%s${CLEARFORMAT} \\n\\n" "$(ScriptStorageLocation check)"
	printf "n.    Toggle Show Notice messages from modem logs (Critical and Error always shown)\\n      Currently: ${SETTING}%s${CLEARFORMAT} \\n\\n" "$(ShowNotice check)"
	printf "c.    Credentials: enter login name & password if required for your cable modem (optional)\\n      Currently: ${SETTING}%s${CLEARFORMAT} \\n\\n" "$(Credentials check)"
	printf "u.    Check for updates\\n"
	printf "uf.   Update %s with latest version (force update)\\n\\n" "$SCRIPT_NAME"
	printf "r.    Reset %s database / delete all data\\n\\n" "$SCRIPT_NAME"
	printf "e.    Exit %s\\n\\n" "$SCRIPT_NAME"
	printf "z.    Uninstall %s\\n" "$SCRIPT_NAME"
	printf "\\n"
	printf "${BOLD}############################################################${CLEARFORMAT}\\n"
	printf "\\n"
	
	while true; do
		printf "Choose an option:  "
		read -r menu
		case "$menu" in
			1)
				printf "\\n"
				printf "Retrieving stats and logs. This will take some time\\n"
				if Check_Lock menu; then
					Get_Modem_Stats
					Clear_Lock
				fi
				PressEnter
				break
			;;
			2)
				printf "\\n"
				if [ "$(OutputDataMode check)" = "raw" ]; then
					OutputDataMode average
				elif [ "$(OutputDataMode check)" = "average" ]; then
					OutputDataMode raw
				fi
				break
			;;
			3)
				printf "\\n"
				if [ "$(OutputTimeMode check)" = "unix" ]; then
					OutputTimeMode non-unix
				elif [ "$(OutputTimeMode check)" = "non-unix" ]; then
					OutputTimeMode unix
				fi
				break
			;;
			4)
				printf "\\n"
				DaysToKeep update
				PressEnter
				break
			;;
			s)
				printf "\\n"
				if [ "$(ScriptStorageLocation check)" = "jffs" ]; then
					ScriptStorageLocation usb
					Create_Symlinks
				elif [ "$(ScriptStorageLocation check)" = "usb" ]; then
					ScriptStorageLocation jffs
					Create_Symlinks
				fi
				break
			;;
			c)
				printf "\\n"
				Credentials update
				PressEnter
				break
			;;
			u)
				printf "\\n"
				if Check_Lock menu; then
					Update_Version
					Clear_Lock
				fi
				PressEnter
				break
			;;
			uf)
				printf "\\n"
				if Check_Lock menu; then
					Update_Version force
					Clear_Lock
				fi
				PressEnter
				break
			;;
			r)
				printf "\\n"
				if Check_Lock menu; then
					Menu_ResetDB
					Clear_Lock
				fi
				PressEnter
				break
			;;
			n)
				printf "\\n"
				ShowNotice toggle
				break
			;;
			l)
				printf "\\n"
				GetLog
				break
			;;
			ec)
				printf "\\n"
				printf "Arris modems do not reset uncorrectable and correctable errors after reporting\\n"
				printf "Arrismon can internally reset any error counts after reporting\\n"
				printf "Reset errors after reporting is presently %s \\n " "$reseterrorct"
				printf "\\n${BOLD}Do you want Arrismon to reset counters after reporting? (y/n)${CLEARFORMAT} "
				read -r confirm
				case "$confirm" in
					y|Y)
						reseterrorct="Y"
					;;
					n|N)
						reseterrorct="N"
					;;
					*)
						break
					;;
					esac
                                sed -i 's/^RESETERRORCT.*$/RESETERRORCT='"$reseterrorct"'/' "$SCRIPT_CONF"
				break
			;;
			ed)
				Display_MdmErrors
				break
			;;
			dbon)
				printf "\\n"
				debug="true"
				break
			;;
			dboff)
				printf "\\n"
				debug="false"
				break
			;;
			e)
				ScriptHeader
				printf "\\n${BOLD}Thanks for using %s!${CLEARFORMAT}\\n\\n\\n" "$SCRIPT_NAME"
				exit 0
			;;
			z)
				while true; do
					printf "\\n${BOLD}Are you sure you want to uninstall %s? (y/n)${CLEARFORMAT}  " "$SCRIPT_NAME"
					read -r confirm
					case "$confirm" in
						y|Y)
							Menu_Uninstall
							exit 0
						;;
						*)
							break
						;;
					esac
				done
			;;
			*)
				printf "\\nPlease choose a valid option\\n\\n"
			;;
		esac
	done
	
	ScriptHeader
	MainMenu
}

GetLog(){

	printf "\\n${BOLD}Getting logs from modem...hold on\\n\\n"
	/usr/sbin/curl -fs --retry 3 --connect-timeout 20 'http://192.168.100.1/RgConnect.asp' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:98.0) Gecko/20100101 Firefox/98.0' -H 'Accept: */*' -H 'X-CSRF-TOKEN: 7d298d27f7ede0df78c9292cdca2cd57' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cookie: lang=fr; PHPSESSID=9csugaomqu52rqc6vgul600b91; auth=7d298d27f7ede0df78c9292cdca2cd57'  > "/tmp/arrislog"                 
	printf "\\n${BOLD}Done, log is /tmp/arrislog\\n\\n"
	sleep 5
}


Check_Requirements(){
	CHECKSFAILED="false"
	
	if [ "$(nvram get jffs2_scripts)" -ne 1 ]; then
		nvram set jffs2_scripts=1
		nvram commit
		Print_Output false "Custom JFFS Scripts enabled" "$WARN"
	fi

# make sure it's an arris modem

	Print_Output false "Checking modem...this might take a while" "$WARN"
	/usr/sbin/curl -fsL --retry 3 "http://192.168.100.1/RgConnect.asp" -o chkmdm.tmp >/dev/null || { echo "Cable modem not compatible - error detected when trying to access cable modem's stats"; CHECKSFAILED="true"; }
	if [ "$(strings chkmdm.tmp | grep -c arris)" -lt 1 ]; then
		echo "Modem doesn't appear to be an Arris modem"
		echo -n "Are you sure its an Arris modmem? (Y or n) "
		read ismodm
		case "$ismodm" in
			Y|y)
				echo "ok"
			;;
			*)
				echo "nope"
				Print_Output false "Cable modem not compatible - Arris modem not detected " "$ERR"
				CHECKSFAILED="true"
			;;
		esac
	fi
	rm chkmdm.tmp
	
	if [ ! -f /opt/bin/opkg ]; then
		Print_Output false "Entware not detected!" "$ERR"
		CHECKSFAILED="true"
	fi
	
	if ! Firmware_Version_Check; then
		Print_Output false "Unsupported firmware version detected" "$ERR"
		Print_Output false "$SCRIPT_NAME requires Merlin 384.15/384.13_4 or Fork 43E5 (or later)" "$ERR"
		CHECKSFAILED="true"
	fi
		
	if [ "$CHECKSFAILED" = "false" ]; then
		Print_Output false "Installing required packages from Entware" "$PASS"
		opkg update
	##	opkg install sqlite3-cli
		opkg install p7zip
		opkg install coreutils-paste
		opkg install findutils
		return 0
	else
		return 1
	fi
}

Menu_Install(){
	ScriptHeader
	Print_Output true "Welcome to $SCRIPT_NAME $SCRIPT_VERSION, a script by JGrana01 and WRKDBF-Guy"
	Print_Output true "               a fork of JakYaz original modmon Addon"
	sleep 1
	
	Print_Output false "Checking your router meets the requirements for $SCRIPT_NAME"
	
	if ! Check_Requirements; then
		Print_Output false "Requirements for $SCRIPT_NAME not met, please see above for the reason(s)" "$CRIT"
		PressEnter
		Clear_Lock
		rm -f "/jffs/scripts/$SCRIPT_NAME" 2>/dev/null
		exit 1
	fi
	
	Create_Dirs
	Conf_Exists
	Set_Version_Custom_Settings local "$SCRIPT_VERSION"
	Set_Version_Custom_Settings server "$SCRIPT_VERSION"
	ScriptStorageLocation load
	Create_Symlinks
	
	Update_File arrismonstats_www.asp
	Update_File shared-jy.tar.gz
	
	Auto_Startup create 2>/dev/null
	Auto_Cron create 2>/dev/null
	Auto_ServiceEvent create 2>/dev/null
	Shortcut_Script create
	
	metriclist="RxPwr RxSnr RxFreq RxCorr RxUncor SymRate TxPwr"	
	
	for metric in $metriclist; do
		echo "CREATE TABLE IF NOT EXISTS [modstats_$metric] ([StatID] INTEGER PRIMARY KEY NOT NULL,[Timestamp] NUMERIC NOT NULL,[ChannelNum] INTEGER NOT NULL,[Measurement] REAL NOT NULL);" > /tmp/arrismon-stats.sql
		"$SQLITE3_PATH" "$SCRIPT_STORAGE_DIR/modstats.db" < /tmp/arrismon-stats.sql
	done
	rm -f /tmp/arrismon-stats.sql
	
	touch "$SCRIPT_STORAGE_DIR/modlogs.csv"
	Process_Upgrade
	Print_Output false "Getting modem stats..."
	Get_Modem_Stats
	
	Clear_Lock
	
	ScriptHeader
	MainMenu
}

Menu_Startup(){
	if [ -z "$1" ]; then
		Print_Output true "Missing argument for startup, not starting $SCRIPT_NAME" "$WARN"
		exit 1
	elif [ "$1" != "force" ]; then
		if [ ! -f "$1/entware/bin/opkg" ]; then
			Print_Output true "$1 does not contain Entware, not starting $SCRIPT_NAME" "$WARN"
			exit 1
		else
			Print_Output true "$1 contains Entware, starting $SCRIPT_NAME" "$WARN"
		fi
	fi
	
	NTP_Ready
	
	Check_Lock
	
	if [ "$1" != "force" ]; then
		sleep 10
	fi
	Create_Dirs
	Conf_Exists
	ScriptStorageLocation load
	Create_Symlinks
	Auto_Startup create 2>/dev/null
	Auto_Cron create 2>/dev/null
	Auto_ServiceEvent create 2>/dev/null
	Shortcut_Script create
	Mount_WebUI
	Clear_Lock
}

Menu_ResetDB(){
	printf "${BOLD}\\e[33mWARNING: This will reset the %s database by deleting all database records.\\n" "$SCRIPT_NAME"
	printf "A backup of the database will be created if you change your mind.${CLEARFORMAT}\\n"
	printf "\\n${BOLD}Do you want to continue? (y/n)${CLEARFORMAT}  "
	read -r confirm
	case "$confirm" in
		y|Y)
			printf "\\n"
			Reset_DB
		;;
		*)
			printf "\\n${BOLD}\\e[33mDatabase reset cancelled${CLEARFORMAT}\\n\\n"
		;;
	esac
}

Menu_Uninstall(){
	Print_Output true "Removing $SCRIPT_NAME..." "$PASS"
	if [ -n "$PPID" ]; then
		ps | grep -v grep | grep -v $$ | grep -v "$PPID" | grep -i "$SCRIPT_NAME" | grep generate | awk '{print $1}' | xargs kill -9 >/dev/null 2>&1
	else
		ps | grep -v grep | grep -v $$ | grep -i "$SCRIPT_NAME" | grep generate | awk '{print $1}' | xargs kill -9 >/dev/null 2>&1
	fi
	Auto_Startup delete 2>/dev/null
	Auto_Cron delete 2>/dev/null
	Auto_ServiceEvent delete 2>/dev/null
	Shortcut_Script delete
	LOCKFILE=/tmp/addonwebui.lock
	FD=386
	eval exec "$FD>$LOCKFILE"
	flock -x "$FD"
	Get_WebUI_Page "$SCRIPT_DIR/arrismonstats_www.asp"
	if [ -n "$MyPage" ] && [ "$MyPage" != "none" ] && [ -f /tmp/menuTree.js ]; then
		sed -i "\\~$MyPage~d" /tmp/menuTree.js
		umount /www/require/modules/menuTree.js
		mount -o bind /tmp/menuTree.js /www/require/modules/menuTree.js
		rm -f "$SCRIPT_WEBPAGE_DIR/$MyPage"
		rm -f "$SCRIPT_WEBPAGE_DIR/$(echo $MyPage | cut -f1 -d'.').title"
	fi
	flock -u "$FD"
	rm -f "$SCRIPT_DIR/arrismonstats_www.asp" 2>/dev/null
	rm -rf "$SCRIPT_WEB_DIR" 2>/dev/null
	printf "\\n${BOLD}Do you want to delete %s stats? (y/n)${CLEARFORMAT}  " "$SCRIPT_NAME"
	read -r confirm
	case "$confirm" in
		y|Y)
			rm -rf "$SCRIPT_DIR" 2>/dev/null
			rm -rf "$SCRIPT_STORAGE_DIR" 2>/dev/null
		;;
		*)
			:
		;;
	esac
	SETTINGSFILE="/jffs/addons/custom_settings.txt"
	sed -i '/arrismon_version_local/d' "$SETTINGSFILE"
	sed -i '/arrismon_version_server/d' "$SETTINGSFILE"
	rm -f "/jffs/scripts/$SCRIPT_NAME" 2>/dev/null
	Clear_Lock
	Print_Output true "Uninstall completed" "$PASS"
}

NTP_Ready(){
	if [ "$(nvram get ntp_ready)" -eq 0 ]; then
		ntpwaitcount=0
		Check_Lock
		while [ "$(nvram get ntp_ready)" -eq 0 ] && [ "$ntpwaitcount" -lt 600 ]; do
			ntpwaitcount="$((ntpwaitcount + 30))"
			Print_Output true "Waiting for NTP to sync..." "$WARN"
			sleep 30
		done
		if [ "$ntpwaitcount" -ge 600 ]; then
			Print_Output true "NTP failed to sync after 10 minutes. Please resolve!" "$CRIT"
			Clear_Lock
			exit 1
		else
			Print_Output true "NTP synced, $SCRIPT_NAME will now continue" "$PASS"
			Clear_Lock
		fi
	fi
}

### function based on @Adamm00's Skynet USB wait function ###
Entware_Ready(){
	if [ ! -f /opt/bin/opkg ]; then
		Check_Lock
		sleepcount=1
		while [ ! -f /opt/bin/opkg ] && [ "$sleepcount" -le 10 ]; do
			Print_Output true "Entware not found, sleeping for 10s (attempt $sleepcount of 10)" "$ERR"
			sleepcount="$((sleepcount + 1))"
			sleep 10
		done
		if [ ! -f /opt/bin/opkg ]; then
			Print_Output true "Entware not found and is required for $SCRIPT_NAME to run, please resolve" "$CRIT"
			Clear_Lock
			exit 1
		else
			Print_Output true "Entware found, $SCRIPT_NAME will now continue" "$PASS"
			Clear_Lock
		fi
	fi
}
### ###

### function based on @dave14305's FlexQoS about function ###
Show_About(){
	cat <<EOF
About
  $SCRIPT_NAME is a tool that tracks your cable modem's stats
  (such as signal power levels) for AsusWRT Merlin with charts
  for daily, weekly and monthly summaries.
License
  $SCRIPT_NAME is free to use under the GNU General Public License
  version 3 (GPL-3.0) https://opensource.org/licenses/GPL-3.0
Help & Support
  https://www.snbforums.com/forums/asuswrt-merlin-addons.60/?prefix_id=21
Source code
  https://github.com/jackyaz/$SCRIPT_NAME
EOF
	printf "\\n"
}
### ###

### function based on @dave14305's FlexQoS show_help function ###
Show_Help(){
	cat <<EOF
Available commands:
  $SCRIPT_NAME about              explains functionality
  $SCRIPT_NAME update             checks for updates
  $SCRIPT_NAME forceupdate        updates to latest version (force update)
  $SCRIPT_NAME startup force      runs startup actions such as mount WebUI tab
  $SCRIPT_NAME install            installs script
  $SCRIPT_NAME uninstall          uninstalls script
  $SCRIPT_NAME generate           get modem stats and logs. also runs outputcsv
  $SCRIPT_NAME outputcsv          create CSVs from database, used by WebUI and export
  $SCRIPT_NAME credentials        create or update login informatio for modem
  $SCRIPT_NAME develop            switch to development branch
  $SCRIPT_NAME stable             switch to stable branch
EOF
	printf "\\n"
}
### ###

if [ -f "/opt/share/$SCRIPT_NAME.d/config" ]; then
	SCRIPT_CONF="/opt/share/$SCRIPT_NAME.d/config"
	SCRIPT_STORAGE_DIR="/opt/share/$SCRIPT_NAME.d"
else
	SCRIPT_CONF="/jffs/addons/$SCRIPT_NAME.d/config"
	SCRIPT_STORAGE_DIR="/jffs/addons/$SCRIPT_NAME.d"
fi

CSV_OUTPUT_DIR="$SCRIPT_STORAGE_DIR/csv"

if [ -z "$1" ]; then
	NTP_Ready
	Entware_Ready
#debug mode, remove
	Clear_Lock
	Create_Dirs
	Conf_Exists
	ScriptStorageLocation load
	Create_Symlinks
	Auto_Startup create 2>/dev/null
	Auto_Cron create 2>/dev/null
	Auto_ServiceEvent create 2>/dev/null
	Shortcut_Script create
	Process_Upgrade
	ScriptHeader
	MainMenu
	exit 0
fi

case "$1" in
	install)
		Check_Lock
		Menu_Install
		exit 0
	;;
	startup)
		Menu_Startup "$2"
		exit 0
	;;
	generate)
		NTP_Ready
		Entware_Ready
		Check_Lock
		Get_Modem_Stats
		Clear_Lock
		exit 0
	;;
	outputcsv)
		NTP_Ready
		Entware_Ready
		Check_Lock
		Generate_CSVs
		Clear_Lock
		exit 0
	;;
	service_event)
		if [ "$2" = "start" ] && [ "$3" = "$SCRIPT_NAME" ]; then
			rm -f /tmp/detect_arrismon.js
			Check_Lock webui
			sleep 3
			Get_Modem_Stats
			Clear_Lock
			exit 0
		elif [ "$2" = "start" ] && [ "$3" = "${SCRIPT_NAME}config" ]; then
			Conf_FromSettings
			exit 0
		elif [ "$2" = "start" ] && [ "$3" = "${SCRIPT_NAME}checkupdate" ]; then
			Update_Check
			exit 0
		elif [ "$2" = "start" ] && [ "$3" = "${SCRIPT_NAME}doupdate" ]; then
			Update_Version force unattended
			exit 0
		fi
		exit 0
	;;
	update)
		Update_Version
		exit 0
	;;
	forceupdate)
		Update_Version force
		exit 0
	;;
	postupdate)
		Create_Dirs
		Conf_Exists
		ScriptStorageLocation load
		Create_Symlinks
		Auto_Startup create 2>/dev/null
		Auto_Cron create 2>/dev/null
		Auto_ServiceEvent create 2>/dev/null
		Shortcut_Script create
		Process_Upgrade
		exit 0
	;;
	checkupdate)
		Update_Check
		exit 0
	;;
	credentials)
		Credentials update
		exit 0
	;;
	uninstall)
		Menu_Uninstall
		exit 0
	;;
	develop)
		SCRIPT_BRANCH="develop"
		SCRIPT_REPO="https://raw.githubusercontent.com/waluwaz/$SCRIPT_NAME/$SCRIPT_BRANCH"
		Update_Version force
		exit 0
	;;
	stable)
		SCRIPT_BRANCH="master"
		SCRIPT_REPO="https://raw.githubusercontent.com/waluwaz/$SCRIPT_NAME/$SCRIPT_BRANCH"
		Update_Version force
		exit 0
	;;
	about)
		ScriptHeader
		Show_About
		exit 0
	;;
	help)
		ScriptHeader
		Show_Help
		exit 0
	;;
	*)
		ScriptHeader
		Print_Output false "Command not recognised." "$ERR"
		Print_Output false "For a list of available commands run: $SCRIPT_NAME help"
		exit 1
	;;
esac
