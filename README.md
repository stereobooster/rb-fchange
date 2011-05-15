# rb-fchange

Code is working. But there is still a lot of work.
This is a simple wrapper over the Windows Kernel functions for monitoring the specified directory or subtree.

Example

```ruby
  require 'rb-fchange'
  
  notifier = FChange::Notifier.new
  notifier.watch("test", :all_events, :recursive) do |event|
    p Time.now.utc
  end
  
  Signal.trap('INT') do
    p "Bye bye...",
    notifier.stop
    abort("\n")
  end
  
  notifier.run
```

## TODO

 - add latency setting with 0.5 default
 - default flag for events :all_events
 - rework interface (should more look like rb-fsevent)
 - add specs (can use specs from rb-fsevent)
 - add none-ANSI path support
 - add jRuby support