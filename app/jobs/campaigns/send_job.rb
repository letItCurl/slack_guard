class Campaigns::SendJob < ApplicationJob
  def perform(*args)
    begin
    @campaign = Campaign.find(args[0])
    @user = @campaign.user

    conn = Faraday.new(
      url: 'https://slack.com',
      headers: { 'Authorization' => "Bearer #{@user.slack_token}" }
    ) do |f|
      f.request :json
      f.response :json
    end

    @campaign.emails_list.each do |email|
      puts "email ----"
      puts email
      # @TODO: Manage error
      if email.match(URI::MailTo::EMAIL_REGEXP).nil?
        next
      end

      get_slack_user_id_response = conn.get('api/users.lookupByEmail') do |req|
        req.params["email"] = email
      end

      # @TODO: Manage error
      if get_slack_user_id_response["ok"] == false
        next
      end

      slack_user_id = get_slack_user_id_response.body.dig("user", "id")
      send_chat_response = conn.post('/api/chat.postMessage') do |req|
        req.body = { channel: slack_user_id, text: @campaign.message }
      end

      # @TODO: Manage error
      if send_chat_response["ok"] == false
        next
      end
    end

    @campaign.done!

    rescue => _
      @campaign.failed!
    end
  end
end
