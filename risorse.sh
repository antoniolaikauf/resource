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
VIRTUAL_MEMORY_FREE=`free -b | awk '/Swap:/ {print$4}'`
VIRTUAL_PERCENTUALE_MEMOR=$(echo "scale=1; ($VIRTUAL_MEMORY_USED * 100) / $VIRTUAL_MEMORY_TOTAL" | bc)

# stty size | perl -ale 'print "-"x$F[1]'

# si evita termini con Microsoft con la falg -v perchè potrebbero derivare da un ambiente virtuale
GPU=`lspci | grep -E "VGA|3D|Display" | grep -v Microsoft` 
echo $GPU

if [ -n "$GPU" ]; then
    echo "non è installata una GPU"
    echo "il modello di CPU è: $MODEL_NAME"
    echo $GPU
    . ./gpu.sh
fi

echo "non è installata una GPU"
echo "il modello di CPU è: $MODEL_NAME"
. ./cpu.sh

# help test 
