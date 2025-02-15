FROM alpine:3.11

LABEL Author="NaveenKumar Namachivayam"
LABEL Website="https://qainsights.com"
LABEL Description="Apache JMeter Dockerfile for GitHub Actions with JMeter Plugins"

ENV JMETER_VERSION "5.4.3"
ENV JMETER_HOME "/opt/apache-jmeter-${JMETER_VERSION}"
ENV JMETER_BIN "${JMETER_HOME}/bin"
ENV PATH "$PATH:$JMETER_BIN"
ENV JMETER_CMD_RUNNER_VERSION "2.3"
ENV JMETER_PLUGIN_MANAGER_VERSION "1.7"
ENV JMETER_LIB "${JMETER_HOME}/lib"

COPY entrypoint.sh /entrypoint.sh
COPY jmeter-plugin-install.sh /jmeter-plugin-install.sh
COPY cmdrunner-2.3.jar /JMETER_LIB


# Downloading JMeter
RUN apk --no-cache add curl ca-certificates openjdk9-jre && \
    curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz --output /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar -zxvf /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    mkdir -p /opt && \
    mv apache-jmeter-${JMETER_VERSION} /opt && \
    rm /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    rm -rf /var/cache/apk/* && \
    chmod a+x /entrypoint.sh && \
    chmod a+x /jmeter-plugin-install.sh

# Downloading CMD Runner
RUN /jmeter-plugin-install.sh

ENTRYPOINT [ "/entrypoint.sh" ]

RUN pip install bzt
