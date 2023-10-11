import wollok.game.*

object motherRussia {

	var property position = game.at(game.width().div(2), game.height() - 1)
	var property vida = 3

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
	
	method reducirVida() {
		vida -= 1
	}
	
	method morir() {
		game.removeVisual(usa)
		game.removeVisual(self)
	}
}

object usa {
	
	var property position = game.at(game.width().div(2), 0)
	var property vida = 3
	
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
	
	method reducirVida() {
		vida -= 1
	}
	
	method morir() {
		game.removeVisual(self)
		game.removeVisual(motherRussia)
	}
}

object balaUsa {
	var property position = usa.position().up(1)
	
	method image() = "balaUsa.png"
	
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
		game.onTick(1000, "moverseBalaUsa", { self.arriba() })
	}
	
	method restarVida() {
		game.removeVisual(self)
		if(motherRussia.vida() == 0)
			motherRussia.morir()
		else
			motherRussia.reducirVida()
	}
}

object balaMotherRussia {
	var property position = motherRussia.position().down(1)
	
	method image() = "balaMotherRussia.png"
	
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
		game.onTick(1000, "moverseBalaMotherRussia", { self.abajo() })
	}
	
	method restarVida() {
		game.removeVisual(self)
		if(usa.vida() == 0)
			usa.morir()
		else
			usa.reducirVida()
	}
}