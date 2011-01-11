namespace :packaged_app do 
  

    desc "Build the app from shared source code"
    task :build do
      FileUtils.rm_rf "packaged_app/javascripts"
      FileUtils.rm_rf "packaged_app/stylesheets"
      
      html = ""
      
      Dir.glob("public/javascripts/**/*").each do |filename|
        unless  File.directory?(filename)
          src = filename
          dest = filename.gsub("public", "packaged_app")
          puts "#{src} -> #{dest}"
          FileUtils.mkdir_p(File.dirname(dest))
          FileUtils.cp(src, dest)
          html << %Q(<script src="#{dest.gsub("packaged_app/", "")}"></script>\n)
        end
      end
      
      Dir.glob("packaged_app/javascripts/models/*").each do |filename|
        puts "Changing storage adaptor used in #{filename}"
        file = File.open(filename, "r")
        content = file.read
        content.gsub!(%r{persistence: Model.REST\(.*\)}, "persistence: Model.localStorage()")
        file.close 
        
        file = File.open(filename, "w")
        file.write(content)
        file.close
      end
      
      system "sass --update public/stylesheets/sass:packaged_app/stylesheets"
      
      Dir.glob("public/stylesheets/images/**/*").each do |filename|
        unless  File.directory?(filename)
          src = filename
          dest = filename.gsub("public", "packaged_app")
          puts "#{src} -> #{dest}"
          FileUtils.mkdir_p(File.dirname(dest))
          FileUtils.cp(src, dest)
        end
      end
      
      
      main_html = File.open("packaged_app/templates/main.html", "r").read
      main_html.gsub!("#scripts", html)
      main_file = File.open("packaged_app/main.html", "w")
      main_file.write main_html
      main_file.close
    end
end