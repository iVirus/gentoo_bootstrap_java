#!/bin/bash

echo "--- BUILDING"

<#assign filename = "/etc/bash/bashrc.d/aliases">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/bash/bashrc.d/aliases.ftl">
EOF

env-update
source /etc/profile

eselect python set python2.7

emerge -q --sync

<#assign filename = "/etc/timezone">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/timezone.ftl">
EOF

emerge --config timezone-data

<#assign filename = "/etc/portage/make.conf">
echo "--- ${filename} (modify)"
cp "${filename}" "${filename}.orig"
sed -i -r \
-e "s|^(CXXFLAGS\=\".*\")|\1\n|" \
-e "s|^(CHOST\=\".*\")|\1\n|" \
-e "s|^(USE\=\".*\")|\1\n\nMAKEOPTS\=\"\-j3\"\nPORTAGE_NICENESS\=\"10\"\nEMERGE_DEFAULT_OPTS\=\"\-\-jobs\=2 \-\-load\-average\=3\.0\"\n|" \
-e "\|^USE|s|bindist\s*||" \
"${filename}"

<#assign filename = "/etc/local.d/makeopts.start">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/local.d/makeopts.start.ftl">
EOF
chmod 755 "${filename}"

/etc/local.d/makeopts.start

<#assign filename = "/etc/local.d/hostname.start">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/local.d/hostname.start.ftl">
EOF
chmod 755 "${filename}"

<#assign filename = "/etc/local.d/initialize.start">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/local.d/initialize.start.ftl">
EOF
chmod 755 "${filename}"

emerge sys-kernel/gentoo-sources || emerge --resume
cd /usr/src/linux

<#assign filename = "/usr/src/linux/.config">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/usr/src/linux/.config.ftl">
EOF

yes "" | make oldconfig
make -j$(grep "^processor" /proc/cpuinfo | tail -n 1 | awk '{print $3 + 2}') && make modules_install

<#if architecture == "i386">
    <#assign kernelArch = "x86">
<#else>
    <#assign kernelArch = "x86_64">
</#if>
cp -L arch/${kernelArch}/boot/bzImage /boot/bzImage

<#assign filename = "/etc/fstab">
echo "--- ${filename} (modify)"
cp "${filename}" "${filename}.orig"
sed -i -r \
-e "s|^(/dev/(BOOT\|SWAP))|#\1|" \
-e "s|^/dev/ROOT(\s+/\s+)ext3(\s+noatime\s+)0 1|/dev/xvda1\1ext4\20 0|" \
"${filename}"

cd /etc/init.d

ln -s net.lo net.eth0

<#assign filename = "/etc/conf.d/net">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/conf.d/net.ftl">
EOF

rc-update add net.eth0 default
rc-update add sshd default

<#assign filename = "/etc/locale.gen">
echo "--- ${filename} (modify)"
cp "${filename}" "${filename}.orig"
sed -i -r \
-e "s|^#(en_US.*)|\1|" \
"${filename}"

locale-gen

<#assign filename = "/etc/sysctl.conf">
echo "--- ${filename} (append)"
cp "${filename}" "${filename}.orig"
cat <<'EOF'>>"${filename}"

vm.swappiness = 10
EOF

emerge mail-mta/netqmail || emerge --resume

<#assign filename = "/var/qmail/control/servercert.cnf">
echo "--- ${filename} (modify)"
cp "${filename}" "${filename}.orig"
sed -i -r \
-e "s|^C\=.*|C\=US|" \
-e "s|^ST\=.*|ST\=Utah|" \
-e "s|^L\=.*|L\=Provo|" \
-e "s|^O\=.*|O\=InsideSales.com, Inc\.|" \
-e "s|^emailAddress\=.*|emailAddress\=systems@insidesales\.com|" \
"${filename}"

rc-update add svscan default

emerge app-admin/syslog-ng sys-process/vixie-cron || emerge --resume
rc-update add syslog-ng default
rc-update add vixie-cron default

emerge sys-boot/grub-static || emerge --resume

<#assign filename = "/boot/grub/menu.lst">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/boot/grub/menu.lst.ftl">
EOF

<#if virtualizationType == "hvm">
grub <<'EOF'
root (hd1,0)
setup (hd1)
quit
EOF
</#if>

emerge -1 sys-apps/portage || emerge --resume

<#if architecture == "i386">
emerge -C sys-apps/module-init-tools
</#if>

<#assign filename = "/var/lib/portage/world">
echo "--- ${filename} (append)"
cat <<'EOF'>>"${filename}"
<#include "/var/lib/portage/world.ftl">
EOF

<#assign filename = "/etc/portage/package.use/ganglia">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/portage/package.use/ganglia.ftl">
EOF

<#assign filename = "/etc/portage/package.use/mysql">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/portage/package.use/mysql.ftl">
EOF

emerge -uDN @world || emerge --resume

easy_install pip
pip install awscli

cfn_file="$(mktemp)"
curl -sf -o "<#noparse>${cfn_file}</#noparse>" "https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz"
easy_install "<#noparse>${cfn_file}</#noparse>"

<#assign filename = "/etc/logrotate.conf">
echo "--- ${filename} (modify)"
cp "${filename}" "${filename}.orig"
sed -i -r \
-e "s|^(dateext)|#\1|" \
"${filename}"

<#assign filename = "/etc/sudoers.d/_wheel">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/sudoers.d/_wheel.ftl">
EOF
chmod 440 "${filename}"

<#assign filename = "/etc/php/cli-php5.6/php.ini">
echo "--- ${filename} (modify)"
cp "${filename}" "${filename}.orig"
sed -i -r \
-e "s|^(short_open_tag\s+\=\s+).*|\1On|" \
-e "s|^(expose_php\s+\=\s+).*|\1Off|" \
-e "s|^(error_reporting\s+\=\s+).*|\1E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED|" \
-e "s|^(display_errors\s+\=\s+).*|\1Off|" \
-e "s|^(display_startup_errors\s+\=\s+).*|\1Off|" \
-e "s|^(track_errors\s+\=\s+).*|\1Off|" \
-e "s|^;(date\.timezone\s+\=).*|\1 America/Denver|" \
"${filename}"

<#assign filename = "/etc/fail2ban/jail.d/sshd.conf">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/fail2ban/jail.d/sshd.conf.ftl">
EOF

<#assign filename = "/etc/hosts.allow">
echo "--- ${filename} (append)"
cp "${filename}" "${filename}.orig"
cat <<'EOF'>>"${filename}"

nrpe: 10.0.0.0/8
EOF

rc-update add fail2ban default

nrpe_file="$(mktemp)"
cat <<'EOF'>"<#noparse>${nrpe_file}</#noparse>"
<#include "/etc/nagios/nrpe.cfg.ftl">
EOF

<#assign filename = "/etc/nagios/nrpe.cfg">
echo "--- ${filename} (modify)"
cp "${filename}" "${filename}.orig"
sed -i -r \
-e "s|^(allowed_hosts=.*)|\1,10.0.0.0/8|" \
-e "s|^(command\[check_load\]=.*)|#\1|" \
-e "\|^command\[check_total_procs\]|r <#noparse>${nrpe_file}</#noparse>" \
"${filename}"

<#assign dirname = "/usr/lib64/nagios/plugins/custom">
echo "--- ${dirname} (create)"
mkdir -p "${dirname}"

<#assign filename = "/usr/lib64/nagios/plugins/custom/check_conntrack">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/usr/lib64/nagios/plugins/custom/check_conntrack.ftl">
EOF
chmod 755 "${filename}"

<#assign filename = "/usr/lib64/nagios/plugins/custom/check_memory">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/usr/lib64/nagios/plugins/custom/check_memory.ftl">
EOF
chmod 755 "${filename}"

<#assign filename = "/usr/lib64/nagios/plugins/custom/check_qmail_queue">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/usr/lib64/nagios/plugins/custom/check_qmail_queue.ftl">
EOF
chmod 755 "${filename}"

usermod -a -G qmail nagios

rc-update add nrpe default

<#assign filename = "/etc/ntp.conf">
echo "--- ${filename} (modify)"
cp "${filename}" "${filename}.orig"
sed -i -r \
-e "s|^(server\s+.*)|#\1|" \
"${filename}"

rc-update add ntp-client default
rc-update add ntpd default

dnscache-conf dnscache dnslog /var/dnscache 127.0.0.1

<#assign filename = "/var/dnscache/root/servers/amazonaws.com">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/var/dnscache/root/servers/amazonaws.com.ftl">
EOF

<#assign filename = "/var/dnscache/root/servers/fastly.net">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/var/dnscache/root/servers/fastly.net.ftl">
EOF

<#assign filename = "/var/dnscache/root/servers/githubusercontent.com">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/var/dnscache/root/servers/githubusercontent.com.ftl">
EOF

<#assign filename = "/var/dnscache/env/FORWARDONLY">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
1
EOF

<#assign filename = "/etc/resolv.conf.head">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/etc/resolv.conf.head.ftl">
EOF

ln -s /var/dnscache/ /service/dnscache

useradd -g users -G wheel -m bmoorman

<#assign filename = "/home/bmoorman/.ssh/authorized_keys">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/keys/bmoorman.ftl">
EOF

useradd -g users -G wheel -m npeterson

<#assign filename = "/home/npeterson/.ssh/authorized_keys">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/keys/npeterson.ftl">
EOF

useradd -g users -G wheel -m khammond

<#assign filename = "/home/khammond/.ssh/authorized_keys">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/keys/khammond.ftl">
EOF

useradd -g users -G wheel -m deployer

<#assign filename = "/home/deployer/.ssh/authorized_keys">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/keys/deployer.ftl">
EOF

useradd -g users -G wheel -m security

<#assign filename = "/home/security/.ssh/authorized_keys">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/keys/security.ftl">
EOF

<#assign dirname = "/usr/local/lib64/ganglia">
echo "--- ${dirname} (create)"
mkdir -p "${dirname}"

<#assign filename = "/usr/local/lib64/ganglia/conntrack.sh">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/usr/local/lib64/ganglia/conntrack.sh.ftl">
EOF
chmod 755 "${filename}"

<#assign filename = "/usr/local/lib64/ganglia/diskstats.php">
echo "--- ${filename} (replace)"
cat <<'EOF'>"${filename}"
<#include "/usr/local/lib64/ganglia/diskstats.php.ftl">
EOF
chmod 755 "${filename}"
