
export class DialogManager
	new: () =>
		@reset!

	reset: () =>
		@tree = nil
		@running = false
		@awaitinginput = false

	setTree: (tree) =>
		@tree = tree
		@running = true
		@awaitinginput = false

	advanceInput: () =>
		if @tree != nil
			@tree\advanceInput!

	update: () =>
		if @tree != nil
			@tree\update!
			@awaitinginput = @tree.awaitinginput
			if @tree.done
				Push\setCanvas("dialogbox")
				lg.clear()
				Push\setCanvas("main")
				@tree = nil
				@running = false

	draw: () =>
		@tree\draw! if @tree != nil