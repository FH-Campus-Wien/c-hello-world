#include <stdio.h>

/*
 * Verwendung im Terminal:
 *   make                         Programm bauen
 *   make run                     Programm bauen und starten
 *   make run ARGS="Hallo 123"   Programm mit Argumenten starten
 *   make debug                   Programm mit GDB debuggen
 *   make debug ARGS="Hallo 123" Programm mit Argumenten debuggen
 *   make clean                   Erzeugte Dateien entfernen
 */

int main(void)
{
    printf("Hello, World!\n");
    return 0;
}
