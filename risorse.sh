#!/bin/bash
# stty size | perl -ale 'print "-"x$F[1]'

#  caratteristiche della cpu
ARCHITETTURA_CPU=` lscpu | grep "Architecture" | awk -F: '{print $2}'`
MODEL_NAME=` lscpu | grep "Model name" | awk -F: '{print $2}' | xargs`
NUMBER_CORE=` lscpu | grep "^CPU(s)" | awk -F: '{print $2}' | xargs`
NUMBER_CORE_ON=` lscpu | grep "On-line CPU(s) list:" | awk -F: '{print $2}'`

# -------------------------------
#          MEMORIA
# -------------------------------

MEMORY_TOTAL=` free -b | awk '/Mem:/ {print$2}'`
MEMORY_USED=` free -b | awk '/Mem:/ {print$3}'`
MEMORY_FREE=` free -b | awk '/Mem:/ {print$4}'`
ALL_MEMORY_FREE=` free -b | awk '/Mem:/ {print$6}'`
PERCENTUALE_MEMOR=$(echo "scale=1; ($MEMORY_USED * 100) / $MEMORY_TOTAL" | bc)

VIRTUAL_MEMORY_TOTAL=` free -b | awk '/Swap:/ {print$2}'`
VIRTUAL_MEMORY_USED=` free -b | awk '/Swap:/ {print$3}'`
VIRTUAL_MEMORY_FREE=` free -b | awk '/Swap:/ {print$4}'`
VIRTUAL_PERCENTUALE_MEMOR=$(echo "scale=1; ($VIRTUAL_MEMORY_USED * 100) / $VIRTUAL_MEMORY_TOTAL" | bc)

# -------------------------------
#          PROCESSI
# -------------------------------

# PROCESS_USER prende chi ha inizializzato quel processo
# PROCESS_PID è l'identificativo del singolo processo
# PROCESS_CPU è quanta cpu sta o ha consumato 
# PROCESS_MEMORY è la memoria che ha consumato il processo
# PROCESS_MEMORY_VIRTUAL è la memoria virtuale del processo
# PROCESS_STATE lo stato attuale del processo
# PROCESS_TIME  il tenpo che la cpu ci ha impiegato ad eseguire il processo
# PROCESS_COMAND il comando che ha permesso di attivare questo processo

# inizializzazione degli array
declare -a PROCESS_USER
declare -a PROCESS_PID
declare -a PROCESS_CPU
declare -a PROCESS_MEMORY
declare -a PROCESS_MEMORY_VIRTUAL
declare -a PROCESS_STATE
declare -a PROCESS_TIME
declare -a PROCESS_COMAND

PROCESS_USER=($(ps aux | awk 'NR>1 {print$1}'))
PROCESS_PID=($(ps aux | awk 'NR>1 {print$2}'))
PROCESS_CPU=($(ps aux | awk 'NR>1 {print$3}'))
PROCESS_MEMORY=($(ps aux | awk 'NR>1 {print$4}'))
PROCESS_MEMORY_VIRTUAL=($(ps aux | awk 'NR>1 {print$5}'))
PROCESS_STATE=($(ps aux | awk 'NR>1 {print$8}'))
PROCESS_TIME=($(ps aux | awk 'NR>1 {print$10}'))
PROCESS_COMAND=($(ps aux | awk 'NR>1 {print$11}'))


processo()
{
    local user=$1 pid=$2 cpu=$3 memory=$4 memory_virtual=$5 state=$6 time=$7 comand=$8

    # array associativo si basa sulle key (pace a cosimo)
    declare -A process

    process["user"]=$user
    process["pid"]=$pid
    process["cpu"]=$cpu
    process["memory"]=$memory
    process["memory_virtual"]=$memory_virtual
    process["state"]=$state
    process["time"]=$time
    process["comand"]=$comand

    nameProcess()
    {
        echo "Processo:"
        echo "${process[user]} " # PROCESSO
        echo "${process[pid]} " # PID
        echo "${process[cpu]} " # CPU
        echo "${process[memory]}% " # MEMORIA
        echo "${process[memory_virtual]}byte " # MEMORIA VIRTUALE
        echo "${process[state]} " # STATO
        echo "${process[time]} " # TIME
        echo "${process[comand]} " # COMAND
    }

    nameProcess
}


for virtual_memory_Id in "${!PROCESS_MEMORY_VIRTUAL[@]}"
do 
    virtual_memory=${PROCESS_MEMORY_VIRTUAL[$virtual_memory_Id]}
    # trasformazione in kiloByte in bytes
    value=$(echo "scale=1; $virtual_memory * 1024" | bc)

    # creazione del proceso
    processo ${PROCESS_USER[$virtual_memory_Id]} ${PROCESS_PID[$virtual_memory_Id]} ${PROCESS_CPU[$virtual_memory_Id]} ${PROCESS_MEMORY[$virtual_memory_Id]} $value ${PROCESS_STATE[$virtual_memory_Id]} ${PROCESS_TIME[$virtual_memory_Id]} ${PROCESS_COMAND[$virtual_memory_Id]}
    echo $?
done

# si evita termini con Microsoft con la falg -v perchè potrebbero derivare da un ambiente virtuale
# GPU=`lspci | grep -E "VGA|3D|Display" | grep -v Microsoft` 
# echo $GPU

# if [ -n "$GPU" ]; then
#     echo "non è installata una GPU"
#     echo "il modello di CPU è: $MODEL_NAME"
#     echo $GPU
#     . ./gpu.sh
# fi

# echo "non è installata una GPU"
# echo "il modello di CPU è: $MODEL_NAME"
# . ./cpu.sh

# help test 
# per vedere singoli processi ps -p pid processo