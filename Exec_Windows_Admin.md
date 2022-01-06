# Execute as a normal user
If you want to execute as yourself that is really easy.  Here we just check to see if we have Admin powers.

returns **False**
```
powershell.exe "(New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)"
```

# Executes as Administrator
Commands invoked as a different user must run in a new context, as a result there is no way to get the output back (without file redirection).  It will always launch in a new window.

## Option 1
If you have an admin account you can use ```-Verb runAs```.  A UAC popup will occur asking yes/no to allow this.

returns **True**
```
powershell.exe Start-Process powershell -Verb runAs -ArgumentList '@("-noexit","(New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)")'
```

## Option 2
If you need to enter a password you can use the ```-Credential myDomain\myUsername``` argument.  A user/pass credential box will open.

```
powershell.exe Start-Process powershell -Credential myDomain\myUsername -ArgumentList '@("-noexit","(New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)")'
```