# Guía de Docker para la API REST

## Requisitos Previos
- Docker
- Docker Compose

## Configuración

### 1. Construir y levantar los servicios

```bash
docker-compose up --build
```

Este comando:
- Construye la imagen de la aplicación Spring Boot
- Levanta el contenedor de Oracle XE
- Levanta el contenedor de la aplicación
- Espera a que Oracle esté saludable antes de iniciar la aplicación

### 2. Verificar que los servicios estén corriendo

```bash
docker-compose ps
```

### 3. Ver los logs

```bash
# Ver todos los logs
docker-compose logs -f

# Ver solo logs de la aplicación
docker-compose logs -f apirest

# Ver solo logs de Oracle
docker-compose logs -f oracle
```

## Probar la API

Una vez que los contenedores estén corriendo, la API estará disponible en:
- **URL Base**: `http://localhost:8080/api/vertical-scaling`

### Endpoints disponibles:

#### 1. Listar todos los registros
```bash
curl http://localhost:8080/api/vertical-scaling
```

#### 2. Obtener un registro por ID
```bash
curl http://localhost:8080/api/vertical-scaling/1
```

#### 3. Crear un nuevo registro
```bash
curl -X POST http://localhost:8080/api/vertical-scaling \
  -H "Content-Type: application/json" \
  -d '{
    "idUserCoverageMap": "USER123",
    "status": "PENDING",
    "operationName": "ONSET",
    "procedureName": "TPDV",
    "site": "RELEASED",
    "segment": "CORPORATE",
    "isReschedule": 0,
    "parentId": null
  }'
```

#### 4. Actualizar un registro
```bash
curl -X PUT http://localhost:8080/api/vertical-scaling/1 \
  -H "Content-Type: application/json" \
  -d '{
    "idUserCoverageMap": "USER123",
    "status": "COMPLETED",
    "operationName": "ONSET",
    "procedureName": "TPDV",
    "site": "RELEASED",
    "segment": "CORPORATE",
    "isReschedule": 0,
    "parentId": null
  }'
```

#### 5. Eliminar un registro
```bash
curl -X DELETE http://localhost:8080/api/vertical-scaling/1
```

## Valores permitidos

### STATUS
- `SCHEDULED`
- `INTERRUPTED`
- `COMPLETED`
- `CANCELED`
- `PENDING`

### OPERATION_NAME
- `ONSET`
- `EXPANSION`

### PROCEDURE_NAME
- `TPDV`
- `TADV`
- `TMDV`
- `TGDV`

### SITE
- `RELEASED`
- `PLANNED`
- `WITHOUT_PORTS`

### SEGMENT
- `CORPORATE`
- `RESIDENTIAL`

## Detener los servicios

```bash
# Detener sin eliminar contenedores
docker-compose stop

# Detener y eliminar contenedores
docker-compose down

# Detener, eliminar contenedores y volúmenes (¡CUIDADO! Elimina los datos)
docker-compose down -v
```

## Solución de problemas

### La aplicación no se conecta a Oracle
1. Verifica que Oracle esté saludable: `docker-compose ps`
2. Revisa los logs: `docker-compose logs oracle`
3. Espera unos minutos, Oracle tarda en iniciarse completamente

### Reconstruir la aplicación
```bash
docker-compose up --build apirest
```

### Acceder a la base de datos Oracle
```bash
docker exec -it oracle sqlplus system/oracle@XEPDB1
```

### Verificar que la tabla existe
```sql
SELECT * FROM WFM.DV_VERTICAL_SCALING;
```

