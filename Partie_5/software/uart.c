#include <stdio.h>
#include <system.h>
#include <io.h>

void send_char(char c) {
    while (IORD(AVALON_UART_0_BASE, 2) & 0x01); // Attendre que Tx ne soit pas occupé
    IOWR(AVALON_UART_0_BASE, 0, c);            // Écrire le caractère à envoyer
}

char receive_char() {
    while (!(IORD(AVALON_UART_0_BASE, 2) & 0x02)); // Attendre Rx prêt
    return IORD(AVALON_UART_0_BASE, 1);           // Lire le caractère reçu
}

int main() {
	while(1) {
		send_char('A');               // Envoyer un caractère
	}
    return 0;
}
