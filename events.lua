--
-- SaxBot callback functions
--
-- To avoid function name collisions, you should use local functions and export them with a unique package name.
--

require('SaxBot/demo')

local MenuIDs = {
	moveToMe = 1,
	moveMeTo = 2,
	swapUsers = 3,
	anchorUser = 4,
}

local anchoredUsers = {}

local commands

local function listCommands(serverConnectionHandlerID)
	local msg = '\n- [color='..saxConfig.colourPacket.red..'][SaxBot][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color]'

	for i,v in pairs(commands) do
		msg = msg .. '\n'..i
	end

	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, msg, 0)
end

commands = {
	['toggleLockdown'] = {{'close','open','lock','shut','public', 'lockdown'}, toggleLockdown}, 
	['showAllChannels'] = {{'channels'}, showAllChannels},
	['sayHello'] = {{'hello','hi','hey','hio'}, sayHello},
	['lorem'] = {{'lorem', 'dummytext', 'example', 'ipsum'}, lorem},
	['moveOthersOut'] = {{'moveothers', 'movetheothers', 'moveothersout'}, moveOthersOut},
	['showAllClients'] = {{'clients'}, showAllClients},
	['listCommands'] = {{'commands'}, listCommands},
	['whitelist'] = {{'whitelist', 'friendsonly'}, toggleWhitelist},
	['insult'] = {{'fuck','fk','bitch','fagit','fgt','faggot','cunt','noob','dumbass', sucks}, insult},
	['apology'] = {{'mean','rude','hurt','bad'}, apology},
	['affection'] = {{'like','love','fancy'}, affection},
	['fanPack'] = {{'fanpack','fan','pack'}, fanPack},
	['sex'] = {{'sex','intercourse','sexytime','jizzwiggle'}, sex},
	['sleep'] = {{'sleep','rest','vacation','holiday'}, sleep},
	['spread'] = {{'spread'}, spread},
	['duckSong'] = {{'ducksong','duck','sing','song'}, duckSong},
	['muteAndAway'] = {{'mute','away','mute&away','quiet','brb','afk', 'back', 'resumesound'}, muteAndAway},

	['move'] = {{'move me to you', 'can i join', 'can i enter', 'put me in your room', 'can i come', 'let me in', 'move me in', 'may i come in'}},
}

-- Will store factor to add to menuID to calculate the real menuID used in the TeamSpeak client (to support menus from multiple Lua modules)
-- Add this value to above menuID when passing the ID to setPluginMenuEnabled. See demo.lua for an example.
local moduleMenuItemID = 0

function onConnectStatusChangeEvent(serverConnectionHandlerID, status, errorNumber)
    print(saxConfig.botName..": onConnectStatusChangeEvent: " .. serverConnectionHandlerID .. " " .. status .. " " .. errorNumber)
end

function onNewChannelEvent(serverConnectionHandlerID, channelID, channelParentID)
    print(saxConfig.botName..": onNewChannelEvent: " .. serverConnectionHandlerID .. " " .. channelID .. " " .. channelParentID)
end

function onTalkStatusChangeEvent(serverConnectionHandlerID, status, isReceivedWhisper, clientID)
    print(saxConfig.botName..": onTalkStatusChangeEvent: " .. serverConnectionHandlerID .. " " .. status .. " " .. isReceivedWhisper .. " " .. clientID)
end

function onPluginCommandEvent(serverConnectionHandlerID, pluginName, pluginCommand)
	print(saxConfig.botName..": onPluginCommandEvent: " .. serverConnectionHandlerID .. " " .. pluginName .. " " .. pluginCommand)
end

--
-- Called when a plugin menu item (see ts3plugin_initMenus) is triggered. Optional function, when not using plugin menus, do not implement this.
--
-- Parameters:
--  serverConnectionHandlerID: ID of the current server tab
--  type: Type of the menu (ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_CHANNEL, ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_CLIENT or ts3defs.PluginMenuType.PLUGIN_MENU_TYPE_GLOBAL)
--  menuItemID: Id used when creating the menu item
--  selectedItemID: Channel or Client ID in the case of PLUGIN_MENU_TYPE_CHANNEL and PLUGIN_MENU_TYPE_CLIENT. 0 for PLUGIN_MENU_TYPE_GLOBAL.
--

local function moveClients(serverConnectionHandlerID, channelID, newChannelID)
	local clientList = ts3.getChannelClientList(serverConnectionHandlerID, channelID)

	for i = 1,#clientList do		
		ts3.requestClientMove(serverConnectionHandlerID, clientList[i], newChannelID, 'nil')
	end
end

local function swapClients(serverConnectionHandlerID, channelID)
	local channelIDTwo = ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID))

	local groupOneChannel = ts3.getChannelClientList(serverConnectionHandlerID, channelID)
	local groupTwoChannel = ts3.getChannelClientList(serverConnectionHandlerID, channelIDTwo)

	for i = 1,#groupOneChannel do
		ts3.printMessageToCurrentTab(groupOneChannel[i])
		ts3.requestClientMove(serverConnectionHandlerID, groupOneChannel[i], channelIDTwo, 'nil')
	end

	for i = 1,#groupTwoChannel do
		ts3.printMessageToCurrentTab(groupTwoChannel[i])
		ts3.requestClientMove(serverConnectionHandlerID, groupTwoChannel[i], channelID, 'nil')
	end
end

local function onMenuItemEvent(serverConnectionHandlerID, menuType, menuItemID, selectedItemID)

	if menuType == 1 and menuItemID == 1 then
		moveClients(serverConnectionHandlerID, selectedItemID, ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID)))
	elseif menuType == 1 and menuItemID == 2 then
		moveClients(serverConnectionHandlerID, ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID)), selectedItemID)
	elseif menuType == 1 and menuItemID == 3 and selectedItemID ~= ts3.getChannelOfClient(serverConnectionHandlerID,ts3.getClientID(serverConnectionHandlerID)) then
		swapClients(serverConnectionHandlerID, selectedItemID)
	elseif menuType == 2 and menuItemID == 4 then
		for i,v in pairs(anchoredUsers) do
			local isInTable = false
			if v == selectedItemID then
				ts3.printMessageToCurrentTab('\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color] \n ~ Removed user '..ts3.getClientVariableAsString(serverConnectionHandlerID, userID, ts3defs.ClientProperties.CLIENT_NICKNAME).. ' from Anchored Users')
				table.remove(anchoredUsers, i)
				isInTable = true
			end
			
			if isInTable == false then
				ts3.printMessageToCurrentTab('\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color] \n ~ Added user '..ts3.getClientVariableAsString(serverConnectionHandlerID, userID, ts3defs.ClientProperties.CLIENT_NICKNAME).. ' to Anchored Users')
				table.insert(anchoredUsers, 1, selectedItemID)
			end
		end
	end

end

local function checkForCommand(check, specific)
	local goodCommands = {}

	if specific == nil then
		for i,v in pairs(commands) do
			for cmd = 1,#v[1] do
				if check:lower():find(v[1][cmd]:lower()) then
					return true, v
				end
			end
		end
		return false
	else
		for i,v in pairs(specific) do
			if check:lower():find(v:lower()) then
				return true, v
			end
		end
		return false
	end
end

local function newCommandStyle(serverConnectionHandlerID, msg, pattern, specific)
	local msg = msg:lower()
	if specific == nil then

		local pattern = (pattern and pattern or '[^%p%s]+')
		local outcome = {}
	
		for match in msg:gmatch(pattern) do
			table.insert(outcome, match)
		end
	
		for i = 1,#outcome do
			for _,v in pairs(commands) do
				for cmd = 1,#v[1] do
					if outcome[i] == v[1][cmd]:lower() then
						return true, v
					end
				end
			end
		end
		
	else
		
		for i,v in pairs(specific) do
			if msg:lower():find(v:lower()) then
				return true, v
			end
		end	
	end
	return false
end

local function checkList(list, 	checkFor)
	for i = 1,#list do
		if tostring(list[i]):lower() == tostring(checkFor):lower() then
			return true, i
		end
	end
	return false
end

local function runCommand(serverConnectionHandlerID, message, targetMode, from, fromUnique, type)
	if type == 'txt' then
		local bool, cmds = newCommandStyle(serverConnectionHandlerID, message)
		if bool then
			cmds[2](serverConnectionHandlerID, message, targetMode, from, fromUniqueIdentifier)
		end
	end
end

function saxbotTextEvent(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
	local clientID = ts3.getClientID(serverConnectionHandlerID)

	if targetMode == 1 and not checkList(saxConfig.blacklist, fromUniqueIdentifier) and not saxConfig.channelLockdown and (saxConfig.blockJoinsWhilstAway and ts3.getClientSelfVariableAsInt(serverConnectionHandlerID, ts3defs.ClientProperties.CLIENT_AWAY) == 1 or not saxConfig.blockJoinsWhilstAway) and (saxConfig.blockJoinsWhenNotInRoom and ts3.getChannelOfClient(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID)) ~= saxConfig.saxAttic or not saxConfig.blockJoinsWhenNotInRoom) or targetMode == 1 and checkList(saxConfig.whitelist, fromUniqueIdentifier) then
		bool = checkForCommand(message, commands.move[1])

		if bool then
			ts3.requestClientMove(serverConnectionHandlerID, fromID, saxConfig.saxAttic, 'nil')
		end

	elseif targetMode == 1 and (saxConfig.channelLockdown or checkList(saxConfig.blacklist, fromUniqueIdentifier)) then
		bool = checkForCommand(message, commands.move[1])

		if bool then
			ts3.requestSendPrivateTextMsg(serverConnectionHandlerID, (saxConfig.channelLockdown and 'This room is in [b]LOCKDOWN[/b]! You can only be moved in here [i]manually[/i].' or 'Unfortunately you are [b]blocked[/b] from this room via auto-move. Sorry!'), fromID)
		end
	end

	if (message:lower():find(saxConfig.botName:lower()) or message:lower():find('saxbot')) and not message:lower():find('automated_message') then
		runCommand(serverConnectionHandlerID, message, targetMode, fromID, fromUnqiue, 'txt')
	end
end

function saxbotPokeEvent(serverConnectionHandlerID, pokerID, pokerName, message, ffIgnored)
	local uniqueID = ts3.getClientVariableAsString(serverConnectionHandlerID, pokerID, ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER)

	if not checkList(saxConfig.blacklist, uniqueID) and not saxConfig.channelLockdown or checkList(saxConfig.whitelist, uniqueID) then
		bool = checkForCommand(message, commands.move[1])

		if bool then
			ts3.requestClientMove(serverConnectionHandlerID, pokerID, saxConfig.saxAttic, 'nil')
		end

	elseif (saxConfig.channelLockdown or checkList(saxConfig.blacklist, uniqueID)) then
		bool = checkForCommand(message, commands.move[1])

		if bool then
			ts3.requestSendPrivateTextMsg(serverConnectionHandlerID, (saxConfig.channelLockdown and 'This room is in [b]LOCKDOWN[/b]! You can only be moved in here [i]manually[/i].' or 'Unfortunately you are [b]blocked[/b] from this room via auto-move. Sorry!'), pokerID)
		end
	end
end

function onServerGroupClientDeletedEvent(serverConnectionHandlerID, clientID, clientName, clientUniqueIdentity, serverGroupID, invokerClientID, invokerName, invokerUniqueIdentity)
	ts3.printMessageToCurrentTab('User '..invokerName..' just removed '..clientName..' from '..serverGroupID)
end

function onServerGroupClientAddedEvent(serverConnectionHandlerID, clientID, clientName, clientUniqueIdentity, serverGroupID, invokerClientID, invokerName, invokerUniqueIdentity)
	ts3.printMessageToCurrentTab('User '..invokerName..' just added '..clientName..' to '..serverGroupID)
end

function onClientMoveEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, moveMessage)
	if saxConfig.channelWhitelist and newChannelID == saxConfig.saxAttic and not checkList(saxConfig.whitelist, ts3.getClientVariableAsString(serverConnectionHandlerID, clientID, ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER)) then
		ts3.requestClientMove(serverConnectionHandlerID, clientID, oldChannelID, 'nil')
	end
end

function onClientMoveMovedEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, moverID, moverName, moverUniqueIdentifier, moveMessage)
	if saxConfig.channelWhitelist and newChannelID == saxConfig.saxAttic and not checkList(saxConfig.whitelist, ts3.getClientVariableAsString(serverConnectionHandlerID, clientID, ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER)) or checkList(anchoredUsers, clientID) then
		ts3.requestClientMove(serverConnectionHandlerID, clientID, oldChannelID, 'nil')
	end
end

SaxBot_events = {
	MenuIDs = MenuIDs,
	moduleMenuItemID = moduleMenuItemID,
	onConnectStatusChangeEvent = onConnectStatusChangeEvent,
	onNewChannelEvent = onNewChannelEvent,
	onTalkStatusChangeEvent = onTalkStatusChangeEvent,
	onPluginCommandEvent = onPluginCommandEvent,
	onMenuItemEvent = onMenuItemEvent,
	onTextMessageEvent = saxbotTextEvent,
	onClientPokeEvent = saxbotPokeEvent,
	onServerGroupClientDeletedEvent = onServerGroupClientDeletedEvent,
	onClientMoveEvent = onClientMoveEvent,
	onClientMoveMovedEvent = onClientMoveMovedEvent,
}
