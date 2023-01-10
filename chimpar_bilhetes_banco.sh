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
# 6 - pegar os bilhetes do txt e cortar na parte do insert e gerar o arquivo final.
# 7 - fim do script
#
#Conta do operador para teste 7070
#
#Desenvolvido por: DevChimpa 10-01-2023
#contato: chimpadeveloper@gmail.com
###########################################################################

CAMINHO_ORIGEM="/home/backups/"
ARQUIVO_ZIP=$1
FILTRO_GREP=$2

#clear
#echo "########################################"
#echo "insira as datas dos bilhetes desejados"
#echo "########################################"


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

cd $CAMINHO_DESTINO
tar -zxvf $ARQUIVO_ZIP
tar -xvf *.tar

grep -ir $FILTRO_GREP >> bilhetes_salvos.txt

cat bilhetes_salvos.txt | awk -F "INSERT INTO" '{print "INSERT INTO"$2}' > inserts.txt

rm bilhetes_salvos.txt

#ls $CAMIMNHO_DESTINO
#$CAMINHO_ORIGEM

#cd $CAMINHO_ORIGEM
#echo $ARQUIVO_ZIP
