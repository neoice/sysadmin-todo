newday() {
	# set up our directories so we can check validity
	TODO_PATH=$HOME/TODO

	if [ -z $HOME ]
	then
		# not having a $HOME could potentially lead to unsafe
		# operations on the root directory (/)
		echo "you are somehow missing a \$HOME variable."
		return 2
	fi

	if [ -e $TODO_PATH ]
	then
		if [ ! -d $TODO_PATH ]
		then
			echo "your \$TODO_PATH is not a directory"
			return 2
		fi
	fi

	LASTFILE=$TODO_PATH/`ls -t1 $TODO_PATH | head -n1`
	FILENAME=$TODO_PATH/`date +%F`

	# set up our new day's list!
	cp $LASTFILE $FILENAME

	# add checkboxes to all items
	sed --in-place -e "s/^\([^\[]\)/[ ] \1/" $FILENAME

	# remove checked items
	sed --in-place -e "s/^\[x\].*$//" $FILENAME

	# removed "postponed" flag
	sed --in-place -e "s/^\[-\]/[ ]/" $FILENAME

	# delete blank lines
	sed --in-place "/^$/d" $FILENAME
}

todo() {
	# [ ] no completed
	# [-] postponed
	# [+] delegated
	# [x] completed

	# set up our directories so we can check validity
	TODO_PATH=$HOME/TODO

	if [ -z $HOME ]
	then
		# not having a $HOME could potentially lead to unsafe
		# operations on the root directory (/)
		echo "you are somehow missing a \$HOME variable."
		return 2
	fi

	if [ -e $TODO_PATH ]
	then
		if [ ! -d $TODO_PATH ]
		then
			echo "your \$TODO_PATH is not a directory"
			return 2
		fi
	fi

	FILENAME=$TODO_PATH/`date +%F`

	# add checkboxes to all items
	sed --in-place -e "s/^\([^\[]\)/[ ] \1/" $FILENAME
	vim $FILENAME
}
