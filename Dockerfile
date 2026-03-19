# Build stage
FROM maven:3.9-eclipse-temurin-23 AS builder

WORKDIR /app

# Copy source code
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:23-jre-alpine

WORKDIR /app

# Copy JAR from build stage
COPY --from=builder /app/target/phanlamtuankiet-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
