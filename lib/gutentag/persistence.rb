# frozen_string_literal: true

require "forwardable"

class Gutentag::Persistence
  extend Forwardable

  attr_writer :tagger

  def initialize(change_state)
    @change_state = change_state
  end

  def persist
    remove_old
    add_new

    taggable.reset_tag_names
  end

  private

  attr_reader :change_state

  def_delegators :change_state, :taggable, :added, :removed

  def add_new
    added.each do |name|
      taggable.tags << tagger.find_or_create(name)
    end
  end

  def remove_old
    removed.each do |name|
      taggable.tags.delete tagger.find_by_name(name)
    end
  end

  def tagger
    @tagger ||= Gutentag::Tag
  end
end
