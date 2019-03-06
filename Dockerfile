FROM openjdk:10-jre-slim
USER apps
COPY ./target/my-app* /opt/my-app/my-app.jar
WORKDIR /opt/my-app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "my-app.jar"]