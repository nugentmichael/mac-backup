#! /bin/bash

# Global Variables
OLD_IFS=${IFS};
IFS="
";

# Display the list of volumes currently mounted.
volumes=$(ls -d /Volumes/* | cut -c10-)

# Prompt which volume you wish to back up the user's data to.
echo "Which external drive do you wish to back up the user's data to?"

select volume in $volumes
    do
        read -rep "Selected volume: $volume. Do you wish to continue? Answer Y/y for Yes or N/n for No:`echo $'\n> '` " yn

        case $yn in
            [Yy]* )
                # Display the list of current users on the system to the user.
                users=$(ls -d /Users/* | cut -c8-)

                # Prompt which user you wish to back up.
                echo "Which user profile would you like to back up from this computer?"

                select user in $users                
                    do
                        read -rep "Selected user: $user. Do you wish to continue? Answer Y/y for Yes or N/n for No:`echo $'\n> '` " yn
                        
                        # Confirm action before proceeding
                        read -rep "We will now back up $user's files to $volume. Continue? Answer Y/y for Yes or N/n for No:`echo $'\n> '` " yn

                        # Create directory to store the user's backup data
                        # mkdir /Volumes/$volume/$user

                        # Backup the user's Desktop directory
                        printf "Backing up $user's Desktop directory... "
                        # cp -R /Users/$user/Desktop /Volumes/$volume/$user
                        printf "done.\n"

                        # Backup the user's Documents directory
                        printf "Backing up $user's Desktop directory... "
                        # cp -R /Users/$user/Documents /Volumes/$volume/$user
                        printf "done.\n"

                        # Backup the user's Downloads directory
                        printf "Backing up $user's Desktop directory... "
                        # cp -R /Users/$user/Downloads /Volumes/$volume/$user
                        printf "done.\n"

                        # Backup the user's Apple Notes directory that contains the SQLite file which stores the user's Apple Notes
                        printf "Backing up $user's Apple Notes... "
                        # cp -R /Users/$user/Library/Group Containers/group.com.apple.notes /Volumes/$volume/$user
                        printf "done.\n"

                        break
                done
                
                echo "\n$user's data has now been backed up."
            break;;

            [Nn]* ) 
                echo "Exiting. Goodbye!"
            exit;;
        esac
done