# jumpapp.spec: specification for building the .rpm file

# Created with: rpmdev-newspec jumpapp

Name:           jumpapp
Version:        %{VERSION}
Release:        1%{?dist}
Summary:        jump to another application, unconditionally

License:        MIT
URL:            https://github.com/mkropat/jumpapp
Source0:        %{name}_%{version}.tar.bz2

BuildArch:      noarch
BuildRequires:	pandoc
Requires:       wmctrl

%description
Jumpapp focuses the window of the application you're interested in — assuming
it's already running — otherwise jumpapp launches the application for you.

%prep
%setup -q

%build
make

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} PREFIX=/usr install
mkdir -p %{buildroot}%{_unitdir}

%files
%{_bindir}/*
%{_mandir}/man1/*

%changelog
* Thu Mar 28 2014 Michael Kropat <mail@michael.kropat.name> - 0.2-1
- Window Cycling feature

* Thu Mar 27 2014 Michael Kropat <mail@michael.kropat.name> - 0.1-1
- Initial version
