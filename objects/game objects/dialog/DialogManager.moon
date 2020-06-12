
export class DialogManager
	new: () =>
		@reset!

	reset: () =>
		@tree = nil
		@running = false
		@awaitinginput = false

	setTree: (tree) =>
		@tree = tree
		@tree\reset!
		@running = true
		@awaitinginput = false

	advanceInput: () =>
		if @tree != nil
			@tree\advanceInput!
			@updateVars!
			
	cancelInput: () =>
		if @tree != nil
			@tree\cancelInput!
			@updateVars!

	updateVars: =>
		@awaitinginput = @tree.awaitinginput
		if @tree.done
			Push\setCanvas("dialogbox")
			lg.clear()
			Push\setCanvas("main")
			@tree = nil
			@running = false

	update: () =>
		if @tree != nil
			@tree\update!
			@updateVars!

	draw: () =>
		@tree\draw! if @tree != nil