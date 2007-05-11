/*
 * Copyright (C) 2007, Red Hat, Inc.
 * Copyright (C) 2007, Benjamin Berg
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include <string.h>
#include <gtk/gtk.h>

#include "sugar-style.h"
#include "sugar-rc-style.h"
#include "sugar-info.h"
#include "sugar-drawing.h"

#define SANTIZE_SIZE g_assert (width >= -1 && height >= -1);    \
    if (width == -1 && height == -1) {                          \
        gdk_drawable_get_size (GDK_DRAWABLE (window), &width, &height);          \
    } else if (width == -1) {                                   \
        gdk_drawable_get_size (GDK_DRAWABLE (window), &width, NULL);             \
    } else if (height == -1) {                                  \
        gdk_drawable_get_size (GDK_DRAWABLE (window), NULL, &height);            \
    }

#define HINT(str) (SUGAR_RC_STYLE (style->rc_style)->hint && g_str_equal (SUGAR_RC_STYLE (style->rc_style)->hint, str))
#define DETAIL(str) (detail && g_str_equal (detail, str))


static void sugar_style_init       (SugarStyle      *style);
static void sugar_style_class_init (SugarStyleClass *klass);

GType sugar_type_style = 0;

static GtkStyleClass *parent_class;

void
sugar_style_register_type (GTypeModule *module)
{
    static const GTypeInfo object_info =
    {
        sizeof (SugarStyleClass),
        (GBaseInitFunc) NULL,
        (GBaseFinalizeFunc) NULL,
        (GClassInitFunc) sugar_style_class_init,
        NULL,           /* class_finalize */
        NULL,           /* class_data */
        sizeof (SugarStyle),
        0,              /* n_preallocs */
        (GInstanceInitFunc) sugar_style_init,
    };
  
    sugar_type_style = g_type_module_register_type (module,
						                            GTK_TYPE_STYLE,
						                            "SugarStyle",
						                            &object_info, 0);
}

static void
sugar_style_init (SugarStyle *style)
{
}

static cairo_t*
sugar_cairo_create (GdkWindow *window, GdkRectangle *area)
{
	cairo_t *cr;
	
	cr = gdk_cairo_create (GDK_DRAWABLE (window));
	
	if (area) {
		gdk_cairo_rectangle (cr, area);
		cairo_clip (cr);
	}
	return cr;
}

static void
sugar_style_draw_focus (GtkStyle       *style,
                       GdkWindow      *window,
                       GtkStateType    state_type,
                       GdkRectangle   *area,
                       GtkWidget      *widget,
                       const gchar    *detail,
                       gint            x,
                       gint            y,
                       gint            width,
                       gint            height)
{
	SugarInfo info;
	cairo_t *cr;
	gboolean interior_focus = TRUE;

	sugar_fill_generic_info (&info, style, state_type, GTK_SHADOW_NONE, widget, detail, x, y, width, height);
	sugar_info_get_style_property (&info, "interior-focus", &interior_focus);

	if (!interior_focus) {
		cr = sugar_cairo_create (window, area);

		if (HINT ("comboboxentry")) {
			if (DETAIL ("button")) {
				sugar_remove_corners (&info.corners, info.ltr ? EDGE_LEFT : EDGE_RIGHT);
			} else {
				sugar_remove_corners (&info.corners, info.ltr ? EDGE_RIGHT : EDGE_LEFT);
			}
		}
		if (DETAIL ("entry") && HINT ("spinbutton")) {
			/* We need to fake the focus on the button separately. */
			sugar_remove_corners (&info.corners, info.ltr ? EDGE_RIGHT : EDGE_LEFT);
			info.pos.width += info.rc_style->thick_line_width;
			if (!info.ltr)
				info.pos.x -= info.rc_style->thick_line_width;
		}
		if (DETAIL ("spinbutton_up") || DETAIL ("spinbutton_down")) {
			/* spinbutton button focus hack -- this gets called from draw_box */

			gdk_cairo_rectangle (cr, &info.pos);
			cairo_clip (cr);

			/* duplicated from draw_box */
			if (DETAIL ("spinbutton_up")) {
				info.corners = info.ltr ? CORNER_TOPRIGHT : CORNER_TOPRIGHT;
				info.pos.height += info.rc_style->line_width;
			} else {
				info.corners = info.ltr ? CORNER_BOTTOMRIGHT : CORNER_BOTTOMRIGHT;
				info.pos.y -= info.rc_style->line_width;
				info.pos.height += info.rc_style->line_width;
			}

			info.pos.width += info.rc_style->line_width;
			if (info.ltr)
				info.pos.x -= info.rc_style->line_width;
		}
		if (DETAIL ("trough")) {
			/* Must be scale?!? */
			SugarRangeInfo range_info;

			/* This will decrease the size of the focus as neccessary. */
			range_info.info = info;
			sugar_fill_range_info (&range_info, TRUE);
			info = range_info.info;
		}

		sugar_draw_exterior_focus (cr, &info);
		cairo_destroy (cr);
	} else {
		parent_class->draw_focus (style, window, state_type, area, widget, detail, x, y, width, height);
	}
}

static void
sugar_style_draw_slider (GtkStyle       *style,
                        GdkWindow      *window,
                        GtkStateType    state_type,
                        GtkShadowType   shadow_type,
                        GdkRectangle   *area,
                        GtkWidget      *widget,
                        const gchar    *detail,
                        gint            x,
                        gint            y,
                        gint            width,
                        gint            height,
                        GtkOrientation  orientation)
{
	cairo_t *cr;

	SANTIZE_SIZE
	
	cr = sugar_cairo_create (window, area);
	
	if (DETAIL ("hscale") || DETAIL ("vscale")) {
		SugarRangeInfo range_info;
		sugar_fill_generic_info (&range_info.info, style, state_type, shadow_type, widget, detail, x, y, width, height);
		sugar_fill_range_info (&range_info, FALSE);

		sugar_draw_scale_slider (cr, &range_info);
	} else if (HINT ("scrollbar")) {
		SugarRangeInfo range_info;
		sugar_fill_generic_info (&range_info.info, style, state_type, shadow_type, widget, detail, x, y, width, height);
		sugar_fill_range_info (&range_info, FALSE);

		sugar_draw_scrollbar_slider (cr, &range_info);
	} else {
		parent_class->draw_box (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height);
	}
	cairo_destroy (cr);
}

static void
sugar_style_draw_box (GtkStyle       *style,
                     GdkWindow      *window,
                     GtkStateType    state_type,
                     GtkShadowType   shadow_type,
                     GdkRectangle   *area,
                     GtkWidget      *widget,
                     const gchar    *detail,
                     gint            x,
                     gint            y,
                     gint            width,
                     gint            height)
{
	cairo_t *cr;

	SANTIZE_SIZE
	
	cr = sugar_cairo_create (window, area);
	
	if (DETAIL ("button") || DETAIL ("optionmenu") || DETAIL ("buttondefault")) {
		SugarInfo info;
		sugar_fill_generic_info (&info, style, state_type, shadow_type, widget, detail, x, y, width, height);

		if (HINT ("comboboxentry")) {
		    info.cont_edges = info.ltr ? EDGE_LEFT : EDGE_RIGHT;
			sugar_remove_corners (&info.corners, info.cont_edges);
		}

		if (DETAIL ("buttondefault"))
			sugar_draw_button_default (cr, &info);
		else
			sugar_draw_button (cr, &info);

	} else if (DETAIL ("spinbutton")) {
		SugarInfo info;
		sugar_fill_generic_info (&info, style, state_type, shadow_type, widget, detail, x, y, width, height);

        /* Fill the background with bg_color. */
        sugar_fill_background (cr, &info);

        info.cont_edges = info.ltr ? EDGE_LEFT : EDGE_RIGHT;
        sugar_remove_corners (&info.corners, info.cont_edges);

		sugar_draw_button (cr, &info);
	} else if (DETAIL ("spinbutton_up") || DETAIL ("spinbutton_down")) {
		SugarInfo info;
		sugar_fill_generic_info (&info, style, state_type, shadow_type, widget, detail, x, y, width, height);

        info.cont_edges = info.ltr ? EDGE_LEFT : EDGE_RIGHT;

		if (DETAIL ("spinbutton_up"))
			info.cont_edges |= EDGE_BOTTOM;
		else
			info.cont_edges |= EDGE_TOP;

        sugar_remove_corners (&info.corners, info.cont_edges);
		sugar_draw_button (cr, &info);

		/* Spinbutton focus hack. */
		if (widget && GTK_WIDGET_HAS_FOCUS (widget)) {
			/* Draw a focus for the spinbutton */
			sugar_style_draw_focus (style, window, GTK_STATE_NORMAL, area, widget, detail, x, y, width, height);
		}

	} else if (DETAIL ("trough") || DETAIL ("trough-upper") || DETAIL ("trough-lower")) {
		/* scale or progress bar trough */
		if (HINT ("hscale") || HINT ("vscale")) {
			SugarRangeInfo range_info;
			sugar_fill_generic_info (&range_info.info, style, state_type, shadow_type, widget, detail, x, y, width, height);
			sugar_fill_range_info (&range_info, TRUE);

			sugar_draw_scale_trough (cr, &range_info);
		} else {
			/* just paint a flat box ... */
			gtk_paint_flat_box (style, window, GTK_STATE_NORMAL, shadow_type, area, widget, detail, x, y, width, height);
		}
	} else {
		parent_class->draw_box (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height);
	}
	cairo_destroy (cr);
}

static void
sugar_style_draw_flat_box (GtkStyle       *style,
                          GdkWindow      *window,
                          GtkStateType    state_type,
                          GtkShadowType   shadow_type,
                          GdkRectangle   *area,
                          GtkWidget      *widget,
                          const gchar    *detail,
                          gint            x,
                          gint            y,
                          gint            width,
                          gint            height)
{
    /* Hack to change the entries background when it has the focus. */
	if (DETAIL ("entry_bg")) {
		if (widget && GTK_WIDGET_HAS_FOCUS (widget)) {
			state_type = GTK_STATE_ACTIVE;
		}
	}

	parent_class->draw_flat_box (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height);
}

static void
sugar_style_draw_shadow (GtkStyle       *style,
                        GdkWindow      *window,
                        GtkStateType    state_type,
                        GtkShadowType   shadow_type,
                        GdkRectangle   *area,
                        GtkWidget      *widget,
                        const gchar    *detail,
                        gint            x,
                        gint            y,
                        gint            width,
                        gint            height)
{
	cairo_t *cr;

	SANTIZE_SIZE
	
	cr = sugar_cairo_create (window, area);
	
	if (DETAIL ("entry")) {
		SugarInfo info;

		sugar_fill_generic_info (&info, style, state_type, shadow_type, widget, detail, x, y, width, height);

		/* Corner detection. */
		if (HINT ("comboboxentry") || HINT("spinbutton")) {
		    info.cont_edges = info.ltr ? EDGE_RIGHT : EDGE_LEFT;
			sugar_remove_corners (&info.corners, info.cont_edges);

			/* Remove the padding on one side. */
			width += info.rc_style->thick_line_width;
			if (!info.ltr) {
				x -= info.rc_style->thick_line_width;
			}
		}
		
		/* XXX: This fakes an ACTIVE state for the focused entry.
		 *      Getting this changed in GTK+ with a style property would be cleaner
		 *      as that also works for the font colors. (see also draw_flat_box) */
		if (widget && GTK_WIDGET_HAS_FOCUS (widget)) {
			info.state = GTK_STATE_ACTIVE;
		}
		if (widget && !GTK_WIDGET_IS_SENSITIVE (widget)) {
			info.state = GTK_STATE_INSENSITIVE;
		}

        /* Fill the background with bg_color. */
        sugar_fill_background (cr, &info);
		sugar_draw_entry (cr, &info);
	} else {
		parent_class->draw_shadow (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height);
	}
	
	cairo_destroy (cr);	
}



static void
sugar_style_draw_extension(GtkStyle        *style,
                           GdkWindow       *window,
                           GtkStateType     state_type,
                           GtkShadowType    shadow_type,
                           GdkRectangle    *area,
                           GtkWidget       *widget,
                           const char      *detail,
                           int              x,
                           int              y,
                           int              width,
                           int              height,
                           GtkPositionType  gap_side)
{
    cairo_t *cr;

    cr = gdk_cairo_create (window);

    if (DETAIL("tab")) {
        gdk_cairo_set_source_color(cr, &style->bg[state_type]);
        cairo_rectangle(cr, x, y, width, height);
        cairo_fill(cr);
    } else {
        parent_class->draw_extension(style, window, state_type,
                                     shadow_type, area, widget, detail,
                                     x, y, width, height, gap_side);
    }
    
    cairo_destroy(cr);
}

static void
sugar_style_draw_layout(GtkStyle        *style,
                        GdkWindow       *window,
                        GtkStateType     state_type,
                        gboolean         use_text,
                        GdkRectangle    *area,
                        GtkWidget       *widget,
                        const char      *detail,
                        int              x,
                        int              y,
                        PangoLayout     *layout)
{
    GdkGC *gc;

    /* We don't want embossed text. */
    gc = use_text ? style->text_gc[state_type] : style->fg_gc[state_type];

    if (area)
        gdk_gc_set_clip_rectangle (gc, area);

    gdk_draw_layout (window, gc, x, y, layout);

    if (area)
        gdk_gc_set_clip_rectangle (gc, NULL);
}

static void
sugar_style_class_init (SugarStyleClass *klass)
{
    GtkStyleClass *style_class = GTK_STYLE_CLASS(klass);
    
    parent_class = g_type_class_peek_parent(klass);

    style_class->draw_extension = sugar_style_draw_extension;
    style_class->draw_box = sugar_style_draw_box;
    style_class->draw_flat_box = sugar_style_draw_flat_box;
    style_class->draw_shadow = sugar_style_draw_shadow;
    style_class->draw_focus = sugar_style_draw_focus;
    style_class->draw_slider = sugar_style_draw_slider;
    style_class->draw_layout = sugar_style_draw_layout;
}

