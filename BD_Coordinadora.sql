
                            --Create 3 tablespaces
--First one with 3Gb and 1 datafile, the name of the tablespace 

create tablespace coordinadora datafile 
'DatFileCoordinadora' size 3000M;

--Undo tablespace with 100Mb and 1 datafile 
--(Set this tablespace to be used in the system)

create UNDO TABLESPACE undotscoordinadora
   DATAFILE 'undotbsCoord.dbf'
   SIZE 100M;

--Bigfile tablespace of 4Gb
create BIGFILE TABLESPACE bigtbs_Coordinadora
  DATAFILE 'bigtbCoord_f1.dbf'
  SIZE 4000M;
--------------------------------------------------------------
--Create an user with the username amartinezg.
--The user should be assigned to the tablespace.
--There are no restrictions of space for this user.
--The role of the user should be dba
--The user should be able to connect to the system.

CREATE USER amartinezg 
IDENTIFIED BY amartinezg 
DEFAULT TABLESPACE COORDINADORA 
QUOTA UNLIMITED ON COORDINADORA;

grant create session to amartinezg;
grant dba to amartinezg;

-------------------------------------------------------------------
                          --Create 3 profiles:
--Profile 1: clerk with a password life of 40 days, 
--one session per user, 15 minutes of idle, 
--3 failed login attempts.

CREATE PROFILE CLERK LIMIT 
      SESSIONS_PER_USER 1
      IDLE_TIME 15   
      FAILED_LOGIN_ATTEMPTS 3
      PASSWORD_LIFE_TIME 40;

--profile 2: development with a password life of 100 days,
--two sessions per user, 30 minutes of idle and no failed login attempts.

CREATE PROFILE DEVELOPMENT LIMIT 
      SESSIONS_PER_USER 2
      IDLE_TIME 30   
      FAILED_LOGIN_ATTEMPTS 1
      PASSWORD_LIFE_TIME 100;


--Profile 3: operative with a password life of 30 days, 
--one session per user, 5 minutes of idle, 4 failed login attemps. 
--This profile can reuse the password after 30 days if the 
--password has already been changed 3 times.


CREATE PROFILE OPERATIVE LIMIT 
      SESSIONS_PER_USER 1
      IDLE_TIME 5   
      FAILED_LOGIN_ATTEMPTS 4
      PASSWORD_LIFE_TIME 30
      PASSWORD_REUSE_MAX 3
      PASSWORD_REUSE_TIME 30;

------------------------------------------------------------------------
--Create 3 users:

--USER 1

CREATE USER luisaMuriel 
IDENTIFIED BY luisaMuriel 
DEFAULT TABLESPACE COORDINADORA 
QUOTA UNLIMITED ON COORDINADORA;

--USER 2

CREATE USER RaulPerez 
IDENTIFIED BY Raul123 
DEFAULT TABLESPACE COORDINADORA 
QUOTA UNLIMITED ON COORDINADORA;

--USER 3

CREATE USER CarlosGonzalez   
IDENTIFIED BY CarlosG 
DEFAULT TABLESPACE COORDINADORA 
QUOTA UNLIMITED ON COORDINADORA;

--ASIGNACION PERFIL A USUARIOS

ALTER USER CarlosGonzalez PROFILE clerk;
ALTER USER luisaMuriel PROFILE OPERATIVE;
ALTER USER RaulPerez PROFILE DEVELOPMENT;

grant create session to CarlosGonzalez;
grant create session to luisaMuriel;
grant create session to RaulPerez;

---BASE DE DATOS COORDINADORA-----
---CRISTIAN CAMILO MONTOYA-----


----------------------------------------------------------------
--CREACION TABLA DEPARTAMENTOS---
CREATE table Departamentos (
	id_departamento INT,
	nombre VARCHAR(50)NOT NULL
);

--CLAVE PRIMARIA TABLA DEPARTAMENTOS---
ALTER TABLE DEPARTAMENTOS 
 ADD PRIMARY KEY 
 (id_departamento) ENABLE;
 
------------------------------------------------------------------
--CREACION TABLA MUNICIPIOS---
create table Municipios (
	id_municipio INT,
	nombre VARCHAR(50) NOT NULL,
  id_departamento INT
);

--CREACION CLAVE FORANEA FORANEA DEPTOS-MUNICIPIOS--
alter table MUNICIPIOS
  add constraint Codigos_Postales_Municipios_FK
  foreign key (id_departamento)
  references DEPARTAMENTOS (id_departamento);
  
--- CLAVE PRIMARIA MUNICIPIOS---
ALTER TABLE Municipios ADD PRIMARY KEY 
 (id_municipio) ENABLE;
 
----------------------------------------------------------------------- 
 
--CREACION TABLA CODIGOS_POSTALES--
 create table CODIGOS_POSTALES (
	id_postal INT,
	codigo_postal VARCHAR(10) NOT NULL,
  id_municipio INT
);

--CLAVE PRIMARIA CODIGOS_POSTABLES--
ALTER TABLE CODIGOS_POSTALES ADD PRIMARY KEY 
 (id_postal) ENABLE;
 
 --CLAVE FORANEA CODIGOS_POSTALES_MUNICIPIOS--
alter table CODIGOS_POSTALES
  add constraint MUNICIPIOS_DEPARTAMENTOS_FK
  foreign key (id_municipio)
  references MUNICIPIOS (iD_municipio);
  
  
---------------------------------------------------------------------------- 
-- CREACION TIPOS_CENTRO_RECIBO---
 create table TIPOS_CENTRO_RECIBO (
	id INT,
	descripcion VARCHAR(15)NOT NULL
);

--CREACION CLAVE PRIMARIA TIPOS_CENTRO_RECIBO--
ALTER TABLE TIPOS_CENTRO_RECIBO ADD PRIMARY KEY 
 (id) ENABLE;
 
 --------------------------------------------------------------------
 --CREACION TABLA CENTROS_RECIBO--
  create table CENTROS_RECIBO (
	id_centro_recibo INT,
	descripcion VARCHAR(100) NOT NULL,
  id_municipio INT,
  id_tipo_centro_recibo INT,
  id_vehiculo INT,
  direccion VARCHAR(200)NOT NULL,
  telefono varchar(30)NOT NULL
);


--CREACION CLAVE PRIMARIA CENTROS_RECIBO--
ALTER TABLE CENTROS_RECIBO ADD PRIMARY KEY 
 (id_centro_recibo) ENABLE;
 
 --CREACION CLAVE FORANEA CENTROS_RECIBO_MUNICIPIOS--
alter table CENTROS_RECIBO
  add constraint Centros_recibo_Municipios_FK
  foreign key (id_municipio)
  references MUNICIPIOS (iD_municipio);
  
---CREACION CLAVE FORANEA CENTROS_RECIBOS_TIPO_CENTROS_RECIBO--
alter table CENTROS_RECIBO
  add constraint Centros_recibo_Tipos_centro_recibo_FK
  foreign key (id_tipo_centro_recibo)
  references TIPOS_CENTRO_RECIBO (id);
  
  
----------------------------------------------------------------  
--CREACION TABLA VEHICULOS-----
  create table VEHICULOS (
	id_vehiculo INT,
	placa VARCHAR(9) NOT NULL,
  marca VARCHAR(20)NOT NULL,
  MODELO varchar(8)not null,
  LINEA VARCHAR(15)NOT NULL,
  KILOMETRAJE INT,
  CAPACIDAD VARCHAR(10)NOT NULL,
  COMBUSTIBLE VARCHAR(15)NOT NULL
); 

--CREACION CLAVE PRIMARIA VEHICULOS ---
ALTER TABLE VEHICULOS ADD PRIMARY KEY 
 (id_vehiculo) ENABLE;
 
--CREACION CONSTRAINT MARCA--
ALTER TABLE VEHICULOS
ADD CONSTRAINT MARCA_VEHICULO
CHECK (marca IN ('Chevrolet', 'Hino', 
'Foton','JAC','Hyundai','Kenworth','International',
'JMC'));

--CREACION CONSTRAINT COMBUSTIBLE--
ALTER TABLE VEHICULOS
ADD CONSTRAINT COMBUSTIBLE_VEHICULO
CHECK (COMBUSTIBLE IN ('Gasolina', 'GAS','DIESEL'));

--CREACION CONSTRAINT CAPACIDAD--
ALTER TABLE VEHICULOS
ADD CONSTRAINT CAPACIDAD_VEHICULO
CHECK (CAPACIDAD IN ('2.5 TON', '2.8 TON', '3.3 TON', '3.5 TON',
'5 TON', '6 TON', '11 TON','700 KG'));

--CREACION CLAVE FORANEA VEHICULOS_CENTRO_RECIBO
alter table CENTROS_RECIBO
  add constraint Centros_recibo_Vehiculos_FK
  foreign key (id_vehiculo)
  references VEHICULOS (id_vehiculo);
---------------------------------------------------------------------

---CREACION TABLA EMPLEADOS---
create table EMPLEADOS (
	id_empleado INT,
	cedula VARCHAR(20) NOT NULL,
  nombre VARCHAR2(100)NOT NULL,
  direccion VARCHAR2(70)not null,
  telefono VARCHAR2(20)NOT NULL,
  salario DECIMAL(10,2) NOT NULL,
  id_jefe INT,
  cargo VARCHAR(20)NOT NULL,
  tipo_empleado VARCHAR(20)NOT NULL
);

alter table empleados
  add centro_recibo INT not null;

--CREACION CLAVE PRIMARIA EMPLEADOS----
ALTER TABLE EMPLEADOS ADD PRIMARY KEY 
 (id_empleado) ENABLE;
 
 ---CREACION CLAVE FORANEA EMPLEADO_CENTRO_RECIBO--
 
 alter table EMPLEADOS
  add constraint Empleados_Centro_Recibo_FK
  foreign key (centro_recibo)
  references CENTROS_RECIBO (id_centro_recibo);
 
 --CREACION CLAVE FORANEA EMPLEADO_JEFE---
alter table EMPLEADOS
  add constraint Empleados_Empleados_FK
  foreign key (id_jefe)
  references EMPLEADOS (id_empleado);
  
  --CREACION CONSTRAINT PARA CARGO_EMPLEADO---
  
  ALTER TABLE EMPLEADOS
 ADD CONSTRAINT CARGO
 CHECK (CARGO IN ('Operacion', 'Nomina','Talento Humano',
  'tecnica','negocios','mercadeo','ventas','Informatica'));
  

  
    --CREACION CONSTRAINT PARA TIPO_EMPLEADO---
  
  ALTER TABLE EMPLEADOS
 ADD CONSTRAINT tipo_empleado
 CHECK (tipo_empleado IN ('Ordinario', 'Supervisor','lìder'));
 
---------------------------------------------------------------------
 
 ---CREACION TABLA CLIENTES--- 
  create table CLIENTES(
	id_cliente INT,
	cedula VARCHAR(15) NOT NULL,
  nombre VARCHAR2(100)NOT NULL,
  direccion varchar(40)not null,
  telefono VARCHAR2(70)NOT NULL
  
);

ALTER TABLE CLIENTES ADD PRIMARY KEY 
 (id_cliente) ENABLE;
 
-------------------------------------------------------------------------
  
--CREACION TABLA ENVIOS----
create table ENVIOS (
	id INT,
	numero_guia VARCHAR(20) NOT NULL,
  peso_real number NOT NULL,
  ancho_envio number not null,
  alto_envio number NOT NULL,
  peso_envio number NOT NULL,
  fecha_hora_envio TIMESTAMP not null,
  fecha_entrega DATE NOT NULL,
  observaciones VARCHAR(100)NOT NULL,
  unidades_envio INT NOT NULL,
  flete_fijo DECIMAL(10,2)not null,
  flete_variable DECIMAL(10,2)not null,
  otros_valores DECIMAL(10,2) null,
  id_municipio_destino int, 
  id_centro_recibo int,
  tipo_envio varchar(15)not null,
  id_cliente_remitente int,
  id_cliente_destino int
);

alter table ENVIOS
  modify fecha_entrega TIMESTAMP;


---CREACION CLAVE PRIMARIA ENVIOS---
ALTER TABLE ENVIOS ADD PRIMARY KEY 
 (id) ENABLE;
 
---CREACION CLAVE FORANEA ENVIOS_CLIENTE_DESTINO--
 alter table ENVIOS
  add constraint FK_Cliente_destino_envio
  foreign key (id_cliente_destino)
  references CLIENTES (id_cliente);

--CREACION CLAVE FORANEA ENVIOS_CLIENTE_REMITENTE--- 
alter table ENVIOS
  add constraint FK_Cliente_remitente_envio
  foreign key (id_cliente_remitente)
  references CLIENTES (id_cliente);
  
---CREACION CLAVE FORANEA ENVIOS_MUNICIPIO_DESTINO--
alter table ENVIOS
  add constraint Envios_Municipios_FK
  foreign key (id_municipio_destino)
  references MUNICIPIOS (iD_municipio);
  
  -------------CREACION CLAVE FORANEA ENVIOS_MUNICIPIO_ORIGEN------------------
  
alter table ENVIOS 
  add id_municipio_origen INT not null;
  
alter table ENVIOS
  add constraint Envios_Municipios_Orign_FK
  foreign key (id_municipio_origen)
  references MUNICIPIOS (iD_municipio);  
  
--CREACION CLAVE FORANEA ENVIOS_CENTRO_RECIBO--
alter table ENVIOS
  add constraint Envios_Centros_recibo_FK
  foreign key (id_centro_recibo)
  references CENTROS_RECIBO (id_centro_recibo);
  
--CREACION CONSTRAINT TIPO_SERVICIO_ENVIO--- 
ALTER TABLE ENVIOS
 ADD CONSTRAINT TIPO_SERVICIO_ENVIO
 CHECK (tipo_envio IN ('carga aérea', 'mercancía','mensajería',
  'firma de documentos','radicación de documentos'));
 
---------------------------------------------------------------------------

 ----CREACION TABLA ESTADOS ENVIO-----
Create table Estados_Envio (
id int,
fecha_hora TIMESTAMP NOT NULL,
estado varchar(20)NOT NULL,
id_envio int
);

 
----CREACION CLAVE PRIMARIA ESTADOS_ENVIO-- 
ALTER TABLE ESTADOS_ENVIO ADD PRIMARY KEY 
 (id) ENABLE;

---CREACION CLAVE FORANEA ESTADOS_ENVIO_ENVIO--
 alter table ESTADOS_ENVIO
  add constraint Estados_envio_envio_FK
  foreign key (id_envio)
  references envios (id); 

--CREACION CONSTRAINT ESTADO--- 
 ALTER TABLE ESTADOS_ENVIO
 ADD CONSTRAINT ESTADOS_ENVIO
 CHECK (estado IN ('A recibir', 'en terminal origen','en transporte',
  'en terminal destino','en reparto','entregada'));


--------------------------------------------------------------

--CREACION TABLA MANTENIMIENTOS----
CREATE TABLE MANTENIMIENTOS (
 id_mantenimiento INT,
 fecha_entrada DATE NOT NULL,
 fecha_salida DATE NOT NULL,
 id_vehiculo int,
 id_empleado int
);

alter table MANTENIMIENTOS
  modify fecha_entrada TIMESTAMP;
  
  alter table MANTENIMIENTOS
  modify fecha_salida TIMESTAMP;

--adicionar dos columnas faltantes a la tabla mantenimiento ---
alter table MANTENIMIENTOS
  add estado varchar2(30) default 'no realizado' not null;
  
 alter table MANTENIMIENTOS
  add mantenimiento varchar2(100) not null; 
  
   ALTER TABLE MANTENIMIENTOS
 ADD CONSTRAINT mantenimientos_tipo
 CHECK (mantenimiento IN ('revision 5.000 KM', 'revision 10.000 KM','revision 20.000 KM',
  'revision 40.000 KM','revision 50.000 KM','revision 100.000 KM'));

---CREACION CLAVE PRIMARIA MANTENIMIENTOS--
ALTER TABLE MANTENIMIENTOS ADD PRIMARY KEY 
 (id_mantenimiento) ENABLE;
 
---CREACION CLAVE FORANEA CON EMPLEADOS--
 alter table MANTENIMIENTOS
  add constraint Mantenimientos_Empleados_FK
  foreign key (id_empleado)
  references EMPLEADOS (id_empleado);
  
  ---CREACION CLAVE FORANEA CON VEHICULOS--
 alter table MANTENIMIENTOS
  add constraint Mantenimientos_Vehiculos_FK
  foreign key (id_vehiculo)
  references VEHICULOS (id_vehiculo);
-----------------------------------------------------------------------
---CREACION TABLA TIPOS_MANTENIMIENTO---
CREATE TABLE TIPOS_MANTENIMIENTO(
id int,
descripcion VARCHAR(255) NOT NULL,
kilometraje INT NOT NULL
);

---CREACION CLAVE PRIMARIA TIPOS_MANTENIMIENTOS--
ALTER TABLE TIPOS_MANTENIMIENTO ADD PRIMARY KEY 
 (id) ENABLE;
--------------------------------------------------------------------

---CREACION TABLA SERVICIOS_MANTENIMIENTO---------
CREATE TABLE SERVICIOS_MANTENIMIENTO(
 id int,
 estado varchar(40) not null,
 observaciones varchar(300)not null,
 id_mantenimiento int,
 id_tipo_mantenimiento int
);

---CREACION CLAVE PRIMARIA TIPOS_MANTENIMIENTOS--
ALTER TABLE SERVICIOS_MANTENIMIENTO ADD PRIMARY KEY 
 (id) ENABLE;
 
 --creacion default estado---
 
 alter table SERVICIOS_MANTENIMIENTO
  modify estado default 'pendiente';
 
 
--- REGISTROS EMPLEADOS ---

INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (1.0,'52.817.196','ANDREA CAROLINA ACUÑA MENDOZA','calle 123 #456','344233321',7000000.0,1.0,'negocios','lìder');
--Fila 2
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (2.0,'52960227','ANDREA DEL PILAR CORTES BARRETO','calle 123 #456','348568569',4000000.0,1.0,'negocios','lìder');
--Fila 3
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (3.0,'52.329.187','ANDREA DEL PILAR GUZMAN ROJAS','calle 123 #456','34348594',4000000.0,1.0,'negocios','lìder');
--Fila 4
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (4.0,'52.494.004','ANDREA PAOLA GUTIERREZ ROMERO','calle 123 #456','49545845',4000000.0,1.0,'negocios','lìder');
--Fila 5
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (5.0,'52.705.875','ANDREA LILIANA SAMPER MARTINEZ','calle 123 #456','45545945',4000000.0,1.0,'negocios','lìder');

INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (6.0,'52.710.695','ADRIANA PAOLA CUJAR ALARCON','calle 789 # 1293','3 479626',2300000.0,2.0,'Operacion','Supervisor');
--Fila 7
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (7.0,'51.738.984','ADRIANA GIRALDO GOMEZ','calle 789 # 1294','7403462',2300000.0,2.0,'Operacion','Supervisor');
--Fila 8
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (8.0,'52.355.290','ADRIANA MARCELA SALCEDO SEGURA','calle 789 # 1295','7127318',2300000.0,3.0,'Operacion','Supervisor');
--Fila 9
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (9.0,'79.962.291','ALEXANDER  DUARTE SANDOVAL','calle 789 # 1296','6771177',2300000.0,3.0,'Operacion','Supervisor');
--Fila 10
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (10.0,'41.547.273','ALCIRA SANTANILLA CARVAJAL','calle 789 # 1297','3134931384',2300000.0,4.0,'Operacion','Supervisor');
--Fila 11
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (11.0,'51.899.077','AMPARO MONTOYA MONTOYA','calle 789 # 1298','3108197376',2300000.0,4.0,'Operacion','Supervisor');
--Fila 12
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (12.0,'39.568.175','ANA MARIA LOZANO SANTOS','calle 789 # 1299','4340364',2300000.0,5.0,'Operacion','Supervisor');
--Fila 13
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (13.0,'52.755.672','ANDREA ARIZA ZAMBRANO','calle 789 # 1300','4340364',2300000.0,5.0,'Operacion','Supervisor');
--Fila 14
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (14.0,'52.987.453','ANDREA MARCELA BARRAGAN GARCIA','calle 789 # 1301','4340364',900000.0,6.0,'Operacion','Ordinario');
--Fila 15
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (15.0,'52.880.406','ANDREA YOHANNA PINZON YEPES','calle 789 # 1302','4340364',900000.0,6.0,'Operacion','Ordinario');
--Fila 16
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (16.0,'39.559.801','AMELIA PEREZ TABARES','calle 789 # 1303','4340364',900000.0,6.0,'Operacion','Ordinario');
--Fila 17
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (17.0,'52.453.801','ALEJANDRA MARIA AGUDELO SUAREZ','calle 789 # 1304','4340364',900000.0,6.0,'Operacion','Ordinario');
--Fila 18
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (18.0,'19.442.527','ALVARO CALDERON ARTUNDUAGA','calle 789 # 1305','4340364',900000.0,7.0,'Operacion','Ordinario');
--Fila 19
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (19.0,'52.198.296','AYDA CATALINA PULIDO CHAPARRO','calle 789 # 1306','4340364',900000.0,7.0,'Operacion','Ordinario');
--Fila 20
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (20.0,'52.807.753','BERTHA XIMENA PATRICIA BARBOSA TORRES','calle 789 # 1307','4340364',900000.0,7.0,'Operacion','Ordinario');
--Fila 21
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (21.0,'51.650.895','BETSABE BAUTISTA VARGAS','calle 789 # 1308','4340364',900000.0,8.0,'Operacion','Ordinario');
--Fila 22
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (22.0,'80.235.960','CAMILO ALEXANDER BOLIVAR FORERO','calle 789 # 1309','4340364',900000.0,8.0,'Operacion','Ordinario');
--Fila 23
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (23.0,'30.396.689','CAROLINA ISAZA RAMIREZ ','calle 789 # 1310','4340364',900000.0,8.0,'Operacion','Ordinario');
--Fila 24
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (24.0,'79998342','CESAR AUGUSTO RAMIREZ LAVERDE','calle 789 # 1311','4340364',900000.0,8.0,'Operacion','Ordinario');
--Fila 25
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (25.0,'52265956','CELMIRA PATRICIA ARROYAVE CORREDOR','calle 789 # 1312','4340364',900000.0,9.0,'Operacion','Ordinario');
--Fila 26
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (26.0,'52428220','CLAUDIA MARCELA NAVARRETE CORTES','calle 789 # 1313','4340364',900000.0,9.0,'Operacion','Ordinario');
--Fila 27
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (27.0,'52.962.491','CLAUDIA MARCELAS LOZADA ARAGON','calle 789 # 1314','4340364',900000.0,9.0,'Operacion','Ordinario');
--Fila 28
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (28.0,'52.517.450','CLAUDIA PATRICIA BOLIVAR CARREÑO','calle 789 # 1315','4340364',900000.0,9.0,'Operacion','Ordinario');
--Fila 29
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (29.0,'52.427.093','CLAUDIA PATRICIA GALLO CIFUENTES','calle 789 # 1316','4340364',900000.0,10.0,'Operacion','Ordinario');
--Fila 30
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (30.0,'39.625.110','CLAUDIA PILAR VANEGAS ORTIZ','calle 789 # 1317','4340364',900000.0,10.0,'Operacion','Ordinario');
--Fila 31
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (31.0,'51.963.634','CONSTANZA AGUDELO FORERO','calle 789 # 1318','4340364',900000.0,10.0,'Operacion','Ordinario');
--Fila 32
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (32.0,'52.329.575','CONSUELO GUERRERO CALDERON','calle 789 # 1319','4340364',900000.0,10.0,'Operacion','Ordinario');
--Fila 33
INSERT INTO EMPLEADOS (ID_EMPLEADO, CEDULA, NOMBRE, DIRECCION, TELEFONO, SALARIO, ID_JEFE, CARGO, TIPO_EMPLEADO) VALUES (33.0,'51.553.923','CONSUELO REYES SUAREZ','calle 789 # 1320','4340364',900000.0,10.0,'Operacion','Ordinario');

--- REGISTRO TIPOS CENTRO_RECIBO--

insert into TIPOS_CENTRO_RECIBO (ID,DESCRIPCION)VALUES
(1,'Convencionales');
insert into TIPOS_CENTRO_RECIBO (ID,DESCRIPCION)VALUES
(2,'Terminal Carga');








