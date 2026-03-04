/// @description Win Screen – Step
blink_timer = (blink_timer + 1) mod 60;

// Press Enter or Z to return to the main menu
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z")))
    room_goto(Menu);
