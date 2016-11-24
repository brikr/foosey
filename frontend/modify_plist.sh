#!/bin/bash

PLIST=platforms/ios/*/*-Info.plist

cat << EOF |
Add :NSAppTransportSecurity dict
Add :NSAppTransportSecurity:NSExceptionDomains dict
Add :NSAppTransportSecurity:NSExceptionDomains:foosey.futbol dict
Add :NSAppTransportSecurity:NSExceptionDomains:foosey.futbol:NSIncludesSubdomains bool YES
Add :NSAppTransportSecurity:NSExceptionDomains:foosey.futbol:NSExceptionAllowsInsecureHTTPLoads bool YES
EOF
while read line
do
    /usr/libexec/PlistBuddy -c "$line" $PLIST
done

true