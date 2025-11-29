#!/bin/bash
# Script que se ejecuta después de la inicialización para verificar/crear objetos si el volumen ya existía

set -e

echo "Verificando si el esquema WFM necesita inicialización..."

# Esperar a que Oracle esté completamente listo
sleep 5

# Verificar si el usuario WFM existe
USER_EXISTS=$(sqlplus -s system/oracle@XEPDB1 <<EOF 2>/dev/null | grep -i "WFM" || echo ""
SELECT username FROM all_users WHERE username = 'WFM';
EXIT;
EOF
)

if [ -z "$USER_EXISTS" ] || ! echo "$USER_EXISTS" | grep -qi "WFM"; then
    echo "Usuario WFM no existe, creándolo..."
    sqlplus -s system/oracle@XEPDB1 <<EOF
CREATE USER WFM IDENTIFIED BY wfm123;
GRANT CONNECT, RESOURCE, DBA TO WFM;
GRANT UNLIMITED TABLESPACE TO WFM;
EXIT;
EOF
fi

# Verificar secuencia
SEQ_EXISTS=$(sqlplus -s WFM/wfm123@XEPDB1 <<EOF 2>/dev/null | grep -i "DV_VERTICAL_SCALING_SEQ" || echo ""
SELECT sequence_name FROM user_sequences WHERE sequence_name = 'DV_VERTICAL_SCALING_SEQ';
EXIT;
EOF
)

if [ -z "$SEQ_EXISTS" ] || ! echo "$SEQ_EXISTS" | grep -qi "DV_VERTICAL_SCALING_SEQ"; then
    echo "Secuencia no existe, creándola..."
    sqlplus -s WFM/wfm123@XEPDB1 <<EOF
CREATE SEQUENCE DV_VERTICAL_SCALING_SEQ START WITH 1 INCREMENT BY 1;
EXIT;
EOF
fi

# Verificar tabla
TABLE_EXISTS=$(sqlplus -s WFM/wfm123@XEPDB1 <<EOF 2>/dev/null | grep -i "DV_VERTICAL_SCALING" || echo ""
SELECT table_name FROM user_tables WHERE table_name = 'DV_VERTICAL_SCALING';
EXIT;
EOF
)

if [ -z "$TABLE_EXISTS" ] || ! echo "$TABLE_EXISTS" | grep -qi "DV_VERTICAL_SCALING"; then
    echo "Tabla no existe, creándola..."
    sqlplus -s WFM/wfm123@XEPDB1 <<EOF
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
EXIT;
EOF
fi

# Otorgar permisos públicos
echo "Otorgando permisos públicos..."
sqlplus -s system/oracle@XEPDB1 <<EOF
GRANT SELECT, INSERT, UPDATE, DELETE ON WFM.DV_VERTICAL_SCALING TO PUBLIC;
GRANT SELECT ON WFM.DV_VERTICAL_SCALING_SEQ TO PUBLIC;
CREATE OR REPLACE PUBLIC SYNONYM DV_VERTICAL_SCALING FOR WFM.DV_VERTICAL_SCALING;
CREATE OR REPLACE PUBLIC SYNONYM DV_VERTICAL_SCALING_SEQ FOR WFM.DV_VERTICAL_SCALING_SEQ;
EXIT;
EOF

echo "Inicialización completada!"

