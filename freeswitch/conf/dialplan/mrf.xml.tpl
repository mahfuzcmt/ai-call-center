<include>
  <!-- Replaces the image's "mrf" dialplan. Phase 1: echo test. No outbound routing. -->
  <context name="public">
    <extension name="hotline-echo-test">
      <!-- Provider number format is an open question: match 09649112525 / 8809649112525 / +8809649112525 -->
      <condition field="destination_number" expression="^(?:\+?880|0)?9649112525$">
        <action application="answer"/>
        <action application="sleep" data="500"/>
        <action application="echo"/>
        <action application="hangup"/>
      </condition>
    </extension>
    <extension name="reject-everything-else">
      <condition field="destination_number" expression=".*">
        <action application="respond" data="404"/>
      </condition>
    </extension>
  </context>
</include>
