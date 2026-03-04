/// @description Network Manager – Initialization
// LAN multiplayer only – NO same-device split-keyboard play.
// Players must be on the same local WiFi/LAN network.

// ── Port constants ────────────────────────────────────────────────────────────
NET_PORT_GAME   = 6511;     // TCP port for game session
NET_PORT_DISC   = 6512;     // UDP port for LAN discovery broadcasts
NET_MAX_CLIENTS = 3;        // host + 3 clients = 4 players max

// ── Message-type IDs (first byte of every packet) ────────────────────────────
NET_DISCOVERY       = 0;    // client → broadcast: "who is hosting?"
NET_DISC_RESPONSE   = 1;    // host  → client: "I am here, TCP port = X"
NET_JOIN_REQUEST    = 2;    // client → host: please accept me
NET_JOIN_ACCEPT     = 3;    // host  → client: ok, your player_id = N
NET_POSITION_UPDATE = 4;    // client → host: my x, y, facing
NET_STATE_BROADCAST = 5;    // host  → all:  snapshot of every player
NET_LEAVE           = 6;    // either side: I am disconnecting

// ── Runtime state ─────────────────────────────────────────────────────────────
net_role   = "none";   // "none" | "host" | "client"
net_state  = "idle";   // "idle" | "hosting" | "searching" | "connecting" | "in_game"

// ── Socket handles ────────────────────────────────────────────────────────────
net_server      = -1;   // TCP server handle (host only)
net_socket      = -1;   // TCP socket to host (client only)
net_disc_socket = -1;   // UDP discovery socket

// ── Player registry (host tracks all; client tracks remotes) ─────────────────
// ds_map: player_id(int) → ds_map { "x", "y", "facing", "socket" }
net_players      = ds_map_create();
net_player_count = 1;    // starts at 1 (host = id 0)
net_my_id        = 0;

// ── Discovery helpers (client only) ──────────────────────────────────────────
net_servers_found = ds_list_create();  // ds_map entries {ip, port}
net_disc_timer    = 0;

// Persist across room transitions so the session survives level changes
persistent = true;
