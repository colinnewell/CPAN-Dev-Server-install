include:
  - nginx
  - daemontools

build-essential:
  pkg.installed

rsync:
  pkg.installed

perl:
  pkg.installed

cpanminus:
  pkg.installed

cpan-mini:
  cmd.run:
    - name: cpanm CPAN::Mini CPAN::Mini::Inject::REST
    - require:
      - pkg: cpanminus

cpan:
  user.present:
    - system: True
    - group: cpan
    - createhome: False
    - home: /opt/cpan
    - shell: /bin/false

/opt/cpan/minicpan/repository:
  file.directory:
    - user: cpan
    - group: cpan
    - mode: 755
    - makedirs: True

/opt/cpan/cpan-inject.conf:
  file.managed:
    - user: cpan
    - group: cpan
    - source: salt://cpan-server/cpan-inject.conf

/opt/cpan/.minicpanrc:
  file.managed:
    - user: cpan
    - group: cpan
    - source: salt://cpan-server/minicpan

/opt/cpan/.mcpani:
  file.directory:
    - user: cpan
    - group: cpan
    - mode: 755
    - makedirs: True

/opt/cpan/.mcpani/config:
  file.symlink:
    - target: /opt/cpan/.minicpanrc
    - require:
      - file: /opt/cpan/.minicpanrc

/usr/local/bin/mcpani --inject:
  cron.present:
    - user: cpan
    - minute: 17
    - identifier: cpani
    - require:
      - pkg: cpanminus
      - cmd: cpan-mini

/usr/local/bin/minicpan > /dev/null:
  cron.present:
    - user: cpan
    - minute: 7
    - hour: 2
    - identifier: CPAN
    - require:
      - pkg: cpanminus
      - cmd: cpan-mini

/etc/nginx/sites-enabled/default:
  file.managed:
    - source: salt://cpan-server/cpan.site
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

/etc/service/cpan-mini-inject-rest/run:
  file.managed:
    - mode: 700
    - template: jinja
    - source: salt://cpan-server/run
    - require:
      - file: /opt/cpan/minicpan/repository
      - cmd: cpan-mini
      - pkg: daemontools

