# Docker for Jenkins & Maven & Supervisord & sshd

### Run command

```bash
docker run -d -p 2222:22 -p 8080:8080 -p 9001:9001 --name=jenkins \
-v /YOULVOL/jenkins/:/data/ -v /YOULVOL/sshkey/:/sshkey/ playniuniu/jenkins-maven-sshd
```

### Configuration

1. You need prepare an authorized_keys for ssh login, password login is not permit

2. This contianer already contains oralce-jdk-8 and maven-3.3
- jdk path: /opt/jdk
- maven path: /opt/maven

3. Jenkins is run over the tomcat-8 server

4. tomcat and ssh service is managed by supervisord

### Port Description
- 22: ssh port ( use authorized_keys in /YOULVOL/sshkey/ )
- 8080: Jenkins port ( initPasswd is in /YOULVOL/jenkins/)
- 9001: supervisord port ( admin, admin123 )
