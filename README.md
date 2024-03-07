I wanted to start a collection of scripts I wrote over the years.
Nothing fancy. Just some tools.

# appendandexpand.sh
Sometimes in a container enviroment a file needs to be appended, and the first part of the file not changed.
This script appends a File $TARGET with some text $VAR.
It checks if the content has changed, and appends the changed content of $VAR if needed.
