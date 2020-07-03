local tree = DialogTree({
		-- Actual Dialogue
		[1] = DialogBox("{wave, A wandering woman bound in drab clothes and blankets watches the party as you approach. She holds up a hand until they stop.}"),
		[2] = DialogBox("Skerri: ‘Greetings, travellers. I am Skerri. What do you seek in these Whistling Flats?’"),
		[3] = DialogBox("{wave, You look past her to the tall cliffs of sandstone and sharp canyons that spread across the horizon in the warmth of a blazing sun. }"),
		[4] = DialogBox("Harold: ‘We’re travelling to Malathar in search of transport down the Splitting River, and across the Ocean of Mist.’"),
		[5] = DialogBox("Prince Falker: ‘Do you know the way, madam?’"),
		[6] = DialogBox("{wave, She eyes the party with suspicion for a moment, then turns with her hand pointed across the dunes and flats of heat.}"),
		[7] = DialogBox("Skerri: ‘That way. Though, I would tell you to stay clear and pass through… there have been whispers of attacks and unholy abominations nearby the town.’  "),
		[8] = DialogBox("Harold: ‘What do you mean, “unholy abominations?”’"),
		[9] = DialogBox("Skerri: ‘Just what I heard, traveller. Be seeing you.’"),
		[10] = DialogBox("{wave, Skerri marches onward the way the party came with a wave, slowly fading into the haze of the desert.}"),
		[11] = DialogBox("{input}What would you like to do now?",
			{"Back to the first dialogue!", "Let's end this conversavtion..."}),
	},{
		-- Dialogue Map
		[1] = 2,
		[2] = 3,
		[3] = 4,
		[4] = 5,
		[5] = 6,
		[6] = 7,
		[7] = 8,
		[8] = 9,
		[9] = 10,
		[10] = 11,
		[11] = 1, nil,
	})
	return tree