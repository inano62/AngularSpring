# api/Dockerfile

# ----- ビルドステージ -----
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# pom とソースをまとめてコピー
COPY pom.xml .
COPY src ./src

# そのままビルド（dependency:go-offline は使わない）
RUN mvn -B package -DskipTests

# ----- 実行ステージ -----
FROM eclipse-temurin:17-jdk

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
