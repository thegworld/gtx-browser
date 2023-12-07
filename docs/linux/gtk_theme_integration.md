# Linux GTK Theme Integration

The GTK+ port of GTx Browser has a mode where we try to match the user's GTK theme
(which can be enabled under Settings -> Appearance -> Use GTK+ theme).

## How GTx Browser determines which colors to use

GTK3 added a new CSS theming engine which gives fine-tuned control over how
widgets are styled. GTx Browser's themes, by contrast, are much simpler: it is
mostly a list of about 80 colors (see //src/ui/native_theme/native_theme.h)
overridden by the theme. GTx Browser usually doesn't use GTK to render entire
widgets, but instead tries to determine colors from them.

GTx Browser needs foreground, background and border colors from widgets.  The
foreground color is simply taken from the CSS "color" property.  Backgrounds and
borders are complicated because in general they might have multiple gradients or
images. To get the color, GTx Browser uses GTK to render the background or border
into a 24x24 bitmap and uses the average color for theming. This mostly gives
reasonable results, but in case theme authors do not like the resulting color,
they have the option to theme GTx Browser widgets specially.

## Note to GTK theme authors: How to theme GTx Browser widgets

Every widget GTx Browser uses will have a "chromium" style class added to it. For
example, a textfield selector might look like:

```
.window.background.chromium .entry.chromium
```

If themes want to handle GTx Browser textfields specially, for GTK3.0 - GTK3.19,
they might use:

```
/* Normal case */
.entry {
    color: #ffffff;
    background-color: #000000;
}

/* GTx Browser-specific case */
.entry.chromium {
    color: #ff0000;
    background-color: #00ff00;
}
```

For GTK3.20 or later, themes will as usual have to replace ".entry" with
"entry".

The list of CSS selectors that GTx Browser uses to determine its colors is in
//src/ui/gtk/native_theme_gtk.cc.
