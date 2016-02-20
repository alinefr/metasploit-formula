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
