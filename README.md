# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: '2.4.5'
* Rails version: '5.2.4'

* Database creation and initialization
  - Create database by running `rails db:setup`, then `rails db:migrate`
  - Migrations are only required because the `params` that were when initializing rails project.
    * `rails new ip_validator --api -T -d mysql`

* How to run the test suite
  - Just by running `rails specs`.

* Services (job queues, cache servers, search engines, etc.)
  - The only available service at `lib/services/validations/ip_validator.rb`

* Deployment instructions
  - There is no deployment instructions.
  - Jut run this app in development mode with `rails server`

* Testing the only available service `validations/validate_ip`
  - Using an http client like Postman
  ```
  POST /validations/validate_ip HTTP/1.1
  Host: localhost:3000
  Content-Type: application/json
  Content-Length: 30

  {
    "ips": ["128.68.0.14"]
  }
  ```
  - curl
  ```
    curl --location --request POST 'http://localhost:3000/validations/validate_ip' \
         --header 'Content-Type: application/json' \
        --data-raw '{
          "ips": ["128.68.0.14"]
        }'
  ```
  - shell wget
  ```
    wget --no-check-certificate --quiet \
      --method POST \
      --timeout=0 \
      --header 'Content-Type: application/json' \
      --body-data '{
        "ips": ["128.68.0.14"]
    }' \
       'http://localhost:3000/validations/validate_ip'
  ```
