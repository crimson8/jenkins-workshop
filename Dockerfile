ARG REPO_LOCATION='' //Add here your docker repository location
FROM ${REPO_LOCATION}adoptopenjdk/openjdk15:jdk-15.0.1_9-alpine-slim AS BUILDER
ARG PROJECT_DIR=./

COPY *.gradle gradle.* gradlew /app/
COPY /gradle /app/gradle
WORKDIR /app
RUN ./gradlew --refresh-dependencies

COPY ${PROJECT_DIR} /app
WORKDIR /app
RUN ./gradlew --no-daemon --info --build-cache --parallel build -x test

FROM ${REPO_LOCATION}adoptopenjdk/openjdk15:jdk-15.0.1_9-alpine-slim
ARG PROJECT_NAME=demo-PROJECT_VERSION

COPY --from=BUILDER /app/build/libs/${PROJECT_NAME}.jar /app/app.jar

WORKDIR /app
RUN jar xf app.jar

EXPOSE 8080
WORKDIR /
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom", "-jar","/app/app.jar"]
