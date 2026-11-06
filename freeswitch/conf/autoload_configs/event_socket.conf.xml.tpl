<configuration name="event_socket.conf" description="Socket Client">
  <settings>
    <param name="nat-map" value="false"/>
    <!-- Loopback only (container uses host networking). -->
    <param name="listen-ip" value="127.0.0.1"/>
    <param name="listen-port" value="8021"/>
    <param name="password" value="__ESL_PASSWORD__"/>
    <param name="apply-inbound-acl" value="loopback.auto"/>
  </settings>
</configuration>
