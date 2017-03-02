begin
    require 'deadweight'
rescue LoadError
end

desc 'run Deadweight CSS check (requires script/server)'
task :deadweight do
    dw = Deadweight.new
    dw.stylesheets = ['/stylesheets/application.css']
    dw.pages = ['/']
    dw.ignore_selectors = /flash_notice|flash_error|errorExplanation|fieldWithErrors/
    puts dw.run
end
