#
# default _topdir points to /usr/src/redhat
#
%define _topdir %(echo `pwd`)

Summary: tools release
Name: tools-release
Version: 1.0.0
Release: 1
License: Docker.
Group: Applications/Images
%Description
Tools release!

# get source
%prep

# builda - get tools-release from build stage
%build
echo buildroot=%{buildroot}

%undefine __check_files
# install
%install
install -m 0755 -d %{buildroot}/go/bin
install -m 0655 %{buildroot}/tools-release.service %{buildroot}/etc/systemd/system
install -m 0655 %{buildroot}/tools-release %{buildroot}/go/bin/

%post
systemctl enable tools-release
systemctl start tools-release

%preun
systemctl stop tools-release
systemctl disable tools-release


%files
/go/bin/tools-release
/etc/systemd/system/tools-release.service
