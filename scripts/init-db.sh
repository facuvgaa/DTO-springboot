#!/bin/bash
# Script de inicialización de base de datos para cuando el volumen ya existe
# Este script se ejecuta después de que Oracle esté listo

set -e

echo "Esperando a que Oracle esté completamente listo..."
sleep 10

MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if sqlplus -L system/oracle@XEPDB1 <<EOF > /dev/null 2>&1
SELECT 1 FROM DUAL;
EXIT;
EOF
    then
        echo "Oracle está listo!"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "Esperando Oracle... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 5
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "Error: Oracle no está disponible después de $MAX_RETRIES intentos"
    exit 1
fi

echo "Verificando si el esquema WFM existe..."

# Verificar si el usuario WFM existe
USER_EXISTS=$(sqlplus -s system/oracle@XEPDB1 <<EOF | grep -i "does not exist" || echo "exists"
SELECT username FROM all_users WHERE username = 'WFM';
EXIT;
EOF
)

if echo "$USER_EXISTS" | grep -qi "does not exist\|no rows selected"; then
    echo "Creando usuario WFM..."
    sqlplus -s system/oracle@XEPDB1 <<EOF
CREATE USER WFM IDENTIFIED BY wfm123;
GRANT CONNECT, RESOURCE, DBA TO WFM;
GRANT UNLIMITED TABLESPACE TO WFM;
EXIT;
EOF
    echo "Usuario WFM creado."
else
    echo "Usuario WFM ya existe."
fi

echo "Verificando secuencia..."
SEQ_EXISTS=$(sqlplus -s WFM/wfm123@XEPDB1 <<EOF | grep -i "does not exist" || echo "exists"
SELECT sequence_name FROM user_sequences WHERE sequence_name = 'DV_VERTICAL_SCALING_SEQ';
EXIT;
EOF
)

if echo "$SEQ_EXISTS" | grep -qi "does not exist\|no rows selected"; then
    echo "Creando secuencia..."
    sqlplus -s WFM/wfm123@XEPDB1 <<EOF
CREATE SEQUENCE WFM.DV_VERTICAL_SCALING_SEQ START WITH 1 INCREMENT BY 1;
EXIT;
EOF
    echo "Secuencia creada."
else
    echo "Secuencia ya existe."
fi

echo "Verificando tabla..."
TABLE_EXISTS=$(sqlplus -s WFM/wfm123@XEPDB1 <<EOF | grep -i "does not exist" || echo "exists"
SELECT table_name FROM user_tables WHERE table_name = 'DV_VERTICAL_SCALING';
EXIT;
EOF
)

if echo "$TABLE_EXISTS" | grep -qi "does not exist\|no rows selected"; then
    echo "Creando tabla..."
    sqlplus -s WFM/wfm123@XEPDB1 <<EOF
CREATE TABLE WFM.DV_VERTICAL_SCALING (
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
    echo "Tabla creada."
else
    echo "Tabla ya existe."
fi

echo "Otorgando permisos públicos..."
sqlplus -s system/oracle@XEPDB1 <<EOF
GRANT SELECT, INSERT, UPDATE, DELETE ON WFM.DV_VERTICAL_SCALING TO PUBLIC;
GRANT SELECT ON WFM.DV_VERTICAL_SCALING_SEQ TO PUBLIC;
EXIT;
EOF

echo "Inicialización completada!"

