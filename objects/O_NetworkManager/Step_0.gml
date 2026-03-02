/// @description Network Manager – Step
// HOST: broadcast discovery beacon every second + collect own position
if (net_role == "host" && net_state == "in_game")
{
    net_disc_timer++;
    if (net_disc_timer >= 60)
    {
        net_disc_timer = 0;
        if (net_disc_socket != -1)
        {
            var _buf = buffer_create(4, buffer_fixed, 1);
            buffer_write(_buf, buffer_u8,  NET_DISC_RESPONSE);
            buffer_write(_buf, buffer_u16, NET_PORT_GAME);
            network_send_broadcast(net_disc_socket, NET_PORT_DISC, _buf, buffer_tell(_buf));
            buffer_delete(_buf);
        }
    }

    // Update own (host) entry and push state to clients
    if (instance_exists(O_Player))
    {
        var _p = O_Player;
        if (ds_map_exists(net_players, 0))
            ds_map_destroy(net_players[? 0]);
        var _m = ds_map_create();
        ds_map_set(_m, "x",      _p.x);
        ds_map_set(_m, "y",      _p.y);
        ds_map_set(_m, "facing", _p.image_xscale);
        ds_map_set(_m, "socket", -1);
        net_players[? 0] = _m;
        _netmgr_broadcast_state();
    }
}

// CLIENT: send own position to host every frame
if (net_role == "client" && net_state == "in_game" && net_socket != -1)
{
    if (instance_exists(O_Player))
    {
        var _p   = O_Player;
        var _buf = buffer_create(14, buffer_fixed, 1);
        buffer_write(_buf, buffer_u8,  NET_POSITION_UPDATE);
        buffer_write(_buf, buffer_u8,  net_my_id);
        buffer_write(_buf, buffer_f32, _p.x);
        buffer_write(_buf, buffer_f32, _p.y);
        buffer_write(_buf, buffer_s8,  sign(_p.image_xscale));
        network_send_packet(net_socket, _buf, buffer_tell(_buf));
        buffer_delete(_buf);
    }
}

/// @description Broadcasts the full player-state snapshot to every client
function _netmgr_broadcast_state()
{
    var _count = ds_map_size(net_players);
    if (_count == 0) exit;

    var _buf = buffer_create(4 + _count * 12, buffer_grow, 1);
    buffer_write(_buf, buffer_u8, NET_STATE_BROADCAST);
    buffer_write(_buf, buffer_u8, _count);

    var _k = ds_map_find_first(net_players);
    repeat (_count)
    {
        var _e = net_players[? _k];
        buffer_write(_buf, buffer_u8,  _k);
        buffer_write(_buf, buffer_f32, _e[? "x"]);
        buffer_write(_buf, buffer_f32, _e[? "y"]);
        buffer_write(_buf, buffer_s8,  _e[? "facing"]);
        _k = ds_map_find_next(net_players, _k);
    }

    // Deliver to each client socket
    _k = ds_map_find_first(net_players);
    repeat (_count)
    {
        var _e = net_players[? _k];
        var _s = _e[? "socket"];
        if (_s != -1)
            network_send_packet(_s, _buf, buffer_tell(_buf));
        _k = ds_map_find_next(net_players, _k);
    }
    buffer_delete(_buf);
}
