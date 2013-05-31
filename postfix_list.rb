#!/usr/bin/env ruby

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

def export_virtual(file, domains)
  domains.sort.map do |domain_name,domain|
    file.puts "##"
    file.puts "## #{domain_name}"
    file.puts "##"
    file.puts
    domain.sort.map do |list,addresses|
      db_path = "db/#{domain_name}/#{list}"
      list_address = "#{list}@#{domain_name}"
      file.puts "#{list_address.ljust(40)} #{addresses.join(',')}"
    end
    file.puts
    file.puts
  end
end

def export_domains(file, domains)
  domains.sort.map do |domain_name,domain|
    file.puts "#{domain_name.ljust(77)} OK"
  end 
end

domains = directory_hash('db')

export_virtual(File.open('/etc/postfix/virtual', 'w'), domains)
export_domains(File.open('/etc/postfix/domains', 'w'), domains)
