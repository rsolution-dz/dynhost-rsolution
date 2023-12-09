#/bin/sh
#########################################################################
# A simple (cron) script to update DynHost on RSolution Hosting 
# https://github.com/rezgui/dynhost-rsolution (Yacine REZGUI) 
# forked from https://github.com/yjajkiew/dynhost-ovh (Yann Jajkiewicz) 
#########################################################################

#
# CONFIG
##################################

DNS='ns1.rsolution.dz'
HOST='oracle.rsolution.dz'
LOGIN='oracle'
PASSWORD='Oracle_Lisa$$2023'
DYNDNS='https://dnsadmin.rsolution.dz/dynamic_update.php?system=dyndns'
OPTIONS='--silent'
VERBOSE=0
SHOWMSG=true

PATH_LOG=./dynhost.log
CURRENT_DATE=`date`

#
# GET IPs
##################################

HOST_IP=`dig +short $HOST @$DNS`
CURRENT_IP=`curl -4 ifconfig.me/ip $OPTIONS`

#
# DO THE WORK
##################################

echo "------------------------------------------------------------------------------------------" >> $PATH_LOG

if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
then
        echo "$CURRENT_DATE : No IP retrieved" >> $PATH_LOG
else
        if [ "$HOST_IP" != "$CURRENT_IP" ]
        then
                RES=`curl $DYNDNS&hostname=$HOST&myip=$CURRENT_IP&verbose=$VERBOSE --user $LOGIN:$PASSWORD $OPTIONS`

                echo "$CURRENT_DATE" >> $PATH_LOG
                echo "IP has changed!" >> $PATH_LOG
				echo "Current IP: $CURRENT_IP --> New IP: $HOST_IP" >> $PATH_LOG
                echo "Result request dynHost:" >> $PATH_LOG
                echo "$RES" >> $PATH_LOG

                if [ "$SHOWMSG" == true]
				then
	                echo "$CURRENT_DATE" 
    	            echo "IP has changed!" 
					echo "Current IP: $CURRENT_IP --> New IP: $HOST_IP" 
                	echo "Result request dynHost:" 
                	echo "$RES"
				fi

        else
                echo "$CURRENT_DATE" >> $PATH_LOG
                echo "IP has not changed" >> $PATH_LOG
				echo "Unchanged IP: $CURRENT_IP" >> $PATH_LOG

                if [ "$SHOWMSG" == true ]
				then
                	echo "$CURRENT_DATE" 
                	echo "IP has not changed" 
					echo "Unchanged IP: $CURRENT_IP"
				fi
        fi
fi
