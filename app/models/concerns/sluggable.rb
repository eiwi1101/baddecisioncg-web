module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug
    class_attribute :slug_options
    class_attribute :slug_source

    self.slug_source  = :name
    self.slug_options = {}
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def slugify(source_column, options = {})
      self.slug_source  = source_column
      self.slug_options = options
    end
  end

  def self.slugify(string, tail=nil)
    to_slug(string, tail)
  end

  private

  def generate_slug
    return true unless self.slug.blank?

    slug_scope = slug_options[:scope] ? {slug_options[:scope] => self.send(slug_options[:scope])} : '1=1'

    count = 0

    begin
      self.slug = Sluggable.to_slug(self.send(slug_source), count > 0 ? count : nil)
      count += 1
    end while self.class.where(slug_scope).exists?(slug: self.slug)

    true
  end

  def self.to_slug(string, tail=nil)
    return '' if string.nil?
    slug = [string, tail].compact.join('-')
    slug = slug.downcase.
        gsub(/([a-z]+)'([a-z]+)/, '\1\2').
        gsub(/[^a-z0-9]+/, '-').
        gsub(/^-+|-+$/, '')

    slug
  end
end
