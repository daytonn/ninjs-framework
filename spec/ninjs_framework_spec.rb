require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe NinjsFramework do

  before :each do
    @fw = NinjsFramework.new
  end

  it 'should have the correct defaults' do
    @fw.defaults.should == {
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
  end

  it 'should have the correct manifest' do
    @fw.manifest.should == [
      'application',
      'elements',
      'lib',
      'models',
      'modules',
      'plugins',
      'spec',
      'spec/javascripts',
      'spec/javascripts/support'
    ]
  end

  it 'should have the correct name' do
    @fw.name.should == 'ninjs'
  end

  it 'should have a template_dir' do
    @fw.template_dir.should == "#{LIB}/ninjs-framework/templates"
  end

  context 'Using Ninjs::Project' do

    before :each do
      FileUtils.mkdir TMP_DIR unless File.exists? TMP_DIR
      @project = Ninjs::Project.new(name: 'myapp', root: TMP_DIR, framework: NinjsFramework)
      suppress_output { @project.create }
    end

    after :each do
      FileUtils.rm_rf "#{TMP_DIR}" if File.exists? TMP_DIR
    end

    it 'should create the default scaffold' do
      File.directory?("#{TMP_DIR}/application").should be_true
      File.directory?("#{TMP_DIR}/elements").should be_true
      File.directory?("#{TMP_DIR}/lib").should be_true
      File.directory?("#{TMP_DIR}/models").should be_true
      File.directory?("#{TMP_DIR}/modules").should be_true
      File.directory?("#{TMP_DIR}/plugins").should be_true
      File.directory?("#{TMP_DIR}/spec").should be_true
      File.directory?("#{TMP_DIR}/spec/javascripts").should be_true
      File.directory?("#{TMP_DIR}/spec/javascripts/support").should be_true
    end
    
    it 'should create a config file' do
      File.exists?("#{TMP_DIR}/ninjs.conf").should be_true
      "#{TMP_DIR}/ninjs.conf".should be_same_file_as "#{FIXTURES}/ninjs.conf"
    end

    it 'should create a lib/nin.js file' do
      File.exists?("#{TMP_DIR}/lib/nin.js").should be_true
      "#{TMP_DIR}/lib/nin.js".should be_same_file_as "#{FIXTURES}/nin.js"
    end

    it 'should create a lib/utilities.js file' do
      File.exists?("#{TMP_DIR}/lib/utilities.js").should be_true
      "#{TMP_DIR}/lib/utilities.js".should be_same_file_as "#{FIXTURES}/utilities.js"
    end

    it 'should create an application.js file' do
      File.exists?("#{TMP_DIR}/application/myapp.js").should be_true
      File.read("#{TMP_DIR}/application/myapp.js").match(/var\smyapp\s\=\snew\sNinjsApplication\(\)\;/).should be_true
    end

    it 'should import the Rakefile' do
      File.exists?("#{TMP_DIR}/Rakefile").should be_true
    end

    it 'should import the spec support files' do
      File.exists?("#{TMP_DIR}/spec/javascripts/support/jasmine_favicon.png").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/support/jasmine.css").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/support/jasmine.js").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/support/jasmine-html.js").should be_true
    end

    it 'should import the spec files' do
      File.exists?("#{TMP_DIR}/spec/javascripts/application_spec.js").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/array_utility_spec.js").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/existence_spec.js").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/extension_spec.js").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/module_spec.js").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/string_utility_spec.js").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/support/jasmine_config.rb").should be_true
      File.exists?("#{TMP_DIR}/spec/javascripts/support/jasmine_runner.rb").should be_true
    end

    it 'should update an application' do
      suppress_output { @project.update }
      "#{TMP_DIR}/application/myapp.js".should be_same_file_as "#{FIXTURES}/myapp.js"
    end
  end
end
