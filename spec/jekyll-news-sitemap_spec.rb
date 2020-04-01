# frozen_string_literal: true

require "spec_helper"

describe(Jekyll::JekyllNewsSitemap) do
  let(:overrides) do
    {
      "source"      => source_dir,
      "destination" => dest_dir,
      "url"         => "http://example.org",
      "collections" => {
        "my_collection" => { "output" => true },
        "other_things"  => { "output" => false },
      },
    }
  end
  let(:config) do
    Jekyll.configuration(overrides)
  end
  let(:site)     { Jekyll::Site.new(config) }
  let(:contents) { File.read(dest_dir("sitemap_news.xml")) }
  before(:each) do
    site.process
  end

  it "has no layout" do
    expect(contents).not_to match(%r!\ATHIS IS MY LAYOUT!)
  end

  it "creates a sitemap_news.xml file" do
    expect(File.exist?(dest_dir("sitemap_news.xml"))).to be_truthy
  end

  it "doesn't have multiple new lines or trailing whitespace" do
    expect(contents).to_not match %r!\s+\n!
    expect(contents).to_not match %r!\n{2,}!
  end

  it "puts all the posts in the sitemap_news.xml file" do
    expect(contents).to match %r!<loc>http://example\.org/2014/03/04/march-the-fourth\.html</loc>!
    expect(contents).to match %r!<loc>http://example\.org/2014/03/02/march-the-second\.html</loc>!
    expect(contents).to match %r!<loc>http://example\.org/2013/12/12/dec-the-second\.html</loc>!
  end

  it "does not include assets or any static files that aren't .html" do
    expect(contents).not_to match %r!<loc>http://example\.org/images/hubot\.png</loc>!
    expect(contents).not_to match %r!<loc>http://example\.org/feeds/atom\.xml</loc>!
  end

  it "does not include any static files named 404.html" do
    expect(contents).not_to match %r!/static_files/404.html!
  end

  if Gem::Version.new(Jekyll::VERSION) >= Gem::Version.new("3.4.2")
    it "does not include any static files that have set 'sitemap: false'" do
      expect(contents).not_to match %r!/static_files/excluded\.pdf!
    end

    it "does not include any static files that have set 'sitemap: false'" do
      expect(contents).not_to match %r!/static_files/html_file\.html!
    end
  end

  it "does not include posts that have set 'sitemap: false'" do
    expect(contents).not_to match %r!/exclude-this-post\.html</loc>!
  end

  it "does not include pages that have set 'sitemap: false'" do
    expect(contents).not_to match %r!/exclude-this-page\.html</loc>!
  end

  it "does not include the 404 page" do
    expect(contents).not_to match %r!/404\.html</loc>!
  end

  it "includes the correct number of items" do
    # static_files/excluded.pdf is excluded on Jekyll 3.4.2 and above
    if Gem::Version.new(Jekyll::VERSION) >= Gem::Version.new("3.4.2")
      expect(contents.scan(%r!(?=<url>)!).count).to eql 7
    else
      expect(contents.scan(%r!(?=<url>)!).count).to eql 7
    end
  end

  context "with a baseurl" do
    let(:config) do
      Jekyll.configuration(Jekyll::Utils.deep_merge_hashes(overrides, "baseurl" => "/bass"))
    end

    it "correctly adds the baseurl to the posts" do
      expect(contents).to match %r!<loc>http://example\.org/bass/2014/03/04/march-the-fourth\.html</loc>!
      expect(contents).to match %r!<loc>http://example\.org/bass/2014/03/02/march-the-second\.html</loc>!
      expect(contents).to match %r!<loc>http://example\.org/bass/2013/12/12/dec-the-second\.html</loc>!
    end
  end
end