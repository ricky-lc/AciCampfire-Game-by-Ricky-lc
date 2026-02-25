/// Player entra nella macchina

// 1. Disattiva il player
controllable = false;

other.just_entered = true;

// 2. Posiziona la macchina dove si trova il player
other.x = x;
other.y = y;

// 3. Alza la macchina di 32px PRIMA di qualsiasi controllo
other.y -= 120;

// 4. Riallinea la macchina al terreno
while (!place_meeting(other.x, other.y + 1, O_Solid)) {
    other.y += 1;
}

// 5. Attiva la macchina
other.controllable = true;

// 6. Distruggi il player
instance_destroy();