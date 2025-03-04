/tool mac-server set allowed-interface-list=none 
/tool mac-server mac-winbox set allowed-interface-list=none 
/tool mac-server ping set enabled=no
/ip neighbor discovery-settings set discover-interface-list=none 
/tool bandwidth-server set enabled=no 
/ip dns set allow-remote-requests=no
/ip proxy set enabled=no
/ip socks set enabled=no
/ip upnp set enabled=no
/ip cloud set ddns-enabled=no update-time=no
/ip ssh set strong-crypto=yes
/interface set X disabled=yes
#optional 
/lcd/pin/set pin-number=$1 hide-pin-number=yes