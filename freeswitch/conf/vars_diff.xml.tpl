<include>
  <!-- Image default is 5080/5081 for the drachtio MRF profile; not used by our profile. -->
  <X-PRE-PROCESS cmd="set" data="sip_port=__SIP_PORT__"/>
  <X-PRE-PROCESS cmd="set" data="tls_port=5081"/>
  <X-PRE-PROCESS cmd="set" data="my_local_ip4=$${local_ip_v4}"/>
  <X-PRE-PROCESS cmd="set" data="ext_rtp_ip=__PUBLIC_IP__"/>
  <X-PRE-PROCESS cmd="set" data="ext_sip_ip=__PUBLIC_IP__"/>
</include>
