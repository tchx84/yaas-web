Object.send(:include,FastGettext::Translation)
FastGettext.add_text_domain('yaas-web', :path=>'translation/locale')
FastGettext.default_text_domain = 'yaas-web'
