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
