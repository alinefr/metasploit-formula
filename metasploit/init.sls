{% from "metasploit/map.jinja" import metasploit with context %}

metasploit:
  file.managed:
    - name: /etc/systemd/system/metasploit.service
    - source: salt://metasploit/files/metasploit.service
    - template: jinja
    - defaults:
        config: {{ metasploit }}

  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: metasploit

  service.running:
    - name: metasploit
    - enable: True
    - require:
      - file: metasploit
      - cmd: metasploit-installer

metasploit-installer:
  file.managed:
    - name: /tmp/metasploit-installer-{{ metasploit.version }}.run
    - source: {{ metasploit.url }}
    - source_hash: {{ metasploit.url }}.sha1
    - mode: 755
    - prereq:
      - cmd: metasploit-installer

  cmd.run:
    - name: /tmp/metasploit-installer-{{ metasploit.version }}.run --mode unattended --prefix {{ metasploit.directory }}
    - unless: test -d {{ metasploit.directory }}
