import wollok.game.*


object menu {
	var property position = game.origin()
	var menu = true
	
	method image() = if(menu) "menu.jpg" else "controles.jpg"
	
	method activarMenu() {
		menu = true
	}
	
	method menu(tipo) {
		menu = tipo
	}
}