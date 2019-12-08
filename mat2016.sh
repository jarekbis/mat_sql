#! /bin/bash
##############################zadanie 4
 
rm punkty_pi.txt  wykres.gnuplot blad.png 2>/dev/null
pi=$(echo "scale=8; 4*a(1)" | bc -l)
echo "4.1" | tee wyniki_4.txt
c=0 l=0 cat punkty.txt | dos2unix | \
while true ; do \
        read a ; \
        if [ -z "$a" ] ; then \
                echo -e "$c \n4.2\n" \
                $(echo -e "scale=4; 4*$c1/1000 ; 4*$c5/5000 ; 4*$c/$l" | bc -l );\
                echo -e "4.3\n"\
                $(echo -e "scale=4; sqrt((4*$c1/1000-$pi)^2); sqrt((4*$c7/1700-$pi)^2)" | bc -l);\
                break ; \
        fi;\
        l=$(($l+1));\
        u=$(echo $a | sed "s/\([0-9]*\) \([0-9]*\)/\(\1-200\)\*\*2\+\(\2-200\)\*\*2/g" ); \
        if [ $(($u - 200*200 )) -eq 0 ] ; then echo $a ; \
                else if  [ $(($u - 200**2 )) -lt 0 ] ; then  c=$(($c+1)) ; fi ; \
        fi ; \
        if [ $l -eq 1000 ] ; then c1=$c ; fi; \
        if [ $l -eq 1700 ] ; then c7=$c ; fi; \
        if [ $l -eq 5000 ] ; then c5=$c ; fi; \
        if [ $l -le 1700 ] ; then $(echo "scale=8 ; sqrt((4*$c/$l-$pi)^2)" | bc -l >> punkty_pi.txt); fi
done | tee -a wyniki_4.txt
cat << EOF > wykres.gnuplot
#! /usr/bin/gnuplot
set terminal pngcairo enhanced size 450,320 font "arial,10"
set output 'blad.png'
set key inside left top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
set title "Błąd bezwzględny po kolejnych próbkach"
set title  font ",12" norotate
set xlabel "Nr próbki"
set ylabel "wartość błędu"
plot [1:1700] 'punkty_pi.txt'
EOF
chmod +x wykres.gnuplot
./wykres.gnuplot
#####################zadanie 5
rm wyniki_5.txt 2>/dev/null
echo 5.1 | tee wyniki_5.txt
u=$(tail -n +2 wypozyczenia.txt | cut -f 2 | sort | uniq -d -c | sort | tail -n1)
u=${u##* } #do u wez ostatnia czesc wartosci u bez spacji
grep $u studenci.txt | cut -f 2,3 | tee -a wyniki_5.txt
grep $u wypozyczenia.txt | cut -f 3 | tee -a wyniki_5.txt
echo 5.2 | tee -a wyniki_5.txt
u=$( tail -n +2 meldunek.txt | cut -f 1 | sort | uniq | wc -l)
c=$( tail -n +2 meldunek.txt | cut -f 2 | sort | uniq | wc -l)
echo "scale=4; $u/$c" | bc -l  | tee -a wyniki_5.txt
echo 5.3 | tee -a wyniki_5.txt
u=$(tail -n +2 studenci.txt | wc -l)
c=$(tail -n +2 studenci.txt | cut -f 1 | cut -c10 | grep "[13579]" | wc -l)
echo -e "Kobiet $(($u - $c)) \nMężczyzn $c" | tee -a wyniki_5.txt
echo 5.4 | tee -a wyniki_5.txt
tail -n +2 studenci.txt | cut -f 1 | sort > stud.bak
tail -n +2 meldunek.txt | cut -f 1 | sort > meld.bak
for i in $( diff stud.bak meld.bak | grep "<" | cut -c3- ) ; do
grep $i studenci.txt | cut -f 2,3
done | sort | tee -a wyniki_5.txt
rm stud.bak meld.bak
echo 5.5 | tee -a wyniki_5.txt
#zamieniam pesele na odpowiedni numer pokoju, najpierw sed-em przygotowuje wyrazenie do sed-a :)
u=$(tail -n +2 meldunek.txt | dos2unix | sed 's/^/s#/g;s/\t/#/g;s/$/#g/g;'| tr "\n" ";")
cp wypozyczenia{.txt,.bak}
sed -i -e "$u" wypozyczenia.bak
tail -n +2 wypozyczenia.bak | cut -f 2,3 | sort | uniq -D > duble.bak
#uwaga w duble.bak moga znalezc sie studenci niezameldowani ktorzy wypozyczyli 2 takie same ksiazki
u=$(tail -n +2 wypozyczenia.bak | wc -l)
c=$(cat duble.bak | wc -l)
i=$(uniq -d duble.bak| wc -l)
echo $(( $u - $c + $i)) | tee -a wyniki_5.txt
rm duble.bak wypozyczenia.bak 2>/dev/null
 
############# Zadanie 6
##64+#12345678901234567890123456
azet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
k=$((107%26))
cez=${azet:k}${azet}
cat dane_6_1.txt | tr $azet $cez > wyniki_6_1.txt
cat dane_6_2.txt | dos2unix |
while true ; do
        read szyf k
        if [ -z $k ] ; then
                if [ -z $szyf ] ; then break; else continue ; fi ; fi
        k=$((26-$k%26));
        cez=${azet:k}${azet}
        echo $szyf | tr  $azet $cez
done > wyniki_6_2.txt
cat dane_6_3.txt| dos2unix |
while true; do
        read slowo szyf
        if [ -z $szyf ] ; then break ; fi
        if [ ${#slowo} -ne ${#szyf} ] ; then echo $slowo ; break; fi
        c=$(printf "%d" "'${slowo:0:1}")
        i=$(printf "%d" "'${szyf:0:1}")
        u=$(((26+$c-$i)%26))
        for k in $(seq 1 $((${#slowo}-1))); do
                c=$(printf "%d" "'${slowo:k:1}")
                i=$(printf "%d" "'${szyf:k:1}")
                if [ $(((26+$c-$i)%26)) -ne $u ]; then
                        echo $slowo ; break;
                fi
        done
done > wyniki_6_3.txt
