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
