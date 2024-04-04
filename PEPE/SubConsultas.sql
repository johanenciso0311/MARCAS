DROP DATABASE IF EXISTS empleados;
CREATE DATABASE empleados CHARACTER SET utf8mb4;
USE empleados;

CREATE TABLE departamento (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  presupuesto DOUBLE UNSIGNED NOT NULL,
  gastos DOUBLE UNSIGNED NOT NULL
);

CREATE TABLE empleado (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nif VARCHAR(9) NOT NULL UNIQUE,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  id_departamento INT UNSIGNED,
  FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

INSERT INTO departamento VALUES(1, 'Desarrollo', 120000, 6000);
INSERT INTO departamento VALUES(2, 'Sistemas', 150000, 21000);
INSERT INTO departamento VALUES(3, 'Recursos Humanos', 280000, 25000);
INSERT INTO departamento VALUES(4, 'Contabilidad', 110000, 3000);
INSERT INTO departamento VALUES(5, 'I+D', 375000, 380000);
INSERT INTO departamento VALUES(6, 'Proyectos', 0, 0);
INSERT INTO departamento VALUES(7, 'Publicidad', 0, 1000);

INSERT INTO empleado VALUES(1, '32481596F', 'Aarón', 'Rivero', 'Gómez', 1);
INSERT INTO empleado VALUES(2, 'Y5575632D', 'Adela', 'Salas', 'Díaz', 2);
INSERT INTO empleado VALUES(3, 'R6970642B', 'Adolfo', 'Rubio', 'Flores', 3);
INSERT INTO empleado VALUES(4, '77705545E', 'Adrián', 'Suárez', NULL, 4);
INSERT INTO empleado VALUES(5, '17087203C', 'Marcos', 'Loyola', 'Méndez', 5);
INSERT INTO empleado VALUES(6, '38382980M', 'María', 'Santana', 'Moreno', 1);
INSERT INTO empleado VALUES(7, '80576669X', 'Pilar', 'Ruiz', NULL, 2);
INSERT INTO empleado VALUES(8, '71651431Z', 'Pepe', 'Ruiz', 'Santana', 3);
INSERT INTO empleado VALUES(9, '56399183D', 'Juan', 'Gómez', 'López', 2);
INSERT INTO empleado VALUES(10, '46384486H', 'Diego','Flores', 'Salas', 5);
INSERT INTO empleado VALUES(11, '67389283A', 'Marta','Herrera', 'Gil', 1);
INSERT INTO empleado VALUES(12, '41234836R', 'Irene','Salas', 'Flores', NULL);
INSERT INTO empleado VALUES(13, '82635162B', 'Juan Antonio','Sáez', 'Guerrero', NULL);

# 1.2.7 Subconsultas
# 1.2.7.1 Con operadores básicos de comparación
# 1 Devuelve un listado con todos los empleados que tiene el departamento de Sistemas. (Sin utilizar INNER JOIN).

    SELECT *
    FROM empleado
    WHERE id_departamento = (
    SELECT departamento.id
    FROM departamento
    WHERE departamento.id = 2);


# 2 Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada.

    SELECT departamento.nombre, departamento.presupuesto
    FROM departamento
    WHERE presupuesto = (SELECT MAX(presupuesto) FROM departamento);

# 3 Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada.

SELECT departamento.nombre, departamento.presupuesto
FROM departamento
WHERE presupuesto = (SELECT MIN(presupuesto) FROM departamento);

# 1.2.7.2 Subconsultas con ALL y ANY

# 4 Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada. Sin hacer uso de MAX, ORDER BY ni LIMIT.

    SELECT nombre, presupuesto
    FROM departamento
    WHERE presupuesto >= ALL (SELECT presupuesto
                              FROM departamento AS departamento2
                              WHERE departamento2.id <> departamento.id);

# 5 Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada. Sin hacer uso de MIN, ORDER BY ni LIMIT.

    SELECT nombre, presupuesto
    FROM departamento
    WHERE presupuesto = ANY (SELECT presupuesto
                             FROM departamento AS departamento2
                             WHERE departamento2.id <> departamento.id);

# 6 Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando ALL o ANY).

    SELECT departamento.nombre
    FROM departamento
    WHERE id = ANY (SELECT empleado.id_departamento FROM empleado);

# 7 Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando ALL o ANY).

SELECT nombre
FROM departamento
WHERE NOT EXISTS (
    SELECT 1
    FROM empleado
    WHERE id_departamento = departamento.id
);


SELECT nombre
FROM departamento
WHERE id <> ANY (
    SELECT id_departamento
    FROM empleado
    WHERE id_departamento IS NOT NULL
);


#1.2.7.3 Subconsultas con IN y NOT IN
# 8 Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando IN o NOT IN).

SELECT departamento.nombre
FROM departamento
WHERE id IN (SELECT empleado.id_departamento
             FROM empleado);

# 9 Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando IN o NOT IN).

SELECT departamento.nombre
FROM departamento
WHERE id NOT IN (SELECT empleado.id_departamento
                 FROM empleado);

# 1.2.7.4 Subconsultas con EXISTS y NOT EXISTS
# 10 Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando EXISTS o NOT EXISTS).

SELECT departamento.nombre
FROM departamento
WHERE exists(SELECT 1
             FROM empleado
             WHERE id_departamento = departamento.id);

# 11 Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando EXISTS o NOT EXISTS).


SELECT departamento.nombre
FROM departamento
WHERE  NOT EXISTS(SELECT 1
                 FROM empleado
                 WHERE id_departamento = departamento.id);
