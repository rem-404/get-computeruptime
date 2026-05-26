# Get-ComputerUptime
*This script is for a lab environment and meant for learning purposes only*

## What does it do
Queries one or more remote computers and returns a clean object per machine with:

Computer name
Operating system name
Uptime in Days, Hours, and Minutes

Uses CIM (win32_operatingsystem) to pull the last boot time and calculates uptime from there.

## What does it solve
Written for PowerShell 5.1 compatibility where Get-Uptime is not available.
Checking uptime one machine at a time via RDP or individual commands is tedious. This lets you query multiple machines in one shot and get consistent readable output — useful for spotting machines that haven't been rebooted in a while or verifying a reboot actually happened.
Who's it for
Sysadmins who need a quick uptime check across multiple machines without logging into each one individually.

## Requirements
PowerShell with remoting enabled on target machines (Enable-PSRemoting)
Credentials with remote access to the target computers — the function will prompt via Get-Credential if $Credential isn't set in your session
WinRM accessible on target machines (port 5985)

## Usage
```
powershell# Single machine
Get-ComputerUptime -ComputerName DC01

# Multiple machines
Get-ComputerUptime -ComputerName DC01, DC02, THINKPAD-T470

# Pipeline from Get-ADComputerState (online machines only)
Get-ADComputerState | Where-Object { $_.Status -eq "Online" } | Get-ComputerUptime

# Using the alias
Get-ComputerUptime -Name DC01
```

## Warning
Defaults to localhost if no computer name is provided

## Limitations
No parallel execution — queries machines sequentially, will be slow on larger environments
Error handling returns a Write-Error string instead of a structured object — breaks pipeline consistency if an error occurs mid-batch
END {} block is empty — placeholder for future use

## Notes
Work in progress — parallel execution and consistent error object output coming in a future iteration. Pairs well with Get-ADComputerState for targeting online machines before querying.
