ENV.each { |k, v| env(k.to_sym, v) }

set :job_template, nil

def add(script)
  jmdsum = script.bytes.reduce(0) { |s, n| s * 256 + n }
  command "cd #{path} && flock -n /tmp/#{jmdsum}.flock #{script} >> /tmp/#{jmdsum}.output 2>&1"
end

every 1.minute do
  add 'date'
  add 'rails -v'
end
