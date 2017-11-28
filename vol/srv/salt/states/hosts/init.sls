hosts_generate:
  file.managed:
    - name: /etc/hosts
    - source: salt://hosts/templates/hosts.j2
    - template: jinja
