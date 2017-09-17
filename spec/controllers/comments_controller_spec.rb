# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  item_type  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data       :hstore
#

require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  let!(:record) { FactoryGirl.create :record }
  let!(:comment) { FactoryGirl.create :comment, item: record }

  it '#index' do
    get "/records/#{record.id}/comments"
    expect(response).to be_success
  end

  it '#show' do
    get "/records/#{record.id}/comments/#{comment.id}"
    expect(response).to be_success
  end

  it '#new' do
    get "/records/#{record.id}/comments/new"
    expect(response).to be_success
  end

  it '#create' do
    expect {
      post "/records/#{record.id}/comments", params: { comments: attributes_for(:comment_for_create) }
    }.to change { Comment.count }.by(1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  it '#edit' do
    get "/records/#{record.id}/comments/#{comment.id}/edit"
    expect(response).to be_success
  end

  it '#update' do
    expect {
      put "/records/#{record.id}/comments/#{comment.id}", params: { comments: { tmp: '12321' } }
    }.to change { comment.reload.tmp }
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

  it '#destroy' do
    expect {
      delete "/records/#{record.id}/comments/#{comment.id}"
    }.to change { Comment.count }.by(-1)
    expect(response).to be_redirect
    follow_redirect!
    expect(response).to be_success
  end

end
