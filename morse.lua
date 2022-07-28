while wait() do
	if game:IsLoaded() then break end
end
wait(4)
l_code = {}

l_code[".-"]    = 'a'
l_code["-..."]  = 'b'
l_code["-.-."]  = 'c'
l_code["-.."]   = 'd'
l_code["."]     = 'e'
l_code["..-."]  = 'f'
l_code["--."]   = 'g'
l_code["...."]  = 'h'
l_code[".."]    = 'i'
l_code[".---"]  = 'j'
l_code["-.-"]   = 'k'
l_code[".-.."]  = 'l'
l_code["--"]    = 'm'
l_code["-."]    = 'n'
l_code["---"]   = 'o'
l_code[".--."]  = 'p'
l_code["--.-"]  = 'q'
l_code[".-."]   = 'r'
l_code["..."]   = 's'
l_code["-"]     = 't'
l_code["..-"]   = 'u'
l_code["...-"]  = 'v'
l_code[".--"]   = 'w'
l_code["-..-"]  = 'x'
l_code["-.--"]  = 'y'
l_code["--.."]  = 'z'
l_code["-----"] = '0'
l_code[".----"] = '1'
l_code["..---"] = '2'
l_code["...--"] = '3'
l_code["....-"] = '4'
l_code["....."] = '5'
l_code["-...."] = '6'
l_code["--..."] = '7'
l_code["---.."] = '8'
l_code["----."] = '9'

-- sound files
sounds = {}

sounds['.'] = "Sounds/dot.wav"
sounds['-'] = "Sounds/dash.wav"
sounds['s'] = "Sounds/shortpause.wav"
sounds[' '] = "Sounds/mediumpause.wav"
sounds['/'] = "Sounds/longpause.wav"

-- adding inverse of table
r_code = {}
for k, v in pairs(l_code) do
	r_code[v] = k
end

-- returns array table of strings seperated by the deliminator
function split_string(str, delim)
	local d_len      = #delim
	local last_index = 0 - d_len
	local next_word  = 1
	local result     = {}

	for i = 1, #str do
		local chunk = string.sub(str, i, i + d_len - 1)

		if chunk == delim then
			result[next_word] = string.sub(str, last_index + d_len, i - 1)
			last_index        = i
			next_word         = next_word + 1
		end
	end

	-- adding the last chunk
	result[next_word] = string.sub(str, last_index + d_len, #str)
	return result
end

-- takes string of alphanumeric characters and returns a new string in
--  morse code
function translate_to_morse(input)
	local str    = string.lower(input)
	local words  = split_string(str, " ")
	local result = ""

	for i= 1, #words do
		for j= 1, #words[i] do
			local letter = string.sub(words[i], j, j)

			if r_code[letter] then
				result = result .. r_code[letter]
				result = result .. " "
			end
		end

		-- removing last space
		result = string.sub(result, 1, #result - 1)
		-- adding a slash to distinguish separate words
		result = result .. "/"
	end

	-- removing last spaces
	return string.sub(result, 1, #result - 1)
end

-- takes a morse code string and returns a new string in alpha-numeric
--  characters
function translate_from_morse(str)
	local words  = split_string(str, "/")
	local result = ""

	for i= 1, #words do
		local letters = split_string(words[i], " ")

		for j= 1, #letters do
			if l_code[letters[j]] then
				result = result .. l_code[letters[j]]
			end
		end

		result = result .. " "
	end

	-- removing the last space
	return string.sub(result, 1, #result - 1)
end
print(translate_to_morse("i hate niggers"))
function onchatted(player, msg)
	if string.find(string.lower(msg), string.lower("/e morse")) then
		local tmp = string.split(msg, " ")
		local words = {}
		for i, v in ipairs(tmp) do
			if i ~= 1 or i ~= 2 then
				table.insert(words, v)
			end
		end
		local first = true
		local text = ""
		for _, v in pairs(words) do
			if first then
				first = false
				text = text..v
			else
				text = text.." "..v
			end
		end
		local args = {
			[1] = translate_to_morse(text),
			[2] = "All"
		}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
	else
		if translate_from_morse(msg) ~= "" then
			print(translate_from_morse(msg))
			game.StarterGui:SetCore( "ChatMakeSystemMessage",  { Text = "[Decryptor] Translation : \""..translate_from_morse(msg).."\"", Color = Color3.fromRGB( 255,255,255 ), Font = Enum.Font.SourceSans, FontSize = Enum.FontSize.Size24 } )
		end		
	end
end
for _, v in pairs(game.Players:GetPlayers()) do
	v.Chatted:Connect(function(msg)
		onchatted(v, msg)
	end)
end
game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		onchatted(player, msg)
	end)
end)
game.StarterGui:SetCore( "ChatMakeSystemMessage",  { Text = "Morse code communicator loaded! made by Glebux#2290", Color = Color3.fromRGB( 255,255,255 ), Font = Enum.Font.SourceSans, FontSize = Enum.FontSize.Size24 } )