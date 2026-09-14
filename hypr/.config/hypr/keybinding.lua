-- Main modifier
local mainMod = "SUPER"

-- Core actions
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q", function()
	hl.dsp("killactive")
end)
hl.bind(mainMod .. " + M", function()
	hl.dispatch("exit")
end)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + V", function()
	hl.dispatch("togglefloating")
end)
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + P", function()
	hl.dispatch("pseudo")
end)
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("wlogout"))

-- Move focus between windows
hl.bind(mainMod .. " + LEFT", function()
	hl.dispatch("movefocus", "l")
end)
hl.bind(mainMod .. " + RIGHT", function()
	hl.dispatch("movefocus", "r")
end)
hl.bind(mainMod .. " + UP", function()
	hl.dispatch("movefocus", "u")
end)
hl.bind(mainMod .. " + DOWN", function()
	hl.dispatch("movefocus", "d")
end)

-- Switch workspaces
for i = 1, 5 do
	hl.bind(mainMod .. " + " .. i, function()
		hl.dispatch("workspace", tostring(i))
	end)
end

-- Move active window to a workspace
for i = 1, 5 do
	hl.bind(mainMod .. " + SHIFT + " .. i, function()
		hl.dispatch("movetoworkspace", tostring(i))
	end)
end

-- Screenshot
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)"'))
