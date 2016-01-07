###############################################
#  TURTLE ME - ETHERNET AND WIFI @ TOGETHER   #
#            Smali code here:                 #
#      http://stackoverflow.com/a/33938162    #
#       Requires ADB, JAVA, and PERL          #
#                                             #
##### ORIGNAL ConnectivityService.smali #######
#                                             #
#    if-eqz v19, :cond_1b1\n                  #
#\n                                           #
#    .line 4266                               #
#                                             #
##### REPLACE ConnectivityService.smali #######
#    goto :cond_1b1                           #
#\n                                           #
#    .line 4266                               #
#                                             #
###############################################

# Pull services.jar and unpack to smali code

adb pull /system/framework/services.jar
cp services.jar services.jar.bak
unzip services.jar classes.dex
java -jar baksmali.jar classes.dex
sleep 3

# Find line to edit, then replace.  Need to match multiple lines

perl -0777 -i.original -pe 's/if-eqz v19, :cond_1b1\n\n    .line 4266/    goto :cond_1b1\n\n    .line 4266/igs' ./out/com/android/server/ConnectivityService.smali

# Repack and send to device

java -jar smali.jar -o classes.dex out
zip services.jar classes.dex
adb push services.jar /system/framework/services.jar