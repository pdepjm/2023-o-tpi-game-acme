import wollok.game.*
import elMenu.*
import juego.*

class Bala {
	var property position
	var nombreNave
	var limiteMovimiento
	var movimiento
	var esMortal
	var esAntiInmunidad
//	const direccion
	
	method image() = "bala" + nombreNave + ".png"
	
	method mover(){	
		if(position.y() == limiteMovimiento && game.hasVisual(self))
		{
			game.removeTickEvent("moverseBala" + nombreNave)
			game.removeVisual(self)
		}
		else
			position =  position.up(movimiento)
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