#! /bin/bash

response=alias net="$(pwd)/webConnect.sh"
if ! grep -q $response ~/.bashrc; then
echo alias net="$(pwd)/webConnect.sh" >> ~/.bashrc
fi

echo ""
echo "Chose your network"
echo "Frecuently used      f"
echo "New network          n"

read -s -n 1 decision 

menu(){

case $decision in
f)
selected=true
process
;;
n)
selected=false
process
;;
*)
menu
;;
esac
}

options(){
read -s -n 1 option
case $option in
y)
echo $savedNet >> $netSaved
echo $savedPass >> $netPassSaved
echo "saved!"
;;
n)
exit 1
;;
*)
options
;;
esac
}

process(){
nmcli d wifi list
netSaved="networkDatas.txt"
netPassSaved="networkPasswordDatas.txt"

if [ -f $netSaved ]
then
if [ $selected = true ]
then
if [ -s $netSaved ]
then
echo "what network do you want to connect?"
echo "press the number visible in the left side of the window"
num=0
while IFS= read -r line
do
num=$((num + 1))
echo $num")" $line
done < $netSaved

read -s -n 1 multi

case $multi in
1)
net=$(sed -n '1p' $netSaved)
pass=$(sed -n '1p' $netPassSaved)
;;
2)
net=$(sed -n '2p' $netSaved)
pass=$(sed -n '2p' $netPassSaved)
;;
3)
net=$(sed -n '3p' $netSaved)
pass=$(sed -n '3p' $netPassSaved)
;;
4)
net=$(sed -n '4p' $netSaved)
pass=$(sed -n '4p' $netPassSaved)
;;
esac
nmcli d wifi connect $net password $pass
fi
exit
fi
else
touch networkDatas.txt
touch networkPasswordDatas.txt
fi

echo "Introduce the name of the network"
read net
echo "Introduce the password of the network"
read pass
nmcli d wifi connect $net password $pass

echo "Do you like to save this network?"
echo "yes or no                    y/n"
savedNet=$net
savedPass=$pass
options
}

nmcli r wifi on
menu
