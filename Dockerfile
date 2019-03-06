FROM openjdk:10-jre-slim
COPY ./target/my-app* /opt/my-app/my-app.jar
# set working directory
WORKDIR /opt/my-app
# by default our app is listening on port 8080
EXPOSE 8080
# the command that is executed when the container starts
ENTRYPOINT ["java", "-jar", "my-app.jar"]