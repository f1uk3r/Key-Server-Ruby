# Key Server

## Problem Statement

Write a server that can generate random API keys, assign them for usage and release them after some time. The following endpoints should be available on the server to interact with it.

E1. There should be one endpoint to generate keys.

E2. There should be an endpoint to get an available key. On hitting this endpoint server should serve a random key that is not already being used. This key should be blocked and should not be served again by E2, until it is in this state. If no eligible key is available then it should serve 404.

E3. There should be an endpoint to unblock a key. Unblocked keys can be served via E2 again.

E4. There should be an endpoint to delete a key. Deleted keys should be purged.

E5. All keys are to be kept alive by clients calling this endpoint every 5 minutes. If a particular key has not received a keep alive in last five minutes then it should be deleted and never used again.
Apart from these endpoints, following rules should be enforced:

R1. All blocked keys should get released automatically within 60 secs if E3 is not called.

No endpoint call should result in an iteration of whole set of keys i.e. no endpoint request should be O(n). They should either be O(lg n) or O(1).

Hint : you can use a lightweight web frameworks for this assignment 

## How to Run the program

Have to install "Sinatra" Gem to run the server

> gem install sinatra --user-install

Run this command to run the server

> ruby server.rb