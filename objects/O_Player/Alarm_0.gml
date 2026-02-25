/// ALARM[0]

var w = window_get_width();
var h = window_get_height();

// Crea surface grande quanto la finestra
var surf = surface_create(w, h);

// Imposta la surface come target
surface_set_target(surf);

// Pulisce
draw_clear(c_black);

// Disegna SOLO la room, senza GUI
draw_room();

// Ripristina
surface_reset_target();

// Salva l’immagine
surface_save(surf, "vittoria.png");

// Libera la surface
surface_free(surf);

// Chiude il gioco
game_end();