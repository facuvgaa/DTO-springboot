-- Script de inicialización de la base de datos
-- Este script se ejecuta automáticamente cuando Oracle se inicializa por primera vez
-- Se ejecuta como SYSTEM

-- Crear el usuario/esquema WFM
CREATE USER WFM IDENTIFIED BY wfm123;

-- Otorgar permisos necesarios
GRANT CONNECT, RESOURCE, DBA TO WFM;
GRANT UNLIMITED TABLESPACE TO WFM;

-- Cambiar al usuario WFM para crear objetos en su esquema
ALTER SESSION SET CURRENT_SCHEMA = WFM;

-- Crear la secuencia
CREATE SEQUENCE DV_VERTICAL_SCALING_SEQ START WITH 1 INCREMENT BY 1;

-- Crear la tabla
CREATE TABLE DV_VERTICAL_SCALING (
    ID                      NUMBER(19,0)        NOT NULL, 
    ID_USER_COVERAGE_MAP    VARCHAR2(255 char)  NOT NULL, 
    STATUS                  VARCHAR2(255 char)  NOT NULL CHECK (STATUS in ('SCHEDULED','INTERRUPTED','COMPLETED','CANCELED','PENDING')), 
    OPERATION_NAME          VARCHAR2(255 char)  NOT NULL CHECK (OPERATION_NAME in ('ONSET','EXPANSION')), 
    PROCEDURE_NAME          VARCHAR2(255 char)  NOT NULL CHECK (PROCEDURE_NAME in ('TPDV','TADV','TMDV','TGDV')), 
    SITE                    VARCHAR2(255 char)  NOT NULL CHECK (SITE in ('RELEASED','PLANNED','WITHOUT_PORTS')), 
    SEGMENT                 VARCHAR2(255 char)  NOT NULL CHECK (SEGMENT in ('CORPORATE','RESIDENTIAL')), 
    CREATED_AT              TIMESTAMP(6), 
    UPDATED_AT              TIMESTAMP(6), 
    IS_RESCHEDULE           NUMBER(1,0)         DEFAULT 0 NOT NULL CHECK (IS_RESCHEDULE IN (0, 1)),
    PARENT_ID               NUMBER(19,0),
    PRIMARY KEY (ID)
);

-- Volver al esquema SYSTEM para otorgar permisos
ALTER SESSION SET CURRENT_SCHEMA = SYSTEM;

-- Otorgar permisos públicos para que cualquier usuario pueda acceder
GRANT SELECT, INSERT, UPDATE, DELETE ON WFM.DV_VERTICAL_SCALING TO PUBLIC;
GRANT SELECT ON WFM.DV_VERTICAL_SCALING_SEQ TO PUBLIC;

-- Crear sinónimos públicos para facilitar el acceso
CREATE PUBLIC SYNONYM DV_VERTICAL_SCALING FOR WFM.DV_VERTICAL_SCALING;
CREATE PUBLIC SYNONYM DV_VERTICAL_SCALING_SEQ FOR WFM.DV_VERTICAL_SCALING_SEQ;

