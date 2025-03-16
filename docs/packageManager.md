# Package Manager Issues

## What are the errors that I could see?
### Could not get lock /var/lib/dpkg/lock
This error occurs when two system processes attempt to access the /var/lib/dpkg/lock file simultaneously.

### Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by the `process` (apt)

### Could not get lock var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)

## Fixes
Take the following steps to examine the running processes:

### Check Running Processes

```bash
sudo ps aux | grep "process" 
```

- if you notice something suspicious. kill -9 `process` asap and try to install the package again. What is something suspicious, if another process is running you package manager! For example, if your using `apt` and another process is stuck using `apt` kill it and see if you can run `apt` again.

### Check dpkg services

```bash
sudo ps aux | grep -i dpkg
```

- If their is multiple users using dpkg communicate with your team and kill the process if needed

### Check if the /var/lib/dpkg/lock file is open 

``` bash
sudo lsof /var/lib/dpkg/lock
```
- The command has no output, meaning that the file is not open. If the file is used by one of the services, the output returns the process ID (PID). In that case, address the service as described in the next method.

## Deleting lock file
If everything else fails, delete the lock files. To accomplish this, use the rm command:

```bash
sudo rm /var/lib/dpkg/lock
sudo rm /var/lib/apt/lists/lock
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
```

- Once you delete all of the locks run

```bash
sudo dpkg --configure -a
```