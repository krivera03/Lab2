#!/bin/bash

# R1.Argumentos 
if [ $# -lt 1 ]; then
	echo "Uso $0 \"comando\" [intervalo]"
	exit 1
fi

COMANDO="$1"
INTERVALO=${2:-2}

# R2.Ejecucion del proceso
eval "$COMANDO" &
PID=$!

LOG="monitor_${PID}.log"

# R4.Manejo de finalizacion
terminar() {
	echo "Interrumpido. Terminando proceso $PID"
	kill -15 $PID 2>/dev/null
	wait $PID 2>/dev/null
	graficar 
	exit 0
}

trap terminar SIGINT

# R3. Registro periodico
INICIO=$(date +%s)

while kill -0 $PID 2>/dev/null; do
	TIEMPO=$(($(date +%s) - INICIO))

	ps -p $PID -o %cpu,%mem,rss --no-headers | \
	awk -v t="$TIEMPO" '{print t, $1, $2, $3}' >> "$LOG"

	sleep $INTERVALO
done

# R5.Graficacion
graficar() {
	OUTPUT="monitor_${PID}.png"
	echo "Generando grafica..."

	gnuplot <<EOF
set terminal png size 800,600
set output "$OUTPUT"

set title "Proceso: $COMANDO (PID $PID)"
set xlabel "Tiempo (s)"

set ylabel "CPU (%)"
set y2label "RSS (KB)"
set y2tics
set grid

# convertir timestamp a segundos
plot \
	"$LOG" using 1:2 with lines title "CPU (%)", \
	"$LOG" using 1:4 axes x1y2 with lines title "RSS (KB)"
EOF

	echo "Gráfica generada: $OUTPUT"
}

wait $PID
graficar

