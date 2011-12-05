Name: yaas-web
Version: 0.4
Release: 1
Vendor: Paraguay Educa
Summary: Web Interface for YAAS
Group:	Applications/Internet
License: GPL
URL: http://git.paraguayeduca.org/gitweb/users/mabente/yaas-web.git
Source0: %{name}-%{version}.tar.gz
BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Requires: ruby(abi) = 1.8, rubygems, rubygem-activesupport, rubygem-rails, mysql-server, ruby-mysql, rubygem-fast_gettext, rubygem-gettext, rubygem-mysql2
BuildArch: noarch

%description
This web application acts as an easy-to-use interface for letting users to generate activations in a controled environment 

%prep
%setup -q

%build
%install
rm -rf $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT/var/%{name}
cp -r * $RPM_BUILD_ROOT/var/%{name}

# kill packaging 
rm -rf $RPM_BUILD_ROOT/var/%{name}/packaging

# kill logs
rm -f $RPM_BUILD_ROOT/var/%{name}/log/*

# create file to be populated on first run
touch $RPM_BUILD_ROOT/var/%{name}/Gemfile.lock

%clean
rm -rf $RPM_BUILD_ROOT

%post
# copy virtual-host-example-config to /etc/httpd/conf.d
if [ ! -f /etc/httpd/conf.d/yaas-web.conf ] ; then
  cp /var/%{name}/extra/yaas-web.conf /etc/httpd/conf.d/yaas-web.conf.example
fi

# copy database config template
if [ ! -f /var/%{name}/config/database.yml ] ; then
  cp /var/%{name}/config/database.yml.example /var/%{name}/config/database.yml
fi

# copy yaas config template
if [ ! -f /var/%{name}/config/yaas.yml ]; then
  cp /var/%{name}/config/yaas.yml.example /var/%{name}/config/yaas.yml
fi

# try to create DB, if it doesnt exist
mysql -u root -e 'create database if not exists yaas;' > /dev/null 2>&1 || true

# load initial database
cd /var/%{name}
if [ -f /var/%{name}/config/database.yml ] ; then
  # migrations & seed
  rake db:migrate
  rake db:seed
else
  echo "No suitable database config file was found."
fi

%postun

%files
%defattr(-,root,root,-)
%dir /var/%{name}
/var/%{name}/config.ru
/var/%{name}/app
%dir /var/%{name}/config
%attr(0644,root,root) %ghost /var/%{name}/config/password_salt
/var/%{name}/config/environments
/var/%{name}/config/initializers
/var/%{name}/config/locales
/var/%{name}/config/application.rb
/var/%{name}/config/boot.rb
/var/%{name}/config/routes.rb
/var/%{name}/config/*.example
%attr(-,apache,apache) /var/%{name}/config/environment.rb
/var/%{name}/COPYING
/var/%{name}/Gemfile
%attr(0664,apache,apache) /var/%{name}/Gemfile.lock
/var/%{name}/README*
/var/%{name}/TODO
/var/%{name}/extra
/var/%{name}/db
/var/%{name}/doc
/var/%{name}/lib
%attr(-,apache,apache) /var/%{name}/log
%dir /var/%{name}/public
/var/%{name}/public/*.html
/var/%{name}/public/*.txt
/var/%{name}/public/*.ico
/var/%{name}/public/stylesheets
/var/%{name}/public/javascripts
%attr(-,apache,apache) /var/%{name}/public/images
/var/%{name}/translation
/var/%{name}/Rakefile
/var/%{name}/script
/var/%{name}/test
%attr(-,apache,apache) /var/%{name}/tmp
/var/%{name}/vendor

%changelog
* Mon Dec  5 2011 Daniel Drake <dsd@laptop.org>
- Port to rails3
- Display server errors in UI
- Config file must be manually moved to new location on upgrades from old versions

* Mon Aug 29 2011 Martin Abente. <tch@paraguayeduca.org>
- Heavy security enhancements

* Fri Sep 10 2010 Martin Abente. <mabente@paraguayeduca.org>
- Fix sort serial numbers

* Thu Sep 9 2010 Martin Abente. <mabente@paraguayeduca.org>
- Add gettext dependencies

* Wed Sep 8 2010 Martin Abente. <mabente@paraguayeduca.org>
- CJson format suppport

* Mon Aug 16 2010 Martin Abente. <mabente@paraguayeduca.org>
- Changes from Daniel Drake
- Localization support
- Bigger size data activation column
- 32 minutes time out

* Wed May 19 2010 Martin Abente. <mabente@paraguayeduca.org>
- Fixed developer key name

* Thu Apr 29 2010 Martin Abente. <mabente@paraguayeduca.org>
- ssl and secret keyword security

* Wed Apr 28 2010 Martin Abente. <mabente@paraguayeduca.org>
- Added database username and password fields
- Removed gems version from environment
- Added admin user via migrations
- Rails 3 can wait
- Fixed admin creation invalid attributes

* Mon Apr 26 2010 Martin Abente. <mabente@paraguayeduca.org>
- Initial version

