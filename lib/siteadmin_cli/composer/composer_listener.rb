require 'fileutils'
require 'json'
require 'siteadmin_cli/utils/project_traversal_utils'
require 'siteadmin_cli/json_file_parser'
require 'digest/md5'

module SiteadminCli::Composer
  class ComposerListener

    def start(dir)
      cache = get_listener_cache
      project_dir = SiteadminCli::Utils::ProjectTraversalUtils.get_project_directory dir
      hasher = Digest::MD5.new
      proj_cache_ref = hasher.hexdigest project_dir

      unless cache.include? proj_cache_ref
        cache[proj_cache_ref] = project_dir
        cache_file = File.open "#{get_cache_dir}/listeners.json", 'w'
        cache_file.write(JSON.pretty_generate cache)
        cache_file.close
      end
    end

    def stop(dir)
      cache = get_listener_cache
      project_dir = SiteadminCli::Utils::ProjectTraversalUtils.get_project_directory dir
      hasher = Digest::MD5.new
      proj_cache_ref = hasher.hexdigest project_dir

      if cache.include? proj_cache_ref
        cache.delete proj_cache_ref
        cache_file = File.open "#{get_cache_dir}/listeners.json", 'w'
        cache_file.write(JSON.pretty_generate cache)
        cache_file.close
      end
    end

    private
    def get_cache_dir
      '/vagrant/.cache/composer'
    end

    def get_proj_cache_dir(dir)

    end

    def get_listener_cache
      cache_path = "#{get_cache_dir}/listeners.json"
      unless File.exists? cache_path
        init_cache cache_path
      end

      SiteadminCli::JsonFileParser.parse cache_path
    end

    def init_cache(path)
      FileUtils.mkpath File.dirname(path)
      json = JSON
      cache = File.open path, 'w'
      cache.write(json.pretty_generate({}))
      cache.close
    end
  end
end