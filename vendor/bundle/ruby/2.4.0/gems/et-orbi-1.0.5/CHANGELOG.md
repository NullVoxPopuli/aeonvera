
# et-orbi CHANGELOG.md


## et-orbi 1.0.5  released 2017-06-23

- Rework EtOrbi.make_time
- Let EtOrbi.make_time accept array or array of args
- Implement EoTime#localtime(zone=nil)
- Move Fugit#wday_in_month into EoTime
- Clarify #add, #subtract, #- and #+ contracts
- Ensure #add and #subtract return `self`
- Make #inc(seconds, direction) public
- Implement EoTime#utc?


## et-orbi 1.0.4  released 2017-05-10

- Survive older versions of TZInfo with poor `<=>` impl, gh-1


## et-orbi 1.0.3  released 2017-04-07

- Let not #render_nozone_time fail when local_tzone is nil


## et-orbi 1.0.2  released 2017-03-24

- Enhance no zone ArgumentError data
- Separate module methods from EoTime methods


## et-orbi 1.0.1  released 2017-03-22

- Detail Rails and Active Support info in nozone err


## et-orbi 1.0.0  released 2017-03-22

- First release for rufus-scheduler


## et-orbi 0.9.5  released 2017-03-17

- Empty, initial release, 圓さんの家で

