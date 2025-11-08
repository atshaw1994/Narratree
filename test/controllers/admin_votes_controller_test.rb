
require "test_helper"
require "warden/test/helpers"

class AdminVotesControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  setup do
    @admin = User.create!(email: "admin@example.com", password: "password", role: :admin, first_name: "Admin", last_name: "User", username: "adminuser", accepted_guidelines: true, confirmed_at: Time.now, approved: true)
    @owner = User.create!(email: "owner@example.com", password: "password", role: :owner, first_name: "Owner", last_name: "User", username: "owneruser", accepted_guidelines: true, confirmed_at: Time.now, approved: true)
    @target = User.create!(email: "target@example.com", password: "password", role: :user, first_name: "Target", last_name: "User", username: "targetuser", accepted_guidelines: true, confirmed_at: Time.now, approved: true)
  login_as @admin, scope: :user
  end

  test "admin can create a vote" do
    assert_difference("AdminVote.count", 1) do
      post admin_admin_votes_url, params: { admin_vote: { vote_type: :delete_user, target_user_id: @target.id, reason: "Serious violation" } }
    end
    assert_redirected_to admin_admin_vote_url(AdminVote.last)
  end

  test "admin can vote and owner is notified if passed" do
    vote = AdminVote.create!(vote_type: :delete_user, target_user_id: @target.id, reason: "Serious violation", initiator: @admin, status: :pending, votes: {})
    post vote_admin_admin_vote_url(vote), params: { vote: "yes" }
    vote.reload
    assert_equal true, vote.result
    assert_equal "completed", vote.status
  end

  test "owner can approve and user is deleted" do
    vote = AdminVote.create!(vote_type: :delete_user, target_user_id: @target.id, reason: "Serious violation", initiator: @admin, status: :completed, result: true, votes: { @admin.id.to_s => "yes" })
  logout(:user)
  login_as @owner, scope: :user
    assert_difference("User.count", -1) do
      patch owner_decide_admin_admin_vote_url(vote), params: { decision: "approve" }
    end
    vote.reload
    assert_equal "owner_decided", vote.status
  end

  test "owner can reject and user is not deleted" do
    vote = AdminVote.create!(vote_type: :delete_user, target_user_id: @target.id, reason: "Serious violation", initiator: @admin, status: :completed, result: true, votes: { @admin.id.to_s => "yes" })
  logout(:user)
  login_as @owner, scope: :user
    assert_no_difference("User.count") do
      patch owner_decide_admin_admin_vote_url(vote), params: { decision: "reject" }
    end
    vote.reload
    assert_equal "owner_decided", vote.status
  end
end
