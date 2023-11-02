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

class PowerUp {
	var property position 
	var imagen
	method image() = imagen
	
 	method aplicarPowerUp(nave)
 	
 	method interactuar(nave) {
  		game.removeVisual(self)
  		self.aplicarPowerUp(nave)
 	}
}

class Inmunidad inherits PowerUp {
	override method aplicarPowerUp(nave) {
  		nave.inmunidad(true)
		game.schedule(10000, { nave.inmunidad(false) })
	}
}

class DisparoMortal inherits PowerUp {
	override method aplicarPowerUp(nave) {
		nave.disparoMortal(true)
		game.schedule(10000, { nave.disparoMortal(false) })
	}
}

class DisparoAntiInmunidad inherits PowerUp {
	override method aplicarPowerUp(nave) {
		nave.disparoAntiInmunidad(true)
		game.schedule(10000, { nave.disparoAntiInmunidad(false) })
	}
}

object asteroide {
	var property position = game.at((0.. game.width()-1).anyOne(), (0.. game.height()-1).anyOne())
	var rebotoArriba = false
	var rebotoDerecha = false
	
	method image() = "asteroide.png"
	
	method interactuar(nave) {
		if(!nave.inmunidad())
			juego.terminar(nave)
	}
	
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
	var property inmunidad = false
	var property disparoMortal = false
	var property disparoAntiInmunidad = false
	var property ganar = false
	var property perder = false
	
	method image() = if(ganar) nombreNave + "Victoria.png" else nombreNave + ".png"
	
	method nombreNave() = nombreNave

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
		if(!game.hasVisual(bala) && !ganar && !perder)
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

class Bala {
	var property position
	var nombreNave
	var limiteMovimiento
	var movimiento
	var esMortal
	var esAntiInmunidad
	
	method image() = "bala" + nombreNave + ".png"
	
	method mover(){	
		if(position.y() == limiteMovimiento && game.hasVisual(self))
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
	
	method interactuar(nave) {
		if(esMortal)
		{
			juego.terminar(nave)
		}
		else
		{
			if(!nave.inmunidad() || esAntiInmunidad)
			{				
				game.removeVisual(self)
				juego.reducirVidaNave(nave)
			}
		}
	}
}

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
