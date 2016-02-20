{% from "metasploit/map.jinja" import metasploit with context %}

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

metasploit-rm-init.d:
  file.absent:
    - name: /etc/init.d/metasploit
    - require:
      - cmd: metasploit-installer

metasploit-service:
  file.managed:
    - name: /etc/systemd/system/metasploit.service
    - source: salt://metasploit/files/metasploit.service
    - template: jinja
    - defaults:
        config: {{ metasploit }}
    - require:
      - file: metasploit-rm-init.d

  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: metasploit-service

  service.running:
    - name: metasploit
    - enable: True
    - require:
      - file: metasploit-service
      - cmd: metasploit-installer
