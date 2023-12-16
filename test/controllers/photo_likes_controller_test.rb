require 'test_helper'

class PhotoLikesControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get photo_likes_create_url
    assert_response :success
  end

  test 'should get destroy' do
    get photo_likes_destroy_url
    assert_response :success
  end
end
