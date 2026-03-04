/// @description LAN Lobby – Initialization
// Manages the title screen: story intro → host/join/solo choice.
// NOTE: Same-device split-keyboard play is intentionally NOT supported.
//       Players must connect over the same local WiFi/LAN network.

// Ensure the network manager exists and persists
if (!instance_exists(O_NetworkManager))
    instance_create_layer(0, 0, "Instances", O_NetworkManager);

phase          = 0;      // 0 = intro story, 1 = menu options, 2 = searching LAN
menu_option    = 0;      // 0 = Host, 1 = Join, 2 = Solo
cursor_blink   = 0;
servers_updated = false;
search_timer   = 0;      // timeout for LAN discovery
status_msg     = "";

// Intro story text (displayed in phase 0)
intro_lines = [
    "YEAR  2087.  A C I C A M P F I R E.",
    "",
    "Once a proud industrial city, now a",
    "crumbling wasteland of rusted steel",
    "and broken concrete.",
    "",
    "You are RICKY – the last survivor.",
    "The radio tower at the city's edge",
    "is your only hope.",
    "",
    "Reach it.  Send the signal.",
    "AciCampfire must not be forgotten.",
];
