require 'nokogiri'
require 'uri'
require 'net/https'

class Scrape
  EXCLUDE_IDS = %w[
    about
    accessibility
    events
    how-it-works
    javascript-behavior
    options
    methods
    notation
    triggers
    usage
    validation
    via-javascript
    via-data-attributes
  ]

  def initialize(file)
    @urls = []
    if File.exist?(file)
      IO.read(file).split(/[\r\n]+/).each do |link|
        @urls << link
      end
    else
      raise "Import failed: #{file} is missing."
    end
  end

  def get(url)
    puts "Downloading: #{url}"
    uri = URI(url)
    response = nil
    begin
      Net::HTTP.start(uri.host, uri.port,
        use_ssl: uri.scheme == 'https',
        verify_mode: OpenSSL::SSL::VERIFY_PEER) do |http|
          response = http.request(Net::HTTP::Get.new(uri))
      end
    rescue
      raise "Error: #{uri}"
    end

    if response.class == Net::HTTPOK
      file_name = nil
      nodes = []
      doc = Nokogiri::HTML(response.body)
      doc.css('main').each do |main|
        main.children.each do |child|
          child_name = child.name
          if child_name == 'h1'
            file_name = child.text.downcase
            child['id'] = nil
            nodes << child
          elsif child_name == 'h2' && !EXCLUDE_IDS.any? { |e| e == child['id'] }
            nodes << child
          elsif child_name == 'h3' && !EXCLUDE_IDS.any? { |e| e == child['id'] }
            nodes << child
          elsif child['class'] == 'bd-example'
            nodes << child
          elsif !child['class'].nil? && child['class'].include?('bd-example-row')
            child.children.each do |sub_child|
              if sub_child['class'] == 'bd-example'
                nodes << child
              end
            end
          elsif !child['class'].nil? && child['class'].include?('bd-example-border-utils')
            child.children.each do |sub_child|
              if sub_child['class'] == 'bd-example'
                nodes << child
              end
            end
          end
        end
      end

      File.open(File.join(Dir.pwd, 'templates', "#{file_name}.html"), 'w') do |file|
        nodes.each do |node|
          file.puts(node.to_html)
        end
      end
    end
  end

  def run
    @urls.each do |url|
      get(url)
      sleep(1) # Be friendly.
    end
  end
end

s = Scrape.new('bootstrap_docs.txt')
s.run