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

  context 'Using Ninjs::Project' do

    before :each do
      FileUtils.mkdir "#{TMP_DIR}"
      @project = Ninjs::Project.new(root: TMP_DIR, framework: NinjsFramework)
      suppress_output { @project.create }
    end

    after :each do
      FileUtils.rm_rf "#{TMP_DIR}"
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
  end
end
