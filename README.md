**Logon Script for Trend Vision One Endpoint Sensor Deployment**

I've created a Logon script in VBS because we’ve found that using PowerShell can be complicated due to the variety of versions that may exist.
For proper functionality, follow these steps:
  1. Login into your tenant.
  2. Navigate to "EndPoint Inventory".
     2.1. “Installer Package” -> “Endpoint Sensor” -> “Operating System: Windows” -> “(x86_64)” -> “Download Installer.”
  3. Unzip the downloaded package:
     3.1. Extract the contents of the downloaded zip file. Place the extracted files in a Network Share accessible within your network.
  4. Ensure computers have access to the Network Share
  ![1](https://github.com/user-attachments/assets/5b269240-8623-4541-9859-e3e79c28a8da)

  6. Verify that all computers can reach the Network Share location.
  7. Deploy the Logon Script: Use Group Policy Objects (GPO) or System Center Configuration Manager (SCCM) to deploy the Logon Script.

Notes: 
Modify line 60 to specify the Network Share and the full path to the folder containing the installer and its components.
![2](https://github.com/user-attachments/assets/1416ea1e-f2ea-419f-8ca6-11a3747f5f1c)
The script installs the sensor using a direct connection to Vision One. 
If the client uses a proxy, comment out line 67 and uncomment line 69, specifying the IP or FQDN and port of the proxy
![3](https://github.com/user-attachments/assets/44bc8a8d-cbe0-4d70-b08b-e4cbfe4d55a2)
(only transparent proxies are supported).
