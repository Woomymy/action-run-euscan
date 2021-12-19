#!/usr/bin/env bash

set -e

find_packages() {
    DIRS=()
    for DIR in *
    do
	DASHES=$(echo $DIR | awk -F "-" '{print NF}')
	[[ "${DASHES}" != "2" ]] && continue
	
	# Ignore empty dirs
	[[ "$(ls "${DIR}" | wc -l)" == "0" ]] && continue

	DIRS+=" $DIR"
    done
    for DIR in $DIRS
    do
	for PACK in $DIR/*
	do
	    echo $PACK
	done
    done

}

cat << EOF
Running euscan version
$(euscan --version)
EOF

echo "Setting up repos"

REPO=$(cat profiles/repo_name)
cat >> "/etc/portage/repos.conf/${REPO}" << EOF
[${REPO}]
location = /var/db/repos/${REPO}
EOF

cp -r "${PWD}" "/var/db/repos/${REPO}"

PACKAGES=$(find_packages)

mkdir euscan-reports

for PACKAGE in $PACKAGES
do
    echo "Scanning ${PACKAGE}..."
    PKGNAME="$(echo $PACKAGE | sed -e "s/\//_/g")"
    euscan --format json $PACKAGE | tee euscan-reports/$PKGNAME.json
done
