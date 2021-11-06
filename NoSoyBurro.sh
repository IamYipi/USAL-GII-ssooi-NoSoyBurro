#!/bin/bash

#FUNCION MENU 
function menu()
{
echo -e "\e[1;36m**********************"
echo "     NO SOY BURRO     "
echo "**********************"
echo "J) JUGAR"
echo "C) CONFIGURACION"
echo "E) ESTADISTICAS"
echo "F) CLASIFICACION"
echo "S) SALIR"
}
#FUNCION QUE REVISA ARGUMENTOS DE ERROR
function argumentosDeError(){
clear
echo "[Uso] NoSoyBurro.sh     -> juego 	     "
echo "      NoSoyBurro.sh -g  -> NOMBRE del creador "
exit 
}

#FUNCION IMPRIME CREADORES
function imprimirCreadores(){
clear
echo "=============================================="
echo "|                CREADORES                   |"
echo "=============================================="
echo "|     Javier García Pechero                  |"
echo "|     Manuel García Galante                  |"
echo "=============================================="
}

#FUNCION QUE REVISA SI LOS ARCHIVOS TIENEN LOS PERMISOS NECESARIOS
function permisos(){
if test ! -w $1
then 
echo "El fichero $1 no tiene permisos suficientes"
echo "**ERROR** faltan permisos de escritura (w)"
exit
elif test ! -r $1
then
echo "El fichero $1 no tiene permisos suficientes"
echo "**ERROR** faltan permisos de lectura (r)"
exit
fi
echo ""
}

#COMPRUEBA QUE NoSoyBurro.cfg EXISTE Y
#SON NECESARIOS LOS PERMISOS DE LECTURA/ESCRITURA
function comprobarCfg(){
if test ! -f config.cfg 
then 
echo "Fichero de configuración no encontrado"
echo "[ERROR] Falta fichero config.cfg"
exit
else	
clear
echo -e "Cargando fichero de configuracion"
sleep 1
permisos "config.cfg"
clear
sleep 1
fi
}
#FUNCION PARA CARGAR LOS DATOS DEL FICHERO "NoSoyBurro.cfg" 
function cargarConfig(){
#While there is a new line with format:
#ATRIBUTE=VALUE (using IFS equal to "=" delimiter)
#checks new line and tries to load config
while IFS== read ATRIBUTE VALUE
do	
if test "$ATRIBUTE" = "PALABRAGANADORA"
then
if test $VALUE -ne 1 -a $VALUE -ne 2 -a $VALUE -ne 3
then
echo "Error al cargar el fichero de configuracion"
echo "[ERROR] Valor para PALABRAGANADORA inválido: $VALUE"
exit
fi
PALABRAGANADORA=$VALUE
elif test "$ATRIBUTE" = "INTELIGENCIA"
then
if test $VALUE -ne 0 -a $VALUE -ne 1
then
echo "Error al cargar el fichero de configuracion"
echo "[ERROR] Valor para INTELIGENCIA inválido: $VALUE"
exit
fi
INTELIGENCIA=$VALUE
elif test "$ATRIBUTE" = "FICHEROLOG"
then
#COMPRUEBA EL ARCHIVO Y TRATA DE CARGARLO
if test ! -f $VALUE
then 
echo "Error al cargar el fichero de configuracion"
echo "No se encontró el fichero de estadísticas"
echo "[ERROR] Fichero de FICHEROLOG inexistente: [NOMBRE].log"
FICHEROLOG="___/_/fichero_inexistente\_\___.log"		
else
FICHEROLOG=$VALUE
sleep 1
comprobarCfg "$FICHEROLOG"
clear 
sleep 2
echo "Iniciando...."
sleep 1
fi
else
echo "No se puede cargar el fichero de configuracion"
echo "[ERROR] Atributo inválido: '$ATRIBUTE'"
exit 	
fi
done < config.cfg
	#Si la configuracion es correcta pero el fichero.log de FICHEROLOG, da la opcion al usuario de crear uno
if test ! -f $FICHEROLOG
then
read -p "¿Quiere crear un nuevo fichero de estadísticas?[S para cambiar]: " SN
if test $SN = "S" -o $SN = "s"
then
read -p "NOMBRE (sin extension)= " NAME
touch $NAME.log
FICHEROLOG="$NAME.log"
chmod 666 $FICHEROLOG
else
exit 	
fi
fi
}
#MENU CONFIGURACION PARA AJUSTAR LA CONFIGURACION
function menuConfig(){
clear
echo -e "\e[1;36m==========================================\e[0m"
echo -e "\e[1;36m|            CONFIGURACION               |\e[0m"
echo -e "\e[1;36m==========================================\e[0m"
echo -e "\e[1;36m-----------------------------------------------------------\e[0m"
echo -e "\e[1;36m|\e[1;33mPALABRAGANADORA = 1 -> NO                         \e[1;36m|\e[0m"
echo -e "\e[1;36m|\e[1;33m                  2 -> NOSOY                      \e[1;36m|\e[0m"
echo -e "\e[1;36m|\e[1;33m                  3 -> NOSOYBURRO                 \e[1;36m|\e[0m"
echo -e "\e[1;36m-----------------------------------------------------------\e[0m"
echo -e "\e[1;36m|\e[1;33mINTELIGENCIA = 0 -> IA TORPE                      \e[1;36m|\e[0m"
echo -e "\e[1;36m|\e[1;33m               1 -> IA SEMIINTELIGENTE            \e[1;36m|\e[0m"
echo -e "\e[1;36m-----------------------------------------------------------\e[0m"
echo -e "\e[1;36m|\e[1;33mESTADISTICAS = NOMBRE_fichero_estadisticas        \e[1;36m|\e[0m"
echo -e "\e[1;36m-----------------------------------------------------------\e[0m"
}
#CONFIGURACION OPCION
function configuracion(){
clear
echo -e "\e[1;36m==========================================\e[0m"
echo -e "\e[1;36m|            CONFIGURACION               |\e[0m"
echo -e "\e[1;36m==========================================\e[0m"	
echo -e "\e[1;36mConfiguración actual:\e[0m"
echo -e "\e[1;36m-----------------------\e[0m"
while IFS== read ATRIBUTO VALOR
do
echo -e "\e[1;33m $ATRIBUTO = $VALOR\e[0m"			
done < config.cfg
echo -e "\e[1;36m-----------------------\e[0m"
echo ""
read -p "¿Quiere cambiar la configuración actual?[S para cambiar]: " SN
if test "$SN" = "S" -o "$SN" = "s"
then
sleep 2
menuConfig	
echo "Introduzca los nuevos valores:"
p=0
PALABRAGANADORA=0 
until test $PALABRAGANADORA -eq 1 -o $PALABRAGANADORA -eq 2 -o $PALABRAGANADORA -eq 3
do
read -p "PALABRAGANADORA = " PALABRAGANADORA
done	
INTELIGENCIA=2
until test $INTELIGENCIA -eq 0 -o $INTELIGENCIA -eq 1
do
read -p "INTELIGENCIA = " INTELIGENCIA
done
AUX=".log"
while test $AUX = ".log"
do                            
read -p "FICHEROLOG (NOMBRE sin extensión) = " AUX 
AUX="$AUX.log"
done
#Si el nuevo NOMBRE es diferente al viejo y no hay un archivo con el
# nuevo NOMBRE, lo renombra
if test $AUX != $FICHEROLOG -a ! -f $AUX
then 
mv $FICHEROLOG $AUX	
fi
FICHEROLOG=$AUX
echo "PALABRAGANADORA=$PALABRAGANADORA" > config.cfg
echo "INTELIGENCIA=$INTELIGENCIA" >> config.cfg
echo "FICHEROLOG=$FICHEROLOG" >> config.cfg
fi
}
#FUNCION PARA GUARDAR LAS FICHEROLOG DE LA ULTIMA PARTIDA GUARDADA
function saveGameStats(){	
unset GUIONES[$(($RONDAS-1))]
n=0
if test $GANAJ -eq 1
then
winners[n]=0
comas[n]=","
n=$(($n+1))
fi
if test $GANAPC1 -eq 1
then
winners[n]=1
comas[n]=","
n=$(($n+1))
fi
if test $GANAPC2 -eq 1
then
winners[n]=2
comas[n]=","
n=$(($n+1))
fi
if test $GANAPC3 -eq 1
then
winners[n]=3
comas[n]=","
n=$(($n+1))
fi
unset comas[$(($GANADORES-1))]	
NUMTOTALRONDAS=$RONDAS
echo -n "$START_DATE|$FINISH_HOUR|$NOMBRE|$INTELIGENCIA|$GAME_TIME" >> auxlog.txt
for (( i=0; i<$NUMTOTALRONDAS; i++ )); do
echo -n "${RONDA[$i]}.${INTERCAMBIOS[$i]}.${TIEMPO_R[$i]}${GUIONES[$i]}" >> auxlog2.txt 
done
if test $PALABRAGANADORA -eq 1
then
echo -n "NO" >> auxlog3.txt
fi
if test $PALABRAGANADORA -eq 2
then
echo -n "NOSOY" >> auxlog3.txt
fi
if test $PALABRAGANADORA -eq 3
then
echo -n "NOSOYBURRO" >> auxlog3.txt
fi
for (( i=0; i<$GANADORES; i++ )); do
echo -n "${winners[i]}${comas[i]}" >> auxlog4.txt
done
paste -d "|" auxlog.txt auxlog2.txt auxlog3.txt auxlog4.txt >> $FICHEROLOG
rm auxlog.txt
rm auxlog2.txt
rm auxlog3.txt
rm auxlog4.txt
}
#FUNCION CLASIFICACION
function clasificacion(){
clear
if test ! -f $FICHEROLOG
then 
echo "Fichero de registro de partidas no encontrado"
echo "[ERROR] Falta fichero log"
exit	
else	
TIEMPO_MIN=0
RONDAS_MIN=0
RONDAS_MAX=0
INTERCAMBIOS_MIN=0
CADENA_PARTIDA=""
CADENA_P_CORTA=""
CADENA_P_LARGA=""
CADENA_P_MINRONDAS=""
CADENA_P_MAXRONDAS=""
INTERCAMBIOS=0
MAX_INTERCAMBIO=0
MIN_INTERCAMBIO=1000
NUM_PARTIDAS=$(cat $FICHEROLOG | wc -l)	
if test $NUM_PARTIDAS -gt 0
then
while IFS="|" read FECHA_P HORA_P NOMBRE_P INTEL_P TIEMPO_P xN[j] PALABRAGANADORA_P GANADORES_P[j]
do
j=$(($j+1))
done < $FICHEROLOG	 	
for (( i=0; i<$NUM_PARTIDAS; i++ )); do
echo ${xN[$i]} >> auxstats.txt
done		
sed -e "s/-/\\
/g" auxstats.txt > auxstats2.txt  #cambiar delimitadores ":" por "\n"(por eso está en dos lineas, por el INTRO) para separar por filas	
while IFS="." read RONDITA INTERCAMBITO TIEMPITO
do
if test $RONDITA -eq 1
then
m=$(($m+1))
partidita[m]=0	
fi
if test $MAX_INTERCAMBIO -le $INTERCAMBITO
then
MAX_INTERCAMBIO=$INTERCAMBITO
part_interc_max=$m
fi
if test $MIN_INTERCAMBIO -ge $INTERCAMBITO
then
MIN_INTERCAMBIO=$INTERCAMBITO
part_interc_min=$m
fi
partidita[m]=$((${partidita[$m]}+1))
INTERCAMBIOS=$(($INTERCAMBIOS+$INTERCAMBITO))
done < auxstats2.txt
rm auxstats2.txt
rm auxstats.txt
echo ${intercambicos[*]}
echo -e "\e[1;36m==========================================\e[0m"
echo -e "\e[1;36m|             CLASIFICACIÓN              |\e[0m"
echo -e "\e[1;36m==========================================\e[0m"
j=0
v=1
IFS="|" read FECHA_P HORA_P NOMBRE_P INTEL_P TIEMPO_P xN[j] PALABRAGANADORA_P GANADORES_P[j] < $FICHEROLOG		        
TIEMPO_MIN=$TIEMPO_P
TIEMPO_MAX=$TIEMPO_P
RONDAS_MIN=${partidita[$v]}
RONDAS_MAX=${partidita[$v]}
while IFS="|" read FECHA_P HORA_P NOMBRE_P INTEL_P TIEMPO_P xN[j] PALABRAGANADORA_P GANADORES_P[j]
do
if test $TIEMPO_MIN -ge $TIEMPO_P
then
TIEMPO_MIN=$TIEMPO_P		
CADENA_P_CORTA=$FECHA_P"|"$HORA_P"|"$NOMBRE_P"|"$INTEL_P"|"$TIEMPO_P"|"${xN[$j]}"|"$PALABRAGANADORA_P"|"${GANADORES_P[$j]}
fi		
if test $TIEMPO_MAX -le $TIEMPO_P
then
TIEMPO_MAX=$TIEMPO_P
CADENA_P_LARGA=$FECHA_P"|"$HORA_P"|"$NOMBRE_P"|"$INTEL_P"|"$TIEMPO_P"|"${xN[$j]}"|"$PALABRAGANADORA_P"|"${GANADORES_P[$j]}	
fi
if test $RONDAS_MIN -ge ${partidita[$v]}
then				
RONDAS_MIN=${partidita[$v]}
CADENA_P_MINRONDAS=$FECHA_P"|"$HORA_P"|"$NOMBRE_P"|"$INTEL_P"|"$TIEMPO_P"|"${xN[$j]}"|"$PALABRAGANADORA_P"|"${GANADORES_P[$j]}
fi
if test $RONDAS_MAX -le ${partidita[$v]}
then
RONDAS_MAX=${partidita[$v]}
CADENA_P_MAXRONDAS=$FECHA_P"|"$HORA_P"|"$NOMBRE_P"|"$INTEL_P"|"$TIEMPO_P"|"${xN[$j]}"|"$PALABRAGANADORA_P"|"${GANADORES_P[$j]}
fi
if test $part_interc_min -eq $v
then
CADENA_P_MAXINTERCAMBIOS=$FECHA_P"|"$HORA_P"|"$NOMBRE_P"|"$INTEL_P"|"$TIEMPO_P"|"${xN[$j]}"|"$PALABRAGANADORA_P"|"${GANADORES_P[$j]}
fi
if test $part_interc_max -eq $v
then
CADENA_P_MININTERCAMBIOS=$FECHA_P"|"$HORA_P"|"$NOMBRE_P"|"$INTEL_P"|"$TIEMPO_P"|"${xN[$j]}"|"$PALABRAGANADORA_P"|"${GANADORES_P[$j]}
fi
j=$(($j+1))
v=$(($v+1))
done < $FICHEROLOG
echo "La partida más corta es $CADENA_P_CORTA"
echo "La partida más larga es $CADENA_P_LARGA"		
echo "La partida con menos rondas es $CADENA_P_MINRONDAS"
echo "La partida con más rondas es $CADENA_P_MAXRONDAS"
echo "La partida con menos intercambios en una ronda es $CADENA_P_MAXINTERCAMBIOS"
echo "La partida con más intercambios en una ronda es $CADENA_P_MININTERCAMBIOS"
else
echo " No hay jugadas registradas comprueba ficherolog"
fi
fi
}
#FUNCION PARA CALCULAR MEDIAS Y ESO
function calculoEstadisticas(){       
TIEMPO_TOTAL=0
RONDAS_TOTAL=0
RONDICAS=0
MEDIA_R=0
MEDIA_I=0
MEDIA_G=0
V_JUGADOR=0
PORCENTAJE_J=0
INTERCAMBIOS=0
GANADORES_TOTAL=0
j=0
f=0
v=0
while IFS="|" read FECHA_P HORA_P NOMBRE_P INTEL_P TIEMPO_P xN[j] PALABRAGANADORA_P GANADORES_P[j]
do
TIEMPO_TOTAL=$(($TIEMPO_TOTAL+$TIEMPO_P))
j=$(($j+1))
done < $FICHEROLOG	 	
for (( i=0; i<$NUM_PARTIDAS; i++ )); do
echo ${xN[$i]} >> auxstats.txt
done
for (( i=0; i<$NUM_PARTIDAS; i++ )); do
echo ${GANADORES_P[$i]} >> ganadores.txt
done		
sed -e "s/-/\\
/g" auxstats.txt > auxstats2.txt  #cambiar delimitadores ":" por "\n"(por eso está en dos lineas, por el INTRO) para separar por filas
sed -e "s/,/\\
/g" ganadores.txt > ganadores2.txt  #cambiar delimitadores ":" por "\n"(por eso está en dos lineas, por el INTRO) para separar por filas		
while IFS="." read RONDITA INTERCAMBITO TIEMPITO
do
if test $RONDITA -eq 1
then
m=$(($m+1))
partidita[m]=0
fi
partidita[m]=$((${partidita[$m]}+1))
INTERCAMBIOS=$(($INTERCAMBIOS+$INTERCAMBITO))
done < auxstats2.txt
RONDAS_TOTAL=$(cat auxstats2.txt | wc -l)
while read GANADORR
do
if test $GANADORR = "0"
then
V_JUGADOR=$(($V_JUGADOR+1))
fi
GANADORES_TOTAL=$(($GANADORES_TOTAL+1))
done < ganadores2.txt
MEDIA_T=$(echo "scale=2;$TIEMPO_TOTAL/$NUM_PARTIDAS" | bc) 
MEDIA_I=$(echo "scale=2;$INTERCAMBIOS/$RONDAS_TOTAL" | bc)
MEDIA_R=$(echo "scale=2;$RONDAS_TOTAL/$NUM_PARTIDAS" | bc)
MEDIA_G=$(echo "scale=2;$GANADORES_TOTAL/$NUM_PARTIDAS" | bc)
PORCENTAJE_J=$(echo "scale=2;$V_JUGADOR/$NUM_PARTIDAS" | bc)
PORCENTAJE_J=$(echo "scale=2;$PORCENTAJE_J*100" | bc)	
rm auxstats2.txt
rm auxstats.txt
rm ganadores.txt
rm ganadores2.txt
}
#FUNCION PARA REPRESENTAR LAS FICHEROLOG
function stats(){
clear
if test ! -f $FICHEROLOG
then 
echo "Fichero de registro de partidas no encontrado"
echo "[ERROR] Falta fichero log"
exit	
else
NUM_PARTIDAS=$(cat $FICHEROLOG | wc -l)
echo -e "\e[1;36m==========================================\e[0m"
echo -e "\e[1;36m|             ESTADISTICAS               |\e[0m"
echo -e "\e[1;36m==========================================\e[0m"	
if test $NUM_PARTIDAS -gt 0
then
calculoEstadisticas
echo "Numero total de partidas jugadas..............................: $NUM_PARTIDAS"
echo "Media de rondas de las partidas jugadas.......................: $MEDIA_R"
echo "Media de los intercambios de las rondas jugadas...............: $MEDIA_I"
echo "Media de los tiempos de todas las partidas jugadas............: $MEDIA_T"	
echo "Media del numero de ganadores.................................: $MEDIA_G"
echo "Tiempo total invertido en todas las partidas..................: $TIEMPO_TOTAL"
echo "Porcentaje de veces que gana el usuario respecto de la maquina: $PORCENTAJE_J %"
else
echo "No hay partidas guardadas en el fichero $FICHEROLOG"
fi
fi
}
#FUNCION QUE MUESTRA FICHEROLOG DEL JUEGO AL FINALIZAR LA PARTIDA
function finishMenuStats(){
sleep 2
echo " Fecha y hora de inicio de partida.: $START_DATE , $START_HOUR"
echo " Tiempo de juego...................: $GAME_TIME segundos"
echo " Nº de rondas......................: $RONDAS"
if test $GANADORES -gt 1
then
echo " Numero de Ganadores...............: $GANADORES" 
else
if test $WINNER -eq 1
then
echo " Ganador...........................: Jugador:($NOMBRE)"
else
echo " Ganador...........................: Computador nº ($jugador)"
fi
fi
echo " Configuracion partida elegida.....:"
if test $PALABRAGANADORA -eq 1 
then
echo "           PALABRAGANADORA=$PALABRAGANADORA (NO)"
elif test $PALABRAGANADORA -eq 2 
then
echo "           PALABRAGANADORA=$PALABRAGANADORA (NOSOY)"
else 
echo "           PALABRAGANADORA=$PALABRAGANADORA (NOSOYBURRO)"
fi
if test $INTELIGENCIA -eq 0
then	
echo "           INTELIGENCIA=$INTELIGENCIA (IA TORPE)"
else
echo "           INTELIGENCIA=$INTELIGENCIA (IA SEMIINTELIGENTE)"		
fi 
echo "           FICHEROLOG=$FICHEROLOG (Donde se guardará la partida)"	
}
#FUNCION QUE INICIA BARAJA
#Crea la baraja a partir de los vectores numeros y palos
function barajar(){
for (( i=0; i<16; i++ )); do
cartas[$i]="${VALORES[$i]}"
indices[$i]=$i
echo ${indices[$i]}>>indices.txt
done
for (( i=1; i<=16; i++ )); do
randindices[$(($i-1))]=$(($RANDOM%16))
echo ${randindices[$(($i-1))]}>>randindices.txt
done
clear
paste -d "-" randindices.txt indices.txt >> randomindices.txt
sort randomindices.txt >> randomizados.txt
cut randomizados.txt -f 2-4 -d "-" >> random.txt
clear
k=0
while IFS= read -r line
do
auxindices[k]=$line 
k=$((k+1))
done < random.txt
rm indices.txt
rm randindices.txt
rm randomindices.txt
rm randomizados.txt
rm random.txt
for (( i=0; i<16; i++ )); do
b=${auxindices[$i]}
baraja[$i]=${cartas[$b]}
done
entregaCartas
}

#FUNCION QUE SIMULA ENTREGA ALTERNATIVA DE CARTAS
function entregaCartas(){
#Simulamos entrega alternativa 
i=0
k=0
while test $i -ne 16
do
barajaJugador[$k]=${baraja[$i]}
i=$((i+1))
barajaPc1[$k]=${baraja[$i]}
i=$((i+1))
barajaPc2[$k]=${baraja[$i]}
i=$((i+1))
barajaPc3[$k]=${baraja[$i]}
i=$((i+1))
k=$((k+1))
done
} 
#FUNCION TURNO JUGADOR
function turnoJugador(){	
if test $TURNO -eq 0
then
echo RONDAS: $RONDAS
echo PUNTOS $NOMBRE: $countJ PUNTOS PC1: $countPc1 PUNTOS PC2: $countPc2 PUNTOS PC3: $countPc3
echo  BARAJA DE PC1......:[ ${barajaPc1[*]} ]
echo  BARAJA DE PC2......:[ ${barajaPc2[*]} ]
echo  BARAJA DE PC3......:[ ${barajaPc3[*]} ]
echo  BARAJA DE $NOMBRE  :[ ${barajaJugador[*]} ] 
read  -p "Escoja la posicion de la carta a intercambiar[1-4]:" nJ
case $nJ in
1)								
;;			
2)	
;;
3)	
;;
4)		
;;
*)
echo "Opcion Incorrecta"
sleep 2
clear
turnoJugador
;;	
esac		
else
echo RONDAS: $RONDAS
echo INTERCAMBIOS: $TURNO
echo PUNTOS $NOMBRE: $countJ PUNTOS PC1: $countPc1 PUNTOS PC2: $countPc2 PUNTOS PC3: $countPc3
echo Recibes carta: $cartaPc3
echo ===================================
echo BARAJA DE PC1.........: ${barajaPc1[*]}
echo BARAJA DE PC2.........: ${barajaPc2[*]}
echo BARAJA DE PC3.........: ${barajaPc3[*]}
echo BARAJA DE $NOMBRE..: ${barajaJugador[*]} 
read -p "Escoja la posicion de la carta a intercambiar[1-4]:" nJ
case $nJ in
1)						
;;			
2)				
;;
3)			
;;
4)				
;;
*)
echo "Opcion Incorrecta"
sleep 2	
clear
turnoJugador
;;	
esac
fi
echo
nJ=$((nJ-1))
TURNO=$((TURNO+1))	
cartaJugador=${barajaJugador[$nJ]}
}
#FUNCION TURNO PC
function turnoPc1(){
if test $INTELIGENCIA -eq 0
then #TONTO
nPc1=$(($RANDOM%4))
else #SEMI-INTELIGENTE #BARAJAMOS TODOS LOS CASOS DE 3 IGUALES POSIBLES
if test "${barajaPc1[0]}" = "${barajaPc1[1]}" -a "${barajaPc1[1]}" = "${barajaPc1[2]}"
then
nPc1=3
elif test "${barajaPc1[0]}" = "${barajaPc1[1]}" -a "${barajaPc1[1]}" = "${barajaPc1[3]}"
then
nPc1=2
elif test "${barajaPc1[0]}" = "${barajaPc1[2]}" -a "${barajaPc1[2]}" = "${barajaPc1[3]}"
then
nPc1=1
elif test "${barajaPc1[1]}" = "${barajaPc1[2]}" -a "${barajaPc1[2]}" = "${barajaPc1[3]}"
then
nPc1=0
#BARAJAMOS CASOS DE 2 IGUALES
elif test "${barajaPc1[0]}" = "${barajaPc1[1]}"
then
nPc1=$(($RANDOM%2+2))
elif test "${barajaPc1[1]}" = "${barajaPc1[2]}"
then
temp=${barajaPc1[0]}
barajaPc1[0]=${barajaPc1[2]}
barajaPc1[2]=$temp
nPc1=$(($RANDOM%2+2))
elif test "${barajaPc1[2]}" = "${barajaPc1[3]}"
then
nPc1=$(($RANDOM%2))
elif test "${barajaPc1[1]}" = "${barajaPc1[3]}"
then
temp=${barajaPc1[2]}
barajaPc1[2]=${barajaPc1[1]}
barajaPc1[1]=$temp
nPc1=$(($RANDOM%2))
elif test "${barajaPc1[0]}" = "${barajaPc1[2]}"
then
temp=${barajaPc1[3]}
barajaPc1[3]=${barajaPc1[0]}
barajaPc1[0]=$temp
nPc1=$(($RANDOM%2))
elif test "${barajaPc1[0]}" = "${barajaPc1[3]}"
then
temp=${barajaPc1[2]}
barajaPc1[2]=${barajaPc1[0]}
barajaPc1[0]=$temp
nPc1=$(($RANDOM%2))		
else	
nPc1=$(($RANDOM%4))
fi
fi
cartaPc1=${barajaPc1[$nPc1]}
}

#PC2
function turnoPc2(){
if test $INTELIGENCIA -eq 0
then #TONTO
nPc2=$(($RANDOM%4))
else #SEMI-INTELIGENTE #BARAJAMOS TODOS LOS CASOS DE 3 POSIBLES
if test "${barajaPc2[0]}" = "${barajaPc2[1]}" -a "${barajaPc2[1]}" = "${barajaPc2[2]}"
then
nPc2=3
elif test "${barajaPc2[0]}" = "${barajaPc2[1]}" -a "${barajaPc2[1]}" = "${barajaPc2[3]}"
then
nPc2=2
elif test "${barajaPc2[0]}" = "${barajaPc2[2]}" -a "${barajaPc2[2]}" = "${barajaPc2[3]}"
then
nPc2=1
elif test "${barajaPc2[1]}" = "${barajaPc2[2]}" -a "${barajaPc2[2]}" = "${barajaPc2[3]}"
then
nPc2=0
#BARAJAMOS CASOS DE 2 IGUALES
elif test "${barajaPc2[0]}" = "${barajaPc2[1]}"
then
nPc2=$(($RANDOM%2+2))
elif test "${barajaPc2[1]}" = "${barajaPc2[2]}"
then
temp=${barajaPc2[0]}
barajaPc2[0]=${barajaPc2[2]}
barajaPc2[2]=$temp
nPc2=$(($RANDOM%2+2))
elif test "${barajaPc2[2]}" = "${barajaPc2[3]}"
then
nPc2=$(($RANDOM%2))
elif test "${barajaPc2[1]}" = "${barajaPc2[3]}"
then
temp=${barajaPc2[2]}
barajaPc2[2]=${barajaPc2[1]}
barajaPc2[1]=$temp
nPc2=$(($RANDOM%2))
elif test "${barajaPc2[0]}" = "${barajaPc2[2]}"
then
temp=${barajaPc2[3]}
barajaPc2[3]=${barajaPc2[0]}
barajaPc2[0]=$temp
nPc2=$(($RANDOM%2))
elif test "${barajaPc2[0]}" = "${barajaPc2[3]}"
then
temp=${barajaPc2[2]}
barajaPc2[2]=${barajaPc2[0]}
barajaPc2[0]=$temp
nPc2=$(($RANDOM%2))	
else
nPc2=$(($RANDOM%4))
fi
fi
cartaPc2=${barajaPc2[$nPc2]}
}
#PC3
function turnoPc3(){
if test $INTELIGENCIA -eq 0
then #TONTO
nPc3=$(($RANDOM%4))
else #SEMI-INTELIGENTE #BARAJAMOS TODOS LOS CASOS DE 3 POSIBLES
if test "${barajaPc3[0]}" = "${barajaPc3[1]}" -a "${barajaPc3[1]}" = "${barajaPc3[2]}"
then
nPc3=3
elif test "${barajaPc3[0]}" = "${barajaPc3[1]}" -a "${barajaPc3[1]}" = "${barajaPc3[3]}"
then
nPc3=2
elif test "${barajaPc3[0]}" = "${barajaPc3[2]}" -a "${barajaPc3[2]}" = "${barajaPc3[3]}"
then
nPc3=1
elif test "${barajaPc3[1]}" = "${barajaPc3[2]}" -a "${barajaPc3[2]}" = "${barajaPc3[3]}"
then
nPc3=0
#BARAJAMOS CASOS DE 2 IGUALES
elif test "${barajaPc3[0]}" = "${barajaPc3[1]}"
then
nPc3=$(($RANDOM%2+2))
elif test "${barajaPc3[1]}" = "${barajaPc3[2]}"
then
temp=${barajaPc3[0]}
barajaPc3[0]=${barajaPc3[2]}
barajaPc3[2]=$temp
nPc3=$(($RANDOM%2+2))
elif test "${barajaPc3[2]}" = "${barajaPc3[3]}"
then
nPc3=$(($RANDOM%2))
elif test "${barajaPc3[1]}" = "${barajaPc3[3]}"
then
temp=${barajaPc3[2]}
barajaPc3[2]=${barajaPc3[1]}
barajaPc3[1]=$temp
nPc3=$(($RANDOM%2))
elif test "${barajaPc3[0]}" = "${barajaPc3[2]}"
then
temp=${barajaPc3[3]}
barajaPc3[3]=${barajaPc3[0]}
barajaPc3[0]=$temp
nPc3=$(($RANDOM%2))
elif test "${barajaPc3[0]}" = "${barajaPc3[3]}"
then
temp=${barajaPc3[2]}
barajaPc3[2]=${barajaPc3[0]}
barajaPc3[0]=$temp
nPc3=$(($RANDOM%2))	
else
nPc3=$(($RANDOM%4))
fi	
fi
cartaPc3=${barajaPc3[$nPc3]}
}

#FUNCION INTERCAMBIOS
function changes(){
clear
echo ==============================
echo BARAJAS ANTES DE INTERCAMBIOS
echo ==============================
echo BARAJA DE PC1..........: ${barajaPc1[*]}
echo BARAJA DE PC2..........: ${barajaPc2[*]}
echo BARAJA DE PC3..........: ${barajaPc3[*]}
echo BARAJA DE $NOMBRE...: ${barajaJugador[*]} 
echo ==============================
echo REALIZANDO INTERCAMBIOS...
sleep 2
echo Pc1 ENTREGA: $cartaPc1 - Pc2
echo RECIBE: $cartaJugador
sleep 2
echo Pc2 ENTREGA: $cartaPc2 - PC3
echo RECIBE: $cartaPc1
sleep 2
echo Pc3 ENTREGA: $cartaPc3 - $NOMBRE
echo RECIBE: $cartaPc2
sleep 2
echo $NOMBRE ENTREGA: $cartaJugador - Pc1
echo RECIBE: $cartaPc3
sleep 2
barajaJugador[$nJ]=$cartaPc3
barajaPc1[$nPc1]=$cartaJugador
barajaPc2[$nPc2]=$cartaPc1
barajaPc3[$nPc3]=$cartaPc2
echo ===============================
echo BARAJAS DESPUES DE INTERCAMBIOS
echo ===============================
echo BARAJA DE PC1    : ${barajaPc1[*]}
echo BARAJA DE PC2    : ${barajaPc2[*]}
echo BARAJA DE PC3    : ${barajaPc3[*]}
echo BARAJA DE $NOMBRE: ${barajaJugador[*]} 
echo ===============================
read -p "PULSA INTRO PARA COMPROBAR SI ALGUIEN CANTA BURRO"	
checkWin
}
#FUNCION QUE COMPRUEBA SI ALGUIEN HA GANADO AL FINALIZAR UNA RONDA
function checkWin(){
echo COMPROBANDO SI ALGUIEN HA GANADO...
echo 
sleep 1
#COMPROBACION VICTORIA JUGADOR
for (( i = 0; i < 4; i++ )); do
barajaVictory[$i]=${barajaJugador[$i]}
done
jugador=0
checkIfWin
#COMPROBACION VICTORIA PC1
for (( i = 0; i < 4; i++ )); do
barajaVictory[$i]=${barajaPc1[$i]}
done
jugador=1
checkIfWin
#COMPROBACION VICTORIA PC2
for (( i = 0; i < 4; i++ )); do
barajaVictory[$i]=${barajaPc2[$i]}
done
jugador=2
checkIfWin
#COMPROBACION VICTORIA PC3
for (( i = 0; i < 4; i++ )); do
barajaVictory[$i]=${barajaPc3[$i]}
done
jugador=3
checkIfWin
if test $BURRO -eq 1
then
FINAL_TIME_RONDA=$SECONDS
TIEMPO_R[x]=$(($FINAL_TIME_RONDA-$INICIO_TIME_RONDA))
INTERCAMBIOS[x]=$TURNO
RONDA[x]=$RONDAS
GUIONES[$x]="-"
x=$(($x+1))
fi
}
#FUNCION QUE COMPRUEBA SI HA GANADO PC O JUGADOR
function checkIfWin(){	
if test "${barajaVictory[0]}" = "${barajaVictory[1]}" -a "${barajaVictory[2]}" = "${barajaVictory[3]}" -a "${barajaVictory[0]}" = "${barajaVictory[2]}"
then
#VICTORIA
if test $jugador -eq 0
then
countJ=$((countJ+1))
if test $countJ -eq $PALABRAVICTORY
then
BURRO=1
PLAYER=0
GANAJ=1
echo "BURRO DE $NOMBRE"			
GANADORES=$(($GANADORES+1))
sleep 2
else
clear
BURRO=1
echo "BURRO DE $NOMBRE"
sleep 2
fi
elif test $jugador -eq 1
then
countPc1=$((countPc1+1))
if test $countPc1 -eq $PALABRAVICTORY
then
BURRO=1
GANAPC1=1
PC1=1
GANADORES=$(($GANADORES+1))
echo "BURRO DE JUGADOR NUMERO $jugador (PC1)"
else
clear
BURRO=1
echo "BURRO DE JUGADOR NUMERO $jugador (PC1)"
sleep 2
fi
elif test $jugador -eq 2
then
countPc2=$((countPc2+1))
if test $countPc2 -eq $PALABRAVICTORY
then
BURRO=1
PC2=2
GANAPC2=1
GANADORES=$(($GANADORES+1))
echo "BURRO DE JUGADOR NUMERO $jugador (PC2)"
else
clear
BURRO=1
echo "BURRO DE JUGADOR NUMERO $jugador (PC2)"
sleep 2
fi
elif test $jugador -eq 3
then
countPc3=$((countPc3+1))
if test $countPc3 -eq $PALABRAVICTORY
then
BURRO=1
PC3=3
GANAPC3=1
GANADORES=$(($GANADORES+1))
echo "BURRO DE JUGADOR NUMERO $jugador (PC3)"
else
clear
BURRO=1
echo "BURRO DE JUGADOR NUMERO $jugador (PC3)"
sleep 2
fi
fi
fi
}

function mostrarVictoriaDerrota(){
if test $GANADORES -gt 1
then
empate
else
if test $GANAJ -eq 1
then
victoria
fi
if test $GANAPC1 -eq 1
then
jugador=1
derrota
fi
if test $GANAPC2 -eq 1
then
jugador=2
derrota
fi
if test $GANAPC3 -eq 1
then
jugador=3
derrota
fi
fi
}
#FUNCION QUE MUESTRA VICTORIA
function victoria(){
FINAL_TIME=$SECONDS
GAME_TIME=$(($FINAL_TIME-$INIT_TIME))
EXIT_IF_WIN=1	
WINNER=1
clear 
echo -e "\e[1;32m===============================================================================\e[0m"
echo -e "\e[1;32m    \        /  ======  ======  ======= ========  ======  ======  ======     | \e[0m"
echo -e "\e[1;32m     \      /     ||    |          |    |      |  |    |    ||    |    |     | \e[0m"
echo -e "\e[1;32m      \    /      ||    |          |    |      |  |____|    ||    |====|     | \e[0m"
echo -e "\e[1;32m       \  /       ||    |          |    |      |  |  \      ||    |    |     | \e[0m"
echo -e "\e[1;32m        \/      ======  ======     |    ========  |   \   ======  |    |     0 \e[0m"
echo -e "\e[1;32m===============================================================================\e[0m"
echo -e "\e[1;32m|                              HAS GANADO!                                    |\e[0m"
echo -e "\e[1;32m===============================================================================\e[0m"	 
finishMenuStats
echo -e "\e[1;32m===============================================================================\e[0m"	
echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
read -p "" 
}
#FUNCION QUE MUESTRA DERROTA
function derrota(){
FINAL_TIME=$SECONDS
GAME_TIME=$(($FINAL_TIME-$INIT_TIME))
EXIT_IF_WIN=1	
WINNER=2
clear 
echo -e "\e[1;31m===============================================================================\e[0m"
echo -e "\e[1;31m         |===     |=====    |===|   |===|   |====|  |=====|  |===|             \e[0m"
echo -e "\e[1;31m         |   \    |         |   |   |   |   |    |     |     |   |             \e[0m"
echo -e "\e[1;31m         |    |   |===      |===|   |===|   |    |     |     |   |             \e[0m"
echo -e "\e[1;31m         |   /    |         |  \    |  \    |    |     |     |===|             \e[0m"
echo -e "\e[1;31m         |===     |=====    |   \   |   \   |====|     |     |   |             \e[0m"
echo -e "\e[1;31m===============================================================================\e[0m"
echo -e "\e[1;31m|                            HAS PERDIDO!                                     |\e[0m"
echo -e "\e[1;31m===============================================================================\e[0m"	
finishMenuStats
echo -e "\e[1;31m===============================================================================\e[0m"
echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
read -p ""
}

function empate(){
FINAL_TIME=$SECONDS
GAME_TIME=$(($FINAL_TIME-$INIT_TIME))
EXIT_IF_WIN=1	
WINNER=3
echo -e "\e[1;30m===============================================================================\e[0m"
echo -e "\e[1;30m           |====   |\      /|   |====|  |===|  |===|  |====                    \e[0m"
echo -e "\e[1;30m           |       | \    / |   |    |  |   |    |    |                        \e[0m"
echo -e "\e[1;30m           |====   |  \  /  |   |____|  |   |    |    |====                    \e[0m"
echo -e "\e[1;30m           |       |   \/   |   |       |===|    |    |                        \e[0m"
echo -e "\e[1;30m           |====   |        |   |       |   |    |    |====                    \e[0m"
echo -e "\e[1;30m===============================================================================\e[0m"
echo -e "\e[1;30m|                            HAS EMPATADO!                                    |\e[0m"
echo -e "\e[1;30m===============================================================================\e[0m"	
finishMenuStats
echo -e "\e[1;30m===============================================================================\e[0m"
echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
read -p ""
}

#INICIALIZA LAS VARIABLES DEL JUEGO
function game(){
VALORES=( J Q K A J Q K A J Q K A J Q K A)
unset cartas
unset baraja
unset NOMBRE
unset barajaJugador
unset barajaPc1
unset barajaPc2
unset barajaPc3
unset barajaVictory
unset cartaJ
unset cartaPc1
unset cartaPc2
unset cartaPc3
unset nJ
unset nPc1
unset nPc2
unset nPc3
unset count
unset countJ
unset countPc1
unset countPc2
unset countPc3
unset BURRO
unset PALABRAVICTORY
unset RONDAS
unset TURNO
unset RONDA
unset INTERCAMBIOS
unset TIEMPO_R
unset k
START_DATE=$(date +%d/%m/%Y)		#Start date
START_HOUR=$(date +"%T") 		#Start hour
RONDAS=0				#RONDAS
read -p "INTRODUZCA SU NOMBRE:" NOMBRE
startGame
#saveGameStats	
}

#GAME FUNCTION
function startGame(){
if test $PALABRAGANADORA -eq 1
then
PALABRAVICTORY=2
elif test $PALABRAGANADORA -eq 2
then
PALABRAVICTORY=5
elif test $PALABRAGANADORA -eq 3
then
PALABRAVICTORY=10
fi	
x=0
START=$PALABRAGANADORA
EXIT_IF_WIN=0
INIT_TIME=$SECONDS
GANADORES=0
GANAJ=0
GANAPC1=0
GANAPC2=0
GANAPC3=0
TURNO=0
countJ=0
countPc1=0
countPc2=0
countPc3=0
InGame
}

function InGame(){
if test $EXIT_IF_WIN -eq 0
then
INICIO_TIME_RONDA=$SECONDS
TURNO=0
RONDAS=$(($RONDAS+1))
BURRO=0
barajar
echo BARAJANDO...
sleep 2
echo ENTREGANDO CARTAS...
sleep 2
while test $BURRO -eq 0
do 
clear
turnoJugador
turnoPc1
turnoPc2
turnoPc3
changes
mostrarVictoriaDerrota
done	
InGame
else
FINISH_HOUR=$(date +"%T") 
saveGameStats
main
fi
}
#INICIO MAIN
function main(){
clear
menu
echo -n "Introduzca una opcion:"
read opc
echo -e "\e[0m"
case $opc in
"j" | "J" )
game   	
echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
read -p ""
main			   
;;
"c" | "C" )
configuracion	    
echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
read -p ""
main
;;
"e" | "E" )
stats	     	
echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
read -p ""
main           
;;
"f" | "F" )
clasificacion     
echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
read -p ""
main
;;
"s" | "S" )
echo "Saliendo..."
sleep 2
exit	
;;
*)         	
clear     
echo "Opcion Incorrecta"
sleep 2
main
;;
esac
}

#Argumentos check
if test $# -gt 1 
then
echo "[ERROR] Numero inválido de argumentos"
argumentosDeError
elif test $# -eq 1
then
if test $1 = "-g"
then
imprimirCreadores
exit
else
echo "[ERROR] Argumento inválido"
argumentosDeError
fi
fi

#Check for config file and if it exists, loads it
comprobarCfg
cargarConfig
main

