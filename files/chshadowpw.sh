#! /bin/sh

PW_EXE=crypt_pw
USER=root

password="$1"
shadow_file="$2"

argc="$#"

usage() {
	cat <<EOF
Usage: $0 <password> </path/to/shadow/file>
EOF
}

do_init() {
	if [ "$argc" -lt "1"  ]; then
		usage
		exit 1
	fi

	if [ "$shadow_file" = "" ]; then
		shadow_file="/etc/shadow"
	else
		if [ ! -f "$shadow_file" ]; then
			echo "$shadow_file: No such file"
			exit 1
		fi
	fi
}

do_verify() {
	local gen_pw="$1"
	local sad_pw=`grep "^$USER:" $shadow_file | head -n 1 | awk -F ':' '{print $2}'`

	if [ "$gen_pw" = "$sad_pw" ]; then
		echo "Password for $USER changed"
	else
		echo "WARN: Failed to change $USER password"
	fi
	#grep "^$USER:" $shadow_file
}

ch_shadow() {
	local new_pw=''

	if [ "$password" = "" ]; then
		new_pw=`$PW_EXE ''`
	else
		new_pw=`$PW_EXE $password`
	fi

	local escape_pw=`echo $new_pw | sed 's/\\$/\\\\$/g'`
	sed -i -e  "s,^$USER:\([^:]\+\|[^:]\?\):,$USER:$escape_pw:," $shadow_file
	do_verify "$new_pw"
}

do_main() {
	do_init
	ch_shadow
}

do_main
