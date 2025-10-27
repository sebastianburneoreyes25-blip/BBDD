# EJERCICIO PRÁCTICO PARA ALUMNOS SOBRE ENTIDADES:

## Identifica si las siguientes entidades son fuertes o débiles y justifica tu respuesta:

1. LIBRO y CAPÍTULO

En este caso, el libro es una entidad fuerte ya que este se identifica por sí solo, y puede existir por sí solo.  
Capitulo sera entidad débil ya que no puede existir por sí solo y necesita del identificador del libro para ser identificado(es decir una FK)

2. UNIVERSIDAD y ESTUDIANTE

Una universidad puede existir por sí sola, y no necesita de otras entidades para diferenciarse, así que es una entidad fuerte. Por otra parte, el estudiante es una entidad fuerte ya que no necesita de otra entidad para identificarse.

3. PEDIDO y ARTÍCULO (el artículo del catálogo, no la línea de pedido)

En este caso, ambos son entidades fuertes, ya que ambos pueden existir y distinguirse sin necesidad de la FK de otra entidad.

4. HOTEL y HABITACIÓN

En este caso, Hotel será una entidad fuerte ya que puede existir por sí solo, y no necesita FK para identificarse. Sin embargo, una habitación no puede existir sin hotel y por ende es una entidad débil.

5.  AUTOR y LIBRO

El Autor será entidad fuerte ya que se identificará y existirá por sí solo. Libro es no dependiente de autor para identificarse, con lo cual será fuerte  
