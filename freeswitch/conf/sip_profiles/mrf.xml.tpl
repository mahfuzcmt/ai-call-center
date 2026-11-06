<include>
  <!-- Replaces the image's drachtio "mrf" profile. External profile + bd-trunk gateway. -->
  <profile name="external">
    <gateways>
      <gateway name="bd-trunk">
        <param name="proxy" value="__BD_TRUNK_HOST__"/>
        <param name="realm" value="__BD_TRUNK_HOST__"/>
        <param name="username" value="__BD_TRUNK_USER__"/>
        <param name="password" value="__BD_TRUNK_PASSWORD__"/>
        <param name="from-user" value="__BD_TRUNK_USER__"/>
        <param name="register" value="__REGISTER__"/>
        <param name="caller-id-in-from" value="true"/>
        <param name="ping" value="30"/>
      </gateway>
    </gateways>
    <domains>
      <domain name="all" alias="false" parse="false"/>
    </domains>
    <settings>
      <param name="sip-trace" value="no"/>
      <param name="rfc2833-pt" value="101"/>
      <param name="dtmf-type" value="rfc2833"/>
      <param name="sip-ip" value="$${local_ip_v4}"/>
      <param name="rtp-ip" value="$${local_ip_v4}"/>
      <param name="ext-sip-ip" value="__PUBLIC_IP__"/>
      <param name="ext-rtp-ip" value="__PUBLIC_IP__"/>
      <param name="sip-port" value="__SIP_PORT__"/>
      <param name="context" value="public"/>
      <!-- IP-auth: only the provider may send us INVITEs (ACL "provider"); no digest challenge. -->
      <param name="apply-inbound-acl" value="provider"/>
      <param name="auth-calls" value="false"/>
      <param name="user-agent-string" value="ai-call-center"/>
      <param name="codec-prefs" value="PCMA,PCMU"/>
      <param name="inbound-codec-prefs" value="PCMA,PCMU"/>
      <param name="outbound-codec-prefs" value="PCMA,PCMU"/>
      <param name="inbound-codec-negotiation" value="generous"/>
      <param name="rtp-timer-name" value="soft"/>
      <param name="manage-presence" value="false"/>
      <param name="nonce-ttl" value="60"/>
      <param name="tls" value="false"/>
    </settings>
  </profile>
</include>
