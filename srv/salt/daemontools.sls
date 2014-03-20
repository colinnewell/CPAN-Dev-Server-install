daemontools:
  pkg.installed:
    - pkgs:
      - daemontools
      - daemontools-run
  service:
    - name: svscan # equivalent to start svscan on the command prompt
    - running
    - require:
      - pkg: daemontools
