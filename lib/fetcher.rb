class Fetcher

  def something
    return 'something'
  end

  def get(client, screen_name)
    # do something more interesting here

    return followers(client, screen_name)
  end

 private
  def followers(client, screen_name)
    return client.friends.ids?(:screen_name => screen_name)
  end
end
