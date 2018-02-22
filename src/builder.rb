require 'erb'

class LayoutRenderer
  def initialize(file)
    @file = file
    @layout = IO.read(File.join(Dir.pwd, 'layout.erb'))
    @template = IO.read(@file)
  end

  def render
    templates = [@template, @layout]
    templates.inject(nil) do | prev, temp |
      _render(temp) { prev }
    end
  end

  def _render temp
    ERB.new(temp).result(binding)
  end

  def save
    File.write(
      File.join(File.expand_path('..', Dir.pwd),
        'dist',
        File.basename(@file)), render)
  end
end

Dir.glob(File.join(Dir.pwd,'templates', '*.html')).each do |page|
  LayoutRenderer.new(page).save
end