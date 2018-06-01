#! /bin/bash
#sed '$a  '$a'.halo.10' /root/test.txt
#echo -e "\033[41;33m 红底黄字 \033[0m"
#echo -e "\033[32m 黑底绿字 \033[0m" 
#echo -e "\033[36m 黑底青字 \033[0m"
#echo -e "\033[36m"

txtname="/root/test.txt"

existsFile(){
	[ ! -f $txtname  ] && echo "No record！" && continue
}

search(){
	read -p "please enter name >>>" name
	[ -z $name ] && echo "you didn't enter a name" && continue 
	[ ! -f $txtname  ] && echo "you  must  have  some  scores  before  you  can  search!" && continue
	grep $name $txtname
	if [ $? -ne 0 ];then
		echo name  not  in record
		sleep 1
	else
		sleep 3		
	fi
}

add(){
       read -p "enter name and score of a record >>>" namescore
       [ -z $namescore ] && echo "you didn't enter a name" && add continue

       if [[ ! "$namescore" =~ \.+  ]];then 
		 echo valid score
	 	add
       fi
       lastnum=`tail -1 $txtname |awk -F. '{print $1}'`
       sed -r -i '/^('$lastnum'\.)/a '$[lastnum+1]'.'$namescore'' $txtname
       echo added $namescore in record
       continue
}

delete(){
	cat $txtname
	echo '----------------------------------------------'
	read -p "enter num of record >>>" num
	lastrow=`sed -n "$=" $txtname`
	egrep '^('$num'\.)' $txtname >& null
	if [ $? -ne 0 ];then
	 echo valid num
	 delete
	fi
	sed -i -r '/^('$num'\.)/d' $txtname
	echo '---------------------------------------------'
	cat $txtname
}

while :
do
echo -e "\033[41;33m ############################################ \033[0m"
echo -e "\033[41;33m #        1:search a record                 # \033[0m"
echo -e "\033[41;33m #        2:add a record                    # \033[0m"
echo -e "\033[41;33m #        3:delete a record                 # \033[0m"
echo -e "\033[41;33m #        4:display all record              # \033[0m"
echo -e "\033[41;33m #        5:edit record with vi             # \033[0m"
echo -e "\033[41;33m #        H:help screen                     # \033[0m"
echo -e "\033[41;33m #        Q:exit program                    # \033[0m"
echo -e "\033[41;33m ############################################ \033[0m"
echo -e "\033[32m"
read -p "please enter your choice [1 2 3 4 5 H Q]:"  num
case $num in 
1)
	search;;
2)
	add;;
3)
	existsFile
	delete;;
4)
	existsFile
	cat $txtname
;;
5)
existsFile
vim $txtname;;
h|H)
echo -e "\033[36m This  is  a  student's  record  manager  program"
sleep 3
continue
;;
q|Q)
echo -e "\033[0m"
exit;;
*)
echo please enter  valid mode
sleep 3
;;
esac
done
