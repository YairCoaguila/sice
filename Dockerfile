FROM tomcat:11-jdk21
COPY target/sice.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]