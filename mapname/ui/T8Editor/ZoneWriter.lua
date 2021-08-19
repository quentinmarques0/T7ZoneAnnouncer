--[[
  	Zone Writer Widget By QuentinFTL v2.0

    This update allow you to use new animations, actually, 9 animations can be setup (see Animations List table).

    first add the widget to your require:
      require("ui.T8Editor.ZoneWriter")
    and into your zone file:
      rawfile,ui/T8Editor/ZoneWriter.lua

    next into your HUD:

    add the widget with newPreset to setup it without getting confused with all methods
    but you can use methods after initiating it.

    Example:
      local ZA = CoD.ZoneWriter.newPreset(HudRef, InstanceRef, "BottomBack")
      ZA:setFont("black_ops_4")

      HudRef:addElement(ZA)

    In this Example I use the "BottomBack" Animation, and I set the font just after the instance

    I give you another example if you want to change the position for an animation with
    the positions of other animations.

    Example:
      local ZA = CoD.ZoneWriter.newPreset(HudRef, InstanceRef, "BottomBack")
      ZA:setFont("black_ops_4")

      ZA:useLeftRight("BlackOps4")

      HudRef:addElement(ZA)

    Now the Text will be bottom left of your screen. I let you try with the other animations !
    PS: I let you see all the methods in the Methods Table !


    -------------------
    |  Constructors   |
    -------------------
    |       new       |
    |    newPreset    |
    -------------------

    -------------------
    |  Methods  List  |
    -------------------
    |    setAlign     |
    |    setFadeIn    |
    |    setFadeOut   |
    |  setFreezeTime  |
    |     setFont     |
    |    useFadeOut   |
    |setLocalLeftRight|
    |setLocalTopBottom|
    |     doAnim      |
    |    fixHeight    |
    |  useAlignment   |
    |  useLeftRight   |
    |  useTopBottom   |
    -------------------

    +-----------------+---------------------------------+
    | Animations List | Location (LeftRight, TopBottom) |
    +-----------------+---------------------------------+
    |   LeftRight     |     E (Center, Middle)          |
    |   RightLeft     |     E (Center, Middle)          |
    |   TopBottom     |     E (Center, Middle)          |
    |   BottomTop     |     E (Center, Middle)          |
    |   LeftBack      |     D (Left, Middle)            |
    |   RightBack     |     F (Right, Middle)           |
    |   TopBack       |     B (Center, Top)             |
    |   BottomBack    |     H (Center, Bottom)          |
    |   BlackOps4     |     A (Left, Top)               |
    |     None        |     B (Center, Top)             |
    |   RotateZoom    |     E (Center, Middle)          |
    +-----------------+---------------------------------+


    Now if you want to have your text in the 'G' case, you can combine:
      ZA:useLeftRight("LeftBack")
      ZA:useTopBottom("BottomBack")

    so Horizontal value of "LeftBack" (D) + VerticalValue of "BottomBack" (H) = G



    Screen:

    +------------------------+
    |   A   |   B   |   C   |
    +------------------------+
    |   D   |   E   |   F   |
    +------------------------+
    |   G   |  H    |   I   |
    +------------------------+
]]

CoD.ZoneWriter         = InheritFrom(LUI.UIElement)

local debug = {
  execute = function(arg)
    if winOs then
      if prefix then
        winOs.execute(prefix .. " " .. arg)
      end
    end
  end
}
--[[
LUI.Alignment{
  Align Horz : Left   Center    Right
  Align Vert : Top    Middle    Bottom
  Align Unset: None
}
]]
CoD.ZoneWriter.setAlign = function(element, align)
  debug.execute("[ZoneWriter]: setAlign(".. align ..")")

  element.Item:setAlignment(LUI.Alignment[align])
end

CoD.ZoneWriter.setFadeIn = function(element, fIn)
  debug.execute("[ZoneWriter]: setFadeIn(".. fIn ..")")
  element.fadeIn = fIn
end

CoD.ZoneWriter.getFadeIn = function(element)
  return element.fadeIn
end

CoD.ZoneWriter.setFadeOut = function(element, fOut)
  debug.execute("[ZoneWriter]: setFadeOut(".. fOut ..")")
  element.fadeOut = fOut
end

CoD.ZoneWriter.getFadeOut = function(element)
  return element.fadeOut
end

CoD.ZoneWriter.setFreezeTime = function(element, fTime)
  debug.execute("[ZoneWriter]: setFreezeTime(".. fTime ..")")

  element.freezeTime = fTime
end

CoD.ZoneWriter.getFreezeTime = function(element)
  return element.freezeTime
end

CoD.ZoneWriter.setFont = function(element, font)
  debug.execute("[ZoneWriter]: setFont(".. font ..")")

  element.font = font
  element.Item:setTTF("fonts/".. font ..".ttf")
end

CoD.ZoneWriter.getFont = function(element)
  return element.font
end

CoD.ZoneWriter.useFadeOut = function(element, fOutDo)
  element.doFadeOut = fOutDo

  debug.execute("[ZoneWriter]: useFadeOut(".. tostring(fOutDo) ..")")
end

CoD.ZoneWriter.getElementLeftRight = function(element)
  local a = element.positions.locLeftRight.leftAnchor
  local b = element.positions.locLeftRight.rightAnchor
  local c = element.positions.locLeftRight.left
  local d = element.positions.locLeftRight.right

  return a, b, c, d
end

CoD.ZoneWriter.getElementTopBottom = function(element)
  local a = element.positions.locTopBottom.topAnchor
  local b = element.positions.locTopBottom.botAnchor
  local c = element.positions.locTopBottom.top
  local d = element.positions.locTopBottom.bot

  return a, b, c, d
end

CoD.ZoneWriter.setLocalLeftRight = function(element, a, b, c, d)
  element.positions.locLeftRight.leftAnchor = a
  element.positions.locLeftRight.rightAnchor = b
  element.positions.locLeftRight.left = c
  element.positions.locLeftRight.right = d
  element:setLeftRight(a,b,c,d)

  debug.execute("[ZoneWriter]: setLocalLeftRight("..tostring(a)..", "..tostring(b)..", ".. tostring(c) ..", ".. tostring(d) .. ")")
end

CoD.ZoneWriter.setLocalTopBottom = function(element, a, b, c, d)
  element.positions.locTopBottom.topAnchor = a
  element.positions.locTopBottom.botAnchor = b
  element.positions.locTopBottom.top = c
  element.positions.locTopBottom.bot = d
  element:setTopBottom(a,b,c,d)

  debug.execute("[ZoneWriter]: setLocalTopBottom("..tostring(a)..", "..tostring(b)..", ".. tostring(c) ..", ".. tostring(d) .. ")")
end

CoD.ZoneWriter.doAnim = function(element, fnAnim)
  element.animation = fnAnim
end

CoD.ZoneWriter.fixHeight = function(element, fH)
  element.textHeight = fH
end

CoD.ZoneWriter.Animations = {
  RotateZoom   =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setZRot(0)
          Elem:setScale(0)
          -- Elem:setLeftRight(false, true, 0, 640)
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          -- Elem:setLeftRight(true, false, -640, 0)
          Elem:setScale(0)
          Elem:setZRot(0*5)


          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          -- Elem:setLeftRight(Elem:getElementLeftRight())
          Elem:setZRot(360*5)
          Elem:setScale(1)
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  LeftRight   =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setLeftRight(false, true, 0, 640)
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          Elem:setLeftRight(true, false, -640, 0)

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          Elem:setLeftRight(Elem:getElementLeftRight())
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  RightLeft   =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setLeftRight(true, false, -640, 0)
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          Elem:setLeftRight(false, true, 0, 640)

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          Elem:setLeftRight(Elem:getElementLeftRight())
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  TopBottom   =  function(HudRef, InstanceRef, Elem, Item, ModelRef)

      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setTopBottom(false, true, (320-Elem.textHeight), 320)
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          Elem:setTopBottom(true, false, -320, (-320+Elem.textHeight))

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          Elem:setTopBottom(Elem:getElementTopBottom())
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  BottomTop   =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setTopBottom(true, false, -320, (-320+Elem.textHeight))
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          Elem:setTopBottom(false, true, (320-Elem.textHeight), 320)

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          Elem:setTopBottom(Elem:getElementTopBottom())
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  LeftBack    =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setLeftRight(true, false, -640, 0)
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          Elem:setLeftRight(true, false, -640, 0)

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          Elem:setLeftRight(Elem:getElementLeftRight())
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  RightBack   =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setLeftRight(false, true, 0, 640)
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          Elem:setLeftRight(false, true, 0, 640)

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          Elem:setLeftRight(Elem:getElementLeftRight())
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  TopBack     =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setTopBottom(true, false, -320, (-320+Elem.textHeight))
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          Elem:setTopBottom(true, false, -320, -320 + Elem.textHeight)

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          Elem:setTopBottom(Elem:getElementTopBottom())
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  BottomBack  =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
          Elem:setTopBottom(false, true, (320-Elem.textHeight), 320)
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          --Set the text pos outside screen
          Elem:setTopBottom(false, true, (320-Elem.textHeight), 320)

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Elem:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          Elem:setTopBottom(Elem:getElementTopBottom())
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  BlackOps4   =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
      local function HideItem( ModelRef )
          Item:setAlpha(1)
          Item:beginAnimation("keyframe", Elem.fadeOut * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(0)
      end
      local value = Engine.GetModelValue(ModelRef)

      --player Entering Different Zone
      if value ~= HudRef.CurrentZone then
          HudRef.CurrentZone = value
          Item:setAlpha(0)
          Item:setText(HudRef.CurrentZone)

          Item:beginAnimation("keyframe", Elem.fadeIn * 1000, true, true, CoD.TweenType.Linear)
          Item:setAlpha(1)
          if Elem.doFadeOut == true then
              local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
              HudRef:addElement(timer)
          end
      end end, -- Tested OK
  None        =  function(HudRef, InstanceRef, Elem, Item, ModelRef)
          local function HideItem( ModelRef )
              Item:setAlpha(0)
          end
          local value = Engine.GetModelValue(ModelRef)

          --player Entering Different Zone
          if value ~= HudRef.CurrentZone then
              HudRef.CurrentZone = value
              Item:setText(HudRef.CurrentZone)
              Item:setAlpha(1)
              if Elem.doFadeOut == true then
                  local timer = LUI.UITimer.newElementTimer( Elem.freezeTime * 1000 + Elem.fadeIn * 1000, true, HideItem)
                  HudRef:addElement(timer)
              end
          end end -- Tested OK
}

local function isAny(str, strTable)
  debug.execute("[BEGIN]ZoneWriter: isAny")

  for i=1,#strTable do
    if str == strTable[i] then
      debug.execute("[END]ZoneWriter: isAny (true)")

      return true
    end
  end
  debug.execute("[END]ZoneWriter: isAny (false)")
  return false
end

function CoD.ZoneWriter.useAlignment(element, strAnim)
  --[[
  LUI.Alignment{
    Align Horz : Left   Center    Right
    Align Vert : Top    Middle    Bottom
    Align Unset: None
  }
  ]]
  debug.execute("[BEGIN]ZoneWriter: useAlignment")
  local aligns = {
    "Center",
    "Middle"
  }

  if isAny(strAnim,
    {
    "LeftRight",
    "RightLeft",
    "TopBottom",
    "BottomTop",
    "TopBack",
    "BottomBack",
    "RotateZoom",
    "None"
    }) then
      aligns = {
        "Center",
        "Middle"
      }
  end

  if isAny(strAnim,
    {
    "LeftBack",
    "BlackOps4"
    }) then
      aligns = {
        "Left",
        "Top"
      }
  end

  if isAny(strAnim,
    {
    "RightBack"
    }) then
      aligns = {
        "Right",
        "Top"
      }
  end

  element:setAlign(aligns[1])
  element:setAlign(aligns[2])
  debug.execute("[END]ZoneWriter: useAlignment")
end

function CoD.ZoneWriter.useTopBottom(element, strAnim)
  debug.execute("[BEGIN]ZoneWriter: useTopBottom")

  if isAny(strAnim,
    {
    "TopBack",
    "BlackOps4",
    "None"
    }) then
      element:setLocalTopBottom(true, false, 25, 50)
  end

  if isAny(strAnim,
    {
    "BottomBack"
    }) then
      element:setLocalTopBottom(false, true, -50, -25)
  end

  if isAny(strAnim,
    {
    "LeftRight",
    "LeftBack",
    "RightLeft",
    "RightBack",
    "BottomTop",
    "TopBottom",
    "RotateZoom"
    }) then
      element:setLocalTopBottom(false, false, -12.5, 12.5)
  end
  debug.execute("[END]ZoneWriter: useTopBottom")
end

function CoD.ZoneWriter.useLeftRight(element, strAnim)
  debug.execute("[BEGIN]ZoneWriter: useLeftRight")

  if isAny(strAnim,
    {
    "TopBottom",
    "BottomTop",
    "TopBack",
    "BottomBack",
    "LeftRight",
    "RightLeft",
    "RotateZoom",
    "None"
    }) then
      element:setLocalLeftRight(true, true, 0, 0)
  end

  if isAny(strAnim,
    {
    "LeftBack",
    "BlackOps4"
    }) then
      element:setLocalLeftRight(true, false, 25, 256)
  end

  if isAny(strAnim,
    {
    "RightBack"
    }) then
      element:setLocalLeftRight(false, true, -256, -25)
  end
  debug.execute("[END]ZoneWriter: useLeftRight")
end

function CoD.ZoneWriter.new(HudRef, InstanceRef)
    local Elem = LUI.UIElement.new()
    Elem:setClass(CoD.ZoneWriter)
    Elem:setLeftRight(true, true, 0, 0)
    Elem:setTopBottom(true, true, 0, 0)
    Elem.id = "ZoneWriter"
    Elem.soundSet = "default"
    HudRef.CurrentZone = nil



    Elem.positions = {
      locLeftRight = {
        leftAnchor, rightAnchor, left, right = Elem:getLocalLeftRight()
      },
      locTopBottom = {
        topAnchor, botAnchor, top, bot = Elem:getLocalTopBottom()
      }
    }

    Elem.fadeIn = 1
    Elem.fadeOut = 1
    Elem.freezeTime = 1
    Elem.doFadeOut = false
    Elem.animation = nil
    Elem.textHeight = 20

    local Item = LUI.UIText.new(Elem, Instance)
    Item:setLeftRight(true, true, 0, 0)
    Item:setTopBottom(true, true, 0, 0)
    Item:setText("")
    -- Item:setTTF("fonts/".. Elem.font ..".ttf")
    Item:setAlpha(0)

    local function checkClientfield(ModelRef)
      if Elem.animation ~= nil then
        Elem:setLeftRight(Elem:getElementLeftRight())
        Elem:setTopBottom(Elem:getElementTopBottom())
        debug.execute("animation loading...")
        Elem.animation(HudRef, InstanceRef, Elem, Item, ModelRef)
      end
    end

    Item:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "zoneNameInHUD"), checkClientfield)
    Elem:addElement(Item)
    Elem.Item = Item

    return Elem
end

CoD.ZoneWriter.newPreset = function(HudRef, InstanceRef, strAnim)
  local ZA = CoD.ZoneWriter.new(HudRef, InstanceRef)
  debug.execute("[BEGIN]ZoneWriter: newPreset")

  --Align First
  ZA:useAlignment(strAnim)

  --Left Right Pos Second
  ZA:useLeftRight(strAnim)

  --Third Top Bottom
  ZA:useTopBottom(strAnim)

  ZA:fixHeight(25)

  ZA:setFadeIn(2)
  ZA:setFadeOut(1)
  ZA:setFreezeTime(7)

  ZA:useFadeOut(true)
  ZA:doAnim(CoD.ZoneWriter.Animations[strAnim])

  return ZA
end
