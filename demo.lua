--[[ Title: SaxBot || Creator: SaxaphoneWalrus ]]--

require("ts3defs")
require("ts3errors")

--
-- Call these function from the TeamSpeak 3 client console via: /lua run SaxBot.<function>
-- Alternatively use the SaxBot event commands in the chat normally!
--

saxConfig = {
	saxAttic = 24421, -- Channel ID.
	movedOut = 23563, -- The 'move others out' channel ID.
	channelLockdown = false,
	channelWhitelist = false,
	blockJoinsWhilstAway = true,
	blockJoinsWhenNotInRoom = true,
	botName = 'SaxBot',
	blacklist = {},

	whitelist = {
		'+S4QibZkiMH2cL94ivlcdu/xOYw=', -- Sax,
		'ofaiR5uDvWI4VIO8rG2YQNOvBg4=', -- Murg,
		'fEAZaOazEVDvtE3d6JaEzqKsjmc=', -- Murg 2,
		'PNlsYX8Dce8Ul4igxghYdi+FGNA=', -- Avi,
		'y7qCEGs1N3SWZvxEXeATcvRe4og=', -- Dylan,
		'isX8bOtsc8pjnkTm6xVe5ugFZHs=', -- Phoenix,
		'2ptmcZAxmDWmAHiwbaVaqQDvTdg=', -- V1v4,
		'S3NflE9jaRMNJ5sj/0EpdYwinzI=', -- Kyle,
		'A44pEe8LbG+ZY837C9NzzLKv7GQ=', -- Chris,
		'7EXza1MUpJT8kDpMdUwINE4td4k=', -- Chris 2,
		'xRhp0MTJhhpuBUFEA7J7r4wh7zM=', -- Cody,
		'Y2G0RoTSQhXvvLjayhb26ac8oGo=', -- 20th,
		'4bejg1MLmMrD8e0+zFUTT2HdZ1w=', -- Sea,
	},

	colourPacket = {
		['red'] = '#FF0000',
		['green'] = '#009933',
		['lavender'] = '#666699',
		['white'] = '#FFFFFF',
	},
}


local function splitMessage(serverConnectionHandlerID, msg)
	pattern = '[^_]+' -- Replaces '_' with ' ', [[[^\]+]] replaces '\' with ' '
	outcome = ''

	if msg == '' or msg == nil then
		msg = 'Boop'
	end

	for match in msg:gmatch(pattern) do
		if outcome ~= '' then
			outcome = outcome..' '..match
		else
			outcome = match
		end
	end

	return outcome
end

function say(serverConnectionHandlerID, message, toReturnBool)
	toReturn = '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color]'

	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, (toReturnBool and toReturn..'\n'..splitMessage(serverConnectionHandlerID, message) or splitMessage(serverConnectionHandlerID, message)), 0)
end

function toggleLockdown(serverConnectionHandlerID, message, targetMode, userID, fromUnique)
	local myClientID = ts3.getClientID(serverConnectionHandlerID)
	local messages = {'[color='..saxConfig.colourPacket.lavender..']Channel on Lockdown[/color]', '[color='..saxConfig.colourPacket.lavender..']Channel Open to the Public[/color]'}
	local descriptions = {'[color='..saxConfig.colourPacket.red..']TRUE[/color]', '[color='..saxConfig.colourPacket.green..']FALSE[/color]'}

	if myClientID == userID then
		saxConfig.channelLockdown = not saxConfig.channelLockdown
		ts3.requestSendChannelTextMsg(serverConnectionHandlerID, '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] '..(saxConfig.channelLockdown and messages[1] or messages[2])..'\n[color='..saxConfig.colourPacket.white..']automated_message[/color]', 0)
		ts3.setChannelVariableAsString(serverConnectionHandlerID, saxConfig.saxAttic, ts3defs.ChannelProperties.CHANNEL_DESCRIPTION, '[ [b][color='..saxConfig.colourPacket.red..']'..saxConfig.botName..' Powered Room[/color][/b] ]\n~ To get in PM SaxaphoneWalrus saying;\n- Can I join\n------------------------------------------\n LOCKDOWN: '..( saxConfig.channelLockdown and descriptions[1] or descriptions[2]))
		ts3.flushChannelUpdates(serverConnectionHandlerID, saxConfig.saxAttic)
	end
end

function toggleWhitelist(serverConnectionHandlerID, message, targetMode, userID, fromUnique)
	if ts3.getClientVariableAsString(serverConnectionHandlerID, userID, ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER) == '+S4QibZkiMH2cL94ivlcdu/xOYw=' then
		saxConfig.channelWhitelist = not saxConfig.channelWhitelist

		local names = {"Sax's [-Whitelisted-] Attic", "Sax's Attic"}
		ts3.setChannelVariableAsString(serverConnectionHandlerID, saxConfig.saxAttic, ts3defs.ChannelProperties.CHANNEL_NAME, (saxConfig.channelWhitelist and names[1] or names[2]))
		ts3.flushChannelUpdates(serverConnectionHandlerID, saxConfig.saxAttic)	

		if not saxConfig.channelLockdown and saxConfig.channelWhitelist then
			toggleLockdown(serverConnectionHandlerID, message, targetMode, userID)
		end
	end
end

function insult(serverConnectionHandlerID, message, targetMode, userID, fromUnique)
	local nickname = ts3.getClientVariableAsString(serverConnectionHandlerID, userID, ts3defs.ClientProperties.CLIENT_NICKNAME)
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color] \nGo fuck yourself you stupid little piece of shit, '..nickname..'!', 0)
end

function apology(serverConnectionHandlerID, message, targetMode, userID, fromUnique)
	local nickname = ts3.getClientVariableAsString(serverConnectionHandlerID, userID, ts3defs.ClientProperties.CLIENT_NICKNAME)
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color] \nEver so sorry, '..nickname..'! Forgive me?', 0)
end

function affection(serverConnectionHandlerID, message, targetMode, userID, fromUnique)
	local nickname = ts3.getClientVariableAsString(serverConnectionHandlerID, userID, ts3defs.ClientProperties.CLIENT_NICKNAME)
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color] \n'..nickname..', every time I see you my knees go weak, I love you so much it hurts. You are my one, my only. I may be a robot but I have computed if I were a person you would be the one I love. Accept my love and we shall be together forever, we are one. We are an unbeatable force.', 0)
end

function sayHello(serverConnectionHandlerID, message, targetMode, userID)
	local nickname = ts3.getClientVariableAsString(serverConnectionHandlerID, userID, ts3defs.ClientProperties.CLIENT_NICKNAME)
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color] \nHello, '..nickname..'!', 0)
end

function fanPack(serverConnectionHandlerID, message, targetMode, userID)
	say(serverConnectionHandlerID, 'You can find the FanPack [url=https://www.dropbox.com/s/9mftb60nzy7d25c/Saxaphone%20%231%20FanPack.zip]here[/url]!')
end

function sex(serverConnectionHandlerID, message, targetMode, userID)
	local nickname = ts3.getClientVariableAsString(serverConnectionHandlerID, userID, ts3defs.ClientProperties.CLIENT_NICKNAME)
	say(serverConnectionHandlerID, 'Sorry '..nickname..', but I would rather not get aids...')
end

function spread(serverConnectionHandlerID, message)
	local empty = (message:find('empty') and false or true)
	local channels = ts3.getChannelList(serverConnectionHandlerID)
	local channel = ts3.getChannelClientList(serverConnectionHandlerID, saxConfig.saxAttic)

	for i = 1,#channel do
		local chosenRoom = math.random(1,#channels)
		if #ts3.getChannelClientList(serverConnectionHandlerID, channels[chosenRoom]) >= 1 and empty then
			repeat chosenRoom = math.random(1,#channels) x = x + 1 until x == 3 or #ts3.getChannelClientList(serverConnectionHandlerID, channels[chosenRoom]) == 0 
			ts3.requestClientMove(serverConnectionHandlerID, channel[i], (channels[chosenRoom] and channels[chosenRoom] or saxConfig.movedOut), 'nil')
		else
			ts3.requestClientMove(serverConnectionHandlerID, channel[i], (channels[chosenRoom] and channels[chosenRoom] or saxConfig.movedOut), 'nil')
		end
	end
end

function lorem(serverConnectionHandlerID)
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color] \nLorem ipsum dolor sit amet, consectetur adipiscing elit.', 0)
end

function duckSong(serverConnectionHandlerID)
	local songTable = {"([i]Bum bum bum ba-dum ba-dum[/i])", "A duck walked up to a lemonade stand.", "And he said to the man running the stand, 'hey!'", "([i]Bum bum bum[/i])", "Got any grapes? The man said 'No, we just sell lemonade.", "But it's cold, And it's fresh and it's all home-made.", "Can I get you a glass?'", "The duck said, 'I'll pass.' Then he waddled away.", "([i]Waddle waddle[/i])", "'Til the very next day.", "([i]Bum bum bum bum bum da-dum[/i])"}	local storedName = ts3.getClientVariableAsString(serverConnectionHandlerID, ts3.getClientID(serverConnectionHandlerID), ts3defs.ClientProperties.CLIENT_NICKNAME)
	
	ts3.setClientSelfVariableAsString(serverConnectionHandlerID, ts3defs.ClientProperties.CLIENT_NICKNAME, 'SBM')
	ts3.flushClientSelfUpdates(serverConnectionHandlerID)

	for i = 1,#songTable do
--		ts3.setClientSelfVariableAsString(serverConnectionHandlerID, ts3defs.ClientProperties.CLIENT_NICKNAME, songTable[i])
--		ts3.flushClientSelfUpdates(serverConnectionHandlerID)
		say(serverConnectionHandlerID, songTable[i], false)
	end

	ts3.setClientSelfVariableAsString(serverConnectionHandlerID, ts3defs.ClientProperties.CLIENT_NICKNAME, storedName)
	ts3.flushClientSelfUpdates(serverConnectionHandlerID)
end

function sleep(serverConnectionHandlerID)
	if saxConfig.channelWhitelist then
		toggleWhitelist(serverConnectionHandlerID, nil, nil, ts3.getClientID(serverConnectionHandlerID))
	end

	if saxConfig.channelLockdown then
		toggleLockdown(serverConnectionHandlerID, nil, nil, ts3.getClientID(serverConnectionHandlerID))
	end
	
	ts3.setChannelVariableAsString(serverConnectionHandlerID, saxConfig.saxAttic, ts3defs.ChannelProperties.CHANNEL_DESCRIPTION, '- SaxBot is asleep. [img]http://i.imgur.com/AwgnjiS.gif[/img]')
	ts3.flushChannelUpdates(serverConnectionHandlerID, saxConfig.saxAttic)
end


function moveOthersOut(serverConnectionHandlerID, ID)
	local myClientID = ts3.getClientID(serverConnectionHandlerID)
	local clients = ts3.getChannelClientList(serverConnectionHandlerID, saxConfig.saxAttic)

	for i = 1,#clients do
		if clients[i] ~= myClientID then
			ts3.requestClientMove(serverConnectionHandlerID, clients[i], (ID and ID or saxConfig.movedOut), 'nil')
		end
	end
end

function showAllChannels(serverConnectionHandlerID)
	toReturn = '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color]'

	for i,v in pairs(ts3.getChannelList(serverConnectionHandlerID)) do
		toReturn = toReturn .. '\n'.. v .. ' :: ' .. ts3.getChannelVariableAsString(serverConnectionHandlerID, v, ts3defs.ChannelProperties.CHANNEL_NAME)
	end
	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, toReturn .. '\n - <ID> :: <NAME>', 0)
	ts3.printMessageToCurrentTab(toReturn .. '\n - <ID> :: <NAME>', 0)
end

function showAllClients(serverConnectionHandlerID)
	local clients = ts3.getClientList(serverConnectionHandlerID)
	local msg = '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color] \nThere are currently ' .. #clients .. ' visible clients:'

	for i = 1,#clients do
		msg = msg .. '\n '..clients[i].. ' :: '..ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_NICKNAME)..' :: '..ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER)..' -- '..ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_SERVERGROUPS)
	end

	msg = msg .. '\n<ID> :: <NAME> :: <UNIQUE_IDENTIFIER>'
	ts3.printMessageToCurrentTab(msg)
end

function showClientsInRoom(serverConnectionHandlerID, channelID)
	local myClientID = ts3.getClientID(serverConnectionHandlerID)
	local myChannelID = ts3.getChannelOfClient(serverConnectionHandlerID, myClientID)

	if channelID == nil or channelID == 0 then
		channelID = myChannelID
	end

	toReturn = '\n- [color='..saxConfig.colourPacket.red..']['..saxConfig.botName..'][/color] [color='..saxConfig.colourPacket.white..']automated_message[/color]'

	for i,v in pairs(ts3.getChannelClientList(serverConnectionHandlerID, channelID)) do
		toReturn = toReturn .. '\n' .. v .. ' :: ' .. ts3.getClientVariableAsString(serverConnectionHandlerID, v, ts3defs.ClientProperties.CLIENT_NICKNAME)
	end

	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, toReturn .. '\n - <ID> :: <NAME>', 0)
end

function muteAndAway(serverConnectionHandlerID, message, targetMode, userID, fromUnique)
	if userID == ts3.getClientID(serverConnectionHandlerID) then

		local int = (ts3.getClientSelfVariableAsInt(serverConnectionHandlerID, ts3defs.ClientProperties.CLIENT_AWAY) == 0 and 1 or 0)

		ts3.setClientSelfVariableAsInt(serverConnectionHandlerID, ts3defs.ClientProperties.CLIENT_AWAY, int)
		ts3.setClientSelfVariableAsInt(serverConnectionHandlerID, ts3defs.ClientProperties.CLIENT_OUTPUT_MUTED, int)
		ts3.flushClientSelfUpdates(serverConnectionHandlerID)
	end
end

--[[

ts3.guiConnect(connectTab, serverLabel, serverAddress, serverPassword, nickname, channel, channelPassword, captureProfile, playbackProfile, hotkeyProfile, soundProfile, userIdentity, oneTimeKey, phoneticName) > scHandlerID, error
ts3.createBookmark(bookmarkuuid, serverLabel, serverAddress, serverPassword, nickname, channel, channelPassword, captureProfile, playbackProfile, hotkeyProfile, soundProfile, userIdentity, oneTimeKey, phoneticName) > error

]]

function saxKlieent(serverConnectionHandlerID)
	ts3.createBookmark('f16c00a0-fa58-11e3-9cec-0002a5d5c51b', 'Team Phoenix SaxKlient', 'voice2.gamingdeluxe.co.uk:10007', 'tinkerbellchris', 'SaxKlient', 29502, 'yelaH', 1, 2, 3, 4, 5, '', 'n0')
end

function saxKlient(serverConnectionHandlerID)
	ts3.guiConnect(0, 'Team Phoenix SaxKlient', 'voice2.gamingdeluxe.co.uk:10007', 'tinkerbellchris', 'sKTest', '29502', 'yelaH', 'x', 'x', 'x', 'Sounds deactivated', 'SaxKlient', '', 'x')
end

function testTime(serverConnectionHandlerID)
	myTime = os.time()
	ts3.printMessageToCurrentTab(myTime.. " :: Difference by 10 minutes: "..myTime + 60*10)
end

SaxBot = {
	toggleLockdown = toggleLockdown,
	toggleWhitelist = toggleWhitelist,
	showAllChannels = showAllChannels,
	showAllClients = showAllClients,
	showClientsInRoom = showClientsInRoom,
	moveOthersOut = moveOthersOut,
	testz = testz,
	say = say,
	spread = spread,
	getConnectionStatus = getConnectionStatus,
	muteAndAway = muteAndAway,
	timedPrint = timedPrint,
	saxKlient = saxKlient,
	testTime = testTime,
}

