
export class NPCShopState extends State
	new: (@parent) =>

	update: =>
		if @parent\checkInteract("shop") then
			room_path = game.state.current_room.room_path
			p = game.state.player
			rx = p.pos.x
			ry = p.pos.y
			game.next_state = {state: GameShopState, params: {@parent.item_list, room_path, rx, ry}}

