# Linode Ruby API

## INSTALLATION:

 Make sure gemcutter.org is in your gem sources list, then:

     % sudo gem install linode

 To run tests you will need both rspec and mocha installed.

## RUNNING:

Consult the Linode API guide here: [http://www.linode.com/api/autodoc.cfm](http://www.linode.com/api/autodoc.cfm)    
You will need to get an API key (check your account profile).

Here is an annoyingly exhaustive IRB session where I play around with the API:

    irb> require 'rubygems'
    irb> require 'linode'
    irb> api_key = 'TOPSECRETAPIKEY'
    irb> l = Linode.new(:api_key => api_key)
    => #<Linode:0x100e03c @api_key="TOPSECRETAPIKEY">

    irb> result = l.test.echo(:foo => 'bar', :baz => 'xyzzy')
    => #<OpenStruct baz="xyzzy", foo="bar">
    irb> result.foo
    => "bar"
    
    irb> result.baz
    => "xyzzy"
 
    irb> result = l.avail.datacenters
    => [#<OpenStruct datacenterid=2, location="Dallas, TX, USA">, #<OpenStruct datacenterid=3, location="Fremont, CA,
    USA">, #<OpenStruct datacenterid=4, location="Atlanta, GA, USA">, #<OpenStruct datacenterid=6, location="Newark, NJ,
    USA">]
    irb> s = _
    => [#<OpenStruct datacenterid=2, location="Dallas, TX, USA">, #<OpenStruct datacenterid=3, location="Fremont, CA,
    USA">, #<OpenStruct datacenterid=4, location="Atlanta, GA, USA">, #<OpenStruct datacenterid=6, location="Newark, NJ,
    USA">]
    irb> result.first
    => #<OpenStruct datacenterid=2, location="Dallas, TX, USA">
    irb> result.first.location
    => "Dallas, TX, USA"
    irb> l.avail.datacenters.collect {|i| i.location }
    => ["Dallas, TX, USA", "Fremont, CA, USA", "Atlanta, GA, USA", "Newark, NJ, USA"]
    irb> l.avail.datacenters.collect {|i| i.datacenterid }
    => [2, 3, 4, 6]

    irb> l.user.getapikey(:username => 'me', :password => 'SECKRIT')
    => #<OpenStruct api_key="TOPSECRETAPIKEY", username="me">
    irb> l.user.getapikey(:username => 'me', :password => 'SECKRIT').api_key
    => "TOPSECRETAPIKEY"
    irb> l.user.getapikey(:username => 'me', :password => 'SECKRIT').username
    => "me"
 
    irb> l.avail.kernels
    => [#<OpenStruct isxen=1, label="2.6.16.38-x86_64-linode2", kernelid=85>, #<OpenStruct isxen=1,
    label="2.6.18.8-domU-linode7", kernelid=81>, #<OpenStruct isxen=1, label="2.6.18.8-linode10", kernelid=89>,
    #<OpenStruct isxen=1, label="2.6.18.8-linode16", kernelid=98>, #<OpenStruct isxen=1,
    label="2.6.18.8-x86_64-linode1", kernelid=86>, #<OpenStruct isxen=1, label="2.6.24.4-linode8", kernelid=84>,
    #<OpenStruct isxen=1, label="2.6.25-linode9", kernelid=88>, #<OpenStruct isxen=1, label="2.6.25.10-linode12",
    kernelid=90>, #<OpenStruct isxen=1, label="2.6.26-linode13", kernelid=91>, #<OpenStruct isxen=1,
    label="2.6.27.4-linode14", kernelid=93>, #<OpenStruct isxen=1, label="2.6.27.4-x86_64-linode3", kernelid=94>,
    #<OpenStruct isxen=1, label="2.6.28-linode15", kernelid=96>, #<OpenStruct isxen=1,
    label="2.6.28-x86_64-linode4", kernelid=97>, #<OpenStruct isxen=1, label="2.6.28.3-linode17", kernelid=99>,
    #<OpenStruct isxen=1, label="2.6.28.3-x86_64-linode5", kernelid=100>, #<OpenStruct isxen=1,
    label="2.6.29-linode18", kernelid=101>, #<OpenStruct isxen=1, label="2.6.29-x86_64-linode6", kernelid=102>,
    #<OpenStruct isxen=1, label="Latest 2.6 Series (2.6.18.8-linode16)", kernelid=60>, #<OpenStruct isxen=1,
    label="pv-grub-x86_32", kernelid=92>, #<OpenStruct isxen=1, label="pv-grub-x86_64", kernelid=95>, #<OpenStruct
    isxen=1, label="Recovery - Finnix (kernel)", kernelid=61>]
    irb> l.avail.kernels.size
    => 21
    irb> l.avail.kernels.first
    => #<OpenStruct isxen=1, label="2.6.16.38-x86_64-linode2", kernelid=85>
    irb> l.avail.kernels.first.label
    => "2.6.16.38-x86_64-linode2"

    irb> l.avail.linodeplans
    => [#<OpenStruct ram=360, label="Linode 360", avail={"6"=>26, "2"=>57, "3"=>20, "4"=>39}, price=19.95, planid=1,
    xfer=200, disk=16>, #<OpenStruct ram=540, label="Linode 540", avail={"6"=>11, "2"=>38, "3"=>14, "4"=>28},
    price=29.95, planid=2, xfer=300, disk=24>, #<OpenStruct ram=720, label="Linode 720", avail={"6"=>13, "2"=>27,
    "3"=>18, "4"=>30}, price=39.95, planid=3, xfer=400, disk=32>, #<OpenStruct ram=1080, label="Linode 1080",
    avail={"6"=>18, "2"=>7, "3"=>9, "4"=>4}, price=59.95, planid=4, xfer=600, disk=48>, #<OpenStruct ram=1440,
    label="Linode 1440", avail={"6"=>14, "2"=>5, "3"=>7, "4"=>3}, price=79.95, planid=5, xfer=800, disk=64>,
    #<OpenStruct ram=2880, label="Linode 2880", avail={"6"=>3, "2"=>3, "3"=>3, "4"=>3}, price=159.95, planid=6,
    xfer=1600, disk=128>, #<OpenStruct ram=5760, label="Linode 5760", avail={"6"=>5, "2"=>6, "3"=>5, "4"=>5},
    price=319.95, planid=7, xfer=2000, disk=256>, #<OpenStruct ram=8640, label="Linode 8640", avail={"6"=>5, "2"=>6,
    "3"=>5, "4"=>5}, price=479.95, planid=8, xfer=2000, disk=384>, #<OpenStruct ram=11520, label="Linode 11520",
    avail={"6"=>5, "2"=>6, "3"=>5, "4"=>5}, price=639.95, planid=9, xfer=2000, disk=512>, #<OpenStruct ram=14400,
    label="Linode 14400", avail={"6"=>5, "2"=>6, "3"=>5, "4"=>5}, price=799.95, planid=10, xfer=2000, disk=640>]
    irb> l.avail.linodeplans.size
    => 10
    irb> l.avail.linodeplans.first
    => #<OpenStruct ram=360, label="Linode 360", avail={"6"=>26, "2"=>57, "3"=>20, "4"=>39}, price=19.95, planid=1,
    xfer=200, disk=16>
    irb> l.avail.linodeplans.first.avail
    => {"6"=>26, "2"=>57, "3"=>20, "4"=>39}

    irb> l.avail.distributions
    => [#<OpenStruct label="Arch Linux 2007.08", minimagesize=436, create_dt="2007-10-24 00:00:00.0", is64bit=0,
    distributionid=38>, #<OpenStruct label="Centos 5.0", minimagesize=594, create_dt="2007-04-27 00:00:00.0",
    is64bit=0, distributionid=32>, #<OpenStruct label="Centos 5.2", minimagesize=950, create_dt="2008-11-30 00:00:00.0",
    is64bit=0, distributionid=46>, #<OpenStruct label="Centos 5.2 64bit", minimagesize=980,
    create_dt="2008-11-30 00:00:00.0", is64bit=1, distributionid=47>, #<OpenStruct label="Debian 4.0",
    minimagesize=200, create_dt="2007-04-18 00:00:00.0", is64bit=0, distributionid=28>, #<OpenStruct
    label="Debian 4.0 64bit", minimagesize=220, create_dt="2008-12-02 00:00:00.0", is64bit=1, distributionid=48>,
    #<OpenStruct label="Debian 5.0", minimagesize=200, create_dt="2009-02-19 00:00:00.0", is64bit=0, distributionid=50>,
    #<OpenStruct label="Debian 5.0 64bit", minimagesize=300, create_dt="2009-02-19 00:00:00.0", is64bit=1,
    distributionid=51>, #<OpenStruct label="Fedora 8", minimagesize=740, create_dt="2007-11-09 00:00:00.0", is64bit=0,
    distributionid=40>, #<OpenStruct label="Fedora 9", minimagesize=1175, create_dt="2008-06-09 15:15:21.0", is64bit=0,
    distributionid=43>, #<OpenStruct label="Gentoo 2007.0", minimagesize=1800, create_dt="2007-08-29 00:00:00.0",
    is64bit=0, distributionid=35>, #<OpenStruct label="Gentoo 2008.0", minimagesize=1500,
    create_dt="2009-03-20 00:00:00.0", is64bit=0, distributionid=52>, #<OpenStruct label="Gentoo 2008.0 64bit",
    minimagesize=2500, create_dt="2009-04-04 00:00:00.0", is64bit=1, distributionid=53>, #<OpenStruct
    label="OpenSUSE 11.0", minimagesize=850, create_dt="2008-08-21 08:32:16.0", is64bit=0, distributionid=44>,
    #<OpenStruct label="Slackware 12.0", minimagesize=315, create_dt="2007-07-16 00:00:00.0", is64bit=0,
    distributionid=34>, #<OpenStruct label="Slackware 12.2", minimagesize=500, create_dt="2009-04-04 00:00:00.0",
    is64bit=0, distributionid=54>, #<OpenStruct label="Ubuntu 8.04 LTS", minimagesize=400,
    create_dt="2008-04-23 15:11:29.0", is64bit=0, distributionid=41>, #<OpenStruct label="Ubuntu 8.04 LTS 64bit",
    minimagesize=350, create_dt="2008-06-03 12:51:11.0", is64bit=1, distributionid=42>,
    #<OpenStruct label="Ubuntu 8.10", minimagesize=220, create_dt="2008-10-30 23:23:03.0", is64bit=0,
    distributionid=45>, #<OpenStruct label="Ubuntu 8.10 64bit", minimagesize=230, create_dt="2008-12-02 00:00:00.0",
    is64bit=1, distributionid=49>, #<OpenStruct label="Ubuntu 9.04", minimagesize=350,
    create_dt="2009-04-23 00:00:00.0", is64bit=0, distributionid=55>, #<OpenStruct label="Ubuntu 9.04 64bit",
    minimagesize=350, create_dt="2009-04-23 00:00:00.0", is64bit=1, distributionid=56>]
    irb> l.avail.distributions.size
    => 22
    irb> l.avail.distributions.first
    => #<OpenStruct label="Arch Linux 2007.08", minimagesize=436, create_dt="2007-10-24 00:00:00.0", is64bit=0,
    distributionid=38>
    irb> l.avail.distributions.first.label
    => "Arch Linux 2007.08"

    irb> l.domain.resource.list
    RuntimeError: Error completing request [domain.resource.list] @ [https://api.linode.com/] with data [{}]:
    ERRORCODE6ERRORMESSAGEDOMAINID is required but was not passed in
    	from ./lib/linode.rb:31:in `send_request'
    	from ./lib/linode.rb:13:in `list'
    	from (irb):3
    irb> l.domain.resource.list(:DomainId => '1')
    RuntimeError: Error completing request [domain.resource.list] @ [https://api.linode.com/] with data
    [{:DomainId=>"1"}]: ERRORCODE5ERRORMESSAGEObject not found
    	from ./lib/linode.rb:31:in `send_request'
    	from ./lib/linode.rb:13:in `list'
    	from (irb):5
    irb> l.domain.resource.list(:DomainId => '1', :ResourceId => '2')
    RuntimeError: Error completing request [domain.resource.list] @ [https://api.linode.com/] with data
    [{:DomainId=>"1", :ResourceId=>"2"}]: ERRORCODE5ERRORMESSAGEObject not found
    	from ./lib/linode.rb:31:in `send_request'
    	from ./lib/linode.rb:13:in `list'
    	from (irb):7

    irb> l.linode
    => #<Linode::Linode:0x10056e4 @api_url="https://api.linode.com/", @api_key="TOPSECRETAPIKEY">
    irb> l.linode.list
    => [#<OpenStruct datacenterid=6, lpm_displaygroup="", totalxfer=600, alert_bwquota_enabled=1,
    alert_diskio_enabled=1, watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5, backupsenabled=0,
    backupweeklyday="", status=1, alert_cpu_enabled=1, label="byggvir", totalram=1080, backupwindow=0,
    alert_diskio_threshold=300, alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=12446, totalhd=49152,
    alert_bwin_enabled=1, alert_bwout_enabled=1>, #<OpenStruct datacenterid=4, lpm_displaygroup="", totalxfer=200,
    alert_bwquota_enabled=1, alert_diskio_enabled=1, watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5,
    backupsenabled=0, backupweeklyday="", status=1, alert_cpu_enabled=1, label="bragi", totalram=360, backupwindow=0,
    alert_diskio_threshold=300, alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=15418, totalhd=16384,
    alert_bwin_enabled=1, alert_bwout_enabled=1>, #<OpenStruct datacenterid=2, lpm_displaygroup="", totalxfer=200,
    alert_bwquota_enabled=1, alert_diskio_enabled=1, watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5,
    backupsenabled=0, backupweeklyday="", status=1, alert_cpu_enabled=1, label="nerthus", totalram=360, backupwindow=0,
    alert_diskio_threshold=300, alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=15419, totalhd=16384,
    alert_bwin_enabled=1, alert_bwout_enabled=1>, #<OpenStruct datacenterid=3, lpm_displaygroup="", totalxfer=200,
    alert_bwquota_enabled=1, alert_diskio_enabled=1, watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5,
    backupsenabled=0, backupweeklyday=0, status=1, alert_cpu_enabled=1, label="hoenir", totalram=360, backupwindow=0,
    alert_diskio_threshold=500, alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=24405, totalhd=16384,
    alert_bwin_enabled=1, alert_bwout_enabled=1>]
    irb> l.linode.list.size
    => 4
    irb> l.linode.list.first
    => #<OpenStruct datacenterid=6, lpm_displaygroup="", totalxfer=600, alert_bwquota_enabled=1, alert_diskio_enabled=1,
    watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5, backupsenabled=0, backupweeklyday="", status=1,
    alert_cpu_enabled=1, label="byggvir", totalram=1080, backupwindow=0, alert_diskio_threshold=300,
    alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=12446, totalhd=49152, alert_bwin_enabled=1,
    alert_bwout_enabled=1>
    irb> l.linode.list.first.datacenterid
    => 6
    irb> l.linode.list.first.label
    => "byggvir"

    irb(main):003:0* l.linode.config.list
    RuntimeError: Error completing request [linode.config.list] @ [https://api.linode.com/] with data [{}]:
    ERRORCODE6ERRORMESSAGELINODEID is required but was not passed in
    	from ./lib/linode.rb:45:in `send_request'
    	from ./lib/linode.rb:13:in `list'
    	from (irb):3
    irb> l.linode.list
    => [#<OpenStruct datacenterid=6, lpm_displaygroup="", totalxfer=600, alert_bwquota_enabled=1,
    alert_diskio_enabled=1, watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5, backupsenabled=0,
    backupweeklyday="", status=1, alert_cpu_enabled=1, label="byggvir", totalram=1080, backupwindow=0,
    alert_diskio_threshold=300, alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=12446, totalhd=49152,
    alert_bwin_enabled=1, alert_bwout_enabled=1>, #<OpenStruct datacenterid=4, lpm_displaygroup="", totalxfer=200,
    alert_bwquota_enabled=1, alert_diskio_enabled=1, watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5,
    backupsenabled=0, backupweeklyday="", status=1, alert_cpu_enabled=1, label="bragi", totalram=360, backupwindow=0,
    alert_diskio_threshold=300, alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=15418, totalhd=16384,
    alert_bwin_enabled=1, alert_bwout_enabled=1>, #<OpenStruct datacenterid=2, lpm_displaygroup="", totalxfer=200,
    alert_bwquota_enabled=1, alert_diskio_enabled=1, watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5,
    backupsenabled=0, backupweeklyday="", status=1, alert_cpu_enabled=1, label="nerthus", totalram=360, backupwindow=0,
    alert_diskio_threshold=300, alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=15419, totalhd=16384,
    alert_bwin_enabled=1, alert_bwout_enabled=1>, #<OpenStruct datacenterid=3, lpm_displaygroup="", totalxfer=200,
    alert_bwquota_enabled=1, alert_diskio_enabled=1, watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5,
    backupsenabled=0, backupweeklyday=0, status=1, alert_cpu_enabled=1, label="hoenir", totalram=360, backupwindow=0,
    alert_diskio_threshold=500, alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=24405, totalhd=16384,
    alert_bwin_enabled=1, alert_bwout_enabled=1>]
    irb> l.linode.list.first
    => #<OpenStruct datacenterid=6, lpm_displaygroup="", totalxfer=600, alert_bwquota_enabled=1, alert_diskio_enabled=1,
    watchdog=1, alert_cpu_threshold=90, alert_bwout_threshold=5, backupsenabled=0, backupweeklyday="", status=1,
    alert_cpu_enabled=1, label="byggvir", totalram=1080, backupwindow=0, alert_diskio_threshold=300,
    alert_bwin_threshold=5, alert_bwquota_threshold=80, linodeid=12446, totalhd=49152, alert_bwin_enabled=1,
    alert_bwout_enabled=1>
    irb> l.linode.list.first.linodeid
    => 12446
    irb> l.linode.config.list(:LinodeId => 12446)
    => [#<OpenStruct helper_disableupdatedb=1, ramlimit=0, kernelid=60, helper_depmod=1, rootdevicecustom="",
    disklist="79850,79851,79854,,,,,,", label="byggvir", runlevel="default", rootdevicero=true, configid=43615,
    rootdevicenum=1, linodeid=12446, helper_libtls=false, helper_xen=1, comments="">]
    irb> l.linode.config.list(:LinodeId => 12446).first.disklist
    => "79850,79851,79854,,,,,,"

    irb> l.linode.job.list
    RuntimeError: Error completing request [linode.job.list] @ [https://api.linode.com/] with data [{}]:
    ERRORCODE6ERRORMESSAGELINODEID is required but was not passed in
    	from ./lib/linode.rb:45:in `send_request'
    	from ./lib/linode.rb:13:in `list'
    	from (irb):7

    irb> l.linode.job.list(:LinodeId => 12446)
    => [#<OpenStruct action="linode.boot", jobid=1241724, duration=8, host_finish_dt="2009-07-14 17:07:29.0",
    host_message="", linodeid=12446, host_success=1, host_start_dt="2009-07-14 17:07:21.0",
    entered_dt="2009-07-14 17:06:25.0", label="System Boot - byggvir">, #<OpenStruct action="linode.shutdown",
    jobid=1241723, duration=14, host_finish_dt="2009-07-14 17:07:20.0", host_message="", linodeid=12446, host_success=1,
    host_start_dt="2009-07-14 17:07:06.0", entered_dt="2009-07-14 17:06:25.0", label="System Shutdown">,
    #<OpenStruct action="linode.boot", jobid=1182441, duration=0, host_finish_dt="2009-06-10 04:27:49.0",
    host_message="Linode already running", linodeid=12446, host_success=0, host_start_dt="2009-06-10 04:27:49.0",
    entered_dt="2009-06-10 04:26:05.0", label="Lassie initiated boot">, #<OpenStruct action="linode.boot",
    jobid=1182436, duration=8, host_finish_dt="2009-06-10 04:27:49.0", host_message="", linodeid=12446, host_success=1,
    host_start_dt="2009-06-10 04:27:41.0", entered_dt="1974-01-04 00:00:00.0", label="Host initiated restart">,
    #<OpenStruct action="linode.boot", jobid=1182273, duration=0, host_finish_dt="2009-06-10 03:02:31.0",
    host_message="Linode already running", linodeid=12446, host_success=0, host_start_dt="2009-06-10 03:02:31.0",
    entered_dt="2009-06-10 02:59:49.0", label="Lassie initiated boot">, #<OpenStruct action="linode.boot",
    jobid=1182268, duration=8, host_finish_dt="2009-06-10 03:02:31.0", host_message="", linodeid=12446, host_success=1,
    host_start_dt="2009-06-10 03:02:23.0", entered_dt="1974-01-04 00:00:00.0", label="Host initiated restart">,
    #<OpenStruct action="linode.boot", jobid=1182150, duration=1, host_finish_dt="2009-06-10 01:28:40.0",
    host_message="Linode already running", linodeid=12446, host_success=0, host_start_dt="2009-06-10 01:28:39.0",
    entered_dt="2009-06-10 01:26:55.0", label="Lassie initiated boot">, #<OpenStruct action="linode.boot",
    jobid=1182145, duration=8, host_finish_dt="2009-06-10 01:28:39.0", host_message="", linodeid=12446, host_success=1,
    host_start_dt="2009-06-10 01:28:31.0", entered_dt="1974-01-04 00:00:00.0", label="Host initiated restart">]
    irb> l.linode.job.list(:LinodeId => 12446).size
    => 8

    irb> l.linode.ip.list
    RuntimeError: Error completing request [linode.ip.list] @ [https://api.linode.com/] with data [{}]:
    ERRORCODE6ERRORMESSAGELINODEID is required but was not passed in
    	from ./lib/linode.rb:45:in `send_request'
    	from ./lib/linode.rb:13:in `list'
    	from (irb):10
    irb> l.linode.ip.list(:LinodeId => 12446)
    => [#<OpenStruct rdns_name="byggvir.websages.com", ipaddressid=12286, linodeid=12446, ispublic=1,
    ipaddress="209.123.234.161">, #<OpenStruct rdns_name="li101-51.members.linode.com", ipaddressid=23981,
    linodeid=12446, ispublic=1, ipaddress="97.107.140.51">]
    irb> ^D@ Wed Aug 05 01:50:52 rick@Yer-Moms-Computer

## CREDITS:

* Thanks to Aditya Sanghi ([asanghi](http://github.com/asanghi)) for a patch to properly namespace stackscripts functionality.
* Thanks to Dan Hodos ([danhodos](http://github.com/danhodos)) for diagnosing and fixing an issue with sending GET requests instead of POST request.
* Thanks to Aaron Hamid for updates for RSpec 2 and work on user.getapikey + username/password initialization.
* Thanks to Musfuut ([musfuut](http://github.com/musfuut)) for diagnosing and recommending a fix for OpenStruct and 'type' data members in Linode returned results.
* Thanks to mihaibirsan ([mihaibirsan](http://github.com/mihaibirsan)) for diagnosing a problem with dependencies on the 'crack' library.
* Thanks to Adam Durana ([durana](http://github.com/durana)) for adding support for linode.ip.addprivate.
