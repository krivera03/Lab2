#!/bin/bash

# R1.Argumentos 
if [$# -lt 1 ]; then
	echo "Uso $0 \"comando\" [intervalo]"
	exit 1
fi

COMANDO="$1"
INTERVALO=${2:-2}

# R2.Ejecucion del proceso
bash -c "$COMANDO"&
PID=$!

LOG="monitor_${PID}.log"



