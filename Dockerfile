FROM maven:3.9.10-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY .  .
RUN mvn package -DskipTests

# FROM eclipse-temurin:8u452-b09-jdk-ubi9-minimal AS run
FROM maven:3.9.10-eclipse-temurin-17-alpine AS run
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar
ARG USER=devops
ENV HOME /home/$USER
RUN adduser -D $USER && chown $USER:$USER /run/demo.jar
# RUN apk add --no-cache curl # Image eclipse-temurin:8u452-b09-jdk-ubi9-minimal does not have apk but has curl
HEALTHCHECK --interval=30s --timeout=10s --retries=2 --start-period=20s CMD curl -f http://localhost:8080/ || exit 1
USER $USER
EXPOSE 8080
CMD java  -jar /run/demo.jar
