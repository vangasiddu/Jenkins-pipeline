FROM maven:3.5-jdk-8-alpine

COPY pom.xml pipeline/

#COPY src/ pipeline/src/

#WORKDIR pipeline/

RUN mvn clean install
#FROM openjdk:8-jdk-alpine  

EXPOSE 8090

ENTRYPOINT [ "java", "-jar", "/pipeline/target/jenkins-pipeline.jar"]
