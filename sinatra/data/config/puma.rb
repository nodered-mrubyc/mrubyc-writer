if "development" == ENV.fetch("RAILS_ENV") { "development" }
    ssl_bind '0.0.0.0', '4567', {
      key: "/file_path/server.key",
      cert: "/file_path/server.crt",
      ca: "/file_path/ca", # オレオレ証明書の場合は必要ないです／中間証明書が必要な場合は指定してください
      verify_mode: "none"
    }
  end