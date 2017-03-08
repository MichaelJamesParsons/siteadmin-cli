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
      composer_path = "#{project_dir}/siteadmin/composer.json"
      hasher = Digest::MD5.new
      proj_dir_ref = hasher.hexdigest project_dir
      proj_cache_ref = hasher.hexdigest composer_path

      unless cache.include? proj_cache_ref
        cache[proj_dir_ref] = {
          cache: "#{proj_cache_ref}.json",
          path: composer_path
        }
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

    def rewind(dir)
      project_dir = SiteadminCli::Utils::ProjectTraversalUtils.get_project_directory dir
      cache = get_proj_cache project_dir

      if cache['current'].nil?
        if cache['history'].length > 0
          raise Exception, 'Cannot revert composer version. History exists but no current configuration is set. ' +
                            'Execute "siteadmin composer history list" to view all available histories. Then ' +
                            'execute "siteadmin composer history use {history item ID}" to set which configuration ' +
                            'you would like to revert to.'
        end

        raise Exception, 'Cannot revert composer version. Composer.json file has no recorded history.'
      end

      current = cache['current']

      if cache['history'][current]['prev'].nil?
        raise Exception, 'Cannot revert composer version. No previous composer.json history exists.'
      end

      new_current = cache['history'][current]['prev']
      cache['current'] = new_current
      cache['history'][new_current]['prev'] = current
      cache['history'][current]['next'] = new_current
    end

    def start
      puts 'listener initialized'
      listener = Listen.to(*list_listener_path_dirs, only: /composer\.json$/) do |modified, added, removed|
        add_cache_items added
        add_cache_items modified

      end
      listener.start
      sleep
    end

    private
    def list_listener_path_dirs
      cache = get_listener_cache.values
      paths = []

      cache.each { |item|
        paths.push File.dirname(item['path'])
      }
      paths
    end

    # todo some of this logic will be used by other commands. Refactor?
    def add_cache_items(cache_path)
      cache_path.each do |cache_item|
        cache = cache_path

        key = "#{Time.now.to_i}"
        current = cache['current']

        # Set new current item
        cache['current'] = key
        cache['history'][key] = {
            prev: current,
            next: nil,
            content: SiteadminCli::JsonFileParser.parse("#{cache_item}")
        }

        unless current.nil?
          cache['history'][current]['next'] = key
        end

        save_proj_cache cache_item, JSON.pretty_generate(cache)
      end
    end

    def get_cache_dir
      '/vagrant/.cache/composer'
    end

    def get_proj_cache(proj_dir)
      cache = get_listener_cache
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