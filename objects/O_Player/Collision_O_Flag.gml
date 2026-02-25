// Verifica se abbiamo già "vinto" per evitare di far ripartire l'allarme a ogni frame
if (!variable_instance_exists(id, "vittoria")) {
    vittoria = true;
    
    // Imposta l'Alarm 0 a 3 secondi. 
    // room_speed rappresenta un secondo (o game_get_speed(gamespeed_fps))
    alarm[0] = game_get_speed(gamespeed_fps) * 3;
}