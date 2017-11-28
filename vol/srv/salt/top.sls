base:
  '*':
    - states.base
    - states.hosts

  '*cluster*':
    - states.hosts
