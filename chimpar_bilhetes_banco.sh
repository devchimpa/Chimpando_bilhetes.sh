#!/bin/bash
#
# Script feito com o objetivo de acelerar o processo
#de inserir bilhetes de chamadas no banco.
#
#
#
#Desenvolvido por: DevChimpa 10-01-2023
#contato: chimpadeveloper@gmail.com
#
# Atualização 12-01-2023
# Atualizado a forma como se busca bilhetes para tentar reduzir os erros.
# próximos passos, testar se foi inserido valor nas variáveis ARQUIVO_ENTRADA e FILTRO_GREP
# caso FILTRO_GREP esteja vazio, substituir por insert
#
##########################################################################

CAMINHO_ORIGEM="/home/backups/"

clear
echo "##################################################"
echo "           --------------------------------------"
echo "          Insira os arquivos de bilhetes.       "
echo "         /--------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
echo "Exemplos: 2023-01-01.tar.gz  ou  2023-01-*       "
echo "#################################################"
ls -m $CAMINHO_ORIGEM
read ARQUIVO_ENTRADA
clear

clear
echo "##################################################"
echo "           --------------------------------------"
echo "          Qual informação gostaria de filtrar?   "
echo "         /--------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
read FILTRO_GREP
clear

echo "##################################################"
echo "           --------------------------------------"
echo "          Um momento por favor...                "
echo "         /--------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"

echo $ARQUIVO_ENTRADA >> /tmp/listadebilhetes.txt
cat -T /tmp/listadebilhetes.txt | tr ' ' '\n' > /tmp/nova_lista.txt
sleep 2
rm /tmp/listadebilhetes.txt

#cat /tmp/nova_lista.txt

ARQUIVO_PRIMARIO="/tmp/nova_lista.txt"
while read PRIMEIRAENTRADA;
do
        cd $CAMINHO_ORIGEM
        ls "$CAMINHO_ORIGEM" | grep "$PRIMEIRAENTRADA" > /tmp/lista_pasta.txt
       # ls "$CAMINHO_ORIGEM$PRIMEIRAENTRADA" > /tmp/lista_pasta.txt
        sort /tmp/lista_pasta.txt | uniq | grep / -v > /tmp/sembranco.txt
        awk 'NF>0' /tmp/sembranco.txt > /tmp/ListaFinal.txt

done < $ARQUIVO_PRIMARIO

rm /tmp/lista_pasta.txt
rm /tmp/nova_lista.txt

ARQUIVO_TEXTO="/tmp/ListaFinal.txt"

while read ARQUIVOLINHA;
do
        #echo "Arquivo: $ARQUIVOLINHA"
        cd $CAMINHO_ORIGEM
                if [ ! -d /tmp/bilhetes ]
                then    mkdir -p /tmp/bilhetes
                CAMINHO_DESTINO="/tmp/bilhetes"
                else
                CAMINHO_DESTINO="/tmp/bilhetes"
                fi
        echo "Copiando ... "
        sleep 2
        cp -v $ARQUIVOLINHA /tmp/bilhetes
        cd $CAMINHO_DESTINO
        echo "Desarquivando ..."
        sleep 2
        tar -zxvf $ARQUIVOLINHA
        sleep 2
        rm $ARQUIVOLINHA
        ARQUIVOTAR=$(ls *.tar)
        echo "Descompactando..."
        sleep 2
        tar -xvf $ARQUIVOTAR
        sleep 2
        echo "Procurando bilhetes..."
        rm $ARQUIVOTAR
        sleep 2
        grep -ir $FILTRO_GREP >> /tmp/grepbilhetes.txt
        PASTA=$(ls )
        rm -r $PASTA
        cd /tmp
        cat grepbilhetes.txt | awk -F "INSERT INTO" '{print "INSERT INTO"$2}' > inserts.txt
        rm grepbilhetes.txt

done < $ARQUIVO_TEXTO

sleep 2

rm -r /tmp/bilhetes
rm -r /tmp/sembranco.txt
rm -r /tmp/ListaFinal.txt


echo "######################################################"
echo "           -------------------------------------------"
echo "          Pronto. Arquivo inserts.txt em /tmp"
echo "         /--------------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
