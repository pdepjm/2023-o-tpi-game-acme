import wollok.game.*
import elMenu.*
import elAsteroide.*
import losPowerUps.*
import juego.*
import laBala.*

class Nave {
	var property position
	var property vida
	var limiteAbajo
	var limiteArriba
	var nombreNave
	var limite
	var direccion
	var property inmunidad = false
	var property disparoMortal = false
	var property disparoAntiInmunidad = false
	var property ganar = false
	var property perder = false
	
	method image() = if(ganar) nombreNave + "Victoria.png" else nombreNave + ".png"
	
	method nombreNave() = nombreNave

//	method puedoMoverme() = position.y() < limiteArriba && !ganar && !perder && position.y() > limiteAbajo

	method moverseArriba() {
		if(position.y() < limiteArriba && !ganar)
			position = position.up(1)
	}
	
	method moverseAbajo() {
		if(position.y() > limiteAbajo && !ganar)
			position = position.down(1)
	}
	
	method moverseIzquierda() {
		if(!ganar && !perder)
		{
			if(position.x() > 0)
				position = position.left(1)
			else
				position = game.at(game.width() - 1, position.y())
		}
		
	}
	
	method moverseDerecha() {
		if(!ganar && !perder)
		{
			if(position.x() < game.width() - 1 && !ganar)
				position = position.right(1)
			else
				position = game.at(0, position.y())
		}
	}
	
	method disparar() {
		const bala = new Bala(position = self.position().down(1), 
		nombreNave = self.nombreNave(), limiteMovimiento = limite, movimiento = direccion,
		esMortal = disparoMortal, esAntiInmunidad = disparoAntiInmunidad)
		if(!ganar && !perder)
		{
			game.sound("blasterSonido.mp3").play()
			game.addVisual(bala)
			bala.moverse(position)
		}	
	}
	
	method reducirVida() {
		vida -= 1
	}
	
	method festejar() {
		self.tocarCancionVictoria()
		position = game.origin()
		game.addVisual(self)
	}
	
	method tocarCancionVictoria() {
		musicaPartida.parar()
		game.sound("cancionVictoria"+ nombreNave +".mp3").play()
	}
}