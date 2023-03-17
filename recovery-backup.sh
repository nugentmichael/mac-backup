#! /bin/bash

# Global Variables
OLD_IFS=${IFS};
IFS="
";

# Display the list of volumes currently mounted.
volumes=$(ls -d /Volumes/* | cut -c10-)

# Initialization Introductory Message
echo "
################################################################
#                                                              #
#          Welcome to the Mac Backup Utility script!           #
#                                                              #
#  Please ensure that you mount the Data partition first       #
#  by opening Disk Utility and selecting the Data parition     #
#  after expanding the main Macintosh HD volume.               #
#                                                              #
#  This script requires an external volume to be plugged       #
#  into the computer that will be used to back up the user's   #
#  data to.                                                    #
#                                                              #
#  If prompted, insert the macOS login password to unlock the  #
#  FileVault encryption that is set on the volume.             #
#                                                              #
################################################################
"

# Prompt which volume you wish to back up the user's data to.
echo "External Drives:"
PS3="Which external drive listed above do you wish to back up the user's data to?`echo $'\n> '` "

select volume in ${volumes[@]}; do
	# Error handling if the user selected an invalid value within the volumes array.
	if [[ -n $volume ]]; then
		read -rep "Selected volume: $volume. Do you wish to continue? Answer Y/y for Yes or N/n for No:`echo $'\n> '` " yn

		case $yn in
			[Yy]* )
				# Display the list of current users on the system to the user.
				users=$(ls -d /Volumes/Data/Users/* | cut -c8-)

				if [[ -n $users ]]; then
					# Prompt which user you wish to back up.
					PS3="Which user profile would you like to back up from this computer? "

					select user in ${users[@]}; do
						# Error handling if the user selected an invalid value within the users array.
						if [[ -n $user ]]; then
							read -rep "Selected user: $user. Do you wish to continue? Answer Y/y for Yes or N/n for No:`echo $'\n> '` " yn
							
							# Confirm action before proceeding
							read -rep "We will now back up $user's files to $volume. Continue? Answer Y/y for Yes or N/n for No:`echo $'\n> '` " yn

							# Create directory to store the user's backup data
							mkdir /Volumes/$volume/$user

							# Backup the user's Desktop directory
							printf "Backing up $user's Desktop directory... "
							cp -R /Volumes/Data/Users/$user/Desktop /Volumes/$volume/$user
							printf "done.\n"

							# Backup the user's Documents directory
							printf "Backing up $user's Documents directory... "
							cp -R /Volumes/Data/Users/$user/Documents /Volumes/$volume/$user
							printf "done.\n"

							# Backup the user's Downloads directory
							printf "Backing up $user's Downloads directory... "
							cp -R /Volumes/Data/Users/$user/Downloads /Volumes/$volume/$user
							printf "done.\n"

							# Backup the user's Apple Notes directory that contains the SQLite file which stores the user's Apple Notes
							printf "Backing up $user's Apple Notes... "
							cp -R /Volumes/Data/Users/$user/Library/Group Containers/group.com.apple.notes /Volumes/$volume/$user
							printf "done.\n"

							echo "$user's data has now been backed up to $volume. Goodbye!"
							break
						else
							echo "Invalid input. Please restart the script.";
							break;
						fi   
					done
				else
					echo "Error in retrieving users. Please ensure that you have the Data parition mounted in Disk Utility before proceeding. Exiting."
					break
				fi
			break;;

			[Nn]* ) 
				echo "Exiting. Goodbye!"
			break;;
			* ) echo "Invalid input. Please try again." >&2
		esac
	else
		echo "Invalid input. Please restart the script."
		break
	fi
done