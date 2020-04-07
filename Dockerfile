#
# ACHE Crawler Dockerfile
#
# https://github.com/ViDA-NYU/ache
#
FROM openjdk:11-jdk

ADD . /ache-src
WORKDIR /ache-src
RUN /ache-src/gradlew installDist
RUN mv /ache-src/build/install/ache /ache
RUN rm -rf /ache-src/ /root/.gradle

# Makes JVM aware of memory limit available to the container (cgroups)
ENV JAVA_OPTS='-XX:+UseContainerSupport -XX:MaxRAMPercentage=80'

RUN export ACHE_HOME=/ache && export PATH="$ACHE_HOME/bin:$PATH"
VOLUME ["/storagemount"]

EXPOSE 8080

ENTRYPOINT ["/ache/bin/ache", "startServer", "-c", "/storagemount/config", "-d", "/storagemount/data"]
