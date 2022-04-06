#!/bin/bash


echo '''
	Welcome to SimpleAppLock for Linux
	----------------------------------

'''

setup_lock (){
echo '''
#!/bin/bash

entry=`zenity --password --title=Authentication`
pas=`echo $entry | cut -d"|" -f1`
inp_check=`echo $pas | sha256sum | cut -d" " -f1`
key_check=`cat /home/$USER/.SimpleAppLock/testApp/testApp.key`
applock=`echo "/home/$USER/.SimpleAppLock/testApp"`

if [ $inp_check = $key_check ]; then
        /usr/bin/testApp &
else
        dt=`date +%y%m%d_%H%M%S`
        streamer -o $applock/unauth_img/$dt.jpeg
        zenity --warning --text="Access Denied"
        echo "Unsuccessful login at $dt" >> $applock/unauth.log
        echo "  password = $pas" >> $applock/unauth.log
        echo "  id_capture = $dt.jpeg\n" >> $applock/unauth.log
fi
''' > $locker/authenticate.sh
chmod u+x $locker/authenticate.sh

}


simple_app_lock () {

read -p "Enter the app name: " app
locker=`echo "/home/$USER/.SimpleAppLock/$app"`

case $selopt in

    1)
        if [ -f /usr/share/applications/$app.desktop ]; then
	        echo """
	        
Enter the applock for $app.
Note: Reset option is not available for now. Keep the credentials safe with you
Only option is you can remove the applock for this app and relock later.
	        
	        """
	        if [ ! -d $locker/conf_bak ]; then mkdir -p $locker/conf_bak; fi
            if [ ! -d $locker/unauth_img ]; then mkdir -p $locker/unauth_img; fi
	        read -p "Password: " pas
	        echo $pas | sha256sum | awk '{print $1}' > $locker/$app.key
	        setup_lock
	        sed -i "s/testApp/$app/g" $locker/authenticate.sh 
	        cp /usr/share/applications/$app.desktop $locker/conf_bak/ && sudo sed -i "s/Exec=.*/Exec=\/home\/$USER\/.SimpleAppLock\/$app\/authenticate.sh/g" /usr/share/applications/$app.desktop
	        if [ -f ~/.bash_aliases ]; then
	            echo "alias $app='$locker/authenticate.sh'" >> ~/.bash_aliases
	        else
	            echo "alias $app='$locker/authenticate.sh'" >> ~/.bashrc
	        fi
	        	        
        else
	        echo -e "Application not be found.\nPease try again later"
        fi
        ;;
        
    2)
        if [ -f $locker/conf_bak/$app.desktop ]; then
            sudo cp $locker/conf_bak/$app.desktop /usr/share/applications/ && echo "Configurations restored"
            rm -rf $locker
            sed -i "s/.*SimpleAppLock\/$app.*//g" ~/.bashrc
            sed -i "s/.*SimpleAppLock\/$app.*//g" ~/.bash_aliases
            
        else
            echo "Older configurations not found in default path. Try with a custom configuration path"
            read cust_path
            if [ -f $custom_path/$app.desktop ]; then
                sudo cp $custom_path/$app.desktop /usr/share/applications/ && echo "Configurations restored"
                rm -rf $locker
                sed -i "s/.*SimpleAppLock\/$app.*//g" ~/.bashrc
                sed -i "s/.*SimpleAppLock\/$app.*//g" ~/.bash_aliases
            fi
        fi
        ;;
    *)
        echo "Invalid Option try again"
        ;;
esac

}


if [ ! -f /home/$USER/.SimpleAppLock/master.key ]; then
	mkdir -p /home/$USER/.SimpleAppLock
	echo ""
	echo "Set a master password for the SimpleAppLock"
	echo "Note: Keep the Master Pasword safe with you"
	read -p "Press Enter to Continue " var
	master_pass=`zenity --password --title='Master Password'`
	echo $master_pass | sha256sum | cut -d' ' -f1 > /home/$USER/.SimpleAppLock/master.key
	echo "Master Password set. Please run the script again"
	exit
else
	echo "Enter the Master Password to Continue"
	read -p "Press any key to Continue " var
	inp_master=`zenity --password --title='Master Password'`
	mast_check=`echo $inp_master | sha256sum | cut -d' ' -f1` 
	if [ $mast_check = $(cat /home/$USER/.SimpleAppLock/master.key) ]; then
		echo '''
1. Setup Applock
2. Remove Applock
'''
		read -p "Choose an Option to continue: " selopt
		simple_app_lock
	else
		echo "Master password does not match. Please Try again Later"
	fi

fi
