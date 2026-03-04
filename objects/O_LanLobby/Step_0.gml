/// @description LAN Lobby – Step
cursor_blink = (cursor_blink + 1) mod 60;

var _nm = O_NetworkManager;
var _enter = keyboard_check_pressed(vk_enter)
          || keyboard_check_pressed(ord("Z"))
          || keyboard_check_pressed(vk_space);

// ── Phase 0: story intro ──────────────────────────────────────────────────────
if (phase == 0)
{
    if (_enter)
        phase = 1;
    exit;
}

// ── Phase 1: main menu ────────────────────────────────────────────────────────
if (phase == 1)
{
    if (keyboard_check_pressed(vk_up))   menu_option = max(0, menu_option - 1);
    if (keyboard_check_pressed(vk_down)) menu_option = min(2, menu_option + 1);

    if (_enter)
    {
        if (menu_option == 0)    // HOST (LAN)
        {
            _nm.net_role        = "host";
            _nm.net_my_id       = 0;
            _nm.net_server      = network_create_server(network_socket_tcp, _nm.NET_PORT_GAME, _nm.NET_MAX_CLIENTS);
            _nm.net_disc_socket = network_create_server(network_socket_udp, _nm.NET_PORT_DISC, 32);
            _nm.net_state       = "in_game";
            room_goto(Start);
        }
        else if (menu_option == 1)    // JOIN (LAN)
        {
            _nm.net_role        = "client";
            _nm.net_state       = "searching";
            _nm.net_disc_socket = network_create_socket_ext(network_socket_udp, _nm.NET_PORT_DISC);
            // Broadcast discovery ping
            var _buf = buffer_create(2, buffer_fixed, 1);
            buffer_write(_buf, buffer_u8, _nm.NET_DISCOVERY);
            network_send_broadcast(_nm.net_disc_socket, _nm.NET_PORT_DISC, _buf, buffer_tell(_buf));
            buffer_delete(_buf);
            status_msg   = "Scanning LAN for games...";
            search_timer = 0;
            phase        = 2;
        }
        else    // SOLO PLAY
        {
            _nm.net_role  = "none";
            _nm.net_state = "idle";
            room_goto(Start);
        }
    }
    exit;
}

// ── Phase 2: waiting for LAN discovery results ────────────────────────────────
if (phase == 2)
{
    search_timer++;

    // Re-broadcast every 90 frames in case the first packet was lost
    if (search_timer mod 90 == 0)
    {
        var _buf = buffer_create(2, buffer_fixed, 1);
        buffer_write(_buf, buffer_u8, _nm.NET_DISCOVERY);
        network_send_broadcast(_nm.net_disc_socket, _nm.NET_PORT_DISC, _buf, buffer_tell(_buf));
        buffer_delete(_buf);
    }

    // Auto-connect to first server found
    if (servers_updated)
    {
        servers_updated = false;
        if (ds_list_size(_nm.net_servers_found) > 0)
        {
            var _e   = _nm.net_servers_found[| 0];
            var _ip  = _e[? "ip"];
            var _p   = _e[? "port"];
            _nm.net_socket = network_create_socket(network_socket_tcp);
            network_connect(_nm.net_socket, _ip, _p);
            _nm.net_state = "connecting";
            status_msg    = "Connecting to " + _ip + "...";
        }
    }

    // Connection accepted → start game
    if (_nm.net_state == "in_game")
        room_goto(Start);

    // Timeout after ~5 seconds with no server found
    if (search_timer >= 300 && _nm.net_state == "searching")
    {
        status_msg  = "No LAN games found. Press [ENTER] to retry.";
        _nm.net_state = "idle";
    }

    // Allow going back to menu
    if (keyboard_check_pressed(vk_escape))
    {
        _nm.net_state = "idle";
        phase         = 1;
        status_msg    = "";
    }
}
