# [ÆONVERA](https://www.aeonvera.com)

[![Join the chat at https://gitter.im/NullVoxPopuli/aeonvera](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/NullVoxPopuli/aeonvera?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

 A generic registration system aimed towards swing dance events.

 Also supports swing dancing scenes / organizations.
 ------------------------------

 L. Preston Sego III  
 Precognition, LLC

 ------------------------------

[![Build Status](https://travis-ci.org/NullVoxPopuli/aeonvera.svg)](https://travis-ci.org/NullVoxPopuli/aeonvera)
[![Code Climate](https://codeclimate.com/github/NullVoxPopuli/aeonvera/badges/gpa.svg)](https://codeclimate.com/github/NullVoxPopuli/aeonvera)
[![codebeat badge](https://codebeat.co/badges/371b7d4d-64fe-4375-8e0b-4a505ee2b2ea)](https://codebeat.co/projects/github-com-nullvoxpopuli-aeonvera)
[![Test Coverage](https://codeclimate.com/github/NullVoxPopuli/aeonvera/badges/coverage.svg)](https://codeclimate.com/github/NullVoxPopuli/aeonvera/coverage)

## Issues / Bug Reports

 [Submit an idea or bug report here](https://github.com/NullVoxPopuli/aeonvera/issues)

## Servers

  * [Production (aeonvera.com)](https://www.aeonvera.com)
  * [Staging (aeonvera-staging.work)](http://aeonvera-staging.work/)
    This is automatically updated every time the master branch is updated. Once test coverage gets over 90%, the production server will update automatically as well.
  * [Development (swing.vhost:3000)](http://swing.vhost:3000)
    For development on a local machine / this isn't publicly accessible.

## Environment Setup

  * Ruby Version >= 2.2
  * PostgreSQL >= 9.3
   - [Setup Guide for Ubuntu](https://gorails.com/setup/ubuntu/15.04)
    - `sudo apt-get install libpq-dev`
    - peer auth: http://stackoverflow.com/a/18664239/356849
  * PhantomJS >= 1.9
    - `apt-get install -y libqtwebkit-dev qt4-qmake
`

```
bundle install
rake db:create
rake db:migrate
rails s
```

## Environment Variables

  * S3_ACCESS_KEY_ID
  * S3_SECRET_ACCESS_KEY
  * STRIPE_CLIENT_ID
  * STRIPE_SECRET_KEY
  * STRIPE_PUBLISHABLE_KEY
  * REDISCLOUD_URL
  * MANDRILL_USERNAME
  * MANDRILL_APIKEY
  * DEVISE_SECRET_KEY
  * COOKIE_SECRET_KEY
  * TRUSTED_IP

## Tests

 Hosts file should contain the following entries

    127.0.0.1 swing.vhost
    127.0.0.1 testevent.test.local.vhost
    217.0.0.1 my.test.local.vhost

 To run all the tests

    rspec

 To run the coverage report

    COVERAGE=true rspec


## License

[GNU AFFERO GENERAL PUBLIC LICENSE](LICENSE.md)
