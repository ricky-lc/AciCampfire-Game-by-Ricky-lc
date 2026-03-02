/// @description Story Text – Initialization
// Shows lore/narrative text at the start of each level.
// Determines its own text from the current room name.

var _rname = room_get_name(room);
switch (_rname)
{
    case "Start":
        story_text =
            "LEVEL 1  –  THE RUINS\n\n" +
            "The city streets are littered with rubble\n" +
            "from the Great Collapse. Mind the spike traps –\n" +
            "salvagers left them to guard what little remained.";
        break;

    case "Level_1":
        story_text =
            "LEVEL 2  –  THE CITY BLOCK\n\n" +
            "You push deeper into the district. The buildings\n" +
            "lean at broken angles. Spikes have been rigged\n" +
            "everywhere.  Stay sharp.";
        break;

    case "Level_2":
        story_text =
            "LEVEL 3  –  UPPER DISTRICT\n\n" +
            "Before the Collapse, wealthy citizens lived above\n" +
            "the chaos on elevated walkways. Now these bridges\n" +
            "are crumbling.  One wrong step and it's over.";
        break;

    case "Taxi":
        story_text =
            "LEVEL 4  –  THE TAXI DISTRICT\n\n" +
            "Among the abandoned vehicles a taxi still idles.\n" +
            "The last driver fled and left the engine running.\n" +
            "The road ahead is broken – use the cab.";
        break;

    case "Level_3":
        story_text =
            "LEVEL 5  –  FINAL RUN\n\n" +
            "The radio tower is visible on the horizon.\n" +
            "The last stretch of road is the worst.\n" +
            "Hold the cab together.  Almost there.";
        break;

    default:
        story_text = "";
        break;
}

// If there is nothing to say, self-destruct immediately
if (story_text == "")
{
    instance_destroy();
    exit;
}

display_timer = 300;    // auto-dismiss after 5 seconds
alpha         = 0.0;
fade_speed    = 0.04;
done          = false;

// Block the local player while text is displayed
if (instance_exists(O_Player))
    O_Player.controllable = false;

depth = -9999;
