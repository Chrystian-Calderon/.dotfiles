-- custom monitor configuration
hl.monitor({
  output = "eDP-1",
  mode = "1366x768@60Hz",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "1024x768@60Hz",
  position = "1366x0",
  scale = 1,
})

-- monitors are automatically configured by default, but you can specify them manually like this. The format is:
-- hl.monitor({
--     output   = "",
--     mode     = "preferred",
--     position = "auto",
--     scale    = "auto",
-- })