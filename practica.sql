CREATE DATABASE IF NOT EXISTS practica3;
USE practica3;

CREATE TABLE IF NOT EXISTS persona (
    cedula INT(10) PRIMARY KEY,
    nombre VARCHAR(20),
    apellido VARCHAR(20),
    peso INT(20),
    estado VARCHAR(20)
);

SELECT * FROM practica3.persona;
DROP TABLE persona;

DELIMITER //
CREATE PROCEDURE donarSangre(
    IN _cedula INT,
    IN _nombre VARCHAR(100),
    IN _apellido VARCHAR(100),
    IN _peso INT
)
BEGIN
    IF _peso < 50 THEN
        INSERT INTO persona (cedula, nombre, apellido, peso, estado) 
        VALUES (_cedula, _nombre, _apellido, _peso, 'No admitido');
    ELSE
        INSERT INTO persona (cedula, nombre, apellido, peso, estado) 
        VALUES (_cedula, _nombre, _apellido, _peso, 'Admitido');
    END IF;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS donarSangre;

CREATE TABLE clientes (
    cedula INT(10) PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100)
);

SELECT * FROM practica3.clientes;

DELIMITER //
CREATE PROCEDURE insertarCliente(
    IN _cedula INT,
    IN _nombre VARCHAR(100),
    IN _apellido VARCHAR(100)
)
BEGIN
    INSERT INTO clientes (cedula, nombre, apellido) VALUES (_cedula, _nombre, _apellido);
END//
DELIMITER ;

call practica3.insertarCliente(1233, 'david', 'salgado');
SELECT * FROM practica3.clientes;

DELIMITER //
CREATE PROCEDURE actualizarNombreCliente(
    IN _cedula INT,
    IN _nuevoNombre VARCHAR(100)
)
BEGIN
    UPDATE clientes SET nombre = _nuevoNombre WHERE cedula = _cedula;
END//
DELIMITER ;

call practica3.actualizarNombreCliente(1233, 'brayan');
SELECT * FROM practica3.clientes;

DELIMITER //
CREATE PROCEDURE eliminarCliente(
    IN _cedula INT
)
BEGIN
    DELETE FROM clientes WHERE cedula = _cedula;
END//
DELIMITER ;

call practica3.eliminarCliente(1233);
SELECT * FROM practica3.clientes;

DELIMITER //
CREATE PROCEDURE obtenerTotalClientes(
    OUT _total INT
)
BEGIN
    SELECT COUNT(*) INTO _total FROM clientes;
END//
DELIMITER ;

set @_total = 0;
call practica3.obtenerTotalClientes(@_total);
select @_total;

DELIMITER //
CREATE PROCEDURE ejemploCicloWhile()
BEGIN
    DECLARE contador INT DEFAULT 0;
    
    -- Inicio del ciclo WHILE
    WHILE contador < 10 DO
        -- Hacer algo en cada iteración
        SET contador = contador + 1;
    END WHILE;
    -- Fin del ciclo WHILE
END//
DELIMITER ;

call practica3.ejemploCicloWhile();

CREATE TABLE empleado (
	cedula int PRIMARY KEY,
    nombre varchar(100),
    salario_basico decimal(20, 2),
    subsidio decimal(10, 2),
    salud decimal(10, 2),
    pension decimal(10, 2),
    bono decimal(10, 2),
    salario_integral decimal(10, 2)
);

DELIMITER //
CREATE FUNCTION calcularSubsidioTransporte(_salario_basico DECIMAL(20, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE _subsidio_transport DECIMAL(10, 2);
    SET _subsidio_transport = _salario_basico * 0.07;
    RETURN _subsidio_transport;
END//
DELIMITER ;

select practica3.calcularSubsidioTransporte(1200000);

DELIMITER //
CREATE FUNCTION calcularSalud(_salario_basico DECIMAL(20, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE _salud DECIMAL(10, 2);
    SET _salud = _salario_basico * 0.04;
    RETURN _salud;
END//
DELIMITER ;

select practica3.calcularSalud(1320000);

DELIMITER //
CREATE FUNCTION calcularSalarioIntegral(_salario_basico DECIMAL(20, 2), 
_subsidio DECIMAL(10, 2), _salud DECIMAL(10, 2), _pension DECIMAL(10, 2), 
_bono DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE _salario_integral DECIMAL(10, 2);
    SET _salario_integral = _salario_basico + _subsidio - _salud - _pension + _bono;
    RETURN _salario_integral;
END//
DELIMITER ;

select practica3.calcularSalarioIntegral(1200000, 80000, 50000, 30000, 20000);

DELIMITER //
CREATE PROCEDURE insertarEmpleado(
    IN _cedula INT,
    IN _nombre VARCHAR(100),
    IN _salario_basico DECIMAL(20, 2),
    IN _bono DECIMAL(10, 2)
)
BEGIN
    DECLARE _subsidio_transport DECIMAL(10, 2);
    DECLARE _salud DECIMAL(10, 2);
    DECLARE _pension DECIMAL(10, 2);
    DECLARE _salario_integral DECIMAL(10, 2);
    
    SET _subsidio_transport = calcularSubsidioTransporte(_salario_basico);
    
    SET _salud = calcularSalud(_salario_basico);
    
    SET _pension = _salario_basico * 0.03;
    SET _salario_integral = calcularSalarioIntegral(_salario_basico, _subsidio_transport, 
    _salud, _pension, _bono);
    
    INSERT INTO empleado (cedula, nombre, salario_basico, subsidio, salud, pension, bono, salario_integral)
    VALUES (_cedula, _nombre, _salario_basico, _subsidio_transport, _salud, _pension, _bono, _salario_integral);
    
    SELECT * FROM empleado WHERE cedula = _cedula;
END//
DELIMITER ;

call practica3.insertarEmpleado(23454, 'BRAYAN', 1345000, 80000);
