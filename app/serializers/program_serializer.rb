# frozen_string_literal: true

class ProgramSerializer < ActiveModel::Serializer
  attributes :id, :category, :name, :status, :price, :image_url

  def image_url
    object.image.url
  end

  def category
    object.category.category_name
  end
end
