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
```bash
wget -O activate.sh https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/rhel/activate.sh && chmod +x activate.sh && ./activate.sh
```

### Mac:
install:
```bash
curl -fsSL https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/activate.sh | bash
```
restore:
```bash
curl -fsSL https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/restore.sh -o /tmp/tenbyte-restore.sh && bash /tmp/tenbyte-restore.sh && rm /tmp/tenbyte-restore.sh
```
