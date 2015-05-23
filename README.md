# Jekyll Dev Blog

A Jekyll site that uses a local version of the jekyll gem (submodule in `vendor/jekyll`)
to quickly test changes and simplify your life when contributing to Jekyll.

Just point the submodule to your Jekyll's clone/feature_branch and start hacking
in the `vendor/jekyll` dir.

To test your changes, edit the blog sources in the `src` directory
and run `./script/server` or `script/console`.

## Available scripts

In the `script` folder, you'll find :

- `server`: Run jekyll serve --watch on port 4001
- `console`: Start a pry debugging console with a loaded Jekyll.
  You can use `init site` to load the `site` variable without writing the output files.

## Get started

```sh
git clone https://github.com/goodtouch/jekyll-dev-blog.git
cd jekyll-dev-blog
./script/bootstrap
```

To run a jekyll server:

```sh
./script/server
```

To run a debugger console:

```sh
./script/console
```

If you want to inspect the fully loaded `site` in the pry console:

```ruby
init site
```

## Current feature (WIP): Add custom classifications (aka groups) for collections

This is a port of #670 for collections

The main idea is to be able to group documents according to custom attributes (like `categories`, `tags`, or whatever you want)
(see #670 for full details and use cases)

You can use the following syntax to define your custom attributes in `_config.yml`:

```yml
collections:
  screencasts:
    output: true
    classifications:
      - categories
      - framework_version
      - tags
      - season
      - episode
```

Then simply define the classification attributes in the Front Matter of a `my_collection` document:

```yml
category: rails
tags:
  - view
  - plugins
  - bootstrap
framework_version: 4.2.1
season: S01
episode: E01
```

and use the following in any template:

```Liquid
<h2>Rails Screencasts</h2>
<ul>
  {% for screencast in site.screencasts.categories.rails %}
    <li>
      <a href="{{ screencast.url | prepend: site.baseurl }}">{{ screencast.title }}</a>
    </li>
  {% endfor %}
</ul>
```

Or if you want to list screencasts by Tags:

```Liquid
<h2>Screencasts by Tags</h1>
<ul>
  {% for tag in site.screencasts.tags %}
    <li>
      <span>{{ tag }}</span>
      <ul>
        {% for screencast in site.screencasts.tags[tag] %}
          <li>
            <a href="{{ screencast.url | prepend: site.baseurl }}">{{ screencast.title }}</a>
          </li>
        {% endfor %}
      </ul>
    </li>
  {% endfor %}
</ul>
```

Note that you can also access (and easily navigate) the full objects (with the metadata specified in `_config.yml`).
This example is more verbose, but allows to easily write nested loops in your liquid templates:

```Liquid
<h2>List Screencasts by</h2>

<ul>
  {% for classification in site.collections.screencasts.classifications %}
    <li>
      <span>{{ classification.label }}</span>
      <ul>
        {% for index in site.collections.screencasts.classifications[classification.label].indexes %}
          <li>
            <span>{{ index.label }}</span>
            <ul>
              {% for screencast in site.collections.screencasts.classifications[classification.label].indexes[index.label].docs %}
                <li>
                  <a href="{{ screencast.url | prepend: site.baseurl }}">{{ screencast.title }}</a>
                </li>
              {% endfor %}
            </ul>
          </li>
        {% endfor %}
      </ul>
    </li>
  {% endfor %}
</ul>
```

## Implementation Details

#### Add the Classification class

Collections now have classification, defined as specified in the `_config.yml` file.
Each classification build an index of the grouped documents, according to the values found in the Front Matter.

It exposes the following attributes in liquid:

- label
- indexes
- merged metadata

#### Provide easy navigation / iteration in Liquid templates.

Added the following simple classes (inheriting from Hash) to provide easy navigation / iteration in Liquid templates:

- `Hash`
  - `LiquidHashWithArray < Hash`
    - `LiquidHashWithKeys < LiquidHashWithArray`
    - `LiquidHashWithValues < LiquidHashWithArray`

The idea is to have a uniq object that behave like:
- a Hash for access (so you can do `{{ hash.key }}` in Liquid)
- an Array for iteration (so you can do `{% for item in array %}` in Liquid)

The `LiquidHashWithArray` allows you to `attach` an array to a Hash and then delegate the `each` method to the array.
`LiquidHashWithKeys` and `LiquidHashWithValues` classes are simple `LiquidHashWithArray` that automatically attach
`hash.keys` or `hash.values` as the default array to iterate through.

When populating data for Liquid templates, we generally want to provide either:
- 'fast access' Hashes (think `site.my_collection => [docs]`) that are easy to navigate through to a specific point as long as the path is static, but not user friendly to iterate through (it forces the use of `item[0]` and `item[1]` because you iterate on a Hash, and it becomes ugly when you try to iterate through nested hashes because you can't use the 'chained dots' to access data with dynamic values and the `hash[key1][key2]` syntax is not allowed in liquid),
- or 'full object' Array (think `site.collections => [collections]`) that are easy to iterate through, but hard to navigate through (you can't do `site.collection.my_collection` if you want to access this specific collection for example).

Using `LiquidHashWithKeys` when you want to provide 'fast access' Hashes or `LiquidHashWithValues` when you want to provide 'full object' Arrays makes it easy to
solves this problem, remains backward compatible and provides a user friendly interface in liquid:

```Liquid
{% for collection in site.collections %}
  works just as before
{% endfor %}
```

But you can also do:

```Liquid
{{ site.collections.mycollection.label }}
```

This becomes quite usefull when providing fast access to grouped docs in collections (aka. classifications),

where you want to be able to do:

```Liquid
{% for doc in site.my_collection %}
  works just as before
{% endfor %}
```

But also:

```Liquid
{% for doc in site.my_collection.categories.rails %}
  ...
{% endfor %}
```

and

```Liquid
{% for category in site.my_collection.categories %}
  {{ category }}

  {% for doc in site.my_collection.categories[category] %}
    ...
  {% endfor %}
{% endfor %}
```

Or even:

```Liquid
{% for classification in site.collections.my_collection.classifications %}
  {% classification.label %}

  {% for index in site.collections.screencasts.classifications[classification.label].indexes %}
    {{ index.label }}

    {% for doc in site.collections.screencasts.classifications[classification.label].indexes[index.label].docs %}
      ...
    {% endfor %}

  {% endfor %}

{% endfor %}
```

When used in 'Ruby land', those classes also provide a `map` method that automatically returns an object of the same class (a Hash instead of a `[[key1, value1], [key2, value2]]` array) to simplify most common use case and a `to_liquid` method that maps to the `values`.

## WIP

You can:
- check out progresses [here](https://github.com/goodtouch/jekyll/tree/add-collection-classifications)
- or quick-start a blog with a vendored gem using this branch for those who want to test & hack things:

```
git clone --branch add-collection-classifications https://github.com/goodtouch/jekyll-dev-blog.git
cd jekyll-dev-blog
./script/bootstrap
./script/server
```

## To-do list:

- [X] define classification class
- [X] add classifications to collections
- [X] define hash helper classes to makes it user friendly in Liquid
- [X] prevent inappropriate uses and common mistakes of those helper classes by raising exceptions
- [X] Add Inflector to handle singular keys
- [ ] add some validations (sanitize name etc..)
- [ ] allow to define relative path for documents in collection? (categories wouldn't be a special case then)
- [ ] allow to define collection default order for documents (depends on #3720)
- [ ] extract Liquid Hash helper classes in an other PR?
- [ ] in-code documentation
- [ ] add doc in site/docs
- [ ] add some tests
