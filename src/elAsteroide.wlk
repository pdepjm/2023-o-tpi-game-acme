import wollok.game.*
import juego.*


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