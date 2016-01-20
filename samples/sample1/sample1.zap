<?xml version="1.0" encoding="utf-8" ?>
<project>
  <outputconsole>true</outputconsole>
  <messageslogpath>D:\Projects\FinityAppServer\Templates\AppServer</messageslogpath>
  <projectitem name = "DatabaseSettingBase.pas">
    <template>[%templatepath%]NovusBOBase2.zt</template>
    <properties>[%propertiespath%]DatabaseSetting.xml</properties>
    <Snippits></Snippits>
    <overrideoutput>true</overrideoutput>
    <output>[%outputpath%]Business\DatabaseSettingBase.pas</output>
  </projectitem>
  <projectitem name = "ServerBase.pas">
    <template>[%templatepath%]NovusBOBase2.zt</template>
    <properties>[%propertiespath%]Server.xml</properties>
    <Snippits></Snippits>
    <overrideoutput>true</overrideoutput>
    <output>[%outputpath2%]Business\ServerBase.pas</output>
  </projectitem>
  <projectitem name = "SessionBase.pas">
    <template>[%templatepath%]NovusBOBase2.zt</template>
    <properties>[%propertiespath%]Session.xml</properties>
    <Snippits></Snippits>
    <overrideoutput>true</overrideoutput>
    <output>[%outputpath2%]Business\SessionBase.pas</output>
  </projectitem>
<projectitem name = "AuditSessionBase.pas">
    <template>[%templatepath%]NovusBOBase2.zt</template>
    <properties>[%propertiespath%]AuditSession.xml</properties>
    <Snippits></Snippits>
    <overrideoutput>true</overrideoutput>
    <output>[%outputpath2%]Business\AuditSessionBase.pas</output>
  </projectitem>
  
</project>
