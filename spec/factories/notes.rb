# frozen_string_literal: true

FactoryGirl.define do
  factory :note do
    title 'MyString'
    content 'MyText'
    user
  end
end
