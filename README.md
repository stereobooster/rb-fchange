# rb-fchange

Code not ready. It's just proof of concept
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