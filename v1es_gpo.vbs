 ' ------------------------------------------------------------------------- '
' Script Name: GPOdeploy_xbc.vbs                                            '
' Version: 1.0                                                              '
' Author: Alex Ortiz, Trend Vision One SME                                  '
' Date: 06-08-2024                                                          '
' Objective: This script installs TMV1 XDR sensor                           '
' ------------------------------------------------------------------------- '     

Option Explicit
Dim WshShell, objFSO, strUserProfilePath, strLogFilePath, strTempPath, strCUTPath, strCommand

' Define function to get the current date and time for logging purposes

Function GetCurrentDateTime()
    Dim dtNow
    dtNow = Now
    GetCurrentDateTime = FormatDateTime(dtNow, 0)
End Function

Set WshShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
strUserProfilePath = WshShell.ExpandEnvironmentStrings("%temp%")

' Initialize Log File
strLogFilePath = strUserProfilePath & "\gpo-xbcInstall.log"
Dim objLogFile
Set objLogFile = objFSO.OpenTextFile(strLogFilePath, 8, True)

' Check if the XBC agent is already installed
Function IsXBCAgentRunning()
    Dim arrNewAgentProcesses, strProcess, colProcessList, blnIsRunning
    arrNewAgentProcesses = Array("EndpointBasecamp.exe", "CloudEndpointService.exe")
    blnIsRunning = False
    For Each strProcess In arrNewAgentProcesses
        Set colProcessList = GetObject("winmgmts:\\.\root\cimv2").ExecQuery("Select * from Win32_Process where Name = '" & strProcess & "'")
        If colProcessList.Count > 0 Then
            blnIsRunning = True
            Exit For
        End If
    Next
    IsXBCAgentRunning = blnIsRunning
End Function

If IsXBCAgentRunning() Then
    objLogFile.WriteLine GetCurrentDateTime() & " - The Endpoint Sensor is already installed. Aborting installation."
    ' Clean and exit
    If Not objLogFile Is Nothing Then objLogFile.Close
    Set WshShell = Nothing
    Set objFSO = Nothing
    WScript.Quit
End If

objLogFile.WriteLine GetCurrentDateTime() & " - Starting Endpoint Basecamp installation process..."

' Set the current directory to the user profile
strTempPath = strUserProfilePath
objLogFile.WriteLine GetCurrentDateTime() & " - Current directory set at: " & strTempPath

' Copy only the contents of the "TMSensorAgent_Windows_x86_64" folder from the network share to the user profile location
strCommand = "robocopy " & Chr(34) & "\\{IpTargetShare}\{path}\TMSensorAgent_Windows_x86_64" & Chr(34) & " " & Chr(34) & strTempPath & Chr(34) & " /E"
WshShell.Run strCommand, 0, True
objLogFile.WriteLine GetCurrentDateTime() & " - EndpointBasecamp copied to user profile location."

' Proceed to install EndPoint Sensor (Direct Connection To Vision One)
strCUTPath = strTempPath & "\EndpointBasecamp.exe"
If objFSO.FileExists(strCUTPath) Then
    WshShell.Run Chr(34) & strCUTPath & Chr(34), 1, True
' if endPoints use proxy, comment the previous line and comment out the following one, then modify as needed the proxy server Ip and port (Only transparent Proxy Supported)
'    WshShell.Run Chr(34) & strCUTPath & Chr(34) & " /proxy_server_port proxy_server_ip_or_fqdn:port", 1, True
    objLogFile.WriteLine GetCurrentDateTime() & " - Installation in Progress..."
Else
    objLogFile.WriteLine GetCurrentDateTime() & " - Error: EndpointBasecamp not Found, check Network connectivity."
    WScript.Quit
End If

' Clean up
If Not objLogFile Is Nothing Then objLogFile.Close
Set WshShell = Nothing
Set objFSO = Nothing