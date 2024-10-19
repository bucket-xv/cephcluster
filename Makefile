main: main.c
	gcc  main.c -o main -lrados

read: read.c
	gcc  read.c -o read -lrados