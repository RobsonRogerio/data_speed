FROM apache/hop-web:2.11.0

USER root

RUN mkdir /project /config

COPY web.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/web.xml

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

RUN chown -R hop:hop /project /config

USER hop