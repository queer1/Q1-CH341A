@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges... 
goto request
) else (goto start)

:request
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b

:start
pushd %~dp0
echo MIIC4TCCAc2gAwIBAgIQ11X/6eS80LZKFs3C8zX89TAJBgUrDgMCHQUAMA4xDDAKBgNVBAMTA1dDSDAeFw0xNzEwMTYwOTQyNDJaFw0zOTEyMzEyMzU5NTlaMA4xDDAKBgNVBAMTA1dDSDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL7DABsjTWa5vWoBYKFKUSUOFdjAUc82tmLKPS1ysT1tjSbme9umRXU78pS6DhSYbPVZPTsdPD2+moQMkEVylCAizJB293V2immfbuuIbCFGmPH5y4iti37tJXdNKaZYQR3HONTcmJqYYCDjNbM4AH2Q6lK1MGcnD/klFwB2OiDwXS3Zfn3Dg+NC7r6YEAeG0pwrXVZl7T3VOpTe1bYPhSvutnCBSMIs2SbOZqfMy2MBi+tz764alZFrrzRDgMRygcxZz/qewg/RQe2ervRwds5bP7KrPj7OFkOpuCPznoTIdewqnbNxETTVse79TiqAMQvfCAcXUpsihVh3fyikhSECAwEAAaNDMEEwPwYDVR0BBDgwNoAQDVX4P2+QDRr+Wbln5SqKe6EQMA4xDDAKBgNVBAMTA1dDSIIQ11X/6eS80LZKFs3C8zX89TAJBgUrDgMCHQUAA4IBAQC9rpFbUT+M+rkj3SPq/rgknsiDfo5RjfIWwrTiSrnyF1iCsagoji48GxZr2/yMNyU0j6Shb74YCUeg7XtCHEEOrzCSeG05jos1nNeukChbYUDluNHkDuApLT44mV6ruyZ5ThekNw2Dtttzlp8tb2A0ubD7L2Ub5ijlMxIzJ+IkRiMGvqxzgGWIJvleZ/MpnwsgJ2hx8uMLK8Iun3lw1N9s2qaGM+3t8NtGWEfbMWyEXtC9zXNlmLVkORvF+43iqM+gI7Z/Q644uX3q56dWL++HA+eZzrFoNwJ1dGuDZ2EdID4N70R2ZH0VyJZqZloxrvW1rbcKZdFtNdld8sOFgWCU > cert.cer
certutil -delstore root wch > nul
certutil -delstore trustedpublisher wch > nul
certutil -addstore root cert.cer > nul
certutil -addstore trustedpublisher cert.cer > nul
del cert.cer
pnputil -i -a CH341A.inf > nul
echo Done!
echo.
pause