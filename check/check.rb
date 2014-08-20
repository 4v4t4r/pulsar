#!/usr/bin/env ruby

# Name:         module_check
# Version:      0.1.2
# Release:      1
# License:      Open Source
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: Solaris, Red Hat Linux, SuSE Linux, Debian Linux,
#               Ubuntu Linux, Mac OS X, AIX FreeBSD
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Check script for pulsar
#               Checks symlinks for facts

require 'getopt/std'
require 'mechanize'

options        = "acfhimrs:vV"
$fact_dir      = ""
$manifest_dir  = ""
$module_name   = "pulsar"
$template_name = "faust"
$template_url  = "https://raw.githubusercontent.com/lateralblast/"+$template_name+"/master/"+$template_name+".rb"

# Fix error / download required file

$fix_it  = "no"

# Create info facts

$do_info = "no"

# Facts specific to module

$mode_file     = $module_name+"_mode.rb"
$search_file   = $module_name+"_filesystemsearch.rb"
$package_file  = $module_name+"_uninstallpackage.rb"
$module_file   = $module_name+"_modules.rb"
$template_file = $template_name+".rb"
$module_facts  = [ $mode_file, $search_file, $package_file, $template_file, $module_file ]

# Set up variables for mode files

$fact_mode     = "detailedreport"
$search_mode   = "no"
$package_mode  = "no"
$module_mode   = "all"

# Print version information

def print_version()
  puts
  file_array = IO.readlines $0
  version    = file_array.grep(/^# Version/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  packager   = file_array.grep(/^# Packager/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  name       = file_array.grep(/^# Name/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  puts name+" v. "+version+" "+packager
  puts
  return
end

# Print usage information

def print_usage(options)
  puts
  puts "Usage: "+$0+" -["+options+"]"
  puts
  puts "-V:\tDisplay version information"
  puts "-h:\tDisplay usage information"
  puts "-a:\tPerform all test"
  puts "-m:\tCheck for missing symbolic links"
  puts "-i:\tCheck for invalid fact names"
  puts "-r:\tCheck for redundant symbolic links"
  puts "-f:\tFix errors (create symlinks etc)"
  puts "-c:\tCheck module configuration only"
  puts "-s:\tSearch facts"
  puts
  return
end

# Get a download

def get_download(url,file)
  agent = Mechanize.new
  agent.redirect_ok = true
  agent.pluggable_parser.default = Mechanize::Download
  begin
    agent.get(url).save(file)
  rescue
    if $verbose == 1
      puts "Error fetching: "+url
    end
  end
  return
end

# Create mode file if it doesn't exist

def check_mode_file()
  output_file = $fact_dir+"/"+$mode_file
  if !File.exist?(output_file)
    puts "Creating "+output_file
    file = File.open(output_file,"w")
    file.write("# Set #{$module_name} mode\n")
    file.write("#\n")
    file.write("# report         = Audit (no changes made)\n")
    file.write("# lockdown       = Lockdown (changes mage)\n")
    file.write("# detailedreport = Detailed Audit (Include Fix Information)\n")
    file.write("#\n")
    file.write("require 'facter'\n")
    file.write("\n")
    file.write("Facter.add('#{$module_name}_mode') do\n")
    file.write("  setcode do\n")
    file.write("    #{$module_name}_mode = '#{$fact_mode}'\n")
    file.write("  end\n")
    file.write("end\n")
    file.write("\n")
    file.close()
  end
  return
end

def check_package_file()
  output_file = $fact_dir+"/"+$package_file
  if !File.exist?(output_file)
    puts "Creating "+output_file
    file = File.open(output_file,"w")
    file.write("# Set #{$module_name} package uninstall mode\n")
    file.write("\n")
    file.write("# If set to yes, packages will be uninstalled\n")
    file.write("\n")
    file.write("require 'facter'\n")
    file.write("\n")
    file.write("Facter.add('#{$module_name}_uninstallpackage') do\n")
    file.write("  setcode do\n")
    file.write("    #{$module_name}_uninstallpackage = '#{$package_mode}'\n")
    file.write("  end\n")
    file.write("end\n")
    file.close()
  end
  return
end

def check_search_file()
  output_file = $fact_dir+"/"+$search_file
  if !File.exist?(output_file)
    puts "Creating "+output_file
    file = File.open(output_file,"w")
    file.write("# Set #{$module_name} filesystem search mode\n")
    file.write("#\n")
    file.write("# If set to yes, filesystem searches will be done\n")
    file.write("# This is disabled by default as it takes time\n")
    file.write("# To enable searches set to yes\n")
    file.write("# If using the template you will also need to enable searches in the template\n")
    file.write("\n")
    file.write("require 'facter'\n")
    file.write("\n")
    file.write("Facter.add('#{$module_name}_filesystemsearch') do\n")
    file.write("  setcode do\n")
    file.write("    #{$module_name}_filesystemsearch = '#{$search_mode}'\n")
    file.write("  end\n")
    file.write("end\n")
    file.close()
  end
  return
end

def check_module_file()
  output_file = $fact_dir+"/"+$module_file
  if !File.exist?(output_file)
    puts "Creating "+output_file
    file = File.open(output_file,"w")
    file.write("# Set #{$module_name} modules mode\n")
    file.write("#\n")
    file.write("# This specifies which modules to run\n")
    file.write("\n")
    file.write("require 'facter'\n")
    file.write("\n")
    file.write("Facter.add('#{$module_name}_modules') do\n")
    file.write("  setcode do\n")
    file.write("    #{$module_name}_modules = '#{$module_mode}'\n")
    file.write("  end\n")
    file.write("end\n")
    file.close()
  end
  return
end

def check_config()
  if $fact_dir !~ /[A-z,0-9]/
    if $0 =~ /^\.|^check/
      $fact_dir = Dir.pwd+"/lib/facter"
    else
      $fact_dir = File.dirname($0)
    end
    $fact_dir = $fact_dir.gsub(/check\//,"")
  end
  if !Dir.exist?($fact_dir)
    puts "Fact directory "+$fact_dir+" does not exist"
    exit
  else
    if $fact_dir !~ /facter/
      puts "Directory "+$fact_dir+" does not appear to be a facter library directory"
      exit
    else
      puts "Setting fact directory "+$fact_dir
    end
  end
  if $manifest_dir !~ /[A-z,0-9]/
    if $0 =~ /^\.|^manifests/
      $manifest_dir = Dir.pwd+"/manifests"
    else
      $manifest_dir = File.dirname($0)+"/manifests"
    end
    $manifest_dir = $manifest_dir.gsub(/check\//,"")
  end
  if !Dir.exist?($manifest_dir)
    puts "Manifest Directory "+$manifest_dir+" does not exist"
    exit
  else
    test_file = $manifest_dir+"/init.pp"
    if !File.exist?(test_file)
      puts "Directory "+$manifest_dir+" does not appear to be a manifest directory"
    else
      puts "Setting manifest directory to "+$manifest_dir
    end
  end
  template_file = $fact_dir+"/"+$template_name+".rb"
  if !File.exist?(template_file) and !File.symlink?(template_file)
    download_file = $fact_dir+"/"+$template_file
    if $fix_it == "yes"
      get_download($template_url,download_file)
    else
      puts "Fact template "+download_file+" does not exist"
      puts "Download template from "+$template_url+" to "+download_file
    end
  end
  check_mode_file()
  check_package_file()
  check_search_file()
  check_module_file()
  return
end

def get_fact_list()
  if $do_info == "yes"
    fact_list = %x[find #{$manifest_dir} -name init.pp -type f |xargs grep '# Requires fact' |awk '{print $1$4}' |sort |uniq].split("\n")
  else
    fact_list = %x[find #{$manifest_dir} -name init.pp -type f |xargs grep '# Requires fact' |awk '{print $1$4}' |grep -v '_info_' |sort |uniq].split("\n")
  end
  return fact_list
end

def get_file_list()
  file_list = %x[find #{$fact_dir} -name "*_*.rb" -type l].split("\n")
  return file_list
end

def invalid_facts()
  fact_list = get_fact_list()
  fact_list.each do |fact_line|
    fact_line     = fact_line.split(":")
    manifest_file = fact_line[0]
    fact_name     = fact_line[1..-1].join(":")
    fact_name     = fact_name.gsub(/^#/,"")
    fact_file     = fact_name+".rb"
    if !$module_facts.to_s.match(/#{fact_file}/)
      fact_file     = $fact_dir+"/"+fact_file
      fact_info     = fact_name.split("_")
      fact_module   = fact_info[0]
      if !fact_module.match(/#{$module_name}/)
        puts "Manifest "+manifest_file+" does not contain a valid fact ("+fact_name+")"
      end
    end
  end
  return
end

def missing_symlinks()
  fact_list = get_fact_list()
  fact_list.each do |fact_line|
    fact_line     = fact_line.split(":")
    manifest_file = fact_line[0]
    fact_name     = fact_line[1..-1].join(":")
    fact_name     = fact_name.gsub(/^#/,"")
    fact_file     = fact_name+".rb"
    if !$module_facts.to_s.match(/#{fact_file}/)
      fact_file     = $fact_dir+"/"+fact_file
      fact_info     = fact_name.split("_")
      fact_module   = fact_info[0]
      if !fact_module.match(/#{$module_name}/)
        puts "Manifest "+manifest_file+" does not contain a valid fact ("+fact_name+")"
      else
        if !File.exists?(fact_file) and !File.symlink?(fact_file)
          puts "File "+fact_file+" does not exist for fact "+fact_name
          if $fix_it == "yes"
            symlink_file  = fact_name+".rb"
            puts "Symlinking: "+symlink_file+" to "+$template_file
            %x[cd #{$fact_dir} ; ln -s #{$template_file} #{symlink_file}]
          end
        end
      end
    end
  end
  return
end

def redundant_symlinks()
  fact_list = get_fact_list()
  file_list = get_file_list()
  file_list.each do |file_name|
    fact_name = File.basename(file_name,".rb")
    if !fact_list.to_s.match(/#{fact_name}/)
      puts "Fact "+fact_name+" is not being used"
      if $fix_it == "yes"
        puts "Deleting: "+file_name
        File.delete(file_name)
      end
    end
  end
  return
end

def print_facts(search)
  fact_list = get_fact_list()
  fact_list.each do |fact_line|
    fact_line     = fact_line.split(":")
    manifest_file = fact_line[0]
    fact_name     = fact_line[1..-1].join("")
    fact_name     = fact_name.gsub(/^#/,"")
    fact_file     = fact_name+".rb"
    fact_file     = $fact_dir+"/"+fact_file
    if fact_name.downcase.match(/#{search.downcase}|full/)
      if !$module_facts.to_s.match(/#{fact_file}/)
        puts "Fact: "+fact_name
        puts "File: "+manifest_file
      end
    end
  end
  return
end

begin
  opt = Getopt::Std.getopts(options)
rescue
  print_usage(options)
  exit
end

if opt["v"]
  $verbose_mode = 1
else
  $verbose_mode = 0
end

if opt["h"]
  print_usage(options)
  exit
end

if opt["f"]
  $fix_it = "yes"
end

if opt["V"]
  print_version()
  exit
end

check_config()
if opt["c"]
  exit
end

if opt["s"]
  search    = opt["s"]
  fact_list = get_fact_list()
  print_facts(search)
  exit
end

if opt["i"] or opt["a"]
  invalid_facts()
  if !opt["a"]
    exit
  end
end

if opt["m"] or opt["a"]
  missing_symlinks()
  if !opt["a"]
    exit
  end
end

if opt["r"] or opt["a"]
  redundant_symlinks()
  if !opt["a"]
    exit
  end
end
