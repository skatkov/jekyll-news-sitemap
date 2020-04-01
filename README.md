# Jekyll::NewsSitemap

*Jekyll plugin to silently generate Google News Sitemap based on posts*

More info on Google News Sitemap could be found here:
https://support.google.com/news/publisher-center/answer/9606710?hl=en&ref_topic=9606468

This gem is a rip-off from jekyll-sitemap.
## Usage

1. Add `gem 'jekyll-news-sitemap'` to your site's Gemfile and run `bundle`
2. Add the following to your site's `_config.yml`:

```yml
url: "https://example.com" # the base hostname & protocol for your site
publisher: "The Example Times"
plugins:
  - jekyll-news-sitemap
```

💡 If you are using a Jekyll version less than 3.5.0, use the `gems` key instead of `plugins`.

If all gem plugins have the same `priority`, they will be executed in the
order they are required, generally. Thus, if you have other plugins which
generate content and store that content in `site.pages`, `site.posts`, or
`site.collections`, be sure to require `jekyll-news-sitemap` either *after*
those other gems if you *want* the sitemap to include the generated
content, or *before* those other gems if you *don't want* the sitemap to
include the generated content from the gems. (Programming is *hard*.)

Because the sitemap is added to `site.pages`, you may have to modify any
templates that iterate through all pages (for example, to build a menu of
all of the site's content).

## Note on Use with GitHub Pages Gem
The GitHub Pages gem ignores all plugins included in the Gemfile. If you only include `jekyll-news-sitemap` in the Gemfile without also including it in the `_config.yml` *the plugin will not work*. This can be confusing because the official Jekyll docs state that plugins can be included in either the Gemfile or `_config.yml`.

When building a site that uses the GitHub Pages gem, follow the instructions above and ensure that `jekyll-news-sitemap` is listed in the `plugins` array in `_config.yml`.

:warning: If you are using Jekyll < 3.5.0 use the `gems` key instead of `plugins`.


## Exclusions

If you would like to exclude specific pages/posts from the sitemap set the
sitemap flag to `false` in the front matter for the page/post.

```yml
sitemap: false
```

To exclude files from your sitemap. It can be achieved with configuration using [Jekyll v3.7.2 and jekyll-sitemap v1.2.0](https://github.com/jekyll/jekyll/commit/776433109b96cb644938ffbf9caf4923bdde4d7f).

Add a glob config to your `_config.yml` file. 

```yml
defaults:
  -
    scope:
      path:            "assets/**/*.pdf"
    values:
      sitemap:         false
```

## Override default development settings

[Follow these instructions on Jekyll's documentation](https://jekyllrb.com/docs/usage/#override-default-development-settings).

## Developing locally

* Use `script/bootstrap` to bootstrap your local development environment.
* Use `script/console` to load a local IRB console with the Gem.

## Testing

1. `script/bootstrap`
2. `script/cibuild`


## Contributing

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request
