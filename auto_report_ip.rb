class AutoReportIP
  require 'net/smtp'
  require 'socket'
  require 'yaml'

  # 获取本机IP
  ip_list = Socket.ip_address_list
  ip_message = ""
  ip_list.each do |ip|
    ip_message += (ip.ip_address.to_s + "\n")
  end

  # 读取配置文件
  yml = YAML.load_file("config.yml")
  address = yml["stmp.server"]["address"]
  port = yml["stmp.server"]["port"]
  account = yml["stmp.server"]["account"]
  password = yml["stmp.server"]["password"]
  from = yml["email"]["from"]
  to = yml["email"]["to"]


  # 需要严格遵守格式
  message = (<<MESSAGE_END)
From: Raspberry #{from}
To: Computer #{to}
Subject: IP address list

#{ip_message}
MESSAGE_END

  response = Net::SMTP.start(address,
                             port,
                             'localhost',
                             account, password,
                             :plain).send_mail(message, from, to)

  puts response
end