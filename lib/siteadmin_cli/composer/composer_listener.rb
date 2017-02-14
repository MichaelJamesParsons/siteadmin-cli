require 'fileutils'
require 'json'
require 'siteadmin_cli/utils/project_traversal_utils'
require 'siteadmin_cli/json_file_parser'
require 'digest/md5'
require 'listen'

module SiteadminCli::Composer
  class ComposerListener
    # todo - handle FileNotFound exception
    def subscribe(dir)
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

    # todo - handle FileNotFound exception
    def unsubscribe(dir)
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

    def start
      cache = get_listener_cache
      puts 'listener initialized'
      listener = Listen.to(*cache.values, only: /siteadmin\/composer\.json$/) do |modified, added, removed|
        add_cache_items added
        add_cache_items modified

      end
      listener.start
      sleep
    end

    private

    # todo some of this logic will be used by other commands. Refactor?
    def add_cache_items(proj_paths)
      proj_paths.each do |proj_path|
        cache = get_proj_cache proj_path

        key = "#{Time.now.to_i}"
        current = cache['current']

        # Set new current item
        cache['current'] = key
        cache['history'][key] = {
            prev: current,
            next: nil,
            content: SiteadminCli::JsonFileParser.parse("#{proj_path}")
        }

        unless current.nil?
          cache['history'][current]['next'] = key
        end

        save_proj_cache proj_path, JSON.pretty_generate(cache)
      end
    end

    def get_cache_dir
      '/vagrant/.cache/composer'
    end

    def get_proj_cache(proj_dir)
      hasher = Digest::MD5.new
      proj_cache_ref = hasher.hexdigest proj_dir
      cache_path = "#{get_cache_dir}/#{proj_cache_ref}.json"

      unless File.exists? cache_path
        init_proj_cache cache_path
      end

      SiteadminCli::JsonFileParser.parse cache_path
    end

    def save_proj_cache(proj_dir, cache)
      hasher = Digest::MD5.new
      proj_cache_ref = hasher.hexdigest proj_dir
      cache_path = "#{get_cache_dir}/#{proj_cache_ref}.json"
      file = File.open cache_path, 'w'
      file.write cache
      file.close
    end

    def init_proj_cache(cache_path)
      cache = File.open cache_path, 'w'
      cache.write JSON.pretty_generate({ current: nil, history: {}})
      cache.close
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