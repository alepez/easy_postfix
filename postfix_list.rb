#!/usr/bin/env ruby

require 'awesome_print'

def read_db(db_path)
  data = []
  File.open(db_path, "r").each_line do |line|
    data << line.split(" ").first
    data.delete_if { |val| !val }
  end
  data
end

def directory_hash(path)
  data = {}
  Dir.foreach(path) do |entry|
    next if (entry == '..' || entry == '.')
    entry_path = File.join(path, entry)
    if File.directory?(entry_path)
      data[entry] = directory_hash(entry_path)
    else
      data[entry] = read_db(entry_path)
    end
  end
  data
end

def print_virtual(domains)
  domains.sort.map do |domain_name,domain|
    puts "##"
    puts "## #{domain_name}"
    puts "##"
    puts
    domain.sort.map do |list,addresses|
      db_path = "db/#{domain_name}/#{list}"
      list_address = "#{list}@#{domain_name}"
      puts "#{list_address.ljust(40)} #{addresses.join(',')}"
    end
    puts
    puts
  end
end

def print_domains(domains)
  domains.sort.map do |domain_name,domain|
    puts "#{domain_name.ljust(77)} OK"
  end 
end

domains = directory_hash('db')

print_virtual(domains)
print_domains(domains)
