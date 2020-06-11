
class UseItemMenuItem extends MenuItem
	text: "Use"
	valid: => return @parent.parent\selectedItem!\is_usable!
	
class MoveItemMenuItem extends MenuItem
	text: "Move"
	valid: => return #game.inventory.items > 1

class TossItemMenuItem extends MenuItem
	text: "Toss"
	valid: => true
	activate: =>
		itemname = @parent.parent\selectedItem!.name
		game.dialog\setTree(DialogTree({
			DialogBox("You tossed the #{itemname}")
		}))
		game.inventory\removeItem(@parent.parent.selectedIndex)
		@parent.parent.state\changeState(InventoryWaitState)

export class InventoryActionState extends State
	new: (@parent) =>
		@items = {
			UseItemMenuItem(@,  {x:GAME_WIDTH/2+21,y:GAME_HEIGHT/2+7})
			MoveItemMenuItem(@, {x:GAME_WIDTH/2+21,y:GAME_HEIGHT/2+22})
			TossItemMenuItem(@, {x:GAME_WIDTH/2+21,y:GAME_HEIGHT/2+37})
		}
		@selectedIndex = 1
		@cursor = Cursor({x:0,y:0}, "right")
		@updateCursorPos!
	
	updateCursorPos: =>
		@cursor.pos = {x:@selectedItem!.pos.x-16,y:@selectedItem!.pos.y-4}

	drawMenu: =>
		for item in *@items
			item\draw!
	
	selectedItem: =>
		return @items[@selectedIndex]

	update: =>
		@cursor\update!
		@moveItemCursor(-1) if input\pressed("up")
		@moveItemCursor(1)  if input\pressed("down")
		@select! if input\pressed("confirm")
		@back! if input\pressed("back")
		@updateCursorPos!
	
	select: =>
		@selectedItem!\clicked!

	back: =>
		@parent.state\changeState(InventoryItemState)

	moveItemCursor: (dir) =>
		@selectedIndex += dir
		@selectedIndex = 1 if @selectedIndex < 1
		@selectedIndex = #@items if @selectedIndex > #@items

	draw: =>
		lg.setColor(1,1,1)
		lg.rectangle("fill",GAME_WIDTH/2+4,GAME_HEIGHT/2+4, GAME_WIDTH/2-12, GAME_HEIGHT/2-12)
		lg.setColor(0,0,0)
		lg.rectangle("line",GAME_WIDTH/2+4,GAME_HEIGHT/2+4, GAME_WIDTH/2-12, GAME_HEIGHT/2-12)

		@drawMenu!
		@cursor\draw!

	