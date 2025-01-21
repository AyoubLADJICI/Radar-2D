#include "system.h"
#include <stdio.h>
#include <math.h>
#include "io.h"
#include "unistd.h"

//Ce code a ete ecrit a l'aide du code exemple fourni dans la documentation (DE10-LITE COMPUTER SYSTEM) a la page 45
//et egalement avec l'aide de ChatGPT

#define PIXEL_BUF_CTRL_BASE VGA_SUBSYSTEM_VGA_PIXEL_DMA_BASE
#define FPGA_CHAR_BASE VGA_SUBSYSTEM_CHAR_BUF_SUBSYSTEM_ONCHIP_SRAM_BASE
#define RGB_RESAMPLER_BASE VGA_SUBSYSTEM_VGA_PIXEL_RGB_RESAMPLER_BASE

/* function prototypes */
void video_text(int, int, char *);
void video_box(int, int, int, int, short);
int resample_rgb(int, int);
int get_data_bits(int);
void clear_text();
void polar_to_cartesian(int angle, int distance, int *x, int *y);
void draw_obstacle(int angle, int distance, short color);
void draw_circle(int center_x, int center_y, int radius, short color);
void draw_distance_circles_and_labels();
void draw_angle_lines_and_labels();
void draw_angle_radial_lines();
void clear_obstacles();
void test_draw_point();
void clear_all_obstacles();

#define STANDARD_X 320
#define STANDARD_Y 240
#define INTEL_BLUE 0x0071C5

#define RADAR_CENTER_X (STANDARD_X / 2) // Centre du radar (160 pour 320x240)
#define RADAR_CENTER_Y (STANDARD_Y - 40) // Commence 40 pixels au-dessus du bas
#define AVAILABLE_HEIGHT (RADAR_CENTER_Y)
#define VERTICAL_SCALE (AVAILABLE_HEIGHT / RADAR_RADIUS)
#define HORIZONTAL_SCALE (10.0 / 2.5)

#define RADAR_RADIUS 50 //Rayon max du radar

/* global variables */
int screen_x;
int screen_y;
int res_offset;
int col_offset;

/*******************************************************************************
* This program demonstrates use of the video in the computer system.
* Draws a blue box on the video display, and places a text string inside the
* box
******************************************************************************/
int main(void) {
    volatile int * video_resolution = (int *)(PIXEL_BUF_CTRL_BASE + 0x8);
    screen_x = *video_resolution & 0xFFFF;
    screen_y = (*video_resolution >> 16) & 0xFFFF;
    volatile int * rgb_status = (int *)(RGB_RESAMPLER_BASE);
    int db = get_data_bits(*rgb_status & 0x3F);
    /* check if resolution is smaller than the standard 320 x 240 */
    res_offset = (screen_x == 160) ? 1 : 0;
    /* check if number of data bits is less than the standard 16-bits */
    col_offset = (db == 8) ? 1 : 0;
    clear_text();
    /* create a message to be displayed on the video and LCD displays */
    char prenom_nom[40] = "Ayoub LADJICI";
    char texte[40] = "Object: In Range";
    char angle[20] = "Angle: ";
    char distance[20] = "Distance: ";
    //test_draw_point();
    /* update color */
    short background_color = resample_rgb(db, INTEL_BLUE);
    video_text(1, 59, prenom_nom);
    video_text(20, 59, texte);
    video_text(45, 59, angle);
    video_text(65, 59, distance);
    video_box(0, 0, STANDARD_X, STANDARD_Y, 0); // clear the screen
    video_box(0 * 4, 58 * 4, 80 * 4 - 1, 60 * 4, background_color);
    //short test_color = 0xFFFF; // Blanc
    //draw_obstacle(angle, distance, test_color);

    draw_distance_circles_and_labels(); // Dessiner les cercles concentriques avec labels
    draw_angle_radial_lines();
    draw_angle_lines_and_labels();      // Dessiner les lignes d'angles avec labels
    while (1) {
    	//Balayer de 0 degre a 135 degres
    	for (unsigned int position = 0; position < 511; position++) {
    		// Envoyer la position au servomoteur
    	    IOWR(AVALON_SERVOMOTEUR_0_BASE, 0, position);
    	    // Conversion de la position (en binaire) en degr�s
    	    int angle = (position * 135 / 511);
    	    // Lecture de la distance avec le telemetre
    	    unsigned int aller_retour = IORD(AVALON_TELEMETRE_0_BASE, 0);
    	    unsigned int distance = aller_retour / 2;

    	    // Afficher la distance et l'angle dans la console
    	    printf("%u degres -> %u cm\n", angle, distance);

    	    // Dessiner l'obstacle sur le radar si la distance est dans le rayon
    	    if (distance > 0 && distance <= RADAR_RADIUS) {
    	    	draw_obstacle(angle, distance, 0xF800); // Couleur rouge pour l'obstacle
    	    }
    	    // Mise a jour des informations textuelles
    	    char angle_str[20], distance_str[20];
    	    sprintf(angle_str, "Angle: %d degres", angle);
    	    sprintf(distance_str, "Distance: %d cm", distance);
    	    video_text(45, 59, angle_str);
    	    video_text(65, 59, distance_str);
    	    usleep(20000);
    	}

    	// Balayer de 135 degres a 0 degre (retour)
    	for (unsigned int position = 511; position > 0; position--) {
    	    // Envoyer la position au servomoteur
    	    IOWR(AVALON_SERVOMOTEUR_0_BASE, 0, position);
    	    // Conversion de la position (en binaire) en degres
    	    int angle = (position * 135 / 511);
    	    // Lecture de la distance avec le telemetre
    	    unsigned int aller_retour = IORD(AVALON_TELEMETRE_0_BASE, 0);
    	    unsigned int distance = aller_retour / 2;

    	    // Afficher la distance et l'angle dans la console
    	    printf("%u� -> %u cm\n", angle, distance);

    	    // Dessiner l'obstacle sur le radar si la distance est dans le rayon
    	    if (distance > 0 && distance <= RADAR_RADIUS) {
    	       draw_obstacle(angle, distance, 0xF800); // Couleur rouge pour l'obstacle
    	    }
    	    // Mise a jour des informations textuelles
    	    char angle_str[20], distance_str[20];
    	    sprintf(angle_str, "Angle: %d degres", angle);
    	    sprintf(distance_str, "Distance: %d cm", distance);
    	    video_text(45, 59, angle_str);
    	    video_text(65, 59, distance_str);
    	    usleep(20000);
    	}
    	clear_all_obstacles();

    	// Pause avant de recommencer un nouveau balayage
    	printf("Fin du balayage.\n");
    	usleep(1000000); // Pause de 1 seconde
    }
    return 0;
}

/*
void test_draw_point() {
    volatile short *pixel_buffer = (short *)(VGA_SUBSYSTEM_VGA_PIXEL_DMA_BASE);
    int x = 160; // Centre de l'ecran
    int y = 120; // Centre de l'ecran
    short test_color = 0xF800; // Rouge

    *(pixel_buffer + (y * 320) + x) = test_color; // Dessine un point
}
*/


/*******************************************************************************
* Subroutine to send a string of text to the video monitor
******************************************************************************/
void video_text(int x, int y, char * text_ptr) {
    int offset;
    volatile char * character_buffer = (char *)FPGA_CHAR_BASE; // video character buffer
    /* assume that the text string fits on one line */
    offset = (y << 7) + x;
    while (*(text_ptr)) {
        *(character_buffer + offset) = *(text_ptr); // write to the character buffer
        ++text_ptr;
        ++offset;
    }
}

/*******************************************************************************
* Draw a filled rectangle on the video monitor
* Takes in points assuming 320x240 resolution and adjusts based on differences
* in resolution and color bits.
******************************************************************************/
void video_box(int x1, int y1, int x2, int y2, short pixel_color) {
    int pixel_buf_ptr = *(int *)PIXEL_BUF_CTRL_BASE;
    int pixel_ptr, row, col;
    int x_factor = 0x1 << (res_offset + col_offset);
    int y_factor = 0x1 << (res_offset);
    x1 = x1 / x_factor;
    x2 = x2 / x_factor;
    y1 = y1 / y_factor;
    y2 = y2 / y_factor;
    /* assume that the box coordinates are valid */
    for (row = y1; row <= y2; row++)
        for (col = x1; col <= x2; ++col) {
            pixel_ptr = pixel_buf_ptr +
            (row << (10 - res_offset - col_offset)) + (col << 1);
            *(short *)pixel_ptr = pixel_color; // set pixel color
    }
}

/********************************************************************************
* Resamples 24-bit color to 16-bit or 8-bit color
*******************************************************************************/
int resample_rgb(int num_bits, int color) {
    if (num_bits == 8) {
        color = (((color >> 16) & 0x000000E0) | ((color >> 11) & 0x0000001C) |
        ((color >> 6) & 0x00000003));
        color = (color << 8) | color;
    } else if (num_bits == 16) {
        color = (((color >> 8) & 0x0000F800) | ((color >> 5) & 0x000007E0) |
    ((color >> 3) & 0x0000001F));
    }
    return color;
}

/********************************************************************************
* Finds the number of data bits from the mode
*******************************************************************************/
int get_data_bits(int mode) {
	switch (mode) {
		case 0x0:
	        return 1;
	    case 0x7:
	        return 8;
	    case 0x11:
	        return 8;
	    case 0x12:
	        return 9;
	    case 0x14:
	        return 16;
	    case 0x17:
	        return 24;
	    case 0x19:
	        return 30;
	    case 0x31:
	        return 8;
	    case 0x32:
	        return 12;
	    case 0x33:
	        return 16;
	    case 0x37:
	        return 32;
	    case 0x39:
	        return 40;
	    default:
	        return -1; // Mode non reconnu
   }
}

void clear_text() {
    volatile char * character_buffer = (char *)FPGA_CHAR_BASE;
    for (int y = 0; y < 60; y++) {
        for (int x = 0; x < 80; x++) {
            int offset = (y << 7) + x;
            *(character_buffer + offset) = ' ';
        }
    }
}

void polar_to_cartesian(int angle, int distance, int *x, int *y) {
    float radians = angle * M_PI / 180.0; // Conversion degres en radians
    *x = RADAR_CENTER_X + (int)(distance * cos(radians) * HORIZONTAL_SCALE); // Echelle horizontale
    *y = RADAR_CENTER_Y - (int)(distance * sin(radians) * VERTICAL_SCALE);   // Echelle verticale
}


// Fonction pour dessiner un obstacle sur le radar VGA
void draw_obstacle(int angle, int distance, short color) {
    // Conversion de l'angle et de la distance en coordonnees cartesiennes
    int x, y;
    polar_to_cartesian(angle, distance, &x, &y);

    // Verification des limites pour eviter d'ecrire hors ecran
    if (x < 0 || x >= STANDARD_X || y < 0 || y >= STANDARD_Y) {
        return; // Ne rien dessiner si hors limites
    }

    // Dessiner un rectangle rouge autour de la position calculee
    int box_size = 4; // Taille du rectangle en pixels
    video_box(x - box_size, y - box_size, x + box_size - 1, y + box_size - 1, color);
}



void draw_circle(int center_x, int center_y, int radius, short color) {
    for (int angle = 0; angle < 180; angle++) {
        int x, y;
        polar_to_cartesian(angle, radius, &x, &y);
        video_box(x - 1, y - 1, x + 1, y + 1, color); // Point pour le cercle
    }
}

void draw_distance_circles_and_labels() {
    int step = RADAR_RADIUS / 5;
    for (int radius = step; radius <= 40; radius += step) {
        draw_circle(RADAR_CENTER_X, RADAR_CENTER_Y, radius, 0x07E0);

        int label_x = RADAR_CENTER_X + (radius * HORIZONTAL_SCALE) + 10;
        int label_y = RADAR_CENTER_Y - (radius * VERTICAL_SCALE);
        char distance_label[10];
        sprintf(distance_label, "%dcm", radius); // Convertit la distance en texte
        video_text(35 + radius, 49, distance_label); // Ajuste pour la grille textuelle
    }
}


void draw_angle_lines_and_labels() {
    int label_radius = RADAR_RADIUS + 5; // Positionner les labels legerement en dehors des cercles

    for (int angle = 0; angle <= 180; angle += 30) { // Lignes tous les 30 degres
        int x, y;
        polar_to_cartesian(angle, RADAR_RADIUS, &x, &y); // Ligne jusqu'au bord du radar
        video_box(RADAR_CENTER_X, RADAR_CENTER_Y, x, y, 0x07E0); // Ligne verte

        // Calculer la position du label avec une �chelle correcte
        int label_x = RADAR_CENTER_X + (int)(label_radius * cos(angle * M_PI / 180.0) * HORIZONTAL_SCALE);
        int label_y = RADAR_CENTER_Y - (int)(label_radius * sin(angle * M_PI / 180.0) * VERTICAL_SCALE);

        // V�rification stricte des limites de l'ecran
        if (label_x < 0) label_x = 10; // Ajuster si trop a gauche
        if (label_x > STANDARD_X) label_x = STANDARD_X - 30; // Ajuster si trop a droite
        if (label_y < 0) label_y = 10; // Ajuster si trop en haut
        if (label_y > STANDARD_Y) label_y = STANDARD_Y - 10; // Ajuster si trop en bas

        // Afficher le label de l'angle
        char angle_label[10];
        sprintf(angle_label, "%d", angle); // Convertir l'angle en texte
        video_text(label_x / 4, label_y / 4, angle_label); // Ajuster pour la grille textuelle
    }
}


void draw_angle_radial_lines() {
    for (int angle = 0; angle <= 180; angle += 30) { // Lignes tous les 30 degres
        int x_end, y_end;
        polar_to_cartesian(angle, RADAR_RADIUS, &x_end, &y_end); // Calcul des coordonnees finales

        // Tracer une ligne entre le centre et (x_end, y_end)
        int x_start = RADAR_CENTER_X;
        int y_start = RADAR_CENTER_Y;

        int dx = x_end - x_start;
        int dy = y_end - y_start;

        int steps = abs(dx) > abs(dy) ? abs(dx) : abs(dy);
        float x_inc = dx / (float)steps;
        float y_inc = dy / (float)steps;

        float x = x_start;
        float y = y_start;

        for (int i = 0; i <= steps; i++) {
            video_box((int)x, (int)y, (int)x, (int)y, 0x07E0);
            x += x_inc;
            y += y_inc;
        }
    }
}

// Fonction pour effacer les obstacles sur le radar
void clear_obstacles(int angle, int distance) {
    // Conversion de l'angle et de la distance en coordonnees cartesiennes
    int x, y;
    polar_to_cartesian(angle, distance, &x, &y);

    // Verification des limites pour eviter d'ecrire hors ecran
    if (x < 0 || x >= STANDARD_X || y < 0 || y >= STANDARD_Y) {
        return; // Ne rien effacer si hors limites
    }

    // Dessiner un rectangle noir (effacer l'obstacle)
    int box_size = 4;
    video_box(x - box_size, y - box_size, x + box_size - 1, y + box_size - 1, 0x0000);
}

void clear_all_obstacles() {
    // Balayer de 0 degre a 135 degres (aller)
    for (unsigned int position = 0; position <= 511; position++) {
        int angle = (position * 180 / 511);
        unsigned int distance = RADAR_RADIUS;
        clear_obstacles(angle, distance);
    }
}
