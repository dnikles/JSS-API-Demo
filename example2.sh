#!/bin/bash

#set username, password, and JSS location
#jssAPIUsername="user"
#jssAPIPassword="password"
jssAddress="YourJSSURL"

#set variable for cocoa dialog
CD="CocoaDialog.app/Contents/MacOS/CocoaDialog"

#Get the JSS Username
rv=`$CD standard-inputbox --informative-text "Please enter JSS Username" --title "Username"`
#extract the values of which button was clicked and which text was entered
buttonclicked=$(echo "$rv"|awk 'NR==1{print}')
jssAPIUsername=$(echo "$rv"| awk 'NR>1{print}')
#if the button was cancel, let's exit the script
[ $buttonclicked -eq 2 ] && exit 1

#Get the JSS Password
rv=`$CD standard-inputbox --informative-text --no-show "Please enter the password" --title "Password"`
#extract the values of which button was clicked and which text was entered
buttonclicked=$(echo "$rv"|awk 'NR==1{print}')
jssAPIPassword=$(echo "$rv"| awk 'NR>1{print}')
#if the button was cancel, let's exit the script
[ $buttonclicked -eq 2 ] && exit 1

#Get the asset tag of the device
rv=`$CD standard-inputbox --informative-text "Please enter the asset tag number" --title "Asset Tag"`
#extract the values of which button was clicked and which text was entered
buttonclicked=$(echo "$rv"|awk 'NR==1{print}')
textentered=$(echo "$rv"| awk 'NR>1{print}')
#if the button was cancel, let's exit the script
[ $buttonclicked -eq 2 ] && exit 1

#Lookup the device id from the given asset tag number
myOutput=`curl -H "Accept: application/xml" -su ${jssAPIUsername}:${jssAPIPassword} -X GET ${jssAddress}/JSSResource/mobiledevices/match/$textentered`
#Parse the name
myName=`echo $myOutput | xpath /mobile_devices/mobile_device/name[1] | awk -F'>|<' '/name/{print $3}'`
#if we can't find the ID try again
if [ -z "$myName" ] 
    then
    $CD msgbox --title "Oops" --text "Bummer" --informative-text "The asset number $textentered was not found" --button1 "Oh well"
    exit 1
fi
#Return a message box with the name of the device
myMsg=`$CD msgbox --text "$myName is the name of iPad $textentered" --button1 "Neat"`

