class NinjsFramework < Ninjs::Framework

  attr_accessor :template_dir

  def initialize
    @fw_root = File.expand_path('../', File.dirname(__FILE__))
    @lib_dir = File.expand_path('lib', @fw_root)
    @template_dir = File.expand_path('ninjs-framework/templates', @lib_dir)
    super({
      name: 'ninjs',
      manifest: [
        'application',
        'elements',
        'lib',
        'models',
        'modules',
        'plugins',
        'spec',
        'spec/javascripts',
        'spec/javascripts/support'
      ],
      defaults: {
        name: 'application',
        framework: 'ninjs',
        src_dir: 'modules',
        dest_dir: 'application',
        asset_root: '../',
        output: 'expanded',
        dependencies: ['<jquery/latest>'],
        autoload: ['../lib/utilities'],
        module_alias: 'm'
      }
    })
  end

  def create(root, config)
    @root = root
    @config = config
    create_ninjs_lib_file
    create_utility_lib_file
    create_ninjs_application_file
    import_rakefile
    import_spec_files
  end

  def update(root, config)
    @root = root
    @config = config
    update_application_file
  end
  
  def create_ninjs_lib_file
    operation = File.exists?("#{@root}/lib/nin.js") ? 'updated' : 'created'
    ninjs_lib_secretary = Sprockets::Secretary.new(
      :root         => "#{@lib_dir}/ninjs-framework",
      :load_path    => ["core", "extensions", "utilities"],
      source_files: ["core/nin.js"]
    )

    ninjs_lib_secretary.concatenation.save_to "#{@root}/lib/nin.js"

    puts Ninjs::Notification.added "lib/nin.js #{operation}"
  end
  
  def create_utility_lib_file
    utility_lib_secretary = Sprockets::Secretary.new(
      root: "#{@lib_dir}/ninjs-framework",
      load_path: ["core", "extensions", "utilities"],
      source_files: ["utilities/all.js"]
    )
    
    utility_lib_secretary.concatenation.save_to "#{@root}/lib/utilities.js"
    
    puts Ninjs::Notification.added "lib/utilities.js created"
  end
  
  def create_ninjs_application_file
    ninjs_lib = File.read("#{@root}/lib/nin.js")
    template = ERB.new(File.read(File.expand_path("#{@template_dir}/application.js.erb")))
    
    File.open("#{@root}/application/#{@config[:name].downcase}.js", "w+") do |file|
      file << template.result(binding)
    end
  end

  def import_rakefile
    FileUtils.cp "#{@fw_root}/Rakefile", "#{@root}/Rakefile"
  end

  def import_spec_files
    {
      "spec/javascripts/application_spec.js" => 'spec/javascripts/',
      "spec/javascripts/array_utility_spec.js" => 'spec/javascripts/',
      "spec/javascripts/existence_spec.js" => 'spec/javascripts/',
      "spec/javascripts/extension_spec.js" => 'spec/javascripts/',
      "spec/javascripts/module_spec.js" => 'spec/javascripts/',
      "spec/javascripts/string_utility_spec.js" => 'spec/javascripts/',
      "spec/javascripts/support/jasmine_config.rb" => 'spec/javascripts/support',
      "spec/javascripts/support/jasmine_runner.rb" => 'spec/javascripts/support',
      "lib/ninjs-framework/templates/test-index.html.erb" => 'spec/index.html',
      "lib/ninjs-framework/templates/jasmine.yml.erb" => 'spec/javascripts/support/',
      "lib/ninjs-framework/assets/jasmine/jasmine-html.js" => 'spec/javascripts/support/',
      "lib/ninjs-framework/assets/jasmine/jasmine.css" => 'spec/javascripts/support/',
      "lib/ninjs-framework/assets/jasmine/jasmine.js" => 'spec/javascripts/support/',
      "lib/ninjs-framework/assets/jasmine/jasmine_favicon.png" => 'spec/javascripts/support/'
    }.each { |src, dest| import_spec_file src, dest }
  end

  def import_spec_file(src, dest)
    FileUtils.cp "#{@fw_root}/#{src}", "#{@root}/#{dest}"
  end

  def update_application_file
    application_file = "#{@root}/#{@config[:dest_dir]}/#{@config[:name].downcase}.js"
    
    File.open(application_file, "w+") do |file|
      write_dependencies(file)
      write_core(file)
      write_autoload(file)
    end
    
    compile_application_file application_file
  end
  
  def write_dependencies(file)
    template = ERB.new(File.read(File.expand_path("#{@template_dir}/dependency.js.erb")))
    @config[:dependencies].each do |dependency|
      is_repo = dependency.match(/^\<.+\>$/)
      file << template.result(binding)
    end
  end
  
  def write_core(file)
    template = ERB.new(File.read(File.expand_path("#{@template_dir}/core.js.erb")))
    file << template.result(binding)
  end
  
  def write_autoload(file)
    template = ERB.new(File.read(File.expand_path("#{@template_dir}/autoload.js.erb")))
    @config[:autoload].each do |auto_file|
      is_repo = auto_file.match(/^\<.+\>$/)
      file << template.result(binding)
    end
  end
  
  def compile_application_file(file)
    begin
      ninjs_lib_secretary = Sprockets::Secretary.new(
        :root => Ninjs::BASE_DIR,
        :asset_root => @config[:asset_root],
        :load_path => ["repository"],
        source_files: ["#{file}"]
      )

      application_file = ninjs_lib_secretary.concatenation
      ninjs_lib_secretary.install_assets
      application_file.save_to "#{file}"
    rescue Exception => error
      @errors = true
      puts Ninjs::Notification.error "Sprockets error: #{error.message}"
    end
  end

end