import wollok.game.*

object musicaDeFondo {
	const musica = game.sound("duelOfFates.mp3")
	
	method sonar() {
		musica.shouldLoop(true)
		musica.volume(0.2)
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
	var limiteAbajo
	var limiteArriba
	var nombreNave
	var limite
	var direccion
	var property ganar = false

	method image() = if(ganar) nombreNave + "Victoria.png" else nombreNave + ".png"

	method nombreNave() = nombreNave

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
		const bala = new Bala(position = self.position().down(1), 
		nombreNave = self.nombreNave(), limiteMovimiento = limite, movimiento = direccion)
		game.sound("blasterSonido.mp3").play()
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
	var nombreNave
	var limiteMovimiento
	var movimiento
	const naves = [usa, motherRussia]
	
	method image() = "bala" + nombreNave + ".png"
	
	method mover(){	
		if(position.y() == limiteMovimiento)
		{
			game.removeTickEvent("moverseBala" + nombreNave)
			game.removeVisual(self)
		}
		else
			position = position.up(movimiento)
	}
	
	method moverse(posicion) {
		position = posicion.up(movimiento)
		game.onTick(100, "moverseBala" + nombreNave, { self.mover() })
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

	method image() = if(nave.vida() < 0) "vacio.png" else (nave.vida() + 1).stringValue() + nave.nombreNave() + ".png"
}

const motherRussia = new Nave(position = game.at(game.width().div(2), game.height() - 1), vida = 2, 
	limiteAbajo = game.height().div(2), limiteArriba = game.height() - 1, nombreNave = "motherRussia",
	limite = 0, direccion = -1)
	
const usa = new Nave(position = game.at(game.width().div(2), 0), vida = 2, 
	limiteAbajo = 0, limiteArriba = game.height().div(2) - 1, nombreNave = "usa",
	limite = game.height() - 1, direccion = 1)
	
const vidaUsa = new Vida(nave = usa, position = game.origin())
const vidaMotherRussia = new Vida(nave = motherRussia, position = game.at(0, game.height() - 1))