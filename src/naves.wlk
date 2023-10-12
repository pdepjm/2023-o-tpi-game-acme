import wollok.game.*

class Nave {
	var property position
	var property vida
	var imagen
	var limiteAbajo
	var limiteArriba
	var bala
	var property ganar = false

	method image() = if(ganar) "1usa.png" else imagen 

	method moverseArriba() {
		if(position.y() < limiteArriba)
			position = position.up(1)
	}
	
	method moverseAbajo() {
		if(position.y() > limiteAbajo)
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
		game.addVisual(bala)
		bala.moverse(position)
	}
	
	method reducirVida() {
		vida -= 1
	}
	
	method morir() {
		game.removeVisual(self)
	}
}

class Bala {
	var property position
	var imagen 
	var limiteMovimiento
	var movimiento
	var nombreEvento
	const naves = [usa, motherRussia]
	
	method image() = imagen
	
	method mover(){	
		if(position.y() == limiteMovimiento)
		{
			game.removeTickEvent(nombreEvento)
			game.removeVisual(self)
		}
		else
			position = position.up(movimiento)
	}
	
	method moverse(posicion) {
		position = posicion.up(movimiento)
		game.onTick(100, nombreEvento, { self.mover() })
	}
	
	method restarVida(nave) {
		game.removeVisual(self)
		if(nave.vida() == 0)
		{
			nave.reducirVida()
			nave.morir()
			naves.remove(nave)
			naves.first().ganar(true)
		}	
		else
			nave.reducirVida()
	}
}

class Vida {
	var property position
	var property nave
	const nombreNave

	method image() = if(nave.vida() < 0) "pepita.png" else (nave.vida() + 1).stringValue() + nombreNave + ".png"
}

const balaMotherRussia = new Bala(position = motherRussia.position().down(1), 
	imagen = "balaMotherRussia.png", limiteMovimiento = 0, movimiento = -1, nombreEvento = "moverseBalaMotherRussia")

const balaUsa = new Bala(position = usa.position().up(1), imagen = "balaUsa.png", 
	limiteMovimiento = game.height() - 1, movimiento = 1, nombreEvento = "moverseBalaUsa")

const motherRussia = new Nave(position = game.at(game.width().div(2), game.height() - 1), vida = 2, 
	imagen = "pepita.png", limiteAbajo = game.height().div(2), limiteArriba = game.height() - 1, bala = balaMotherRussia)
	
const usa = new Nave(position = game.at(game.width().div(2), 0), vida = 2, 
	imagen = "pepita.png", limiteAbajo = 0, limiteArriba = game.height().div(2) - 1, bala = balaUsa)
	
const vidaUsa = new Vida(nave = usa, position = game.origin(), nombreNave = "usa")
const vidaMotherRussia = new Vida(nave = motherRussia, position = game.at(0, game.height() - 1), nombreNave = "motherRussia")