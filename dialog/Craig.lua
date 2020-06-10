
-- Very important dialogue for Craig, the most important character in our story

local tree = DialogTree({
	-- Actual Dialogue
	[1] = DialogBox("Yo! It's me, Craig!"),
	[2] = DialogBox("I'm the main character of this game,\n{pause, 30}right?"),
},{
	-- Dialogue Map
	[1] = 2,
	[2] = nil,
})
return tree
