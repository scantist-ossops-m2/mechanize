require 'mechanize/test_case'

class TestMechanizeFile < Mechanize::TestCase

  def setup
    super

    @parser = Mechanize::File
  end

  def test_save
    uri = URI 'http://example/name.html'
    page = Mechanize::File.new uri, nil, '0123456789'

    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        page.save 'test.html'

        assert_equal '0123456789', File.read('test.html')
      end
    end
  end

  def test_save_default
    uri = URI 'http://example/test.html'
    page = Mechanize::File.new uri, nil, ''

    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        page.save

        assert File.exist? 'test.html'

        page.save

        assert File.exist? 'test.html.1'

        page.save

        assert File.exist? 'test.html.2'
      end
    end
  end

  def test_save_default_dots
    uri = URI 'http://localhost/../test.html'
    page = Mechanize::File.new uri, nil, ''

    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        page.save
        assert File.exist? 'test.html'

        page.save
        assert File.exist? 'test.html.1'
      end
    end
  end

  def test_filename
    uri = URI 'http://localhost/test.html'
    page = Mechanize::File.new uri, nil, ''

    assert_equal "test.html", page.filename
  end

  def test_save_bang_does_not_allow_command_injection
    uri = URI 'http://example/test.html'
    page = Mechanize::File.new uri, nil, ''

    in_tmpdir do
      page.save!('| ruby -rfileutils -e \'FileUtils.touch("vul.txt")\'')
      refute_operator(File, :exist?, "vul.txt")
    end
  end
end

