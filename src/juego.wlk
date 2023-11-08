import wollok.game.*
import elMenu.*
import elAsteroide.*
import losPowerUps.*
import lasNaves.*

object juego {
	const naves = [usa, motherRussia]
	var comenzado = false
	
	method comenzar() {
		if(!comenzado)
		{
			comenzado = true
			game.removeVisual(menu)
			musicaMenu.parar()
			musicaPartida.sonar()
			game.addVisual(motherRussia)
			game.addVisual(usa)
			game.addVisual(vidaUsa)
			game.addVisual(vidaMotherRussia)
			game.addVisual(asteroide)
			
			// Colocacion de Power Ups
			game.onTick(10000, "colocarPowerUp", { self.colocarPowerUp() })
			
			// Movimiento del asteroide
			game.onTick(1000, "moverseAsteroide", { asteroide.moverse() })
			
			// Colisioness
			game.onCollideDo(usa, { objeto => objeto.interactuar(usa) })
			game.onCollideDo(motherRussia, { objeto => objeto.interactuar(motherRussia) })
		}
		
	}
	
	method powerUpAleatorio() {
		const powerUps = [new Inmunidad(imagen = "inmunidad.png",
			position = game.at((0.. game.width()-1).anyOne(), (0.. game.height()-1).anyOne())),
			new DisparoMortal(imagen = "mortal.png",
				position = game.at((0.. game.width()-1).anyOne(), (0.. game.height()-1).anyOne())),
				new DisparoAntiInmunidad(imagen = "antiInmunidad.png",
				position = game.at((0.. game.width()-1).anyOne(), (0.. game.height()-1).anyOne()))]
		return powerUps.anyOne()
	}
	
	method colocarPowerUp() {
		game.addVisual(self.powerUpAleatorio())
	}
	
	method reducirVidaNave(nave) {
		if(nave.vida() == 0)
		{
			self.terminar(nave)
		}	
		else
			nave.reducirVida()
	}
	
	method terminar(nave) {
		nave.reducirVida()
		naves.remove(nave)
		game.removeTickEvent("colocarPowerUp")
		game.allVisuals().forEach({ cosa => game.removeVisual(cosa) })
		nave.perder(true)
		naves.first().ganar(true)
		naves.first().festejar()
	}
}

class MusicaDeFondo {
	const musica
	
	method sonar() {
		musica.shouldLoop(true)
		musica.volume(1)
		game.schedule(500, {musica.play()})
	}
	
	method parar() {
		musica.stop()
	}
}

const musicaMenu = new MusicaDeFondo(musica = game.sound("cancionMenu.mp3"))
const musicaPartida = new MusicaDeFondo(musica = game.sound("duelOfFates.mp3"))

class Vida {
	var property position
	var property nave

	method image() = if(nave.vida() < 0) "vacio.png" else (nave.vida() + 1).stringValue() + nave.nombreNave() + ".png"
	
	method interactuar(laNave){}
}

const motherRussia = new Nave(position = game.at(game.width().div(2), game.height() - 1), vida = 2, 
	limiteAbajo = game.height().div(2), limiteArriba = game.height() - 1, nombreNave = "motherRussia",
	limite = 0, direccion = -1)
	
const usa = new Nave(position = game.at(game.width().div(2), 0), vida = 2, 
	limiteAbajo = 0, limiteArriba = game.height().div(2) - 1, nombreNave = "usa",
	limite = game.height() - 1, direccion = 1)
	
const vidaUsa = new Vida(nave = usa, position = game.origin())
const vidaMotherRussia = new Vida(nave = motherRussia, position = game.at(0, game.height() - 1))
