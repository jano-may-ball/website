---
title: "Installation"
date: 2010-024T19:02:50-07:00
draft: false
menu:
  docs:
    parent: 'GettingStarted'
    weight: 0
---

## Requirements

If you're not using the Docker image, you will need to make sure that the following are
installed on your machine:

* Web server (e.g. Apache or Nginx)
* PHP, version 7.1 or above
* Database (either MySQL or MariaDB)
* Node.js and npm

## Steps

* Clone repository and install dependencies
<pre><code class="language-bash">git clone https://github.com/jano-may-ball/ticketing.git
cd ticketing
composer install --no-dev
npm install</code></pre>
* Stylesheet can be customised by editing <code class="language-bash">resources/assets/sass/_variables.scss</code>
* Complie stylesheet and scripts
<pre><code class="language-bash">npm run production</code></pre>
* Edit the configuration file at <code class="language-bash">.env</code> and
  <code class="language-bash">storage/settings.hjson</code>
* Generate the public and private keys for OAuth authentication
<pre><code class="language-bash">openssl genpkey -algorithm RSA -out storage/oauth-private.key -pkeyopt rsa_keygen_bits:2048
openssl rsa -in storage/oauth-private.key -outform PEM -pubout -out storage/oauth-public.key</code></pre>
* Create tables required by the application
<pre><code class="language-bash">php jano migrate</code></pre>
* Point web server to <code>public</code> directory and **you're done**!

If you do not want to have to worry about the dependencies, you can also use the Docker
image [janomayball/ticketing](https://hub.docker.com/r/janomayball/ticketing).