/// @description Story Text – Step
if (done) exit;

// Fade in
alpha = min(1.0, alpha + fade_speed);

display_timer--;

var _dismiss = keyboard_check_pressed(vk_enter)
            || keyboard_check_pressed(ord("Z"))
            || keyboard_check_pressed(vk_space)
            || display_timer <= 0;

if (_dismiss)
{
    done = true;
    if (instance_exists(O_Player))
        O_Player.controllable = true;
    instance_destroy();
}
