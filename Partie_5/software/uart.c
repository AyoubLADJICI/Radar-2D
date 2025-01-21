#include <stdio.h>
#include <system.h>
#include <io.h>

void send_char(char c) {
    while (IORD(AVALON_UART_0_BASE, 2) & 0x01); // Attendre que Tx ne soit pas occup�
    IOWR(AVALON_UART_0_BASE, 0, c);            // �crire le caract�re � envoyer
}

char receive_char() {
    while (!(IORD(AVALON_UART_0_BASE, 2) & 0x02)); // Attendre Rx pr�t
    return IORD(AVALON_UART_0_BASE, 1);           // Lire le caract�re re�u
}

int main() {
	while(1) {
		send_char('A');               // Envoyer un caract�re
	}
    return 0;
}
