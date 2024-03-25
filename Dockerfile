FROM alpine as build
RUN apk update
RUN apk add openjdk8
RUN apk add maven 
RUN apk add libpng
#RUN apt-get install -f libjasper1
#RUN apt-get install -f libdc1394-22
RUN apk add git

RUN git clone https://github.com/barais/TPDockerSampleApp
RUN mvn install:install-file -Dfile=./lib/opencv-3410.jar -DgroupId=org.opencv -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar && \
     mvn package

FROM alpine as run
COPY --from = build /TPDockerSampleApp /TPDockerSampleApp
EXPOSE 8080
CMD ["java", "-Djava.library.path=lib/", "-jar", "target/fatjar-0.0.1-SNAPSHOT.jar"]
