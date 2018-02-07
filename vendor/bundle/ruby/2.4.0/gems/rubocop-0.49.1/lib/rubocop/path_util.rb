# frozen_string_literal: true

module RuboCop
  # Common methods and behaviors for dealing with paths.
  module PathUtil
    module_function

    def relative_path(path, base_dir = Dir.pwd)
      # Optimization for the common case where path begins with the base
      # dir. Just cut off the first part.
      return path[(base_dir.length + 1)..-1] if path.start_with?(base_dir)

      path_name = Pathname.new(File.expand_path(path))
      path_name.relative_path_from(Pathname.new(base_dir)).to_s
    end

    def smart_path(path)
      # Ideally, we calculate this relative to the project root.
      base_dir = Dir.pwd

      if path.start_with? base_dir
        relative_path(path, base_dir)
      else
        path
      end
    end

    def match_path?(pattern, path)
      case pattern
      when String
        File.fnmatch?(pattern, path, File::FNM_PATHNAME)
      when Regexp
        begin
          path =~ pattern
        rescue ArgumentError => e
          return false if e.message.start_with?('invalid byte sequence')
          raise e
        end
      end
    end

    # Returns true for an absolute Unix or Windows path.
    def absolute?(path)
      path =~ %r{\A([A-Z]:)?/}
    end
  end
end
