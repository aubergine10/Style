# Style

This mod provides several APIs that make defining LuaGuiElement style prototypes much, much easier. To use it in your project, simply add the mod as a dependency in your `info.json`. See the wiki for [full documentation](https://github.com/aubergine10/Style/wiki).

> The library motto is: _"Concise is nice! Semantic is fantastic!"_

The goal is to drastically reduce verbosity of style definitions (and associated things like images, sound, keyboard shortcuts, etc), with a strong focus on making stlesheets much easier to reason about via a consistent, semantic syntax.

## Comparison

Here's an example frame style sheet, using the Style API:

```lua
image.path = '__MyMod__/graphics'

style.frame 'example_frame' {
  padding    = {0,6,3,0};
  autoSize   = true;
  background = image.composite 'toolbar.png' { corner = 3 };
  title      = { padding = 0, color = color '#F00' };
  flow       = { padding = 0, spacing = 0, autoSize = true, maxOnRow = 0 };
}

-- the frame style will be converted to raw prototype format (see below)
```

The exact same thing, written without the API (raw prototype format used in vanilla Factorio styles):

```lua
data.raw['gui-style'].default['example-frame'] = {
  top_padding = 0,
  right_padding = 6,
  bottom_padding = 3,
  left_padding = 0,
  resize_row_to_width = true,
  resize_to_row_height = true,
  title_top_padding = 0,
  title_right_padding = 0,
  title_bottom_padding = 0,
  title_left_padding = 0,
  font_color = color '#F00',
  graphical_set = {
    type = 'composition',
    filename = '__MyMod__/graphics/toolbar.png',
    position = { 0, 0 },
    corner = { 3, 3 },
    priority = 'extra-high-no-scale',
  },
  flow_style = {
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    horizontal_spacing = 0,
    vertical_spacing = 0,
    resize_row_to_width = true,
    resize_to_row_height = true,
    max_on_row = 0,
  }
}
```

See the difference?
