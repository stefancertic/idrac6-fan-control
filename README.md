# idrac6-fan-control
Control Fan on IDrac 6 based servers (Dell Poweredge R720 and similar models with no function exposed over IDRAC) - Use on your own responsibility.

Script to controll Fans speed based on ambient temperature reading through IPMI
Do note that some / most IDRAC 6 based devices do not provide CPU temperature reading, hence Ambient Temperature is used as a reference. 

This script can demage CPU and cause overheating problems. There's no guarantee or responsibility taken - use it at your own discretion.
