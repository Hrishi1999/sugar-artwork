${
import math

def my_floor(num):
    return int(math.floor(num))

def my_ceil(num):
    return int(math.ceil(num))


# Should we set the line width in the engine to 2.25, and draw non pixel aligned lines?
# Are these already the correct sizes for the XO?

# These sizes need to be sanity checked ...
if scaling == "100":
    xo = True
    line_width = 2.0        # 2.25px, rounded down
    thick_line_width = 3.5  # 3.5
    subcell_size = 15
    icon_base = 11
    bullet_size = 9.5
    font_height = 24
    default_padding = 6
    toolbutton_padding = 9
else: # About 72% of the XO size, adjusted so that eg. toolbuttons work
    xo = False
    line_width = 2.0            # 1.62 rounded up
    thick_line_width = 3.0      # 2.52
    subcell_size = 11           # 10.8
    icon_base = 8               # 7.92
    bullet_size = 6.5           # 6.84
    # This is a guess on the font size (Sans 10 at 96 DPI)
    font_height = 17
    default_padding = 4         # 4.32
    toolbutton_padding = 6      # 7.68


radio_size = my_floor(subcell_size + bullet_size + line_width)
scale_slider_width = my_floor(2 * subcell_size + line_width)
thickness = my_ceil(line_width)

icon_small = icon_base * 3
icon_large = icon_base * 5

}

* {
    -sugar-focus-line: @white;

    background-color: @button_grey;
    color: @black;

    border-width: $(thickness)px;
    border-color: none;
    border-radius: 0;
    border-style: none;

    padding: $thickness;

    /* A lot of these will probably need to be changed, but this has to
       be done when the exact sizes are known */
    -GtkWidget-interior-focus: 0;

    /* we have to disable focus border for GtkTreeView, see #1261 */
    -GtkTreeView-interior-focus: 1;
    -GtkTreeView-focus-line-width: 0;

    -GtkTextView-interior-focus: 1;

    -GtkWidget-focus-line-width: 0;  /* Prevents some drawing glitches */
    -GtkEntry-focus-line-width: 0;
    -GtkScale-focus-line-width: 0;
    -GtkScale-focus-line-width: 0;
    -GtkWidget-focus-padding: 0;
    /* 0.05 works good for both the sugar and sugar-xo themes */
    -GtkWidget-cursor-aspect-ratio: 0.05;

    -GtkWidget-wide-separators: false;
    -GtkWidget-separator-height: $thickness;
    -GtkWidget-separator-width: $thickness;

    -GtkWidget-scroll-arrow-hlength: $subcell_size;
    -GtkWidget-scroll-arrow-vlength: $subcell_size;

    -GtkRange-activate-slider: 1;

    /* We fake the default border in the theme */
    -GtkButton-default-border: 0 0 0 0;
    -GtkButton-default-outside-border: 0 0 0 0;
    -GtkButton-image-spacing: $subcell_size;

    -GtkEntry-progress-border: $thickness $thickness $thickness $thickness;

    -GtkScrolledWindow-scrollbar-spacing: 0;

    -GtkExpander-expander-size: $font_height;
    -GtkExpander-expander-spacing: 2;

    -GtkTreeView-expander-size: $font_height;

    /* we have to disable focus border for GtkTreeView, see #1261 */
    -GtkTreeView-interior-focus: 1;
    -GtkTreeView-focus-line-width: 0;

    -GtkArrow-arrow-size: 1.0;

    /* -GtkToolbar-shadow-type: ; */
    -GtkToolbar-space-size: $(2*subcell_size);

    -GtkProgressBar-min-horizontal-bar-height: $subcell_size;
    -GtkProgressBar-min-vertical-bar-width: $subcell_size;

    -GtkButtonBox-child-min-height: $(3*subcell_size);
    -GtkButtonBox-child-min-width: $(3*subcell_size);
    -GtkButtonBox-child-internal-pad-x: 0;
    -GtkButtonBox-child-internal-pad-y: 0;

/*    engine "sugar" {
        line_width: $line_width
        thick_line_width: $thick_line_width
        subcell_size: $subcell_size

        max_radius: $( 2*subcell_size )
    }*/
}

/* spinbutton should be *above* button */
.spinbutton {
    ${ spin_ythickness = my_ceil(3*subcell_size - font_height) }
    ${ spin_xthickness = subcell_size }
    ${ spin_btn_ythickness = spin_ythickness }
    ${ spin_btn_xthickness = subcell_size * 2 }

    /* small inner border and a lage x/ythickness for entries
       to reduce the number of hacks needed :-) */
    padding: $(spin_xthickness)px $(spin_ythickness)px;
}

.spinbutton.button,
.spinbutton.button:prelight,
.spinbutton.button:focused,
.spinbutton.button:active {
    padding: $(spin_ythickness)px $(spin_xthickness)px;

    border-color: @white;
    border-width: 0px;
    background-color: @button_grey;
    color: @white;
}

.spinbutton.button:focused {
    border-width: $(thickness)px;
}


.spinbutton.button:active {
    background-color: @white;
    color: @button_grey;
}

/* Text selection */
.entry:selected:focused, .view:selected:focused {
    background-color: @text_field_grey;
    color: @white;
}

*:insensitive {
    /* the insensitive background is visible in GtkToolButtons (where a label exists, see gedit back button)??? */
    background-color: #00ff00;
    color: @button_grey;
    border-color: @button_grey;
}

*:active {
    background-color: @white;
    color: @black;
}

.view {
    border-width: 0px;
    border-style: none;
    border-radius: 0;
    padding: 0px;
    background-color: @text_field_grey;
}

.entry {
    border-radius: $(2*subcell_size);
    border-width: $(thickness);
    border-color: @button_grey;
    border-style: solid;
    background-color: @text_field_grey;
    color: @black;
}

.entry:focused {
    background-color: @white;
}

.entry:insensitive, .view:insensitive {
    background-color: @button_grey;
}

.view:selected {
    background-color: @panel_grey;
    color: @black;
}

.entry:selected, .entry:selected:focused, 
.view:selected:focused {
    background-color: @selection_grey;
    color: @black;
}

.button {
    ${ border = max(0, my_ceil((3*subcell_size/2.0 - icon_small / 2.0))) }
    /* It would be nicer to just set the inner-border, but that does not work
       for combo boxes ... The combobox ignores it, so set it to 0px
       See http://bugzilla.gnome.org/show_bug.cgi?id=485762 */

    -GtkButton-inner-border: 0 0 0 0;
    padding: $(border)px $(border)px $(border)px $(border)px;

    border-radius: $(2*subcell_size);
    background-color: @button_grey;
    color: @white;
}

.button:focused {
    border-width: $(thickness);
    border-color: @white;
    border-style: solid;
}

.button:active {
    background-color: @;
    color: #ff00ff;
}

.button:selected {
    background-color: #ff0000;

    border-width: 0;
    border-color: none;
    border-radius: 10;
    border-style: none;

    color: #0000ff;
}


.notebook:active {
    background-color: @button_grey;
}

.background {
    padding: 0px;
    border-width: 0px;
    background-color: @panel_grey;
}

.window {
    background-color: @panel_grey;
    color: @black;
}

/* Handle this differently? */
.window *:insensitive {
    background-color: @panel_grey;
}


SugarSectionView {
    background-color: @white;
    color: @black;
}

SugarSectionView *:insensitive {
    background-color: @white;
}


SugarAlert {
    background-color: @black;
    color: @white;
}

SugarAlert *:insensitive {
    background-color: @black;
}


SugarGroupBox {
    background-color: @selection_grey;
    color: @black;
}

SugarGroupBox *:insensitive {
    background-color: @selection_grey;
}


SugarPaletteWindow SugarGroupBox {
    background-color: @toolbar_grey;
    color: @white;
}

SugarPaletteWindow SugarGroupBox *:insensitive {
    background-color: @toolbar_grey;
}


.menu, .palette {
    background-color: @black;
    color: @white;


    -GtkMenu-scroll-arrow-vlength: $(my_floor(subcell_size/0.7 + 2*thickness));
    -GtkMenu-horizontal-padding: $thickness;
    -GtkMenu-vertical-padding  : $thickness;
    /* This means the outline of the submenu overlaps with a palette.
     * However in the case of two normal menus, they are next to each other.
     * It is not possible to be smarter about this, because the style comes from
     * the submenu. */
    -GtkMenu-horizontal-offset : 0;
    -GtkMenu-vertical-offset   : 0;

    padding: 0;
}

.menu :prelight, palette :prelight {
    color: @white
}

.menu :active, palette :active {
    background-color: @button_grey;
}

.palette {
    padding: $(thickness)px;
}

.palette .menu {
    -GtkMenu-horizontal-padding: 0;
    -GtkMenu-vertical-padding: 0;

    padding: 0px $(subcell_size)px;
}

/* Correct? */
.menu * {
    background-color: @button_grey;
    color: @white;
}

.menu * :insensitive {
    background-color: @black;
}

.scrollbar {
    -GtkRange-slider-width: $subcell_size;
    -GtkRange-trough-border: 0;
    -GtkRange-stepper-size: 0;
    -GtkScrollbar-min-slider-length: $(3*subcell_size);
    -GtkScrollbar-has-forward-stepper: 0;
    -GtkScrollbar-has-backward-stepper: 0;
    -GtkScrollbar-has-secondary-forward-stepper: 0;
    -GtkScrollbar-has-secondary-backward-stepper: 0;
}

.scrollbar.trough {
    background-color: @button_grey;
    border-width: 0;
}

.scrollbar.slider {
    background-color: @white;
    border-radius: $(2*subcell_size);
    border-width: 0;
}

.scrollbar.slider:active {
    background-color: @text_field_grey;
}

/* Scrollbar padding hack? What was that about? */

/*

# hints for the trough padding hacks
# We cannot go trough GTK+, as we don't want a padding on all sides, but only one
# If we wanted padding on all sides, trough-border would work great.
style "hscrollbar": "scrollbar"
{
    engine "sugar" {
        hint: "hscrollbar"
        scrollbar_border: $thickness
    }
}

style "vscrollbar": "scrollbar"
{
    engine "sugar" {
        hint: "vscrollbar"
        scrollbar_border: $thickness
    }
}

style "hscrollbar-scrolled-window"
{
    GtkScrollbar-slider-width: $(subcell_size - thickness)
    GtkScrollbar-stepper-spacing: $thickness
    GtkScrollbar-has-forward-stepper: 1
    GtkScrollbar-has-backward-stepper: 1
    GtkScrollbar-stepper-size: 0

    engine "sugar" {
        hint: "hscrollbar-scrolled-window"
    }
}

style "vscrollbar-scrolled-window"
{
    GtkScrollbar-slider-width: $(subcell_size - thickness)
    GtkScrollbar-stepper-spacing: $thickness
    GtkScrollbar-has-forward-stepper: 1
    GtkScrollbar-has-backward-stepper: 1
    GtkScrollbar-stepper-size: 0

    engine "sugar" {
        hint: "vscrollbar-scrolled-window"
    }
}

style "scale"
{
    GtkWidget-focus-line-width: 0

    bg[NORMAL]: @button_grey

    # "square" slider (really round of course)
    # Same as indicator-size?
    GtkRange-slider-width: $scale_slider_width
    GtkScale-slider-length: $scale_slider_width
    GtkRange-trough-border: 0
    GtkRange-stepper-spacing: 0
    GtkRange-trough-side-details: 1
}

# hints for the trough sizing hacks
style "hscale": "scale"
{
    engine "sugar" {
        hint: "hscale"
    }
}

style "vscale": "scale"
{
    engine "sugar" {
        hint: "vscale"
    }
}

style "spinbutton"
{
    bg[NORMAL] : @button_grey
    bg[ACTIVE] : @white
    fg[NORMAL] : @white
    fg[ACTIVE] : @black

    ${ spin_ythickness = my_ceil(0.2 * (subcell_size*3.0/2.0 - thickness) + thickness) }
    ${ spin_xthickness = subcell_size }

    # small inner border and a large x/ythickness for entries
    # to reduce the number of hacks needed :-)
    xthickness: $spin_xthickness
    ythickness: $spin_ythickness
    GtkWidget-focus-line-width: 0

    # This tries to get a height of exactly 45 pixel for the entry.
    GtkEntry-inner-border: { $(max(subcell_size - spin_xthickness, 0)), $(max(subcell_size - spin_xthickness, 0)),
                               $(max(my_ceil((3*subcell_size - font_height - spin_ythickness*2)/2.0),0)), $(max(my_floor((3*subcell_size - font_height - spin_ythickness*2)/2.0), 0)) }

    engine "sugar" {
        hint: "spinbutton"
    }
}


style "frame"
{
    bg[NORMAL]: @toolbar_grey

    engine "sugar" {
        parent_bg_color: @toolbar_grey
        parent_fg_color: @white
    }
}

style "notebook-tab"
{
    bg[ACTIVE]: @button_grey
    fg[ACTIVE]: @white
}

style "notebook-panel"
{
    GtkNotebook-tab-overlap: -2
    GtkNotebook-tab-curvature: $default_padding
    
    xthickness: 0
    ythickness: 0
    
    bg[NORMAL]: @selection_grey
}

style "toolbox-notebook"
{
    GtkNotebook-tab-overlap: -2
    
    xthickness: 0
    ythickness: 0
}

style "toolbutton"
{
    xthickness: 0
    ythickness: 0
    GtkButton-inner-border: { $toolbutton_padding,
                                $toolbutton_padding,
                                $toolbutton_padding,
                                $toolbutton_padding }
    GtkWidget-focus-padding: 0

    bg[PRELIGHT]: @black
    bg[ACTIVE]: @button_grey
    bg[NORMAL]: @black

    fg[NORMAL]: @white
    fg[ACTIVE]: @white
    fg[PRELIGHT]: @white

    engine "sugar" {
        max_radius: 5.0
        fake_padding: $default_padding
    }
}

style "separatortoolbutton"
{
    # The sizing is handled in the engine.
    bg[NORMAL]: @button_grey
}

style "toolbar"
{
    xthickness: 0
    ythickness: 0

    bg[NORMAL]: @toolbar_grey
    bg[INSENSITIVE]: @toolbar_grey
    base[INSENSITIVE]: @toolbar_grey

    engine "sugar" {
        parent_fg_color: @white
        parent_bg_color: @toolbar_grey
    }
}

style "toolbox"
{
    fg[NORMAL]: @white
    fg[ACTIVE]: @white

    bg[NORMAL]: @toolbar_grey
    bg[INSENSITIVE]: @toolbar_grey
    base[INSENSITIVE]: @toolbar_grey

    engine "sugar" {
        parent_fg_color: @white
        parent_bg_color: @toolbar_grey
    }
}

style "panel"
{
    bg[NORMAL]: @panel_grey
    fg[NORMAL]: @black
}

style "entry"
{
    color["focus_line"]: @text_field_grey

    ${ entry_ythickness = my_ceil(0.2 * (subcell_size*3.0/2.0 - thickness) + thickness) }
    ${ entry_xthickness = my_ceil(0.32 * (subcell_size*3.0/2.0 - thickness) + thickness) }

    # small inner border and a large x/ythickness for entries
    # to reduce the number of hacks needed :-)
    xthickness: $entry_xthickness
    ythickness: $entry_ythickness
    GtkWidget-focus-line-width: 0

    # Colors for the progress bar.
    bg[SELECTED]: @selection_grey
    fg[SELECTED]: @black

    # This tries to get a height of exactly 45 pixel for the entry.
    GtkEntry-inner-border: { $(max(subcell_size - entry_xthickness, 0)), $(max(subcell_size - entry_xthickness, 0)),
                               $(max(my_ceil((3*subcell_size - font_height - entry_ythickness*2)/2.0),0)), $(max(my_floor((3*subcell_size - font_height - entry_ythickness*2)/2.0), 0)) }
}

style "button"
{
    ${ border = max(0, my_ceil((3*subcell_size/2.0 - icon_small / 2.0))) }
    # It would be nicer to just set the inner-border, but that does not work
    # for combo boxes ... The combobox ignores it, so set it to 0px
    # See http://bugzilla.gnome.org/show_bug.cgi?id:485762

    GtkButton-inner-border: { 0, 0, 0, 0 }

    # So set the x/ythickness; y-padding is $subcell_size overall
    xthickness: $(border)
    ythickness: $(border)


    fg[NORMAL]: @white
    fg[ACTIVE]: @black

    bg[NORMAL]: @button_grey
}

style "combobox"
{
    # "Disable" the ACTIVE state of the button, it only creates problems :-(
    bg[ACTIVE]: @button_grey
    fg[ACTIVE]: @white

    # Work around GTK+ bug #382646
    text[NORMAL]     : @white
    text[ACTIVE]     : @white
    text[PRELIGHT]   : @white
}

style "comboboxentry"
{
    # Copied from the "default" style. Part of the workaround for bug #382646.
    text[NORMAL]: @black
    text[ACTIVE]: @black
    text[SELECTED]: @black
    text[PRELIGHT]: @black

    # It just happens that the entry xthickness works good for the button,
    # which simplefies matters a bit.
    xthickness: $entry_xthickness

    engine "sugar" {
        hint: "comboboxentry"
    }
}

style "checkbutton"
{
    base[NORMAL]     : @white
    base[PRELIGHT]   : @white
    base[ACTIVE]     : @text_field_grey

    text[PRELIGHT]   : @toolbar_grey
    text[NORMAL]     : @toolbar_grey
    text[ACTIVE]     : @toolbar_grey

    # I won't get the exact sizing, but this should be pretty close
    GtkCheckButton-indicator-size: $radio_size
    GtkCheckButton-indicator-spacing: 3
    GtkWidget-focus-padding: 3

    engine "sugar" {
        # Reset the colors to the normal color again
        # as they were overriden by the button style
        fg[NORMAL]       : parent_fg_color
        fg[PRELIGHT]     : parent_fg_color
        fg[ACTIVE]       : parent_fg_color
    }
}

style "progressbar"
{
    # text[PRELIGHT] is used for the bar in the sugar engine
    text[PRELIGHT]: @white

    # Text on top of the bar
    fg[PRELIGHT]: @black
    xthickness: $thickness
    ythickness: $thickness

    engine "sugar" {
        # Someone seems to have decided, that the background fill of a progress
        # bar should be done with bg[ACTIVE].
        bg[ACTIVE]: parent_bg_color

        # Color to fill the progress bar ("transparent" usually, except for the
        # white background case)
        bg[NORMAL]: parent_bg_color
        fg[NORMAL]: parent_fg_color
    }
}

style "progressbar-on-white" {
    bg[NORMAL]: @panel_grey
    fg[NORMAL]: @black
}

style "menuitem"
{
    GtkMenuItem-horizontal-padding: 0
    GtkMenuItem-arrow-spacing: $subcell_size
    GtkMenuItem-toggle-spacing: $subcell_size

    bg[PRELIGHT]: @button_grey

    # Work around bug #382646
    text[PRELIGHT]   : @white
    text[NORMAL]     : @white
    text[ACTIVE]     : @white

    xthickness: $subcell_size
    ythickness: $((subcell_size * 3 - font_height) / 2)
}

style "checkmenuitem"
{
    GtkCheckMenuItem-indicator-size: $radio_size
    GtkMenuItem-toggle-spacing: $(subcell_size * 2 / 3)

    ythickness: $((subcell_size * 3 - max(font_height, subcell_size * 2 / 3)) / 2)

    # This is only there because of bug #382646 ...
    base[NORMAL]     : @white
    base[PRELIGHT]   : @white
    base[ACTIVE]     : @text_field_grey

    text[PRELIGHT]   : @toolbar_grey
    text[NORMAL]     : @toolbar_grey
    text[ACTIVE]     : @toolbar_grey
}

style "imagemenuitem"
{
    # Assume a $(icon_small)px image and height of $(4*subcell_size)
    ythickness: $(max(0, (3*subcell_size - icon_small) / 2))
}

style "separatormenuitem"
{
    GtkWidget-wide-separators: 1
    GtkWidget-separator-height: $(2*subcell_size)

    ythickness: 0
    xthickness: 0
}

style "trayicon"
{
    bg[PRELIGHT]: @black
    bg[ACTIVE]: @button_grey
}

style "parent-bg"
{
    engine "sugar" {
        bg[NORMAL]: parent_bg_color
        bg[INSENSITIVE]: parent_bg_color
    }
}

####################################################################
# Default style, setting some generic options and style properties
####################################################################
class "GtkWidget" style "default"


####################################################################
# Styles that apply the different background (and foreground) colors
####################################################################

# This one should probably be the default (ie. no window-child style)
widget_class "<GtkWindow>"               style "window"
widget_class "<GtkWindow>*"              style "window-child"

widget_class "*<SugarAlert>"               style "black-bg"
widget_class "*<SugarAlert>*"              style "black-bg-child"

widget_class "*<SugarSectionView>"       style "white-bg"
widget_class "*<SugarSectionView>*"      style "white-bg-child"


# The notebook is very high, so that everything is overriden
# Only the color of the tab labels needs to be modified inside the
# notebooks in this style (and the widget itself).
# Assume that there is either just a normal label in the notebook tab, or
# it is inside a GtkBox (H- or VBox) together with eg. a close button.
widget_class "*<GtkNotebook>"                        style "notebook-tab"
widget_class "*<GtkNotebook>.<GtkLabel>"             style "notebook-tab"
widget_class "*<GtkNotebook>.<GtkBox>.<GtkLabel>"    style "notebook-tab"


# SugarPalette and Menu
widget_class "*<GtkMenu>"               style "menu"
widget_class "<SugarPaletteWindow>"           style "palette"
widget_class "<SugarPaletteWindow>.*"         style "menu-child"
widget_class "<SugarPaletteWindow>*<GtkMenu>" style "palette-menu"
widget_class "*<GtkMenuShell>.*"        style "menu-child"

# SugarFrameWindow
widget_class "*<SugarFrameWindow>*"    style "frame"

# SugarPanel
widget_class "*<SugarPanel>*"          style "panel"


# GroupBoxes (don't set bg[NORMAL] on the widget itself)
widget_class "<GtkWindow>*<SugarGroupBox>*"   style "groupbox-panel-child"

widget_class "<GtkWindow>*<GtkNotebook>*"   style "groupbox-panel-child"
widget_class "<GtkWindow>*<GtkNotebook>"    style "notebook-panel"


widget_class "<SugarPaletteWindow>*<SugarGroupBox>*"   style "groupbox-palette-child"


# SugarToolbox
#widget_class "*<SugarToolbox>" style "toolbox"
#widget_class "*<SugarToolbox>*" style "toolbox-child"
#widget_class "*<SugarToolbox>*<GtkEventBox>" style "toolbox"
#widget_class "*<SugarToolbox>*<GtkLayout>"   style "toolbox"
widget_class "*<SugarToolbox>*"        style "toolbox"
widget_class "*<GtkToolbar>*"          style "toolbox"
widget_class "*<SugarToolbox>.<GtkNotebook>" style "toolbox-notebook"


####################################################################
# Normal widget styles, using the above things
####################################################################
# The following only uses widget_class matches to get the priority
# right. An alternative would be to lower the priority of the
# background matches (which need widget_class) to eg. "application"

widget_class "*<GtkMenuItem>*"            style "menuitem"
widget_class "*<GtkCheckMenuItem>"        style "checkmenuitem"
widget_class "*<GtkImageMenuItem>"        style "imagemenuitem"
widget_class "*<GtkSeparatorMenuItem>*"   style "separatormenuitem"

# Buttons and Combos
widget_class "*<GtkButton>*"           style "button"
widget_class "*<GtkCheckButton>*"      style "checkbutton"
widget_class "*<GtkComboBox>*"         style "combobox"
widget_class "*<GtkComboBoxEntry>*"    style "comboboxentry"
widget_class "*<GtkCombo>*"            style "comboboxentry"

# Entries
widget_class "*<GtkEntry>"       style "entry"
widget_class "*<GtkSpinButton>"  style "spinbutton"
widget_class "*<GtkTextView>"    style "textview"


# Misc widgets
widget_class "*<GtkHScrollbar>"  style "hscrollbar"
widget_class "*<GtkVScrollbar>"  style "vscrollbar"
widget_class "*<GtkHScale>"      style "hscale"
widget_class "*<GtkVScale>"      style "vscale"
widget_class "*<GtkProgressBar>" style "progressbar"

widget_class "*<SugarSectionView>*<GtkProgress>"  style "progressbar-on-white"


# Scrolled window scrollbars
widget_class "*<GtkScrolledWindow>.<GtkVScrollbar>" style "vscrollbar-scrolled-window"
widget_class "*<GtkScrolledWindow>.<GtkHScrollbar>" style "hscrollbar-scrolled-window"

# Toolbar
widget_class "*<GtkToolButton>*"          style "toolbutton"
widget_class "*<SugarColorToolButton>*"   style "toolbutton"
widget_class "*<GtkSeparatorToolItem>*"   style "separatortoolbutton"
widget_class "*<GtkToolbar>"              style "toolbar"

# Tray
widget_class "*<SugarTrayIcon>*" style "trayicon"

# Widgets that should get the background color from the parent
widget_class "*<GtkEventBox>"        style "parent-bg"
widget_class "*<GtkLayout>"          style "parent-bg"
widget_class "*<GtkViewport>"        style "parent-bg"
widget_class "*<GtkDrawingArea>"     style "parent-bg"
widget_class "*<GtkScrolledWindow>"  style "parent-bg"

*/
