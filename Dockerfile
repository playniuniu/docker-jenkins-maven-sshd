FROM ubuntu:latest
MAINTAINER playniuniu <playniuniu@gmail.com>

ENV URL_JDK="http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz" \
    URL_MAVEN="http://apache.fayea.com/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz" \
    URL_TOMCAT="http://apache.fayea.com/tomcat/tomcat-8/v8.5.6/bin/apache-tomcat-8.5.6.tar.gz" \
    URL_JENKINS="http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war"

ENV JAVA_HOME=/opt/jdk \
    JAVA=/opt/jdk/bin \
    M2_HOME=/opt/maven \
    M2=/opt/maven/bin \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_OPTS="-server -d64 -XX:+AggressiveOpts -Djava.awt.headless=true \
    -XX:MaxGCPauseMillis=500 -XX:MaxPermSize=256m -XX:PermSize=128m -Xmx512m -Xms128m -Xincgc" \
    JENKINS_HOME=/data/jenkins \
    PATH=${PATH}:/opt/jdk/bin:/opt/maven/bin:/opt/tomcat/bin \
    PREINSTALL_PACKAGES="curl git supervisor openssh-client openssh-server"

# supervisor.conf need not override
COPY ./config/supervisor.conf /etc/
COPY ./config/entrypoint.sh /usr/sbin/
# COPY ./config/sources.list /etc/apt/

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y $PREINSTALL_PACKAGES \
    && apt-get clean

RUN mkdir /opt/downloads/ \
    && cd /opt/downloads/ \
    && curl -jk#SLH "Cookie: oraclelicense=accept-securebackup-cookie" -o jdk.tar.gz ${URL_JDK} \
    && curl -#SL -o maven.tar.gz ${URL_MAVEN} \
    && curl -#SL -o tomcat.tar.gz ${URL_TOMCAT} \
    && curl -#SL -o jenkins.war ${URL_JENKINS} \
    && mkdir /opt/jdk \
    && mkdir /opt/maven \
    && mkdir /opt/tomcat \
    && tar xzf /opt/downloads/jdk.tar.gz -C /opt/jdk --strip-components=1 \
    && tar xzf /opt/downloads/maven.tar.gz -C /opt/maven --strip-components=1 \
    && tar xzf /opt/downloads/tomcat.tar.gz -C /opt/tomcat --strip-components=1 \
    && rm -rf /opt/tomcat/webapps/* \
    && cp /opt/downloads/jenkins.war /opt/tomcat/webapps/ROOT.war \
    && rm -rf /opt/downloads/ \
    && chmod +x "/usr/sbin/entrypoint.sh"

VOLUME /data
EXPOSE 22 8080 9001
ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.conf", "-n"]
