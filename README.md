## Memphis Config Reloader

This is a sidecar that you can use to automatically reload your Memphis configuration file.

### Configuring

```yaml
reloader:
  enabled: true
  image: memphisos/memphis-config-reloader-test:$(ver)
  pullPolicy: IfNotPresent
```

### Build Docker image

```sh
# First, add in Makefile specific version (line 8) of config reloader.

# Next, build Docker image like this
make memphis-config-reloader-dockerx
```
