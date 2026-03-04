/// @description Network Manager – Async Networking event
// Handles all incoming TCP/UDP network traffic.

var _type = async_load[? "type"];

// ── New TCP connection (host only) ────────────────────────────────────────────
if (_type == network_type_connect && net_role == "host")
{
    var _sock   = async_load[? "socket"];
    var _new_id = net_player_count;
    net_player_count++;

    var _m = ds_map_create();
    ds_map_set(_m, "x",      160);
    ds_map_set(_m, "y",      128);
    ds_map_set(_m, "facing", 1);
    ds_map_set(_m, "socket", _sock);
    net_players[? _new_id] = _m;

    // Tell the client its assigned player ID
    var _buf = buffer_create(3, buffer_fixed, 1);
    buffer_write(_buf, buffer_u8, NET_JOIN_ACCEPT);
    buffer_write(_buf, buffer_u8, _new_id);
    network_send_packet(_sock, _buf, buffer_tell(_buf));
    buffer_delete(_buf);

    // Spawn a visual ghost for this remote player
    if (layer_exists("Instances"))
    {
        var _rp    = instance_create_layer(160, 128, "Instances", O_RemotePlayer);
        _rp.net_id = _new_id;
    }
}

// ── Disconnection ─────────────────────────────────────────────────────────────
if (_type == network_type_disconnect)
{
    var _sock = async_load[? "socket"];
    var _k    = ds_map_find_first(net_players);
    repeat (ds_map_size(net_players))
    {
        var _e = net_players[? _k];
        if (ds_exists(_e, ds_type_map) && _e[? "socket"] == _sock)
        {
            with (O_RemotePlayer)
            {
                if (net_id == _k)
                {
                    instance_destroy();
                    break;
                }
            }
            ds_map_destroy(_e);
            ds_map_delete(net_players, _k);
            break;
        }
        _k = ds_map_find_next(net_players, _k);
    }
}

// ── Incoming data packet ──────────────────────────────────────────────────────
if (_type == network_type_data)
{
    var _sock = async_load[? "id"];
    var _buf  = async_load[? "buffer"];
    var _msg  = buffer_read(_buf, buffer_u8);

    // HOST receives POSITION_UPDATE from a client
    if (_msg == NET_POSITION_UPDATE && net_role == "host")
    {
        var _pid    = buffer_read(_buf, buffer_u8);
        var _px     = buffer_read(_buf, buffer_f32);
        var _py     = buffer_read(_buf, buffer_f32);
        var _facing = buffer_read(_buf, buffer_s8);

        if (ds_map_exists(net_players, _pid))
        {
            var _e = net_players[? _pid];
            ds_map_set(_e, "x",      _px);
            ds_map_set(_e, "y",      _py);
            ds_map_set(_e, "facing", _facing);
        }

        // Update ghost sprite
        with (O_RemotePlayer)
        {
            if (net_id == _pid)
            {
                x            = _px;
                y            = _py;
                image_xscale = _facing;
                break;
            }
        }
    }

    // CLIENT receives JOIN_ACCEPT
    if (_msg == NET_JOIN_ACCEPT && net_role == "client")
    {
        net_my_id = buffer_read(_buf, buffer_u8);
        net_state = "in_game";
    }

    // CLIENT receives STATE_BROADCAST from host
    if (_msg == NET_STATE_BROADCAST && net_role == "client")
    {
        var _count = buffer_read(_buf, buffer_u8);
        repeat (_count)
        {
            var _pid    = buffer_read(_buf, buffer_u8);
            var _px     = buffer_read(_buf, buffer_f32);
            var _py     = buffer_read(_buf, buffer_f32);
            var _facing = buffer_read(_buf, buffer_s8);

            if (_pid == net_my_id) continue;

            // Find or create a ghost for this remote player
            var _found = false;
            with (O_RemotePlayer)
            {
                if (net_id == _pid)
                {
                    x            = _px;
                    y            = _py;
                    image_xscale = _facing;
                    _found       = true;
                    break;
                }
            }
            if (!_found && layer_exists("Instances"))
            {
                var _rp    = instance_create_layer(_px, _py, "Instances", O_RemotePlayer);
                _rp.net_id = _pid;
            }
        }
    }

    // CLIENT receives DISC_RESPONSE on UDP discovery socket
    if (_msg == NET_DISC_RESPONSE && net_role == "client" && net_state == "searching")
    {
        var _port  = buffer_read(_buf, buffer_u16);
        var _ip    = async_load[? "ip"];
        var _entry = ds_map_create();
        ds_map_set(_entry, "ip",   _ip);
        ds_map_set(_entry, "port", _port);
        ds_list_add(net_servers_found, _entry);

        if (instance_exists(O_LanLobby))
            O_LanLobby.servers_updated = true;
    }
}
