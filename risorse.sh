#  caratteristiche della cpu
ARCHITETTURA_CPU=`lscpu | grep "Architecture" | awk -F: '{print $2}'`
MODEL_NAME=`lscpu | grep "Model name" | awk -F: '{print $2}' | xargs`
NUMBER_CORE=`lscpu | grep "^CPU(s)" | awk -F: '{print $2}' | xargs`
NUMBER_CORE_ON=`lscpu | grep "On-line CPU(s) list:" | awk -F: '{print $2}'`

# stty size | perl -ale 'print "-"x$F[1]'

# si evita termini con Microsoft con la falg -v perchè potrebbero derivare da un ambiente virtuale
GPU=`lspci | grep -E "VGA|3D|Display" | grep -v Microsoft` 
echo $GPU

if [ -z "$GPU" ]; then
    echo "non è installata una GPU"
    echo "The value is: $MODEL_NAME"
    . ./cpu.sh
else
    . ./cpu.sh
    . ./gpu.sh
    echo $GPU
    echo echo $MODEL_NAME
fi
