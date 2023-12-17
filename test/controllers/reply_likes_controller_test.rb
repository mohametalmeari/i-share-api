require 'test_helper'

class ReplyLikesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get reply_likes_index_url
    assert_response :success
  end

  test 'should get create' do
    get reply_likes_create_url
    assert_response :success
  end

  test 'should get destroy' do
    get reply_likes_destroy_url
    assert_response :success
  end
end
