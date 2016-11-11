--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Chili Integral Menu",
		desc      = "Integral Command Menu",
		author    = "GoogleFrog",
		date      = "8 Novemember 2016",
		license   = "GNU GPL, v2 or later",
		layer     = math.huge-10,
		enabled   = true,
		handler   = true,
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Configuration

include("keysym.h.lua")

-- Chili classes
local Chili
local Button
local Label
local Colorbars
local Checkbox
local Window
local Panel
local StackPanel
local TextBox
local Image
local Progressbar
local Control

-- Chili instances
local screen0

local MIN_HEIGHT = 80
local MIN_WIDTH = 200
local COMMAND_SECTION_WIDTH = 74 -- percent
local STATE_SECTION_WIDTH = 24 -- percent

local SELECT_BUTTON_COLOR = {0.8, 0, 0, 1}
local SELECT_BUTTON_FOCUS_COLOR = {0.8, 0, 0, 1}

-- Defined upon learning the appropriate colors
local BUTTON_COLOR
local BUTTON_FOCUS_COLOR

local NO_TEXT = ""

local EPIC_NAME = "epic_chili_integral_menu_"
local EPIC_NAME_UNITS = "epic_chili_integral_menu_tab_units"

local _, _, buildCmdFactory, buildCmdEconomy, buildCmdDefence, buildCmdSpecial,_ , commandDisplayConfig, _, hiddenCommands, buildCmdUnits = include("Configs/integral_menu_commands.lua")

local textConfig = {
	bottomLeft = {
		name = "bottomLeft",
		x = "15%",
		right = 0,
		bottom = 2,
		height = 12,
		fontsize = 12,
	},
	topLeft = {
		name = "topLeft",
		x = "12%",
		y = "11%",
		fontsize = 12,
	},
	queue = {
		name = "queue",
		right = "18%",
		bottom = "14%",
		align = "right",
		fontsize = 16,
		height = 16,
	},
}

local buttonLayoutConfig = {
	command = {
		image = {
			x = "9%",
			y = "9%",
			right = "9%",
			height = "82%",
			keepAspect = true,
		}
	},
	build = {
		image = {
			x = "5%",
			y = "3%",
			right = "5%",
			bottom = 13,
			keepAspect = false,
		},
		showCost = true
	},
	queue = {
		image = {
			x = "5%",
			y = "5%",
			right = "5%",
			height = "90%",
			keepAspect = false,
		},
		showCost = false,
		tooltipOverride = "\255\1\255\1Left/Right click \255\255\255\255: Add to/subtract from queue\n\255\1\255\1Hold Left mouse \255\255\255\255: Drag to a different position in queue",
		dragAndDrop = true,
	},
	queueWithDots = {
		image = {
			x = "5%",
			y = "5%",
			right = "5%",
			height = "90%",
			keepAspect = false,
		},
		caption = "...",
		showCost = false,
		-- "\255\1\255\1Hold Left mouse \255\255\255\255: drag drop to different factory or position in queue\n"
		tooltipOverride = "\255\1\255\1Left/Right click \255\255\255\255: Add to/subtract from queue\n\255\1\255\1Hold Left mouse \255\255\255\255: Drag to a different position in queue",
		dragAndDrop = true,
		dotDotOnOverflow = true,
	}
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Widget Options

options_path = 'Settings/HUD Panels/Command Panel'
options_order = { 
	'background_opacity', 'keyboardType', 'unitsHotkeys', 'hide_when_spectating',
	'tab_economy', 'tab_defence', 'tab_special', 'tab_factory',  'tab_units',
}

options = {
	background_opacity = {
		name = "Opacity",
		type = "number",
		value = 0.8, min = 0, max = 1, step = 0.01,
	},
	keyboardType = {
		type='radioButton', 
		name='Keyboard Layout',
		items = {
			{name = 'QWERTY (standard)',key = 'qwerty', hotkey = nil},
			{name = 'QWERTZ (central Europe)', key = 'qwertz', hotkey = nil},
			{name = 'AZERTY (France)', key = 'azerty', hotkey = nil},
		},
		value = 'qwerty',  --default at start of widget
		noHotkey = true,
	},
	unitsHotkeys = {
		name = 'Enable Factory Hotkeys',
		type = 'bool',
		value = true,
		noHotkey = true,
	},
	hide_when_spectating = {
		name = 'Hide when Spectating',
		type = 'bool',
		value = false,
		noHotkey = true,
	},
	tab_economy = {
		name = "Economy Tab",
		desc = "Switches to economy tab.",
		type = 'button',
	},
	tab_defence = {
		name = "Defence Tab",
		desc = "Switches to defence tab.",
		type = 'button',
	},
	tab_special = {
		name = "Special Tab",
		desc = "Switches to special tab.",
		type = 'button',
	},
	tab_factory = {
		name = "Factory Tab",
		desc = "Switches to factory tab.",
		type = 'button',
	},
	tab_units = {
		name = "Units Tab",
		desc = "Switches to units tab.",
		type = 'button',
	},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Very Global Globals

local buttonsByCommand = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Utility

local function GenerateGridKeyMap(name)
	local gridMap = include("Configs/keyboard_layout.lua")[name]
	local ret = {}
	for i = 1, 3 do
		for j = 1, 6 do
			ret[KEYSYMS[gridMap[i][j]]] = {i, j}
		end
	end
	return ret, gridMap
end

local function RemoveAction(cmd, types)
	return widgetHandler.actionHandler:RemoveAction(widget, cmd, types)
end

local function GetHotkeyText(actionName)
	local hotkey = WG.crude.GetHotkey(actionName)
	if hotkey ~= '' then
		return '\255\0\255\0' .. hotkey
	end
	return nil
end

local function GetActionHotkey(actionName)
	return WG.crude.GetHotkey(actionName)
end

local function TabListsAreIdentical(newTabList, tabList)
	if (not tabList) or (not newTabList) then
		return false
	end
	if #newTabList ~= #tabList then
		return false
	end
	for i = 1, #newTabList do
		if newTabList[i].name ~= tabList[i].name then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Command Queue Editing Implementation

local function MoveOrRemoveCommands(cmdID, factoryUnitID, commands, queuePosition, inputMult, reinsertPosition)
	if not commands then
		return
	end
	
	-- delete from back so that the order is not canceled while under construction
	local i = queuePosition
	local j = 0
	while commands[i] and ((not inputMult) or j < inputMult) do
		local thisCmdID = commands[i].id
		if thisCmdID < 0 then
			if thisCmdID ~= cmdID then
				break
			end
	
			Spring.GiveOrderToUnit(factoryUnitID, CMD.REMOVE, {commands[i].tag}, {"ctrl"})
			if reinsertPosition then
				Spring.GiveOrderToUnit(factoryUnitID, CMD.INSERT, {reinsertPosition, cmdID, 0}, {"alt", "ctrl"})
			end
			j = j + 1
			i = i - 1
		end
	end
end

local function MoveCommandBlock(factoryUnitID, queueCmdID, moveBlock, insertBlock)
	local commands = Spring.GetFactoryCommands(factoryUnitID)
	if not commands then
		return
	end
	
	-- Insert at the end of blocks which are after the move block
	if insertBlock > moveBlock then
		insertBlock = insertBlock + 1
	end
	
	-- Delete moved commands from the end of the block so look for the start of the next block.
	moveBlock = moveBlock + 1
	
	local movePos, insertPos
	local lastBlockCmdID
	local blockCount = 0
	local lastPosition = 0
	local i = 1
	local iterationEnd = #commands + 1
	while i <= iterationEnd and ((not movePos) or (not insertPos)) do
		local command = commands[i]
		local cmdID = command and command.id
		if (not cmdID) or cmdID < 0 then
			if cmdID ~= lastBlockCmdID then
				blockCount = blockCount + 1
				if blockCount == moveBlock then
					movePos = lastPosition
				elseif blockCount == insertBlock then
					insertPos = lastPosition
					-- Prevent canceling construction of identical units
					if cmdID == queueCmdID then
						insertPos = insertPos + 1
					end
				end
				lastBlockCmdID = cmdID
			end
			lastPosition = i
		end
		i = i + 1
	end
	
	if not insertPos then
		insertPos = #commands 
	end
	
	if not (movePos and insertPos) then
		return
	end
	
	MoveOrRemoveCommands(queueCmdID, factoryUnitID, commands, movePos, nil, insertPos)
end

local function QueueClickFunc(left, right, alt, ctrl, meta, shift, queueCmdID, factoryUnitID, queueBlock)
	local commands = Spring.GetFactoryCommands(factoryUnitID)
	if not commands then
		return
	end
	
	-- Find the end of the block
	queueBlock = queueBlock + 1
	
	local queuePosition
	local lastBlockCmdID
	local blockCount = 0
	local lastPosition = 0
	local i = 1
	local iterationEnd = #commands + 1
	for i = 1, iterationEnd  do
		local command = commands[i]
		local cmdID = command and command.id
		if (not cmdID) or cmdID < 0 then
			if cmdID ~= lastBlockCmdID then
				blockCount = blockCount + 1
				if blockCount == queueBlock then
					queuePosition = lastPosition
					break
				end
				lastBlockCmdID = cmdID
			end
			lastPosition = i
		end
	end
	
	if not queuePosition then
		return
	end
	
	if alt then
		MoveOrRemoveCommands(queueCmdID, factoryUnitID, commands, queuePosition, false, 0)
		return
	end

	local inputMult = 1*(shift and 5 or 1)*(ctrl and 20 or 1)
	if right then
		MoveOrRemoveCommands(queueCmdID, factoryUnitID, commands, queuePosition, inputMult)
		return
	end
	
	for i = 1, inputMult do
		Spring.GiveOrderToUnit(factoryUnitID, CMD.INSERT, {queuePosition, queueCmdID, 0 }, {"alt", "ctrl"})
	end
end

local function ClickFunc(mouse, cmdID, isStructure, factoryUnitID, queueBlock)
	local left, right = mouse == 1, mouse == 3
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	if factoryUnitID then
		QueueClickFunc(left, right, alt, ctrl, meta, shift, cmdID, factoryUnitID, queueBlock)
		return
	end
	
	local mb = (left and 1) or (right and 3)
	if mb then
		local index = Spring.GetCmdDescIndex(cmdID)
		if index then
			Spring.SetActiveCommand(index, mb, left, right, alt, ctrl, meta, shift)
			if alt and isStructure and WG.Terraform_SetPlacingRectangle then
				WG.Terraform_SetPlacingRectangle(-cmdID)
			end
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Button Panel

local function GetButton(parent, selectionIndex, x, y, xStr, yStr, width, height, buttonLayout, isStructure, onClick)
	local cmdID
	local usingGrid
	local factoryUnitID
	local queueCount
	local isDisabled = false
	local isSelected = false
	local hotkeyText
	
	local function DoClick(_, _, _, mouse)
		if isDisabled then
			return
		end
		ClickFunc(mouse or 1, cmdID, isStructure, factoryUnitID, x)
		if onClick then
			onClick()
		end
	end
	
	local button = Button:New {
		x = xStr,
		y = yStr,
		width = width,
		height = height,
		caption = buttonLayout.caption or "",
		padding = {0, 0, 0, 0},
		parent = parent,
		OnClick = {DoClick}
	}
	
	if buttonLayout.dragAndDrop then
		button.OnMouseDown = { 
			function(obj,_,_,mouse) --for drag_drop feature
				if mouse == 1 then
					local badX, badY = obj:CorrectlyImplementedLocalToScreen(obj.x, obj.y, true)
					WG.DrawMouseBuild.SetMouseIcon(-cmdID, obj.width/2, queueCount - 1, badX, badY, obj.width, obj.height)
				end
			end
		}
		button.OnMouseUp = {
			function(obj, clickX, clickY, mouse) -- MouseRelease event, for drag_drop feature --note: x & y is coordinate with respect to obj
				WG.DrawMouseBuild.ClearMouseIcon()
				if not factoryUnitID then
					return
				end
				if clickY < 0 or clickY > button.height or button.width == 0 then
					return
				end
				local clickPosition = math.floor(clickX/button.width) + x
				if clickPosition < 1 then
					return
				end
				if factoryUnitID and x ~= clickPosition then
					MoveCommandBlock(factoryUnitID, cmdID, x, clickPosition)
				end
			end
		}
	end
	
	if not BUTTON_COLOR then
		BUTTON_COLOR = button.backgroundColor
	end
	if not BUTTON_FOCUS_COLOR then
		BUTTON_FOCUS_COLOR = button.focusColor
	end
	
	local image
	local buildProgress
	local textBoxes = {}
	
	local function SetImage(texture1, texture2)
		if not image then
			image = Image:New {
				x = buttonLayout.image.x,
				y = buttonLayout.image.y,
				right = buttonLayout.image.right,
				bottom = buttonLayout.image.bottom,
				height = buttonLayout.image.height,
				keepAspect = buttonLayout.image.keepAspect,
				file = texture1,
				file2 = texture2,
				parent = button,
			}
			image:SendToBack()
			return
		end
		
		if image.file == texture1 and image.file2 == texture2 then
			return
		end
		
		if image.file == texture1 and image.file2 == texture2 then
			return
		end
		image.file = texture1
		image.file2 = texture2
		image:Invalidate()
	end
	
	local function SetText(textPosition, text)
		if isDisabled then
			text = false
		end
		if not textBoxes[textPosition] then
			if not text then
				return
			end
			local config = textConfig[textPosition]
			textBoxes[textPosition] = Label:New {
				x = config.x,
				y = config.y,
				right = config.right,
				bottom = config.bottom,
				height = config.height,
				align = config.align,
				fontsize = config.fontsize,
				caption = text,
				parent = button,
			}
			textBoxes[textPosition]:BringToFront()
			return
		end
		
		if text == textBoxes[textPosition].caption then
			return
		end
		
		textBoxes[textPosition]:SetCaption(text or NO_TEXT)
		textBoxes[textPosition]:Invalidate()
	end
		
	local externalFunctionsAndData = {
		button = button,
		DoClick = DoClick,
		selectionIndex = selectionIndex,
	}
	
	local function SetDisabled(newDisabled)
		if newDisabled == isDisabled then
			return
		end
		isDisabled = newDisabled
		
		if not image then
			SetImage("")
		end
		if isDisabled then
			button.backgroundColor = {0,0,0,1}
			image.color = {0.3, 0.3, 0.3, 1}
			externalFunctionsAndData.ClearGridHotkey()
		else
			button.backgroundColor = {1,1,1,0.7}
			image.color = {1, 1, 1, 1}
			if hotkeyText then
				SetText(textConfig.topLeft.name, hotkeyText)
			end
		end
			
		button:Invalidate()
		image:Invalidate()
	end
	
	function externalFunctionsAndData.SetProgressBar(proportion)
		if buildProgress then
			buildProgress:SetValue(proportion or 0)
			return
		end
		
		if not image then
			SetImage("")
		end
		
		buildProgress = Progressbar:New{
			x = "5%",
			y = "5%",
			right = "5%",
			bottom = "5%",
			value = proportion,
			max = 1,
			color   		= {0.7, 0.7, 0.4, 0.6},
			backgroundColor = {1, 1, 1, 0.01},
			parent = image,
			skin = nil,
			skinName = 'default',
		}
	end
	
	function externalFunctionsAndData.UpdateGridHotkey(gridMap)
		local key = gridMap[y] and gridMap[y][x]
		if not key then
			return
		end
		usingGrid = true
		hotkeyText = '\255\0\255\0' .. key
		SetText(textConfig.topLeft.name, hotkeyText)
	end
	
	function externalFunctionsAndData.RemoveGridHotkey()
		usingGrid = false
		if command and command.action then
			local hotkey = GetHotkeyText(command.action)
			SetText(textConfig.topLeft.name, hotkey)
		else
			SetText(textConfig.topLeft.name, nil)
		end
	end
	
	function externalFunctionsAndData.ClearGridHotkey()
		SetText(textConfig.topLeft.name)
	end
	
	local currentOverflow, onMouseOverFun
	function externalFunctionsAndData.SetQueueCommandParameter(newFactoryUnitID, overflow)
		factoryUnitID = newFactoryUnitID
		if buttonLayout.dotDotOnOverflow then
			currentOverflow = overflow 
			if overflow then
				button.tooltip = ""
				for _,textBox in pairs(textBoxes) do
					textBox:SetCaption(NO_TEXT)
				end
				SetImage()
				
				if not onMouseOverFun then
					onMouseOverFun = function ()
						if not currentOverflow then
							return
						end
						local buildQueue = Spring.GetRealBuildQueue(factoryUnitID)
						
						local overflowString = ""
						for i = x, #buildQueue do
							for udid, count in pairs(buildQueue[i]) do
								local name = UnitDefs[udid].humanName
								overflowString = overflowString .. name .. " x" .. count .. ((i < #buildQueue and "\n") or "")
							end
						end
						button.tooltip = overflowString
					end
					button.OnMouseOver[#button.OnMouseOver + 1] = onMouseOverFun
				end
			end
		end
	end
	
	function externalFunctionsAndData.SetSelection(newIsSelected)
		if isSelected == newIsSelected then
			return
		end
		isSelected = newIsSelected
	
		if isSelected then
			button.backgroundColor = SELECT_BUTTON_COLOR
			button.focusColor = SELECT_BUTTON_FOCUS_COLOR
		else
			button.backgroundColor = BUTTON_COLOR
			button.focusColor = BUTTON_FOCUS_COLOR
		end
		button:Invalidate()
	end
	
	function externalFunctionsAndData.GetCommandID()
		return cmdID
	end
	
	function externalFunctionsAndData.SetBuildQueueCount(count)
		if not (count or queueCount) then
			return
		end
		queueCount = count
		SetText(textConfig.queue.name, count)
	end
	
	function externalFunctionsAndData.SetCommand(command, overrideCmdID, notGlobal)
		-- If overrideCmdID is negative then command can be nil.
		local newCmdID = overrideCmdID or command.id
		
		externalFunctionsAndData.SetSelection(false)
		externalFunctionsAndData.SetBuildQueueCount(nil)
		
		if cmdID == newCmdID then
			local isStateCommand = command and (command.type == CMDTYPE.ICON_MODE and #command.params > 1)
			if isStateCommand then
				local state = command.params[1] + 1
				local displayConfig = commandDisplayConfig[cmdID]
				local texture = displayConfig.texture[state]
				SetImage(texture)
			end
			return
		end
		cmdID = newCmdID
		if not notGlobal then
			buttonsByCommand[cmdID] = externalFunctionsAndData
		end
		if buildProgress then
			externalFunctionsAndData.SetProgressBar(0)
		end
		if command then
			SetDisabled(command.disabled)
		end
		if cmdID < 0 then
			local ud = UnitDefs[-cmdID]
			if buttonLayout.tooltipOverride then
				button.tooltip = buttonLayout.tooltipOverride
			else
				local tooltip = "Build Unit: " .. ud.humanName .. " - " .. ud.tooltip .. "\n"
				button.tooltip = tooltip
			end
			SetImage("#" .. -cmdID, WG.GetBuildIconFrame(UnitDefs[-cmdID]))
			if buttonLayout.showCost then
				SetText(textConfig.bottomLeft.name, UnitDefs[-cmdID].metalCost)
			end
			return
		end
		
		local displayConfig = commandDisplayConfig[cmdID]
		local tooltip = (displayConfig and displayConfig.tooltip) or command.tooltip
		
		local isStateCommand = (command.type == CMDTYPE.ICON_MODE and #command.params > 1)
		
		if command.action then
			local hotkey = GetHotkeyText(command.action)
			if tooltip and hotkey then
				tooltip = tooltip .. " (\255\0\255\0" .. hotkey .. "\008)"
			end
			if not (isStateCommand or usingGrid) then 
				SetText(textConfig.topLeft.name, hotkey)
			end
		end
		
		button.tooltip = tooltip
		
		if isStateCommand then
			local state = command.params[1] + 1
			local texture = displayConfig.texture[state]
			SetImage(texture)
		else
			local texture = (displayConfig and displayConfig.texture) or command.texture
			SetImage(texture)
		end
	end

	return externalFunctionsAndData
end

local function GetButtonPanel(parent, rows, columns, vertical, generalButtonLayout, generalIsStructure, onClick, buttonLayoutOverride)
	local buttons = {}
	local buttonList = {}
	
	local width = tostring(100/columns) .. "%"
	local height = tostring(100/rows) .. "%"
	
	local gridMap
	
	local externalFunctions = {}
	
	function externalFunctions.ClearOldButtons(selectionIndex)
		for i = 1, #buttonList do
			local button = buttonList[i]
			if button.selectionIndex ~= selectionIndex then
				parent:RemoveChild(button.button)
			end
		end
	end
	
	function externalFunctions.GetButton(x, y, selectionIndex)
		if buttons[x] and buttons[x][y] then
			if not buttons[x][y].button.parent then
				if not selectionIndex then
					return false
				end
				parent:AddChild(buttons[x][y].button)
			end
			if selectionIndex then
				buttons[x][y].selectionIndex = selectionIndex
			end
			return buttons[x][y]
		end
		
		if not selectionIndex then
			return false
		end
		
		buttons[x] = buttons[x] or {}
		
		local xStr = tostring((x - 1)*100/columns) .. "%"
		local yStr = tostring((y - 1)*100/rows) .. "%"
		
		local buttonLayout, isStructure = generalButtonLayout, generalIsStructure
		if buttonLayoutOverride and buttonLayoutOverride[x] and buttonLayoutOverride[x][y] then
			buttonLayout = buttonLayoutOverride[x][y].buttonLayoutConfig
			isStructure = buttonLayoutOverride[x][y].isStructure
		end
		
		newButton = GetButton(parent, selectionIndex, x, y, xStr, yStr, width, height, buttonLayout, isStructure, onClick)
		
		buttonList[#buttonList + 1] = newButton
		if gridMap then
			newButton.UpdateGridHotkey(gridMap)
		end
		
		buttons[x][y] = newButton
		
		return newButton
	end
	
	function externalFunctions.IndexToPosition(index)
		if vertical then
			local y = (index - 1)%rows + 1
			local x = columns - (index - y)/rows
			return x, y
		else
			local x = (index - 1)%columns + 1
			local y = (index - x)/columns + 1
			return x, y
		end
	end
	
	function externalFunctions.ApplyGridHotkeys(newGridMap)
		gridMap = newGridMap
		for i = 1, #buttonList do
			buttonList[i].UpdateGridHotkey(gridMap)
		end
	end
	
	function externalFunctions.RemoveGridHotkeys()
		gridMap = nil
		for i = 1, #buttonList do
			buttonList[i].RemoveGridHotkey()
		end
	end
	
	return externalFunctions
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Queue Panel

local function GetQueuePanel(parent, columns)
	local externalFunctions = {}
	
	local factoryUnitID
	local factoryUnitDefID
	
	local buttonLayoutOverride = {
		[columns] = {
			[1] = {
				buttonLayoutConfig = buttonLayoutConfig.queueWithDots,
				isStructure = false,
			}
		}
	}
	
	local buttons = GetButtonPanel(parent, 1, columns, false, buttonLayoutConfig.queue, false, onClick, buttonLayoutOverride)

	function externalFunctions.ClearOldButtons(selectionIndex)
		factoryUnitID = false
		factoryUnitDefID = false
		buttons.ClearOldButtons(selectionIndex)
	end
	
	function externalFunctions.UpdateBuildProgress()
		if not factoryUnitID then
			return
		end
		local button = buttons.GetButton(1, 1)
		if not button then
			return
		end
		local unitBuildID = Spring.GetUnitIsBuilding(factoryUnitID)
		if not unitBuildID then 
			return
		end
		local progress = select(5, Spring.GetUnitHealth(unitBuildID))
		button.SetProgressBar(progress)
	end
	
	function externalFunctions.ClearFactory()
		factoryUnitID = false
		factoryUnitDefID = false
	end
	
	function externalFunctions.UpdateFactory(newFactoryUnitID, newFactoryUnitDefID, selectionIndex)
		local buttonCount = 0
		
		factoryUnitID = newFactoryUnitID 
		factoryUnitDefID = newFactoryUnitDefID
	
		local buildQueue = Spring.GetRealBuildQueue(factoryUnitID)
	
		local buildDefIDCounts = {}
		if buildQueue then
			for i = 1, #buildQueue do
				for udid, count in pairs(buildQueue[i]) do
					if buttonCount <= columns then
						buttonCount = buttonCount + 1
						local x, y = buttons.IndexToPosition(buttonCount)
						local button = buttons.GetButton(x, y, selectionIndex)
						button.SetCommand(nil, -udid, true)
						button.SetBuildQueueCount(count)
						button.SetQueueCommandParameter(newFactoryUnitID, #buildQueue > columns)
					end
					buildDefIDCounts[udid] = (buildDefIDCounts[udid] or 0) + count
				end
			end
		end
		
		externalFunctions.UpdateBuildProgress()
		
		for udid, count in pairs(buildDefIDCounts) do
			local button = buttonsByCommand[-udid]
			if button then
				button.SetBuildQueueCount(count)
			end
		end
	end
	
	return externalFunctions
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Tab Panel

local function GetTabButton(panel, contentControl, name, humanName, hotkey, loiterable, OnSelect)
	
	local function DoClick()
		panel.SwitchToTab(name)
		panel.SetHotkeysActive(loiterable)
		if OnSelect then
			OnSelect()
		end
	end
	
	local button = Button:New {
		caption = humanName,
		padding = {0, 0, 0, 0},
		OnClick = {DoClick}
	}
	button.backgroundColor[4] = 0.4
	
	local hideHotkey = loiterable
	
	if hotkey and not hideHotkey then
		button:SetCaption(humanName .. " (\255\0\255\0" .. hotkey .. "\008)")
		button:Invalidate()
	end
	
	local externalFunctionsAndData = {
		button = button,
		name = name,
		DoClick = DoClick,
	}
		
	function externalFunctionsAndData.IsTabSelected()
		return contentControl.visible
	end
	
	function externalFunctionsAndData.IsTabPresent()
		return button.parent and true or false
	end
	
	function externalFunctionsAndData.SetHotkeyActive(isActive)
		if (not hotkey) or hideHotkey then
			return
		end
		if loiterable then
			isActive = isActive and (not contentControl.visible)
		end
		
		if isActive then
			button:SetCaption(humanName .. " (\255\0\255\0" .. hotkey .. "\008)")
		else
			button:SetCaption(humanName .. " (" .. hotkey .. ")")
		end
		button:Invalidate()
	end
	
	function externalFunctionsAndData.SetHideHotkey(newHidden)
		if not loiterable then
			return
		end
		hideHotkey = newHidden
		if hideHotkey then
			button:SetCaption(humanName)
			button:Invalidate()
		end
	end
	
	function externalFunctionsAndData.SetSelected(isSelected)
		contentControl:SetVisibility(isSelected)
		if loiterable and not hideHotkey then
			externalFunctionsAndData.SetHotkeyActive(not isSelected)
		end
		button.backgroundColor[4] = isSelected and 1 or 0.4
		button:Invalidate()
	end
	
	return externalFunctionsAndData
end

local function GetTabPanel(parent, rows, columns)
	local tabHolder = StackPanel:New{
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
		padding = {0, 0, 0, 0},
		itemMargin  = {1, 1, 1, -1},	
		parent = parent,
		preserveChildrenOrder = true,
		resizeItems = true,
		orientation = "horizontal",
	}
	
	local currentSelectedIndex
	local hotkeysActive = true
	local currentTab
	local tabList = false
	
	local externalFunctions = {}
	
	function externalFunctions.SwitchToTab(name)
		if not tabList then
			return
		end
		currentTab = name
		for i = 1, #tabList do
			local data = tabList[i]
			data.SetSelected(data.name == name)
			if data.name == name then
				currentSelectedIndex = i
			end
		end
	end
		
	function externalFunctions.SetTabs(newTabList, showTabs, variableHide, tabToSelect)
		if TabListsAreIdentical(newTabList, tabList) then
			return
		end
		if currentSelectedIndex and tabList[currentSelectedIndex] then
			tabList[currentSelectedIndex].SetSelected(false)
		end
		tabList = newTabList
		tabHolder:ClearChildren()
		for i = 1, #tabList do
			if showTabs then
				tabHolder:AddChild(tabList[i].button)
				tabList[i].SetHideHotkey(variableHide)
				tabList[i].SetHotkeyActive(hotkeysActive)
			end
			if tabList[i].name == tabToSelect then
				tabList[i].DoClick()
			end
		end
	end
	
	function externalFunctions.ClearTabs()
		if tabList then
			externalFunctions.SwitchToTab()
			tabList = false
			currentSelectedIndex = false
			tabHolder:ClearChildren()
		end
	end
	
	function externalFunctions.SetHotkeysActive(newActive)
		hotkeysActive = newActive
		if not tabList then
			return
		end
		for i = 1, #tabList do
			local data = tabList[i]
			data.SetHotkeyActive(hotkeysActive)
		end
	end
	
	function externalFunctions.GetCurrentTab()
		return currentTab
	end
	
	return externalFunctions
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Global Variables

local specialButtonLayoutOverride = {}
for i = 1, 5 do
	specialButtonLayoutOverride[i] = {
		[3] = {
			buttonLayoutConfig = buttonLayoutConfig.command,
			isStructure = false,
		}
	}
end

local commandPanels = {
	{
		humanName = "Orders",
		name = "orders",
		inclusionFunction = function(cmdID)
			return cmdID >= 0 and not buildCmdSpecial[cmdID] -- Terraform
		end,
		loiterable = true,
		buttonLayoutConfig = buttonLayoutConfig.command,
	},
	{
		humanName = "Econ",
		name = "economy",
		inclusionFunction = function(cmdID)
			local position = buildCmdEconomy[cmdID]
			return position and true or false, position
		end,
		isBuild = true,
		isStructure = true,
		gridHotkeys = true,
		returnOnClick = "orders",
		optionName = "tab_economy",
		buttonLayoutConfig = buttonLayoutConfig.build,
	},
	{
		humanName = "Defence",
		name = "defence",
		inclusionFunction = function(cmdID)
			local position = buildCmdDefence[cmdID]
			return position and true or false, position
		end,
		isBuild = true,
		isStructure = true,
		gridHotkeys = true,
		returnOnClick = "orders",
		optionName = "tab_defence",
		buttonLayoutConfig = buttonLayoutConfig.build,
	},
	{
		humanName = "Special",
		name = "special",
		inclusionFunction = function(cmdID)
			local position = buildCmdSpecial[cmdID]
			return position and true or false, position
		end,
		isBuild = true,
		isStructure = true,
		notBuildRow = 3,
		gridHotkeys = true,
		returnOnClick = "orders",
		optionName = "tab_special",
		buttonLayoutConfig = buttonLayoutConfig.build,
		buttonLayoutOverride = specialButtonLayoutOverride,
	},
	{
		humanName = "Factory",
		name = "factory",
		inclusionFunction = function(cmdID)
			local position = buildCmdFactory[cmdID]
			return position and true or false, position
		end,
		isBuild = true,
		isStructure = true,
		gridHotkeys = true,
		returnOnClick = "orders",
		optionName = "tab_factory",
		buttonLayoutConfig = buttonLayoutConfig.build,
	},
	{
		humanName = "Units",
		name = "units_mobile",
		inclusionFunction = function(cmdID, factoryUnitDefID)
			return not factoryUnitDefID -- Only called if previous funcs don't
		end,
		isBuild = true,
		gridHotkeys = true,
		returnOnClick = "orders",
		optionName = "tab_units",
		buttonLayoutConfig = buttonLayoutConfig.build,
	},
	{
		humanName = "Units",
		name = "units_factory",
		inclusionFunction = function(cmdID, factoryUnitDefID)
			if not factoryUnitDefID then
				return false
			end
			local buildOptions = UnitDefs[factoryUnitDefID].buildOptions
			for i = 1, #buildOptions do
				if buildOptions[i] == -cmdID then
					local position = buildCmdUnits[cmdID]
					return position and true or false, position
				end
			end
			return false
		end,
		loiterable = true,
		factoryQueue = true,
		isBuild = true,
		hotkeyReplacement = "Orders",
		gridHotkeys = true,
		disableableKeys = true,
		buttonLayoutConfig = buttonLayoutConfig.build,
	},
}

local commandPanelMap = {}
for i = 1, #commandPanels do
	commandPanelMap[commandPanels[i].name] = commandPanels[i]
end

local statePanel = {}
local tabPanel

local selectionIndex = 0

local contentHolder

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Command Handling

local function GetSelectionValues()	
	local selection = Spring.GetSelectedUnits()
	for i = 1, #selection do
		local unitID = selection[i]
		local defID = Spring.GetUnitDefID(unitID)
		if defID and (UnitDefs[defID].isFactory or UnitDefs[defID].customParams.isfakefactory) then
			return unitID, defID, UnitDefs[defID].customParams.isfakefactory, #selection
		end
	end
	return false, nil, nil, #selection
end

local function ProcessCommand(command, factorySelected, selectionIndex)
	if hiddenCommands[command.id] or command.hidden then
		return
	end

	local isStateCommand = (command.type == CMDTYPE.ICON_MODE and #command.params > 1)
	if isStateCommand then
		statePanel.commandCount = statePanel.commandCount + 1
		
		local x, y = statePanel.buttons.IndexToPosition(statePanel.commandCount)
		local button = statePanel.buttons.GetButton(x, y, selectionIndex)
		button.SetCommand(command)
		return
	end
	
	for i = 1, #commandPanels do
		local data = commandPanels[i]
		local found, position = data.inclusionFunction(command.id, factorySelected)
		if found then
			data.commandCount = data.commandCount + 1
			
			local x, y
			if position then
				x, y = position.col, position.row
			else
				x, y = data.buttons.IndexToPosition(data.commandCount)
			end
			
			local button = data.buttons.GetButton(x, y, selectionIndex)
			
			button.SetCommand(command)
			return
		end
	end
end

local function ProcessAllCommands(commands, customCommands)
	local factoryUnitID, factoryUnitDefID, fakeFactory, selectedUnitCount = GetSelectionValues()

	selectionIndex = selectionIndex + 1
	
	for i = 1, #commandPanels do
		local data = commandPanels[i]
		data.commandCount = 0
	end
	
	statePanel.commandCount = 0
	
	for i = 1, #commands do
		ProcessCommand(commands[i], factoryUnitDefID, selectionIndex)
	end
	
	for i = 1, #customCommands do
		ProcessCommand(customCommands[i], factoryUnitDefID, selectionIndex)
	end
	
	-- Call factory queue update here because the update will globally
	-- set queue count for the top two rows of the factory tab. Therefore
	-- the factory tab must have updated its commands.
	if factoryUnitDefID then
		for i = 1, #commandPanels do
			local data = commandPanels[i]
			if data.queue then
				if fakeFactory then
					data.queue.ClearFactory()
				else
					data.queue.UpdateFactory(factoryUnitID, factoryUnitDefID, selectionIndex)
				end
			end
		end
	end
	
	local tabsToShow = {}
	local lastTabSelected = tabPanel.GetCurrentTab()
	local tabToSelect
	
	-- Switch to factory tab is a factory is newly selected.
	if factoryUnitDefID then
		local unitsFactoryTab = commandPanelMap.units_factory.tabButton
		if not unitsFactoryTab.IsTabPresent() then
			tabToSelect = "units_factory"
		end
	end
	
	-- Determine which tabs to display and which to select
	for i = 1, #commandPanels do
		local data = commandPanels[i]
		if data.commandCount ~= 0 then
			tabsToShow[#tabsToShow + 1] = data.tabButton
			data.buttons.ClearOldButtons(selectionIndex)
			if data.queue then
				data.queue.ClearOldButtons(selectionIndex)
			end
			if (not tabToSelect) and data.tabButton.name == lastTabSelected then
				tabToSelect = lastTabSelected
			end
		end
	end
	
	statePanel.holder:SetVisibility(statePanel.commandCount ~= 0)
	if statePanel.commandCount ~= 0 then
		statePanel.buttons.ClearOldButtons(selectionIndex)
	end
	
	if not tabToSelect then
		tabToSelect = "orders"
	end
	
	if #tabsToShow == 0 then
		tabPanel.ClearTabs()
		lastTabSelected = false
	else
		tabPanel.SetTabs(tabsToShow, #tabsToShow > 1, not factoryUnitDefID, tabToSelect)
		lastTabSelected = tabToSelect
	end
	
	-- Keeps main window for tweak mode.
	contentHolder:SetVisibility(not (#tabsToShow == 0 and selectedUnitCount == 0))
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Initialization

local gridKeyMap, gridMap -- Configuration requires this

local function InitializeControls()
	-- Set the size for the default settings.
	local screenWidth, screenHeight = Spring.GetWindowGeometry()
	local width = math.max(350, math.min(450, screenWidth*screenHeight*0.0004))
	local height = math.min(screenHeight/4.5, 200*width/450)

	gridKeyMap, gridMap = GenerateGridKeyMap(options.keyboardType.value)
	
	local leftPadding = 0
	local rightPadding = 0
	
	local mainWindow = Window:New{
		name      = 'integralwindow',
		x         = 0, 
		bottom    = 0,
		width     = width,
		height    = height,
		minWidth  = MIN_WIDTH,
		minHeight = MIN_HEIGHT,
		dockable  = true,
		draggable = false,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = true,
		padding = {0, 0, 0, -1},
		color = {0, 0, 0, 0},
		parent    = screen0,
	}
		
	local tabHolder = Control:New{
		x = leftPadding,
		y = "0%",
		right = rightPadding,
		height = "15%",
		padding = {2, 2, 2, 0},
		parent = mainWindow,
	}
	
	tabPanel = GetTabPanel(tabHolder)
	
	contentHolder = Panel:New{
		--classname = "bottomMiddlePanel",
		x = 0,
		y = "15%",
		width = "100%",
		bottom = 0,
		draggable = false,
		resizable = false,
		padding = {0, 0, 0, 0},
		backgroundColor = {1, 1, 1, options.background_opacity.value},
		parent = mainWindow,
	}
	
	buttonsHolder = Control:New{
		x = leftPadding,
		y = 0,
		right = rightPadding,
		bottom = 0,
		padding = {0, 0, 0, 0},
		parent = contentHolder,
	}
	
	--local currentSkin = Chili.theme.skin.general.skinName
	--local skin = Chili.SkinHandler.GetSkin(currentSkin)
	--
	--if skin.bottomLeftPanel then
	--	contentHolder.tiles = skin.bottomLeftPanel.tiles
	--	contentHolder.TileImageFG = skin.bottomLeftPanel.TileImageFG
	--	contentHolder.backgroundColor = skin.bottomLeftPanel.backgroundColor
	--	contentHolder.TileImageBK = skin.bottomLeftPanel.TileImageBK
	--	contentHolder:Invalidate()
	--end
	
	local function ReturnToOrders()
		commandPanelMap.orders.tabButton.DoClick()
	end
	
	for i = 1, #commandPanels do
		local data = commandPanels[i]
		local commandHolder = Control:New{
			x = "0%",
			y = "0%",
			width = COMMAND_SECTION_WIDTH .. "%",
			height = "100%",
			padding = {4, 4, 0, 4},
			parent = buttonsHolder,
		}
		commandHolder:SetVisibility(false)
		
		local hotkey
		if data.optionName then
			hotkey = GetActionHotkey(EPIC_NAME .. data.optionName)
		else
			hotkey = GetActionHotkey(EPIC_NAME_UNITS)
		end

		if data.returnOnClick then
			data.onClick = ReturnToOrders
		end
		
		local OnTabSelect
		
		data.holder = commandHolder
		data.buttons = GetButtonPanel(commandHolder, 3, 6,  false, data.buttonLayoutConfig, data.isStructure, data.onClick, data.buttonLayoutOverride)
		
		if data.factoryQueue then
			local queueHolder = Control:New{
				x = "0%",
				y = "66.666%",
				width = "100%",
				height = "33.3333%",
				padding = {0, 0, 0, 0},
				parent = commandHolder,
			}
			data.queue = GetQueuePanel(queueHolder, 6)
			
			-- If many things need doing they must be put in a function
			-- but this works for now.
			OnTabSelect = data.queue.UpdateBuildProgress
		end
		
		data.tabButton = GetTabButton(tabPanel, commandHolder, data.name, data.humanName, hotkey, data.loiterable, OnTabSelect)
	
		if data.gridHotkeys and ((not data.disableableKeys) or options.unitsHotkeys.value) then
			data.buttons.ApplyGridHotkeys(gridMap)
		end
	end
	
	statePanel.holder = Control:New{
		x = (100 - STATE_SECTION_WIDTH) .. "%",
		y = "0%",
		width = STATE_SECTION_WIDTH .. "%",
		height = "100%",
		padding = {0, 4, 3, 4},
		parent = buttonsHolder,
	}
	statePanel.holder:SetVisibility(false)
	
	statePanel.buttons = GetButtonPanel(statePanel.holder, 5, 3, true, buttonLayoutConfig.command)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Epic Menu Configuration and Hotkey Functions

function options.keyboardType.OnChange(self)
	gridKeyMap, gridMap = GenerateGridKeyMap(self.value)
	for i = 1, #commandPanels do
		local data = commandPanels[i]
		if data.gridHotkeys and ((not data.disableableKeys) or options.unitsHotkeys.value) then
			data.buttons.ApplyGridHotkeys(gridMap)
		end
	end
end

function options.background_opacity.OnChange(self)
	contentHolder.backgroundColor[4] = self.value
	contentHolder:Invalidate()
end

function options.hide_when_spectating.OnChange(self)
	local isSpec = Spring.GetSpectatingState()
	contentHolder:SetVisibility(not (self.value and isSpec))
end

function options.unitsHotkeys.OnChange(self)
	for i = 1, #commandPanels do
		local data = commandPanels[i]
		if data.disableableKeys then
			if not options.unitsHotkeys.value then
				data.buttons.RemoveGridHotkeys()
			else
				data.buttons.ApplyGridHotkeys(gridMap)
			end
		end
	end
end

function options.tab_economy.OnChange()
	local tab = commandPanelMap.economy.tabButton
	if tab.IsTabPresent() then
		tab.DoClick()
	end
end

local function HotkeyTabDefence()
	local tab = commandPanelMap.defence.tabButton
	if tab.IsTabPresent() then
		tab.DoClick()
	end
end

local function HotkeyTabSpecial()
	local tab = commandPanelMap.special.tabButton
	if tab.IsTabPresent() then
		tab.DoClick()
	end
end

local function HotkeyTabFactory()
	local tab = commandPanelMap.factory.tabButton
	if tab.IsTabPresent() then
		tab.DoClick()
	end
end

local function HotkeyTabUnits()
	local tab = commandPanelMap.units_mobile.tabButton
	if tab.IsTabPresent() then
		tab.DoClick()
		return
	end
	local unitsFactoryTab = commandPanelMap.units_factory.tabButton
	if not unitsFactoryTab.IsTabPresent() then
		return
	end
	if unitsFactoryTab.IsTabSelected() then
		commandPanelMap.orders.tabButton.DoClick()
	else
		unitsFactoryTab.DoClick()
	end
end

options.tab_defence.OnChange = HotkeyTabDefence
options.tab_special.OnChange = HotkeyTabSpecial
options.tab_factory.OnChange = HotkeyTabFactory
options.tab_units.OnChange   = HotkeyTabUnits

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Widget Interface

local initialized = false

local lastCmdID
function widget:Update()
	local _,cmdID = Spring.GetActiveCommand()
	if cmdID ~= lastCmdID then
		if lastCmdID and buttonsByCommand[lastCmdID] then
			buttonsByCommand[lastCmdID].SetSelection(false)
		end
		if buttonsByCommand[cmdID] then
			buttonsByCommand[cmdID].SetSelection(true)
		end
		
		lastCmdID = cmdID
	end
end

function widget:KeyPress(key, modifier, isRepeat)
	if isRepeat then
		return false
	end
	
	local currentTab = tabPanel.GetCurrentTab()
	local commandPanel = currentTab and commandPanelMap[currentTab]
	if (not commandPanel) or (not (commandPanel.gridHotkeys and ((not commandPanel.disableableKeys) or options.unitsHotkeys.value))) then
		return false
	end
	
	local pos = gridKeyMap[key]
	if pos then
		local x, y = pos[2], pos[1]
		local button = commandPanel.buttons.GetButton(x, y)
		if button then
			button.DoClick()
			return true
		end
	end

	if (key == KEYSYMS.ESCAPE or gridKeyMap[key]) and commandPanel.onClick then
		commandPanel.onClick()
		return true
	end
	return false
end

function widget:PlayerChanged(playerID)
	if options.hide_when_spectating.value then
		local isSpec = Spring.GetSpectatingState()
		contentHolder:SetVisibility(not isSpec)
	end
end

function widget:CommandsChanged()
	if not initialized then
		return
	end

	local commands = widgetHandler.commands
	local customCommands = widgetHandler.customCommands
	ProcessAllCommands(commands, customCommands)
end

function widget:GameFrame(n)
	if n%6 == 0 then
		local unitsFactoryPanel = commandPanelMap.units_factory
		if unitsFactoryPanel and unitsFactoryPanel.tabButton.IsTabSelected() then
			unitsFactoryPanel.queue.UpdateBuildProgress()
		end
	end
end

function widget:Initialize()
	RemoveAction("nextmenu")
	RemoveAction("prevmenu")
	initialized = true
	
	Chili = WG.Chili
	Button = Chili.Button
	Label = Chili.Label
	Colorbars = Chili.Colorbars
	Checkbox = Chili.Checkbox
	Window = Chili.Window
	Panel = Chili.Panel
	StackPanel = Chili.StackPanel
	TextBox = Chili.TextBox
	Image = Chili.Image
	Progressbar = Chili.Progressbar
	Control = Chili.Control
	screen0 = Chili.Screen0
	
	InitializeControls()
end
