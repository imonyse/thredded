module Thredded
  class UserPrivateTopicDecorator
    extend Forwardable
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    def self.decorate_all(user, private_topics)
      private_topics.map do |private_topic|
        new(user, private_topic)
      end
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, 'PrivateTopic')
    end

    def initialize(user, private_topic)
      @user = user || NullUser.new
      @private_topic = PrivateTopicDecorator.new(private_topic)
    end

    def method_missing(meth, *args)
      if private_topic.respond_to?(meth)
        private_topic.send(meth, *args)
      else
        super
      end
    end

    def_delegators :private_topic,
      :created_at_timeago,
      :css_class,
      :gravatar_url,
      :last_user_link,
      :original,
      :updated_at_timeago

    def persisted?
      false
    end

    def css_class
      "unread #{super}"
    end

    private

    attr_reader :private_topic, :user
  end
end
