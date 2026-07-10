#!/usr/bin/env bash
# last_verified: 2026-07-10

# Samba file server setup
# Usage: ./samba-setup.sh --install [--share-name NAME] [--share-path PATH] [--username USER]
# Installs Samba, creates a share directory, writes smb.conf, and enables the smb service

INSTALL=false
SHARE_NAME="share"
SHARE_PATH="/srv/samba/share"
USERNAME=""

while [ $# -gt 0 ]; do
  case "$1" in
    --install)        INSTALL=true; shift ;;
    --share-name)     SHARE_NAME="$2"; shift 2 ;;
    --share-path)     SHARE_PATH="$2"; shift 2 ;;
    --username)       USERNAME="$2"; shift 2 ;;
    *)                echo "Usage: $0 --install [--share-name NAME] [--share-path PATH] [--username USER]"; exit 1 ;;
  esac
done

if [ "$INSTALL" != true ]; then
  echo "[!] --install is required"
  exit 1
fi

echo "[*] Setting up Samba share: $SHARE_NAME -> $SHARE_PATH"

command -v apt-get >/dev/null 2>&1 && PKG_MGR="apt-get" || PKG_MGR="yum"

if [ "$PKG_MGR" = "apt-get" ]; then
  apt-get update >/dev/null 2>&1
  apt-get install -y samba smbclient cifs-utils >/dev/null 2>&1
else
  yum install -y samba samba-client cifs-utils >/dev/null 2>&1
fi

echo "[+] Samba installed"

mkdir -p "$SHARE_PATH"
chmod 2770 "$SHARE_PATH"
groupadd -f smbgroup
chown root:smbgroup "$SHARE_PATH"
echo "[+] Share directory created at $SHARE_PATH"

cat > /etc/samba/smb.conf << SMBCONF
[global]
   server role = standalone server
   security = user
   map to guest = never
   smb ports = 445

[$SHARE_NAME]
   path = $SHARE_PATH
   browseable = yes
   read only = no
   guest ok = no
SMBCONF
echo "[+] smb.conf written"

testparm -s /etc/samba/smb.conf >/dev/null 2>&1 && echo "[+] Config validated" || echo "[!] Config validation failed"

systemctl enable --now smb nmb >/dev/null 2>&1
echo "[+] Samba services started"

if [ -n "$USERNAME" ]; then
  useradd -M -s /usr/sbin/nologin "$USERNAME" 2>/dev/null || true
  (echo "$USERNAME:password"; sleep 1) | smbpasswd -a "$USERNAME" -s >/dev/null 2>&1
  smbpasswd -e "$USERNAME" >/dev/null 2>&1
  echo "[+] Samba user created: $USERNAME"
fi

echo "[*] Setup complete — access share with: smbclient //localhost/$SHARE_NAME -U $USERNAME"
