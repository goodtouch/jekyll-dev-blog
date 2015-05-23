---
layout: post
title:  "Twitter Bootstrap Basics"
date:   2015-05-19 23:38:42
category: rails
tags:
  - view
  - plugins
  - bootstrap
framework_version: 4.2.0
season: s01
episode: e01
---

Twitter Bootstrap can help make beautiful web apps quickly by providing you with useful CSS and JavaScript. Here you will learn how to include it into Rails with the twitter-bootstrap-rails gem.

[Twitter’s Bootstrap](http://twitter.github.com/bootstrap/) helps you build beautiful web apps quickly. It provides a variety of CSS and JavaScript for making layouts, navigation, forms and a lot more and it even includes support for responsive web design. As an example, if you visit its homepage and alter the width of the browser window the page layout will change to best fit that width. This can really improve the experience of using web applications on mobile devices.

It’s well worth taking some time to explore the Twitter Bootstrap website to see everything that it provides but in this episode we’re going to show you how you can use it with a Rails application. One option is to download the static CSS and JavaScript by clicking on the “Download Bootstrap” button and then move the appropriate files into /app/assets directory. This isn’t the best approach if you’re using Rails, however. Twitter Bootstrap is written using LESS, which is a CSS preprocessor and which is very similar to the SASS used by Rails.

To get the most flexibility from Twitter Bootstrap it’s best to use it with a dynamic language, such as LESS, instead of using the static compiled files which it outputs. To get LESS working with Rails we’ll need the help of some Ruby gems. There are several gems available for integrating Bootstrap with Rails. In this episode we’ll be using the [twitter-bootstrap-rails](https://github.com/seyhunak/twitter-bootstrap-rails) gem but we’ll mention some of the alternatives later. We’ve chosen this gem as it works directly with LESS and offers some nice generators to help us get started. We’re getting a little ahead of ourselves here, though as we don’t even have a Rails application to work with yet.

### Adding Bootstrap to a New Rails Application.

We’ll start with a new app that we’ll call `store` and we’ll generate a scaffold for a `Product` model so that we have something to work with.

{% highlight sh %}
rails new store
cd store
rails g scaffold product name price:decimal --skip-stylesheets
rake db:migrate
{% endhighlight %}

Note that we’ve used the --skip-stylesheets option in the scaffold as we want to use Bootstrap’s CSS instead of the scaffolding’s. We’ve also migrated the database so that the products table is created. Here’s what the generated scaffold page looks like. It isn’t very pretty as we don’t have any styling applied. It’s time to add Twitter Bootstrap...

Read more on [RailsCasts](http://railscasts.com/episodes/328-twitter-bootstrap-basics)!
