# REST API - Vertical Scaling CRUD

![CI](https://github.com/facuvgaa/apirest/workflows/CI/badge.svg)

REST API developed with Spring Boot to manage CRUD operations on the `DV_VERTICAL_SCALING` table in Oracle Database.

## 🚀 Features

- **Complete CRUD** for the `DvVerticalScaling` entity
- **Validations** according to database CHECK constraints
- **Docker Compose** for easy deployment
- **Automatic database initialization**
- **Spring Security** configured for REST APIs
- **JPA/Hibernate** for persistence

## 📋 Prerequisites

- Docker
- Docker Compose
- Java 21 (only if you want to run locally without Docker)
- Maven 3.9+ (only if you want to run locally without Docker)

## 🐳 Running with Docker (Recommended)

### Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd apirest

# Start services (Oracle + API)
docker compose up --build

# API will be available at http://localhost:8081
```

### What does it do automatically?

When running `docker compose up`, the following happens automatically:

1. ✅ Oracle XE container is created
2. ✅ Database is initialized with:
   - User/schema `WFM`
   - Sequence `DV_VERTICAL_SCALING_SEQ`
   - Table `DV_VERTICAL_SCALING` with all CHECK constraints
   - Required permissions
3. ✅ Spring Boot application is built and started
4. ✅ Application automatically connects to Oracle

### Verify everything works

```bash
# Check containers
docker compose ps

# View logs
docker compose logs -f

# Test the API
curl http://localhost:8081/api/vertical-scaling
```

## 📡 API Endpoints

Base URL: `http://localhost:8081/api/vertical-scaling`

### 1. List all records
```bash
GET /api/vertical-scaling
```

### 2. Get a record by ID
```bash
GET /api/vertical-scaling/{id}
```

### 3. Create a new record
```bash
POST /api/vertical-scaling
Content-Type: application/json

{
  "idUserCoverageMap": "USER123",
  "status": "PENDING",
  "operationName": "ONSET",
  "procedureName": "TPDV",
  "site": "RELEASED",
  "segment": "CORPORATE",
  "isReschedule": 0,
  "parentId": null
}
```

### 4. Update a record
```bash
PUT /api/vertical-scaling/{id}
Content-Type: application/json

{
  "idUserCoverageMap": "USER123",
  "status": "COMPLETED",
  "operationName": "ONSET",
  "procedureName": "TPDV",
  "site": "RELEASED",
  "segment": "CORPORATE",
  "isReschedule": 0,
  "parentId": null
}
```

### 5. Delete a record
```bash
DELETE /api/vertical-scaling/{id}
```

## 📊 Allowed Values

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

## 🏗️ Project Structure

```
apirest/
├── src/
│   ├── main/
│   │   ├── java/com/apirest/
│   │   │   ├── controller/     # REST Controllers
│   │   │   ├── model/          # JPA Entities
│   │   │   ├── repository/    # Spring Data Repositories
│   │   │   ├── service/        # Business Logic
│   │   │   └── config/         # Configurations
│   │   └── resources/
│   │       ├── application.properties
│   │       └── application-docker.properties
├── docker-entrypoint-initdb.d/  # SQL initialization scripts
├── scripts/                      # Auxiliary scripts
├── Dockerfile
├── docker-compose.yml
└── pom.xml
```

## 🔧 Configuration

### Environment Variables (Docker)

The following variables can be configured in `docker-compose.yml`:

- `SPRING_DATASOURCE_URL`: Oracle connection URL
- `SPRING_DATASOURCE_USERNAME`: Oracle user (default: SYSTEM)
- `SPRING_DATASOURCE_PASSWORD`: Oracle password (default: oracle)
- `SPRING_JPA_HIBERNATE_DDL_AUTO`: Schema update mode (default: update)

### Database

- **User**: SYSTEM
- **Password**: oracle
- **Schema**: WFM
- **Table**: DV_VERTICAL_SCALING
- **Sequence**: DV_VERTICAL_SCALING_SEQ

## 🧪 Testing

### Complete test example

```bash
# 1. Create a record
curl -X POST http://localhost:8081/api/vertical-scaling \
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

# 2. List all
curl http://localhost:8081/api/vertical-scaling

# 3. Get by ID
curl http://localhost:8081/api/vertical-scaling/1

# 4. Update
curl -X PUT http://localhost:8081/api/vertical-scaling/1 \
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

# 5. Delete
curl -X DELETE http://localhost:8081/api/vertical-scaling/1
```

## 🛠️ Useful Commands

### Docker Compose

```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f apirest
docker compose logs -f oracle

# Stop services
docker compose stop

# Stop and remove containers
docker compose down

# Rebuild only the application
docker compose up --build apirest
```

### Database

```bash
# Access Oracle
docker exec -it oracle sqlplus system/oracle@XEPDB1

# Verify table
docker exec -it oracle sqlplus WFM/wfm123@XEPDB1 <<EOF
SELECT * FROM DV_VERTICAL_SCALING;
EXIT;
EOF
```

## 🔄 Continuous Integration

This project includes a GitHub Actions CI workflow that:

- ✅ Compiles the project with Maven
- ✅ Runs unit tests
- ✅ Packages the application
- ✅ Builds the Docker image
- ✅ Validates the project structure

The CI runs automatically on:
- Push to `main`, `master`, or `develop` branches
- Pull requests to `main`, `master`, or `develop` branches

## 📝 Notes

- Port 8081 is used to avoid conflicts with other applications
- Oracle data is persisted in the `oracle_data` volume
- Database initialization only occurs the first time (when the volume is empty)
- If you need to reinitialize, remove the volume: `docker compose down -v`

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.
