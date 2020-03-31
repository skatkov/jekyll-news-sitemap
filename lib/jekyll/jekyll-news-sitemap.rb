# frozen_string_literal: true

require "fileutils"

module Jekyll
  class JekyllNewsSitemap < Jekyll::Generator
    safe true
    priority :lowest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      @site = site
      @site.pages << sitemap unless file_exists?("sitemap_news.xml")
    end

    private

    INCLUDED_EXTENSIONS = %w(
      .htm
      .html
      .xhtml
      .pdf
      .xml
    ).freeze

    # Matches all whitespace that follows
    #   1. A '>' followed by a newline or
    #   2. A '}' which closes a Liquid tag
    # We will strip all of this whitespace to minify the template
    MINIFY_REGEX = %r!(?<=>\n|})\s+!.freeze

    # Array of all non-jekyll site files with an HTML extension
    def static_files
      @site.static_files.select { |file| INCLUDED_EXTENSIONS.include? file.extname }
    end

    # Path to sitemap_news.xml template file
    def source_path(file = "sitemap_news.xml")
      File.expand_path "../#{file}", __dir__
    end

    # Destination for sitemap_news.xml file within the site source directory
    def destination_path(file = "sitemap_news.xml")
      @site.in_dest_dir(file)
    end

    def sitemap
      site_map = PageWithoutAFile.new(@site, __dir__, "", "sitemap_news.xml")
      site_map.content = File.read(source_path).gsub(MINIFY_REGEX, "")
      site_map.data["layout"] = nil
      site_map.data["static_files"] = static_files.map(&:to_liquid)
      site_map.data["xsl"] = file_exists?("sitemap.xsl")
      site_map
    end

    # Checks if a file already exists in the site source
    def file_exists?(file_path)
      pages_and_files.any? { |p| p.url == "/#{file_path}" }
    end

    def pages_and_files
      @pages_and_files ||= @site.pages + @site.static_files
    end
  end
end
