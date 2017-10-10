# frozen_string_literal: true

module Rails
  class Engine
    # https://github.com/rails/rails/blob/5-1-stable/railties/lib/rails/engine.rb#L472-L479
    # https://github.com/rails/rails/blob/4-2-stable/railties/lib/rails/engine.rb#L468
    def eager_load!
      config.eager_load_paths.each do |load_path|
        matcher = /\A#{Regexp.escape(load_path.to_s)}\/(.*)\.rb\Z/
        Dir.glob("#{load_path}/**/*!(spec).rb").sort.each do |file|
          require_dependency file.sub(matcher, '\1')
        end
      end
    end
  end
end
