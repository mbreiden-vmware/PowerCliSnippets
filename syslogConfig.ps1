#requires -Version 1
#requires -PSSnapin VMware.VimAutomation.Core

# Get all ESXi Hosts, set default rotate value to 8 and syslog host to syslogServer using EsxiCli V2


$esxis = Get-VMHost 
foreach ($esxi in $esxis)
{
    $esxcli = Get-EsxCli -VMHost $esxi -V2
    Write-Host -Object 'Configure Syslog'
    $esxcli.system.syslog.config.set.invoke(@{
            defaultrotate = 8
            loghost       = 'udp://syslogServer:514'
    })
    $syslog = Get-VMHostService -VMHost $esxi |
    Where-Object -FilterScript {
        $_.key -eq 'vmsyslogd'
    }
    Restart-VMHostService -HostService $syslog -Confirm:$false
}
