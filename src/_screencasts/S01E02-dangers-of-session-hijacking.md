---
layout: post
title:  "Dangers of Session Hijacking"
date:   2015-05-20 23:38:42
category: rails
tags:
  - security
framework_version: 4.2.1
season: s01
episode: e02
---

If a user's authentication cookie is sent over an insecure connection it is vulnerable to session hijacking, or more specifically, sidejacking. Learn how this is done, and how you can prevent it.

We have a ToDo application where the user can either sign up or log in. Whenever we accept sensitive user information such as passwords it’s important that it’s sent over a secure connection so that it’s encrypted and not sent as plain text. This means that any login or signup forms should use HTTPS.

It’s quite common after signing in a user to switch back to HTTP as we no longer need the users to submit sensitive information. If we do this, however, our application is vulnerable to session hijacking. This technique, also known as sidejacking, was popularized a couple of years ago by a Firefox extension called [Firesheep](http://codebutler.com/firesheep/). With it we can visit a public WiFi location and monitor local network traffic and hijack any users’ sessions that take place over an unsecured connection.

We can demonstrate how a hijacker might hijack a session from a Rails application without using Firesheep. Instead we’ll use the tcpdump command. This comes with Mac OS X but similar commands are available for other operating systems. We can use this command to inspect traffic on a network interface, usually en0, en1 or en2, but here we’ll use lo0 to monitor localhost as that’s where the Rails application we’re monitoring is running. We’ll also use the -A flag to display the output as ASCII text.

Read more on [RailsCasts](http://railscasts.com/episodes/356-dangers-of-session-hijacking)!
