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
git clone --branch add-configuration-for-collection-order https://github.com/goodtouch/jekyll-dev-blog.git
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

## Current feature (WIP): Add configuration for collection order

In order to :
- help reduce the gap between document collections and posts (#3169 and #3690)
- help fixing #3539
- port #670 for collection (:grin:)

I started working on configurable way to define default sort order for collections in the metadata
(thus allowing to sort collections by date for example).

You can use the following syntax in `_config.yml` :

```yaml
my_date_sorted_collection:
  output: true
  order: data.date DESC, path
```

The string format supports multiple properties and nested fields (`data.time.start ASC`) (with limit to prevent abuse).

It generates static methods to prevent string manipulation performance issues (see benchmarks in #3720)

## WIP

You can:
- check out progresses [here](https://github.com/goodtouch/jekyll/tree/add-configuration-for-collection-order)
- or quick-start a blog with a vendored gem using this branch for those who want to test & hack things:

```
git clone --branch add-configuration-for-collection-order https://github.com/goodtouch/jekyll-dev-blog.git
cd jekyll-dev-blog
./script/bootstrap
./script/server
```

## To-do list:

- [X] Support nested fields (Jekyll::Sorter.order(docs, "data.time.start ASC"))
- [X] Validate format of the order string
- [X] Limit nesting level (2) and number of fields (2) to prevent GitHub Pages potential abuses
      (easy to change constants)
- [X] Make Posts and Collections use Jekyll::Sorter.order when populating liquid hashes
- [X] Add a Liquid filter (named order for now as it's not backward compatible with the sort filter)
      this one should fix #3539 if using order: 'time.start' instead of sort
- [X] Fix existing tests
- [X] Code documentation
- [X] Benchmarks (see #3720)
- [ ] Site doc
- [ ] Add some tests (for Sorter module and Liquid filter)
- [ ] Gracefully handle nil fields? (this should not be necessary)
- [ ] Count and limit maximum generated order methods to prevent abuse?
- [ ] Validate allowed top level fields for sorting (`date`, `slug`, `path`, ...)
      or make them available in a Hash (like `data` ?) and force sorting to use that hash.
