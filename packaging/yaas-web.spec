Name: yaas-web
Version: 0.1
Release: 7
Vendor: Paraguay Educa
Summary: Web Interface for YAAS
Group:	Applications/Internet
License: GPL
URL: http://git.paraguayeduca.org/gitweb/users/mabente/yaas-web.git
Source0: %{name}-%{version}.tar.gz
BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Requires: ruby(abi) = 1.8, rubygems, rubygem-activesupport, rubygem-rails, mysql-server, ruby-mysql
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
rm -f $RPM_BUILD_ROOT/var/%{name}/application/log/*

%clean
rm -rf $RPM_BUILD_ROOT

%post
# copy virtual-host-example-config to /etc/httpd/conf.d
if [ ! -f /etc/httpd/conf.d/yaas-web.conf ] ; then
  cp /var/%{name}/extra/yaas-web.conf /etc/httpd/conf.d/yaas-web.conf.example
fi

# update Rails stuff
cd /var/%{name}/application/ && rake rails:update

# copy database config template
cp /var/%{name}/application/config/database.yml.example /var/%{name}/application/config/database.yml

# copy yaas config template
cp /var/%{name}/application/config/yaas.yml.example /var/%{name}/application/config/yaas.yml

# try to create DB, if it doesnt exist
mysql -u root -e 'create database if not exists yaas;' > /dev/null 2>&1 || true

# load initial database
cd /var/%{name}/application
if [ -f /var/%{name}/application/config/database.yml ] ; then
  # migrations
  rake db:migrate
else
  echo "No suitable database config file was found."
fi

%postun

%files
%defattr(-,root,root,-)
%dir /var/%{name}
/var/%{name}/application/app
/var/%{name}/application/config
%attr(-,apache,apache) /var/%{name}/application/config/environment.rb
/var/%{name}/application/COPYING
/var/%{name}/application/README
/var/%{name}/README
/var/%{name}/TODO
/var/%{name}/extra
/var/%{name}/application/db
/var/%{name}/application/doc
/var/%{name}/application/lib
%attr(-,apache,apache) /var/%{name}/application/log
/var/%{name}/application/public
%attr(-,apache,apache) /var/%{name}/application/public/images
/var/%{name}/application/Rakefile
/var/%{name}/application/script
/var/%{name}/application/test
%attr(-,apache,apache) /var/%{name}/application/tmp

%changelog

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

