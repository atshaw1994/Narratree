class AdminVoteMailer < ApplicationMailer
  default from: "no-reply@narratree.com"

  def vote_called(admin_vote, admin)
    @admin_vote = admin_vote
    @admin = admin
    mail(to: @admin.email, subject: "An admin vote has been called")
  end

  def vote_completed(admin_vote, owner)
    @admin_vote = admin_vote
    @owner = owner
    mail(to: @owner.email, subject: "Admin vote completed - owner action required")
  end
end
