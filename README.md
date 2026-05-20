# motd
Custom tenbyte motds

### Ubuntu:

Install:

```bash
wget -O activate.sh https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/ubuntu/activate.sh && chmod +x activate.sh && ./activate.sh
```
Restore:
```bash
wget -O restore.sh https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/ubuntu/restore.sh && chmod +x restore.sh && ./restore.sh
```


### Rhel:

Install:
```bash
wget -O activate.sh https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/rhel/activate.sh && chmod +x activate.sh && ./activate.sh
```

restore:
```bash
wget -O restore.sh https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/rhel/restore.sh && chmod +x restore.sh && ./restore.sh
```


### Mac:
Install (standard):
```bash
curl -fsSL https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/activate.sh | bash
```
Install (nerd icons):
```bash
curl -fsSL https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/activate-nerd.sh | bash
```
Uninstall:
```bash
curl -fsSL https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/uninstall.sh -o /tmp/tenbyte-uninstall.sh && bash /tmp/tenbyte-uninstall.sh && rm /tmp/tenbyte-uninstall.sh
```
Restore (legacy):
```bash
curl -fsSL https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/restore.sh -o /tmp/tenbyte-restore.sh && bash /tmp/tenbyte-restore.sh && rm /tmp/tenbyte-restore.sh
```

### Windows:
Install (PowerShell 7):
```powershell
iwr https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/windows/activate.ps1 -OutFile activate.ps1; powershell -ExecutionPolicy Bypass -File .\activate.ps1; Remove-Item .\activate.ps1
```
Install (also hook legacy Windows PowerShell 5.1):
```powershell
iwr https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/windows/activate.ps1 -OutFile activate.ps1; powershell -ExecutionPolicy Bypass -File .\activate.ps1 -IncludeWindowsPowerShell; Remove-Item .\activate.ps1
```
Restore:
```powershell
iwr https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/windows/restore.ps1 -OutFile restore.ps1; powershell -ExecutionPolicy Bypass -File .\restore.ps1; Remove-Item .\restore.ps1
```

### Slackware/unRAID:
Install:
```bash
wget -O activate.sh https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/slackware/activate.sh && chmod +x activate.sh && ./activate.sh
```
Restore:
```bash
wget -O restore.sh https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/slackware/restore.sh && chmod +x restore.sh && ./restore.sh
```
