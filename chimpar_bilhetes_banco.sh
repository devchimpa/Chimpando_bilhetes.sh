#!/bin/bash
#
# Script feito com o objetivo de acelerar o processo
#de inserir bilhetes de chamadas no banco.
#
#informacoes importantes sobre o que o script  faz...
#
# 1 - ele vai pegar o arquivo da pasta de backup
# 2 - mandar para a tmp
# 3 - descompactar
# 4 - dar um grep para saber se tem bilhete.
# 5 - vai pegar os bilhetes e transformar em txt
# 6 - pegar os bilhetes do txt e cortar na parte do insert
# 7 - remover a pasta, o tar.gz e tar da pasta /tmp
# 8 - fim do script
#
#
#
#Desenvolvido por: DevChimpa
#Data: 10-01-2023
#Contato: chimpadeveloper@gmail.com
#https://github.com/devchimpa/
#
########################################################################
#
# Siga o modelo abaixo caso mexa no script: ############################
#
#Modificado por:
#Data:
#Contato:
#Modificação feita:
#
##########################################################################


#CAMINHO_ORIGEM="/home/backups/"
CAMINHO_ORIGEM="/home/extend/calls/backup/"

ls  $CAMINHO_ORIGEM
echo "##################################################"
echo "           --------------------------------------"
echo "          Insira os arquivos de bilhetes.       "
echo "         /--------------------------------------"
echo "        /
     /~\
   C(o o)D   -----
    _(^)   /    /
   /__m~\m/____/ "
echo "############################################################"
echo "Ex: 2023-01-01.tar.gz , 2023-01-* 2023-01-0[1-5].tar.gz     "
echo "############################################################"
read ARQUIVO_ENTRADA
clear
VALORENTRADA=$(echo ${#ARQUIVO_ENTRADA})
if [ $VALORENTRADA -eq 0 ]
        then
                echo "Insira algum arquivo válido."

                exit
fi

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
echo "Ex: conta, ramal, atendidas ..."
echo "#################################################"
read FGREP
ENTRADAGREP=$(echo ${#FGREP})
if [ $ENTRADAGREP -eq 0 ]
        then
               FILTRO_GREP=Insert
        else FILTRO_GREP="$FGREP"
        fi
clear
#echo "$FILTRO_GREP"
#sleep 10
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

#echo $ARQUIVO_ENTRADA

############################## Este trecho pode resolver parte do código e reduzir as filtragens

echo "$ARQUIVO_ENTRADA" >> /tmp/listadeentrada.txt

for listadearquivos in $(cat /tmp/listadeentrada.txt)
        do
                ls $CAMINHO_ORIGEM | grep $listadearquivos >> /tmp/listadebilhetes.txt
        done
echo "## ARQUIVOS LOCALIZADOS...##"
cat /tmp/listadebilhetes.txt
sleep 3

for linha in $(cat /tmp/listadebilhetes.txt)
        do

                if [ -f $CAMINHO_ORIGEM/$linha ]
                then
                        #CRIAR PASTA
                                if [ ! -d /tmp/bilhetes ]
                                then    mkdir -p /tmp/bilhetes
                                CAMINHO_DESTINO="/tmp/bilhetes"
                                else
                                CAMINHO_DESTINO="/tmp/bilhetes"
                                fi

                #COPIAR OS ARQUIVOS PRO DESTINO

                cd $CAMINHO_ORIGEM
                cp -rpuv $linha $CAMINHO_DESTINO
                cd $CAMINHO_DESTINO

                echo "Desarquivando ..."
                sleep 3
                tar -zxvf $linha
                rm $linha

                ARQUIVO_TAR=$(ls *tar)
                tar -xvf "$ARQUIVO_TAR"
                echo "Removendo tar..."
                rm "$ARQUIVO_TAR"
                sleep 3

                ARQUIVO_PASTA=$(ls )
                grep -ir $FILTRO_GREP >> /tmp/grepbilhetes.txt

                echo "Filtrando Bilhetes"
                cat /tmp/grepbilhetes.txt | awk -F "INSERT INTO" '{print "INSERT INTO"$2}' > /tmp/inserts.txt
                sleep 3
                rm -r $ARQUIVO_PASTA

                        else
                                cd /tmp
                                clear
                                echo "Arquivo Inválido, log armazenado na pasta tmp"
                                echo "Arquivo Inválido $linha" >> /tmp/log_de_erro_chimposo.txt

                                if [ -f /tmp/listadebilhetes.txt ]
                                        then
                                                rm listadebilhetes.txt
                                                rm grepbilhetes.txt
                                                rm -r bilhetes
                                                rm listadeentrada.txt
                                fi

                        exit
                fi

        done

        cd /tmp
        rm -r bilhetes
        rm listadebilhetes.txt
        rm grepbilhetes.txt
        rm listadeentrada.txt

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
echo " Agora só enviar para o banco de dados."
echo "#################################################"
