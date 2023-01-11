#!/bin/bash
#
# Script feito com o objetivo de acelerar o processo
#de inserir bilhetes de chamadas no banco.
#
#informacoes importantes sobre o que o script deve fazer...
#
# 1 - ele vai pegar o arquivo da pasta de backup
# 2 - mandar para a tmp
# 3 - descompactar
# 4 - dar um grep para saber se tem bilhete.
# 5 - vai pegar os bilhetes e transformar em txt
# 6 - pegar os bilhetes do txt e cortar nai parte do insert
# 7 - fim do script
#
#Conta do operador para teste 7070
#
#Desenvolvido por: DevChimpa 10-01-2023
#contato: chimpadeveloper@gmail.com
#
##########################################################################

CAMINHO_ORIGEM="/home/backups/"

clear
echo "##################################################"
echo "           --------------------------------------"
echo "          insira as datas dos bilhetes desejados:"
echo "         /--------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
echo "Exemplos: 2023-01-01.tar.gz , 2023-01*, 2023* "
echo "#################################################"
read ARQUIVO_ZIP

clear
echo "######################################################"
echo "           ------------------------------------------"
echo "          insira a informação que gostaria de filtrar:"
echo "         /-------------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
echo " Exemplos: Conta, ramal, ou tipo de bilhete "
echo "#################################################"
read FILTRO_GREP

clear
echo "######################################################"
echo "           --------------------------"
echo "          Só um momento por favor..."
echo "         /---------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
sleep 2
# inicialmente o script está pegando como primeiro parametro os bilhetes
# e como segundo parametro o filtro que deve ser aplicado.
# futuramente pretendo solicitar cada parametro separadamente
#
if [ ! -d /tmp/bilhetes ]
then    mkdir -p /tmp/bilhetes
CAMINHO_DESTINO="/tmp/bilhetes"
else
        CAMINHO_DESTINO="/tmp/bilhetes"
fi

cd $CAMINHO_ORIGEM
cp $ARQUIVO_ZIP $CAMINHO_DESTINO
#####################################Trecho necessitando de correção
cd $CAMINHO_DESTINO
tar -zxf $ARQUIVO_ZIP
tar -xf *.tar

grep -ir $FILTRO_GREP >> bilhetes_salvos.txt

cat bilhetes_salvos.txt | awk -F "INSERT INTO" '{print "INSERT INTO"$2}' > inserts.txt

rm bilhetes_salvos.txt

clear
echo "######################################################"
echo "           -------------------------------------------"
echo "          Prontinho. Arquivo inserts em /tmp/bilhetes/"
echo "         /--------------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
sleep 5
clear

#ls $CAMIMNHO_DESTINO
#$CAMINHO_ORIGEM

#cd $CAMINHO_ORIGEM
#echo $ARQUIVO_ZIP
