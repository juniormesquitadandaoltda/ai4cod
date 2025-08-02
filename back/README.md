# AI for Code .COM

### Install

- Do you use linux or mac? Configure your host: https://github.com/juniormesquitadandao/gerlessver
- Do you use windows? I'm sorry, docker doesn't work well on Windows.

```bash
cd back
  sh devops/chmod.sh
  ./devops/compose/config.sh
  ./devops/compose/build.sh
  ./devops/compose/up.sh
  ./devops/compose/exec.sh postgresql bash
    psql --version
    exit
  ./devops/compose/exec.sh redis bash
    redis-cli --version
    exit
  ./devops/compose/exec.sh app bash
    ./devops/linux/status.sh
    exit
  ./devops/compose/down.sh
  exit
```

### Development

- Start terminal

```bash
cd back
  ./devops/compose/up.sh
  ./devops/compose/exec.sh app bash
    ./devops/rails/install.sh

    ./devops/postgresql/update.sh

    ./devops/rails/reset.sh
    ./devops/rails/rollback/development.sh
    ./devops/rails/migrate/development.sh

    ./devops/rails/terminal/development.sh
      Redis.new.keys
      exit

    ./devops/rails/rubocop.sh
    ./devops/rails/test.sh

    LOG=TRUE ./devops/rails/test.sh spec/models/application_record_spec.rb:4

    ./devops/rails/server/development.sh
      # browser: http://localhost:3004
      # CTRL + C
    exit
  ./devops/compose/down.sh
  exit
```

### Restoring db?

```bash
cd back
  # playground, sandbox, production
  ./devops/postgresql/restore/playground.sh
  ./devops/postgresql/restore/sandbox.sh
  ./devops/postgresql/restore/production.sh
  exit
```

### AWS

```bash
cd back
  ./devops/aws/ssh/playground.sh
  ./devops/aws/ssh/sandbox.sh
  ./devops/aws/ssh/production.sh
  exit
```

### Upgrading versions?

```bash
cd back
  ./devops/compose/down.sh
  ./devops/compose/delete.sh
  ./devops/compose/build.sh --no-cache
  ./devops/compose/up.sh
  exit
```

### Uninstall

```bash
cd back
  ./devops/compose/down.sh
  ./devops/compose/delete.sh
  exit
```

### Access new aws iam user

```txt
First Login: Access https://b8f472df-e050-421c-9038-21e35637df2d.signin.aws.amazon.com/console in an anonymous tab, enter username and password.

Change Password: Enter current and new password and confirm.

Enable MFA: Access https://us-east-1.console.aws.amazon.com/iamv2/home#/security_credentials/mfa in an anonymous tab, type "[username]-mfa-01" (e.g.: marcelo-mfa-01) in the name, click "next", click "show qrcode", read qrcode, enter the next 2 codes, save, log out, close all anonymous tabs.

Check the account: Access https:/b8f472df-e050-421c-9038-21e35637df2d.signin.aws.amazon.com/console in an anonymous tab, enter username and password, continue, enter new mfa code, access https://us-east-1.console.aws.amazon.com/settings/home, edit location, language english us, region us-east-2, save, access AWS Billing Dashboard, log out, close all anonymous tabs.

Access the normal tab https:/b8f472df-e050-421c-9038-21e35637df2d.signin.aws.amazon.com/console when you need it.
```