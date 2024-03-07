#!/bin/sh
##
### Sometimes in a container enviroment a file needs to be appended, and the first part of the file not changed.
### This script appends a File $TARGET with some text $VAR.
### It checks if the content has changed, and appends the changed content of $VAR if needed.

# The file to append
TARGET="/var/www/html/.htaccess"

# The content to append, in this case rules for nginx
VAR=$(cat <<-EOM
###-my-rules-START###
# No Upload Limit for Apache
LimitRequestBody 0
# Limit Access to some ips
<If "%{THE_REQUEST} =~ m#^.*/login#">
    Require all denied
    Require ip 0.0.0.0
</If>
###-my-rules-END###
EOM

)

# read the file content 
FILECONTENT=`cat $TARGET`
# cut and keep the original content if there is already a my-rule in the file
CUTSPAM=${FILECONTENT%\#\#\#-my-rules-START\#\#\#*}
# cut and keep the my-rule part to compare
CUTHAM=${FILECONTENT#*my-rules-START\#\#\#}
# extent the my-rule part with the header, it got cut a line above
COCOMPARE="###-my-rules-START###${CUTHAM}"

# if the file has no line containing the my-rule header
if grep -Fxq "###-my-rules-START###" $TARGET then
   # compare if the content of the rules has changed. If not no change, if the content changed paste it to the file
   [ "$VAR" = "$COCOMPARE" ] && echo "${TARGET} rules not changed" || (echo "$CUTSPAM$VAR" > $TARGET && echo "${TARGET} rules updated") 
else
    # No my-rules header in the file, just append the my-rules
    echo "${TARGET} rules added"
    echo "$VAR" >> $TARGET
fi
