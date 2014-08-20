#!/usr/bin/env ruby

# Name:         pulsar
# Version:      0.0.6
# Release:      1
# License:      Open Source
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: Solaris, Red Hat Linux, SuSE Linux, Debian Linux,
#               Ubuntu Linux, Mac OS X, AIX FreeBSD
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Report script for pulsar
#               Wrapper script for puppet

require 'getopt/std'

options      = "cdi:fF:hm:Mp:RrvV"
$base_dir    = ""
$puppet_bin  = ""
$init_file   = ""
$module_file = ""
$fact_dir    = ""
$module_mode = "all"
$base_name   = "pulsar"
$detail      = "no"

$ruby_env    = [ 'export RUBY_HEAP_MIN_SLOTS=1000000',
                 'export RUBY_HEAP_SLOTS_INCREMENT=250000',
                 'export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1',
                 'export RUBY_GC_MALLOC_LIMIT=50000000' ]

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
  puts "-r:\tRun in report mode"
  puts "-R:\tRun in detailed report mode (includes test descriptions)"
  puts "-d:\tRun in debug mode (displays all puppet output"
  puts "-v:\tRun in verbose mode"
  puts "-m:\tSet which modules to run"
  puts "-M:\tList available modules"
  puts "-c:\tCheck local configuration"
  puts "-p:\tSpecify puppet bin to use (otherwise puppet in PATH is used)"
  puts "-i:\tSpecify init file to use (otherwise init file in test directory is used)"
  puts "-F:\tSet FACTERLIB path (otherwise is set to one for script)"
  puts
  return
end

# Do config check

def check_config()
  # Set base directory
  if $base_dir !~ /[A-z,0-9]/
    if $0 =~ /^\./
      $base_dir = Dir.pwd
    else
      $base_dir = File.dirname($0)
    end
    $base_dir = $base_dir.gsub(/\/report/,"")
  end
  if !File.directory?($base_dir) and !File.symlink?($base_dir)
    puts "Cannot find base directory " + $base_dir
    exit
  else
    if $verbose_mode
      puts "Setting base directory to "+$base_dir
    end
  end
  # Set fact directory
  if $fact_dir !~ /[A-z,0-9]/
    if $0 =~ /^\.|^report/
      $fact_dir = Dir.pwd+"/lib/facter"
    else
      $fact_dir = File.dirname($0)
      $fact_dir = $fact_dir+"/lib/facter"
    end
    $fact_dir = $fact_dir.gsub(/report\//,"")
  end
  if !File.directory?($fact_dir) and !File.symlink?($fact_dir)
    puts "Cannot find fact directory "+$fact_dir
    exit
  else
    if $verbose_mode
      puts "Setting fact directory to "+$fact_dir
    end
  end
  # Set module directory
  if $module_dir !~ /[A-z,0-9]/
    if $0 =~ /^\.|^reporter/
      $module_dir = Dir.pwd+"/manifests"
    else
      $module_dir = File.dirname($0)
      $module_dir = $module_dir+"/manifests"
    end
    $module_dir = $module_dir.gsub(/report\//,"")
  end
  if !File.directory?($module_dir) and !File.symlink?($module_dir)
    puts "Cannot find module directory "+$module_dir
    exit
  else
    if $verbose_mode
      puts "Setting module directory to "+$module_dir
    end
  end
  # Set init file
  if $init_file !~ /[A-z,0-9]/
    $init_file = $base_dir+"/test/init.pp"
  end
  if !File.exist?($init_file) and !File.symlink?($init_file)
    puts "Cannot find init file"+$init_file
  else
    if $verbose_mode
      puts "Using init file "+$init_file
    end
  end
  if $puppet_bin !~ /[A-z]/
    $puppet_bin = %x[which puppet].chomp
  end
  # Set puppet binary
  if !File.exist?($puppet_bin) and !File.symlink?($puppet_bin)
    puts "Cannot find puppet executable "+$puppet_bin
    exit
  else
    if $verbose_mode
      puts "Using puppet executable "+$puppet_bin
    end
  end
  # Set module file
  if $module_file !~ /[A-z]/
    $module_file = $fact_dir+"/"+$base_name+"_modules.rb"
  end
  if !File.exist?($module_file) and !File.symlink?($module_file)
    puts "Cannot find module file "+$module_file
    exit
  else
    if $verbose_mode
      puts "Using module file "+$module_file
    end
  end
  return
end

# Wrapper around puppet

def do_report()
  ruby_string  = $ruby_env.join(" ; ")
  command_line = "#{ruby_string} ; export FACTERLIB=#{$fact_dir} ; #{$puppet_bin} apply #{$init_file} #{$verbose_mode}#{$debug_mode}"
  if $verbose_mode
    puts "Executing: "+command_line
  end
  lines = %x[#{command_line}].split("\n")
  lines.each do |line|
    line = line.gsub(/Notice: /,"")
    if $detail == "yes"
      if line.match(/Auditing/)
        puts
        puts line
        check = line.split("(")[1].split(")")[0].gsub(/pulsar::/,"")
        file  = $module_dir+"/"+check.gsub(/::/,"/")+"/init.pp"
        if File.exist?(file)
          puts
          readme = %x[cat #{file} |grep '^#'].split("\n")
          readme.each do |info|
            if !info.match(/pulsar::|fact:/)
              puts info
            end
          end
          puts
        end
      else
        puts line
      end
    else
      puts line
    end
  end
  return
end

def update_module_file()
  module_list = get_avail_modules()
  if !module_list.to_s.match(/#{$module_mode}|all/)
    puts "Invalid module "+$module_mode
    puts
    list_modules()
    exit
  end
  if $verbose_mode
    puts "Creating "+$module_file
  end
  file = File.open($module_file,"w")
  file.write("# Set #{$module_name} modules mode\n")
  file.write("#\n")
  file.write("# This specifies which modules to run\n")
  file.write("\n")
  file.write("require 'facter'\n")
  file.write("\n")
  file.write("Facter.add('#{$base_name}_modules') do\n")
  file.write("  setcode do\n")
  file.write("    #{$base_name}_modules = '#{$module_mode}'\n")
  file.write("  end\n")
  file.write("end\n")
  file.close()
  return
end

def get_avail_modules()
  module_list = []
  dir_list = Dir.entries($module_dir)
  dir_list.each do |dir_item|
    if dir_item.match(/[A-z]/) and !dir_item.match(/\.pp$/)
      test_dir = $module_dir+"/"+dir_item
      if File.directory?(test_dir)
        module_list.push(dir_item)
      end
    end
  end
  module_list.push("full")
  return module_list
end

def list_modules()
  puts
  puts "Available modules:"
  puts
  module_list = get_avail_modules()
  module_list.each do |module_name|
    puts module_name
  end
  puts
  return
end

begin
  opt = Getopt::Std.getopts(options)
rescue
  print_usage(options)
  exit
end

if opt["h"]
  print_usage(options)
  exit
end

if opt["c"]
  check_config()
  exit
end

if opt["p"]
  $puppet_bin = opt["p"]
end

if opt["i"]
  $init_file = opt["i"]
end

if opt["F"]
  $fact_dir = opt["F"]
end

if opt["v"]
  $verbose_mode=" --verbose"
end

check_config()

if opt["f"]
  $fix_it = "yes"
end

if opt["V"]
  print_version()
  exit
end

if opt["M"]
  list_modules()
  exit
end

if opt["m"]
  $module_mode = opt["m"]
  update_module_file()
end

if opt["d"]
  $debug_mode = ""
else
  $debug_mode = " 2>&1 |grep -v \"]\" |grep -v \"'\""
end

if opt["R"]
  $detail = "yes"
end

if opt["r"] or opt["R"]
  do_report()
  exit
end
