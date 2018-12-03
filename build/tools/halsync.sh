#!/bin/bash
if [ ! -f .repo/local_manifests/hals.xml ]; then
# Initial vars setup
    REMOTE="kaf"

# Sanitize the vars used internally by this script
    unset HALS

# Make the HALs manifest
    echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<manifest>' > .repo/local_manifests/hals.xml
    for hal in $(<target_hals); do
        rev=$(echo $hal | sed -e 's/.*://')
        path=$(echo $hal | sed -e 's/:.*//')
        name=$(echo $path | sed -e 's=/=_=g')
	    echo '  <project path="'"$path"'" name="'"$name"'" remote="'"$REMOTE"'" revision="'"$rev"'" />' >> .repo/local_manifests/hals.xml
        HALS=$(echo -e "$HALS $path")
    done
    echo "</manifest>" >> .repo/local_manifests/hals.xml

# Repo sync all the HALs
    for hals in $HALS; do if ! repo sync --force-sync "$hals" &> /dev/null; then FAILED=1; fi; done

# Remove the manifest so we know if the user overrided it
    rm -rf .repo/local_manifests/hals.xml

# Exit 1 if the script failed
    if [ "$FAILED" == "1" ]; then exit 1; else exit 0; fi

#else
# The user overrided the manifest
# TODO: Tell the user that he did this
fi
