namespace :packaged_app do 
  

    desc "Build the app from shared source code"
    task :build do
      FileUtils.rm_rf "packaged_app/dist/"
      
      script_html = ""
      
      Dir.glob("public/javascripts/**/*").each do |filename|
        unless  File.directory?(filename)
          src = filename
          dest = filename.gsub("public", "packaged_app/dist")
          puts "#{src} -> #{dest}"
          FileUtils.mkdir_p(File.dirname(dest))
          FileUtils.cp(src, dest)
          script_html << %Q(<script src="#{dest.gsub("packaged_app/dist", "")}"></script>\n)
        end
      end
      
      Dir.glob("packaged_app/dist/javascripts/models/*").each do |filename|
        puts "Changing storage adaptor used in #{filename}"
        file = File.open(filename, "r")
        content = file.read
        content.gsub!(%r{persistence: Model.REST\(.*\)}, "persistence: Model.localStorage()")
        file.close 
        
        file = File.open(filename, "w")
        file.write(content)
        file.close
      end
      
      system "sass --update public/stylesheets/sass:packaged_app/dist/stylesheets"
      
      Dir.glob("public/stylesheets/images/**/*").each do |filename|
        unless  File.directory?(filename)
          src = filename
          dest = filename.gsub("public", "packaged_app/dist")
          puts "#{src} -> #{dest}"
          FileUtils.mkdir_p(File.dirname(dest))
          FileUtils.cp(src, dest)
        end
      end

      Dir.glob("packaged_app/public/**/*").each do |filename|
        unless  File.directory?(filename)
          src = filename
          dest = filename.gsub("packaged_app/public", "packaged_app/dist")
          puts "#{src} -> #{dest}"
          FileUtils.mkdir_p(File.dirname(dest))
          FileUtils.cp(src, dest)
        end
      end
      
      file = File.open("packaged_app/dist/main.html", "r")
      html = file.read
      file.close
      
      html.gsub!("#scripts", script_html)
      
      file = File.open("packaged_app/dist/main.html", "w")
      file.write html
      file.close
    end
end