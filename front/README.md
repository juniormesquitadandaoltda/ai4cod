# AI for Code .COM

### Install

- Do you use linux or mac? Configure your host: https://github.com/juniormesquitadandao/gerlessver
- Do you use windows? I'm sorry, docker doesn't work well on Windows.

```bash
cd front
  sh devops/chmod.sh
  ./devops/compose/config.sh
  ./devops/compose/build.sh
  ./devops/compose/up.sh
  ./devops/compose/exec.sh app bash
    ./devops/linux/status.sh
    exit
  ./devops/compose/down.sh
  exit
```

### Development

- Start terminal

```bash
cd front
  ./devops/compose/up.sh
  ./devops/compose/exec.sh app bash
    ./devops/node/install.sh
    ./devops/node/nobocop.sh

    ./devops/node/server.sh
    # browser: http://localhost:4004
    # CTRL + C
    exit
  ./devops/compose/down.sh
  exit
```

### Upgrading versions?

```bash
cd front
  ./devops/compose/down.sh
  ./devops/compose/delete.sh
  ./devops/compose/build.sh --no-cache
  ./devops/compose/up.sh
  exit
```

### Uninstall

```bash
cd front
  ./devops/compose/down.sh
  ./devops/compose/delete.sh
  exit
```
