env:
  file.managed:
    - name: /tmp/salt_test123/env.conf
    - source: salt://base/files/env.conf
    - mode: 700
    - makedirs: True
