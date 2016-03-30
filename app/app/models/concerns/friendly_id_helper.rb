module FriendlyIdHelper
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.extend FriendlyId
    klass.class_eval do
      def normalize_friendly_id(text)
    #    (text || name).to_s.to_slug.normalize(transliterations: [:russian, :latin]).to_s
        text.to_slug.normalize!( :transliterations => [:russian, :latin]).gsub("-", "_")
      end
    end
  end

end

