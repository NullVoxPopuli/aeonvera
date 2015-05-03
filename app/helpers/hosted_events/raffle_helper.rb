module HostedEvents::RaffleHelper
  def raffle_menu_options(raffle)
    dropdown_options(
      links: [
        {
          name: "Edit",
          path: hosted_event_raffle_path(@event, raffle)
        },
        {
          name: "Destroy",
          path: hosted_event_raffle_path(@event, raffle),
          options: {
            :method => :delete
          }
        }
      ]
    )
  end
end
