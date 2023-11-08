import wollok.game.*


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