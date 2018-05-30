require 'nokogiri'
require 'pp'

ASSEMBLIES = {}

# Given a .csproj file, load the xml seeking elements of data from
# specifiec propertygroups, the directory, and file base name.
def load_projects(base, csproj)
  Dir.chdir(base)  # Because of relative references in the csproj file
  doc = Nokogiri::XML(File.open(csproj))
  prj = {
      asmname: doc.css('PropertyGroup > AssemblyName').text,
      outtype: doc.css('PropertyGroup > OutputType').text,
      config: doc.css('PropertyGroup > Configuration').text,
      dirname: File.dirname(File.absolute_path(csproj)),
      fname: File.basename(csproj,'.*'),
      refs: []
  }

  # save the project if it does not already exist in the hash
  ASSEMBLIES[prj[:asmname]] = prj unless ASSEMBLIES.has_key?(prj[:asmname])

  # recurse each project reference made in this project
  begin
    doc.css('ItemGroup > ProjectReference').each {|o|
      csproj = o.attributes['Include'].value.gsub('\\','/')
      prj[:refs] << csproj
      load_projects(prj[:dirname], csproj)
    }
  rescue
    pp '<<<<<<<',prj,'>>>>>>>'
    raise
  end

end

# ============== DO STUFF BELOW =================

# fname = 'C:\Code\Branches\NIEDO\DriverManagement\ConsoleApps\RTIDMRDOCalculationUpdate\RTIDMRDOCalulationUpdate\RTIDMRDOCalulationUpdate.csproj'.gsub('\\','/')
# fname = 'c:/code/branches/niedo/companymanagement/consoleapps/rticompanyuserreplication/rticompanyuserreplication.csproj'
# fname = 'c:/code/branches/niedo/operationsmanagement/consoleapps/rtieventsbackgroundprocess/rtieventsbackgroundprocess.csproj'
fname = 'c:/code/branches/niedo/shared/webapps/rtiportal/rtiportal.csproj'
load_projects(File.dirname(fname), fname)

puts '','====='*3
puts "project base(#{File.basename(fname,'.*').upcase})"
puts "assembly references(#{ASSEMBLIES.size})",''
ASSEMBLIES.sort.each{|key,asm|
  puts sprintf('%-30s | %-10s | %-7s | %-s',asm[:asmname],asm[:outtype],asm[:config],asm[:dirname])
  asm[:refs].each {|ref|
    puts sprintf('%-30s   %-10s   %-7s>> %-s','','','',ref)
  }
}

# what projects make reference to rtibusinesslayer
puts '','====='*3
ASSEMBLIES.sort.each{|key,asm|
  if (asm[:refs].map{|r| File.basename(r,'.*').downcase}).include?('rtibusinesslayer')
  # if asm[:fname].downcase == 'rtibusinesslayer'
    puts sprintf('%-30s | %-10s | %-7s | %-s',asm[:asmname],asm[:outtype],asm[:config],asm[:dirname])
  end
}


__END__
dlls = {}
dll_count = 0
ASSEMBLIES.each {|key,fname|
  Dir.glob(File.join(fname[:dirname],'bin/debug','*.{dll,xml}')).each {|dll|
    dll_count += 1
    dlls[File.basename(dll)] = dll unless dlls.has_key?(File.basename(dll))
  }
}

puts ''*2,'====='*2
puts "qty dlls across all assemblies(#{dll_count})"
puts "qty unique dlls across all assemblies(#{dlls.size})",''

dlls.sort.each{|key,val| puts sprintf('%-45s | %s',key,val)}

puts ''*2,'====='*2
dlls.sort.each{|key,val|
  puts sprintf(
           '%-45s | %s',
           key[0,45],
           val.gsub(/C:\/Code\/Branches\/NIEDO/i,'**/bin/$(BuildConfiguration)').gsub('/','\\')
       )
}
