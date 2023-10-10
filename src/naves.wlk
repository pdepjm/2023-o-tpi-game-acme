import wollok.game.*

object motherRussia {

	var property position = game.at(game.width().div(2), game.height() - 1)

	method image() = "pepita.png"

	method moverseArriba() {
		if(position.y() < game.height() - 1)
			position = position.up(1)
	}
	
	method moverseAbajo() {
		if(position.y() > game.height().div(2))
			position = position.down(1)
	}
	
	method moverseIzquierda() {
		if(position.x() > 0)
			position = position.left(1)
	}
	
	method moverseDerecha() {
		if(position.x() < game.width() - 1)
			position = position.right(1)
	}

	method disparar() {
		game.addVisual(balaMotherRussia)
		balaMotherRussia.moverse()
	}
}

object usa {
	var property position = game.at(game.width().div(2), 0)
	
	method image() = "pepita.png"
	
	method moverseArriba() {
		if(position.y() < game.height().div(2) - 1)
			position = position.up(1)
	}
	
	method moverseAbajo() {
		if(position.y() > 0)
			position = position.down(1)
	}
	
	method moverseIzquierda() {
		if(position.x() > 0)
			position = position.left(1)
	}
	
	method moverseDerecha() {
		if(position.x() < game.width() - 1)
			position = position.right(1)
	}
	
	method disparar() {
		game.addVisual(balaUsa)
		balaUsa.moverse()
	}
}

object balaUsa {
	var property position = usa.position().up(1)
	
	method image() = "224681.png"
	
	method arriba(){
		if(position.y() < game.height() - 1)
			position = position.up(1)
		else
		{
			game.removeTickEvent("moverseBalaUsa")
			game.removeVisual(self)
		}
	}
	
	method moverse() {
		position = usa.position().up(1)
		game.onTick(2000, "moverseBalaUsa", {self.arriba()})
	}
}

object balaMotherRussia {
	var property position = motherRussia.position().down(1)
	
	method image() = "224681.png"
	
	method abajo(){
		if(position.y() > 0)
			position = position.down(1)
		else
		{
			game.removeTickEvent("moverseBalaMotherRussia")
			game.removeVisual(self)
		}
	}
	
	method moverse() {
		position = motherRussia.position().down(1)
		game.onTick(2000, "moverseBalaMotherRussia", {self.abajo()})
	}
}