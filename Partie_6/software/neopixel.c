#include "system.h"
#include "io.h"
#include <stdio.h>
#include "unistd.h"


int main() {
  int nb_leds_allumees = 0;
  while (1) {
	  printf("Nombre de leds allumees : %d\n", nb_leds_allumees);
	  IOWR(AVALON_NEOPIXEL_0_BASE,0,nb_leds_allumees);
	  nb_leds_allumees++;
	  if (nb_leds_allumees>12){
		  nb_leds_allumees = 0;
	  }
	  usleep(200000);
  }
  return 0;
}
