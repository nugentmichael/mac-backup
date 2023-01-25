#! /bin/bash

# Global Variables
OLD_IFS=${IFS};
IFS="
";

# Display the list of volumes currently mounted.
# cd /Volumes
# volumes=$(ls -d */ | cut -f1 -d'/')
volumes=$(ls -d /Volumes/* | cut -c10-)
# echo $volumes

# Prompt which volume you wish to back up the user's data to.
echo "Which external drive do you wish to back up the user's data to?"

select volume in $volumes
    do
        read -rep "Selected volume: $volume. Do you wish to continue? Answer Y/y for Yes or N/n for No:`echo $'\n> '` " yn

        case $yn in
            [Yy]* )
                # Display the list of current users on the system to the user.
                # cd /Users
                users=$(ls -d /Users/* | cut -c8-)
                # echo $users

                # Prompt which user you wish to back up.
                echo "Which user profile would you like to back up from this computer?"

                select user in $users                
                    do
                        echo "Selected user: $user"
                        read -rep "Selected user: $user. Do you wish to continue? Answer Y/y for Yes or N/n for No:`echo $'\n> '` " yn
                done
                
                echo "The user's data has now been backed up."
            break;;

            [Nn]* ) 
                echo "Exiting. Goodbye!"
            exit;;
        esac
done