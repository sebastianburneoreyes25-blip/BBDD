**cuaderno de prácticas profesional para DAM** centrado en MongoDB y Docker.

---

# **Cuaderno de Prácticas: MongoDB + Docker Compose**

## **Objetivo del módulo**
Aprender a:
- Montar MongoDB en Docker con persistencia.
- Utilizar Mongo Express para gestionar datos.
- Usar la shell de MongoDB (`mongosh`) para crear bases de datos, insertar documentos, hacer consultas y relaciones entre colecciones.

---

## **1. Preparación del entorno con Docker**

### 1.1. Estructura recomendada:

```
proyecto-mongo/
├── docker-compose.yml
├── mongo-data/             # Se crea automáticamente (persistencia)
└── mongo-init/             # Scripts de inicialización opcionales
    └── init.js
```

### 1.2. Contenido del archivo `docker-compose.yml`

```yaml
version: '3.8'

services:
  mongodb:
    image: mongo:6.0
    container_name: mongo-container
    restart: unless-stopped
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin123
    volumes:
      - ./mongo-data:/data/db
      - ./mongo-init:/docker-entrypoint-initdb.d
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.adminCommand('ping')"]
      interval: 10s
      timeout: 5s
      retries: 5

  mongo-express:
    image: mongo-express:1.0.0-alpha.4
    container_name: mongo-express
    restart: unless-stopped
    ports:
      - "8081:8081"
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: admin
      ME_CONFIG_MONGODB_ADMINPASSWORD: admin123
      ME_CONFIG_MONGODB_SERVER: mongodb
    depends_on:
      mongodb:
        condition: service_healthy
```

### 1.3. Levantar el entorno

```bash
docker compose up -d
```

Accede a Mongo Express desde: [http://localhost:8081](http://localhost:8081)

---

## **2. Script de datos de ejemplo**

### 2.1. Crear archivo `mongo-init/init.js`:

```js
db = db.getSiblingDB('instituto');

db.alumnos.insertMany([
  { _id: 1, nombre: "Carlos López", curso: "2º DAM" },
  { _id: 2, nombre: "Lucía Pérez", curso: "2º DAM" }
]);

db.asignaturas.insertMany([
  { _id: 101, nombre: "Programación" },
  { _id: 102, nombre: "Bases de Datos" }
]);

db.notas.insertMany([
  { alumno_id: 1, asignatura_id: 101, nota: 8.5 },
  { alumno_id: 1, asignatura_id: 102, nota: 7.0 },
  { alumno_id: 2, asignatura_id: 101, nota: 9.2 }
]);
```

### 2.2. Reiniciar contenedores para aplicar el script:

```bash
docker compose down -v
docker compose up -d
```

---

## **3. Comandos MongoDB desde `mongosh`**

```bash
docker exec -it mongo-container mongosh -u admin -p admin123
```

### 3.1. Seleccionar base de datos

```js
use instituto
```

### 3.2. Consultar documentos

```js
db.alumnos.find().pretty()
db.asignaturas.find()
db.notas.find()
```

---

## **4. Insertar y consultar**

### 4.1. Insertar documentos

```js
db.alumnos.insertOne({ nombre: "María López", curso: "1º DAM" })
db.asignaturas.insertOne({ nombre: "Entornos de Desarrollo" })
```

### 4.2. Consultas con filtros

```js
db.alumnos.find({ curso: "2º DAM" })
db.alumnos.find({ nombre: /Carlos/i })
```

---

## **5. Relaciones (JOINs con `$lookup`)**

```js
db.notas.aggregate([
  {
    $lookup: {
      from: "alumnos",
      localField: "alumno_id",
      foreignField: "_id",
      as: "alumno"
    }
  },
  { $unwind: "$alumno" },
  {
    $lookup: {
      from: "asignaturas",
      localField: "asignatura_id",
      foreignField: "_id",
      as: "asignatura"
    }
  },
  { $unwind: "$asignatura" },
  {
    $project: {
      _id: 0,
      alumno: "$alumno.nombre",
      asignatura: "$asignatura.nombre",
      nota: 1
    }
  }
])
```

---

## **6. Actividades propuestas**

1. Añadir 3 alumnos más y 2 asignaturas nuevas.
2. Registrar varias notas para cada alumno.
3. Consultar:
   - Alumnos con notas mayores de 8.
   - Asignaturas en las que ha participado un alumno concreto.
   - Media de notas por alumno (usando `$group`).
4. Visualizar todos los datos desde Mongo Express.

---


# Una vez que hemos entrado al shell:

Dentro del shell interactivo de MongoDB (mongosh), puedes listar las bases de datos disponibles utilizando el comando:

```js
show dbs
```
Esto mostrará todas las bases de datos existentes en tu instancia de MongoDB junto con su tamaño. Si necesitas crear o trabajar con una base de datos específica, puedes usar el comando use seguido del nombre de la base de datos:

```js
use nombre_de_la_base_de_datos
```

En MongoDB, para realizar una consulta que muestre todos los registros de una colección (similar a SELECT * FROM en SQL), puedes usar el siguiente comando en el shell interactivo (mongosh):

```js
db.nombre_de_la_coleccion.find()
```


Si deseas que los resultados se muestren de forma más legible, puedes usar:

```javascript
db.nombre_de_la_coleccion.find().pretty()
```


Por ejemplo, si estás trabajando con la colección alumnos, el comando sería:

```javascript
db.alumnos.find().pretty()
```

Esto mostrará todos los documentos de la colección alumnos.

Si no sabes el nombre de las colecciones disponibles en la base de datos, puedes listarlas con:

```javascript
show collections
```

Esto mostrará todas las colecciones dentro de la base de datos local. Luego, reemplaza nombre_de_la_coleccion con el nombre de la colección que quieras consultar.

Para mostrar los registros de forma más legible, puedes usar:

```javascript
db.nombre_de_la_coleccion.find().pretty()
```

¡Claro! Aquí tienes las **soluciones completas a las actividades propuestas** en el cuaderno de prácticas de MongoDB + Docker, con comandos comentados paso a paso para usar en `mongosh` o Mongo Express.

---

# **Solución de las Actividades Propuestas**

---

### **1. Añadir 3 alumnos más y 2 asignaturas nuevas**

```js
// Insertar alumnos
db.alumnos.insertMany([
  { _id: 3, nombre: "Juan Martínez", curso: "1º DAM" },
  { _id: 4, nombre: "Sofía Romero", curso: "2º DAM" },
  { _id: 5, nombre: "Elena Torres", curso: "1º DAM" }
]);

// Insertar asignaturas
db.asignaturas.insertMany([
  { _id: 103, nombre: "Lenguajes de marcas" },
  { _id: 104, nombre: "Acceso a datos" }
]);
```

---

### **2. Registrar varias notas para cada alumno**

```js
db.notas.insertMany([
  { alumno_id: 3, asignatura_id: 101, nota: 6.5 },
  { alumno_id: 3, asignatura_id: 102, nota: 7.8 },
  { alumno_id: 4, asignatura_id: 101, nota: 8.9 },
  { alumno_id: 4, asignatura_id: 104, nota: 9.5 },
  { alumno_id: 5, asignatura_id: 103, nota: 6.0 }
]);
```

---

### **3. Consultas**

#### a) **Alumnos con notas mayores de 8**

```js
db.notas.aggregate([
  { $match: { nota: { $gt: 8 } } },
  {
    $lookup: {
      from: "alumnos",
      localField: "alumno_id",
      foreignField: "_id",
      as: "alumno"
    }
  },
  { $unwind: "$alumno" },
  {
    $project: {
      _id: 0,
      alumno: "$alumno.nombre",
      nota: 1
    }
  }
])
```

---

#### b) **Asignaturas en las que ha participado un alumno concreto**  
(Ejemplo: `alumno_id = 4` → Sofía Romero)

```js
db.notas.aggregate([
  { $match: { alumno_id: 4 } },
  {
    $lookup: {
      from: "asignaturas",
      localField: "asignatura_id",
      foreignField: "_id",
      as: "asignatura"
    }
  },
  { $unwind: "$asignatura" },
  {
    $project: {
      _id: 0,
      asignatura: "$asignatura.nombre",
      nota: 1
    }
  }
])
```

---

#### c) **Media de notas por alumno**

```js
db.notas.aggregate([
  {
    $group: {
      _id: "$alumno_id",
      nota_media: { $avg: "$nota" }
    }
  },
  {
    $lookup: {
      from: "alumnos",
      localField: "_id",
      foreignField: "_id",
      as: "alumno"
    }
  },
  { $unwind: "$alumno" },
  {
    $project: {
      _id: 0,
      alumno: "$alumno.nombre",
      media: { $round: ["$nota_media", 2] }
    }
  },
  { $sort: { media: -1 } }
])
```

---

### **4. Visualizar todo desde Mongo Express**

1. Entra en: [http://localhost:8081](http://localhost:8081)
2. Selecciona la base de datos **`instituto`**
3. Navega por las colecciones:
   - `alumnos`: verás los 5 alumnos insertados
   - `asignaturas`: todas las asignaturas creadas
   - `notas`: incluyendo los enlaces por `alumno_id` y `asignatura_id`
4. Puedes insertar, editar, eliminar y filtrar documentos desde la interfaz.

---

