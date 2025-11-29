# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Install wget for healthcheck
RUN apk add --no-cache wget

# Copy jar from build stage
COPY --from=build /app/target/apirest-0.0.1-SNAPSHOT.jar app.jar

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring

# Expose port
EXPOSE 8080

# Health check (runs as root by default)
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/vertical-scaling || exit 1

# Switch to non-root user for application
USER spring:spring

# Run the application with docker profile
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=docker", "app.jar"]

