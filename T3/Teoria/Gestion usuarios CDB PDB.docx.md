\-Usuarios comunes 

Existen en todos los PDB 

Requiere prefijo C\#\#

Acceso a múltiples PDBs

Permisos y roles aplicables en todos los PDBs 

Uso típico administración a nivel CDB

\-Usuarios locales 

Existen en un PDB específico

No requiere prefijo

Acceso solo dentro de su PDB

Permisos y roles solo en a PDB donde se creó

Uso típico 

CREAR USUARIOS 

comun

CREATE USER c\#\#\<username\> IDENTIFIED BY \<password\>;

GRANT CREATE SESSION TO c\#\#\<username\>; //Solo 

local

CREATE USER \<username\> IDENTIFIED BY \<password\>;

GRANT CREATE SESSION TO c\#\#\<username\>; //Solo 

GRANT DBA TO c\#\#nombre\_usuario;

GRANT DBA TO nombre\_usuario;

SELECT \* FROM DBA\_SYS\_PRIVS WHERE GRANTEE=’NOMBRE\_USUARIO’; /\* consultar privilegios\*/

