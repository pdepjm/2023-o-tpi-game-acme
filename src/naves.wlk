import wollok.game.*

object musicaDeFondo {
	const musica = game.sound("cancionDeFondo.mp3")
	
	method sonar() {
		musica.shouldLoop(true)
		musica.volume(0.5)
		game.schedule(500, {musica.play()})
	}
	
	method parar() {
		musica.stop()
	}
}

object asteroide {
	var property position = game.at((0.. game.width()-1).anyOne(), (0.. game.height()-1).anyOne())
	var rebotoArriba = false
	var rebotoDerecha = false
	
	method image() = "asteroide.png"
	
	method moverseDiagonal(direccion) {
		if( position.x() < game.width() - 1 && !rebotoDerecha)	
		{
			position = position.up(direccion).right(1)
			rebotoDerecha = false
		}
		else
		{
			if(position.x() > 0)
			{
				position = position.up(direccion).left(1)
				rebotoDerecha = true	
			}
			else
				rebotoDerecha = false
		}
	}

	method moverse() {
		if(position.y() < game.height() - 1 && !rebotoArriba)
		{
			self.moverseDiagonal(1)
			rebotoArriba = false
		}
		else
		{
			if(position.y() > 0)
			{
				self.moverseDiagonal(-1)
				rebotoArriba = true
			}	
			else
				rebotoArriba = false
		}	
	}
}

class Nave {
	var property position
	var property vida
	var imagen
	var limiteAbajo
	var limiteArriba
	var bala
	var nombreNave
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
	
	method tocarCancionVictoria(){
		musicaDeFondo.parar()
		game.sound("cancionVictoria"+ nombreNave +".mp3").play()
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
			naves.first().tocarCancionVictoria()
		}	
		else
			nave.reducirVida()
	}
}

class Vida {
	var property position
	var property nave
	const nombreNave

	method image() = if(nave.vida() < 0) "vacio.png" else (nave.vida() + 1).stringValue() + nombreNave + ".png"
}

const balaMotherRussia = new Bala(position = motherRussia.position().down(1), 
	imagen = "balaMotherRussia.png", limiteMovimiento = 0, movimiento = -1, nombreEvento = "moverseBalaMotherRussia")

const balaUsa = new Bala(position = usa.position().up(1), imagen = "balaUsa.png", 
	limiteMovimiento = game.height() - 1, movimiento = 1, nombreEvento = "moverseBalaUsa")

const motherRussia = new Nave(position = game.at(game.width().div(2), game.height() - 1), vida = 2, 
	imagen = "pepita.png", limiteAbajo = game.height().div(2), limiteArriba = game.height() - 1, 
	nombreNave = "motherRussia", bala = balaMotherRussia)
	
const usa = new Nave(position = game.at(game.width().div(2), 0), vida = 2, 
	imagen = "pepita.png", limiteAbajo = 0, limiteArriba = game.height().div(2) - 1, 
	nombreNave = "usa", bala = balaUsa)
	
const vidaUsa = new Vida(nave = usa, position = game.origin(), nombreNave = "usa")
const vidaMotherRussia = new Vida(nave = motherRussia, position = game.at(0, game.height() - 1), nombreNave = "motherRussia")