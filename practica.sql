drop database if exists mia_practica;

create database mia_practica;


drop table if exists evento_sede;
drop table if exists Disciplina_Atleta;

drop table if exists costo_evento;
drop table if exists televisora;
drop table if exists evento_atleta;
drop table if exists evento;
drop table if exists tipo_participacion;
drop table if exists categoria;
drop table if exists atleta;
drop table if exists disciplina;
drop table if exists medallero;
drop table if exists tipo_medalla;
drop table if exists puesto_miembro;
drop table if exists miembro;
drop table if exists departamento;
drop table if exists puesto;
drop table if exists pais;
drop table if exists profesion;

drop table if exists sede;


create database mia_practica;


-- **** 1**** Según documentación el tipo soportado para cadena de caracteres es varchar()

/* create table profesion(
    cod_prof int not null,
    nombre varchar(50) not null
);
alter table profesion add primary key (cod_prof);
alter table profesion add constraint u_unique unique (nombre);

create table profesion(
    cod_prof int not null,
    nombre varchar(50) unique not null,
    primary key(cod_prof)
); */

create table profesion(
    cod_prof int primary key not null,
    nombre varchar(50) unique not null
);


-- ejemplo de campo unique
create table pais(
    cod_pais int primary key not null,
    nombre varchar(50) unique not null
);



create table puesto(
    cod_puesto int primary key not null,
    nombre varchar(50) unique not null
);



create table departamento(
    cod_depto int primary key not null,
    nombre varchar(50) unique not null
);



/* create table miembro(
    cod_miembro int not null,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    edad int not null,
    telefono int null,
    residencia varchar(100) null,
    PAIS_cod_pais int references pais(cod_pais) not null,
    PROFESION_cod_prof int references profesion(cod_prof) not null,
    primary key (cod_miembro)
); */
-- ejemplo de llaves foráneas
create table miembro(
    cod_miembro int not null,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    edad int not null,
    telefono int null,
    residencia varchar(100) null,
    PAIS_cod_pais int not null,
    PROFESION_cod_prof int not null,
    primary key (cod_miembro),
    foreign key (PAIS_cod_pais) references pais(cod_pais),
    foreign key (PROFESION_cod_prof) references profesion(cod_prof)
);



-- fecha_fin puede ser un registro nulo, llave primaria compuesta por dos llaves foráneas
create table puesto_miembro(
    MIEMBRO_cod_miembro int not null,
    PUESTO_cod_puesto int not null,
    DEPARTAMENTO_cod_depto int not null,
    fecha_inicio date not null,
    fecha_fin date null,
    primary key (MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto),
    foreign key (MIEMBRO_cod_miembro) references miembro(cod_miembro),
    foreign key (PUESTO_cod_puesto) references puesto(cod_puesto),
    foreign key (DEPARTAMENTO_cod_depto) references departamento(cod_depto)
);



create table tipo_medalla(
    cod_tipo int primary key not null,
    medalla varchar(20) unique not null
);



create table medallero(
    PAIS_cod_pais int not null,
    cantidad_medallas int not null,
    TIPO_MEDALLA_cod_tipo int not null,
    primary key (PAIS_cod_pais, TIPO_MEDALLA_cod_tipo),
    foreign key (PAIS_cod_pais) references pais(cod_pais),
    foreign key (TIPO_MEDALLA_cod_tipo) references tipo_medalla(cod_tipo)
);


-- descripcion puede ser un registro nulo
create table disciplina(
    cod_disciplina int primary key not null,
    nombre varchar(50) not null,
    descripcion varchar(150) null
);


-- Lave primaria simple y dos llaves foráneas
create table atleta(
    cod_atleta int not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    edad int not null,
    Participaciones varchar(100) not null,
    DISCIPLINA_cod_disciplina int not null,
    PAIS_cod_pais int not null,
    primary key (cod_atleta),
    foreign key (DISCIPLINA_cod_disciplina) references disciplina(cod_disciplina),
    foreign key (PAIS_cod_pais) references pais(cod_pais)
);



create table categoria(
    cod_categoria int primary key not null,
    categoria varchar(50) not null
);



create table tipo_participacion(
    cod_participacion int primary key not null,
    tipo_participacion varchar(100) not null
);



create table evento(
    cod_evento int not null,
    fecha date not null,
    ubicacion varchar(50) not null,
    hora date not null,
    DISCIPLINA_cod_disciplina int not null,
    TIPO_PARTICIPACION_cod_participacion int not null,
    CATEGORIA_cod_categoria int not null,
    primary key (cod_evento),
    foreign key (DISCIPLINA_cod_disciplina) references disciplina(cod_disciplina),
    foreign key (TIPO_PARTICIPACION_cod_participacion) references tipo_participacion(cod_participacion),
    foreign key (CATEGORIA_cod_categoria) references categoria(cod_categoria)
);


--ejemplo de detalle
create table evento_atleta(
    ATLETA_cod_atleta int not null,
    EVENTO_cod_evento int not null,
    primary key (ATLETA_cod_atleta, EVENTO_cod_evento),
    foreign key (ATLETA_cod_atleta) references atleta(cod_atleta),
    foreign key (EVENTO_cod_evento) references evento(cod_evento)
);



create table televisora(
    cod_televisora int primary key not null,
    nombre varchar(50) not null
);





create table costo_evento(
    EVENTO_cod_evento int not null,
    TELEVISORA_cod_televisora int not null,
    Tarifa numeric not null,
    primary key (EVENTO_cod_evento, TELEVISORA_cod_televisora),
    foreign key (EVENTO_cod_evento) references evento(cod_evento),
    foreign key (TELEVISORA_cod_televisora) references televisora(cod_televisora)
);



set datestyle to 'European'; -- para ingresar en formato dd/mm/aaaa
-- **** 2**** tipo de datos timestamp acepta fecha y hora
alter table evento drop column fecha;
alter table evento drop column hora;

alter table evento add column fecha_hora timestamp;



-- **** 3**** un check constraint sirve para agregar alguna condición de agregado que querramos en alguna columna, en este caso un rango de fecha y hora en la tabla evento
alter table evento add constraint rango_fecha_check check(
    fecha_hora between '24/07/2020 9:00:00.00' and '09/08/2020 20:00:00.00'
); 

insert into evento(cod_evento, fecha_hora, SEDE_codigo_sede, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) values(64, '10/01/2020 16:20:00', 2, 2, 2, 1);


-- **** 4**** tabla sede para una lista de sedes, cambiar el tipo de la columna y su nombre para referenciar a la nueva llave foránea que será la llave primaria de la tabla sede. Agregar llave foránea.
create table sede(
    codigo_sede int primary key not null,
    sede varchar(50) not null
);
alter table evento alter column ubicacion type integer using (ubicacion::integer);
alter table evento rename column ubicacion to SEDE_codigo_sede;
alter table evento add foreign key (SEDE_codigo_sede) references sede(codigo_sede);



-- **** 5**** se hace un alter al valor de los teléfonos para cuando sean nulos
alter table miembro alter column telefono set default 0;

update miembro set telefono = '0'
where telefono = NULL;




-- **** 6****
select * from profesion;
insert into profesion(cod_prof, nombre) values(1, 'Médico');
insert into profesion(cod_prof, nombre) values(2, 'Arquitecto');
insert into profesion(cod_prof, nombre) values(3, 'Ingeniero');
insert into profesion(cod_prof, nombre) values(4, 'Secretaria');
insert into profesion(cod_prof, nombre) values(5, 'Auditor');

select * from pais;
insert into pais(cod_pais, nombre) values(1, 'Guatemala');
insert into pais(cod_pais, nombre) values(2, 'Francia');
insert into pais(cod_pais, nombre) values(3, 'Argentina');
insert into pais(cod_pais, nombre) values(4, 'Alemania');
insert into pais(cod_pais, nombre) values(5, 'Italia');
insert into pais(cod_pais, nombre) values(6, 'Brasil');
insert into pais(cod_pais, nombre) values(7, 'Estados Unidos');

select * from miembro;
insert into miembro(cod_miembro, nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, PROFESION_cod_prof) values(1, 'Scott', 'Mitchell', 32, 0, '1092 Highland Drive Manitowoc, WI 54220', 7, 3);
insert into miembro(cod_miembro, nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, PROFESION_cod_prof) values(2, 'Fanette', 'Poulin', 25, 25075823, '49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY', 2, 4);
insert into miembro(cod_miembro, nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, PROFESION_cod_prof) values(3, 'Laura', 'Cunha Silva', 55, 0, 'Rua Onze, 86 Uberaba-MG', 6, 5);
insert into miembro(cod_miembro, nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, PROFESION_cod_prof) values(4, 'Juan José', 'López', 38, 36985247, '26 calle 4-10 zona 11', 1, 2);
insert into miembro(cod_miembro, nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, PROFESION_cod_prof) values(5, 'Arcangela', 'Panicucci', 39, 391664921, 'Via Santa Teresa, 114 90010-Geraci Siculo PA', 5, 1);
insert into miembro(cod_miembro, nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, PROFESION_cod_prof) values(6, 'Jeuel', 'Villalpando', 31, 0, 'Acuña de Figeroa 6106 80101 Playa Pascual', 3, 5);

select * from tipo_medalla;
insert into tipo_medalla(cod_tipo, medalla) values(1, 'Oro');
insert into tipo_medalla(cod_tipo, medalla) values(2, 'Plata');
insert into tipo_medalla(cod_tipo, medalla) values(3, 'Bronce');
insert into tipo_medalla(cod_tipo, medalla) values(4, 'Platino');

select * from medallero;
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(5, 1, 3);
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(2, 1, 5);
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(6, 3, 4);
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(4, 4, 3);
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(7, 3, 10);
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(3, 2, 8);
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(1, 1, 2);
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(1, 4, 5);
insert into medallero(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas) values(5, 2, 7);

select * from disciplina;
insert into disciplina(cod_disciplina, nombre, descripcion) values(1, 'Atletismo', 'Saltos de longitud y triples, de altura y con pértiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco');
insert into disciplina(cod_disciplina, nombre, descripcion) values(2, 'Bádminton', ' ');
insert into disciplina(cod_disciplina, nombre, descripcion) values(3, 'Ciclismo', ' ');
insert into disciplina(cod_disciplina, nombre, descripcion) values(4, 'Judo', 'Es un arte marcial que se originó en Japón alrededor de 1880');
insert into disciplina(cod_disciplina, nombre, descripcion) values(5, 'Lucha', ' ');
insert into disciplina(cod_disciplina, nombre, descripcion) values(6, 'Tenis de Mesa', ' ');
insert into disciplina(cod_disciplina, nombre, descripcion) values(7, 'Boxeo', ' ');
insert into disciplina(cod_disciplina, nombre, descripcion) values(8, 'Natación', 'Está presente como deporte en los JUegos desde la primera edición de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.');
insert into disciplina(cod_disciplina, nombre, descripcion) values(9, 'Esgrima', ' ');
insert into disciplina(cod_disciplina, nombre, descripcion) values(10, 'Vela', ' ');

select * from categoria;
insert into categoria(cod_categoria, categoria) values(1, 'Clasificatorio');
insert into categoria(cod_categoria, categoria) values(2, 'Eliminatorio');
insert into categoria(cod_categoria, categoria) values(3, 'Final');

select * from tipo_participacion;
insert into tipo_participacion(cod_participacion, tipo_participacion) values(1, 'Individual');
insert into tipo_participacion(cod_participacion, tipo_participacion) values(2, 'Parejas');
insert into tipo_participacion(cod_participacion, tipo_participacion) values(3, 'Equipos');

select * from sede;
insert into sede(codigo_sede, sede) values(1, 'Gimnasio Metropolitano de Tokio');
insert into sede(codigo_sede, sede) values(2, 'Jardín del Palacio Imperial de Tokio');
insert into sede(codigo_sede, sede) values(3, 'Gimnasio Nacional Yoyogi');
insert into sede(codigo_sede, sede) values(4, 'Nippon Budokan');
insert into sede(codigo_sede, sede) values(5, 'Estadio Olímpico');

select * from evento;
insert into evento(cod_evento, fecha_hora, SEDE_codigo_sede, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) values(1, '24/07/2020 11:00:00', 3, 2, 2, 1);
insert into evento(cod_evento, fecha_hora, SEDE_codigo_sede, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) values(2, '26/07/2020 10:30:00', 1, 6, 1, 3);
insert into evento(cod_evento, fecha_hora, SEDE_codigo_sede, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) values(3, '30/07/2020 18:45:00', 5, 7, 1, 2);
insert into evento(cod_evento, fecha_hora, SEDE_codigo_sede, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) values(4, '01/08/2020 12:15:00', 2, 1, 1, 1);
insert into evento(cod_evento, fecha_hora, SEDE_codigo_sede, DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) values(5, '08/08/2020 19:35:00', 4, 10, 3, 1);



-- **** 7**** eliminado constraint de restricción unique de cada tabla requerida.
alter table pais drop constraint pais_nombre_key;
alter table tipo_medalla drop constraint tipo_medalla_medalla_key;
alter table departamento drop constraint departamento_nombre_key;




-- **** 8**** Se crea una tabla que sirva como detalle para romper la relación de que una disciplina puede tener muchos atletas pero cada atleta solo puede estar en una disciplina
select * from atleta;

alter table atleta drop column disciplina_cod_disciplina;

create table Disciplina_Atleta(
    Cod_atleta int not null,
    Cod_disciplina int not null,
    primary key (Cod_atleta, Cod_disciplina),
    foreign key (Cod_atleta) references atleta(cod_atleta),
    foreign key (Cod_disciplina) references disciplina(cod_disciplina)
);

select * from Disciplina_Atleta;



-- **** 9**** -- segun documentación de postgresql el tipo numeric y decimal son similares
alter table costo_evento alter column Tarifa type decimal(12,2) using (Tarifa::decimal(12,2));




-- 10**** Para eliminar el registro de tipo_medalla habrá que eliminar primero los registros de medallero que tengan el registro a borrar
select * from tipo_medalla;
select * from medallero;
delete from medallero where TIPO_MEDALLA_cod_tipo = 4;
delete from tipo_medalla where cod_tipo = 4 and medalla = 'Platino';




-- 11**** se elimina primero costo_evento por tener llaves foraneas a otras tablas
drop table if exists costo_evento;
drop table if exists televisora;




-- 12**** como los eventos requieren obligatoriamente de una disciplina también deberán de ser eliminados, como primer paso.
select * from evento;
select * from disciplina;

delete from evento where cod_evento > 0;
delete from disciplina where cod_disciplina > 0;

select * from evento;
select * from disciplina;




-- 13****
select * from miembro;

update miembro set telefono = 55464601
 where nombre = 'Laura' and apellido = 'Cunha Silva'; 
update miembro set telefono = 91514243
 where nombre = 'Jeuel' and apellido = 'Villalpando';
update miembro set telefono = 920686670
 where nombre = 'Scott' and apellido = 'Mitchell';

select * from miembro;




-- 14**** la columna fotografia contendrá las direcciones de las fotografías, tanto locales como en servidores externos para que al levantar el sistema los direcciones proyecten las vistas de las imagenes
select * from atleta;

alter table atleta add column fotografia varchar(128) null;

select * from atleta;



-- 15****
alter table atleta add constraint rango_edad_check check(
    edad > 25
);

insert into atleta(cod_atleta, nombre, apellido, edad, Participaciones, PAIS_cod_pais, fotografia) values(1, 'Erick', 'Barrondo', 24, 1, 1, 'images.gt/erickBarrondo/portada.png';
