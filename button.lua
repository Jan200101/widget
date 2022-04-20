--
-- Button Widget.
-- @copyright Jefferson Gonzalez
-- @license MIT
--

local style = require "core.style"
local Widget = require "widget"

---@class widget.button.icon
---@field public code string
---@field public color renderer.color
---@field public hover_color renderer.color
local ButtonIcon = {}

---@class widget.button : widget
---@field public padding widget.position
---@field public icon widget.button.icon
---@field public expanded boolean
local Button = Widget:extend()

function Button:new(parent, label)
  Button.super.new(self, parent)

  self.icon = {
    code = nil, color = nil, hover_color = nil
  }

  self.padding = {
    x = style.padding.x,
    y = style.padding.y
  }

  self.expanded = false

  self:set_label(label or "")
end

---When set to true the button width will be the same as parent
---@param expand? boolean | nil
function Button:toggle_expand(expand)
  if type(expand) == "boolean" then
    self.expanded = expand
  else
    self.expanded = not self.expanded
  end
end

function Button:set_icon(code, color, hover_color)
  self.icon.code = code
  self.icon.color = color
  self.icon.hover_color = hover_color

  self:set_label(self.label)
end

function Button:set_label(text)
  Button.super.set_label(self, text)

  if self.expanded and self.parent then
    self.size.x = self.parent.size.x - self.position.rx
  else
    self.size.x = self.font:get_width(self.label) + (self.padding.x * 2)
  end

  self.size.y = self.font:get_height() + (self.padding.y * 2)

  if self.icon.code then
    local icon_w = style.icon_font:get_width(self.icon.code)
      + (self.padding.x / 2)

    local icon_h = style.icon_font:get_height() + (self.padding.y * 2)

    self.size.x = self.size.x + icon_w
    self.size.y = math.max(self.size.y, icon_h)
  end
end

function Button:on_mouse_enter(...)
  Button.super.on_mouse_enter(self, ...)
  self.hover_text = style.accent
  self.hover_back = style.dim
end

function Button:on_mouse_leave(...)
  Button.super.on_mouse_leave(self, ...)
  self.hover_text = nil
  self.hover_back = nil
end

function Button:update()
  if not Button.super.update(self) then return false end

  -- update size
  self:set_label(self.label)

  return true
end

function Button:draw()
  self.background_color = self.hover_back or style.background

  if not Button.super.draw(self) then return false end

  local offsetx = self.position.x + self.padding.x
  local offsety = self.position.y + self.padding.y

  if self.icon.code then
    local normal = self.icon.color or style.text
    local hover = self.icon.hover_color or style.accent
    renderer.draw_text(
      style.icon_font,
      self.icon.code,
      offsetx,
      offsety,
      self.hover_text and hover or normal
    )
    offsetx = offsetx + style.icon_font:get_width(self.icon.code) + (style.padding.x / 2)
  end

  renderer.draw_text(
    self.font,
    self.label,
    offsetx,
    offsety,
    self.hover_text or self.foreground_color or style.text
  )

  return true
end


return Button
