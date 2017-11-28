cluster:
  defined: True
  type: "dev"
  host1: {{ salt['grains.get']('host') }}
  host2: {{ grains.get('host') }}
  host3: {{ grains['host'] }}
  fqdn: {{ grains['fqdn'] }}
