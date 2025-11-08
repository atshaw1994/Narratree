module Admin
  class AdminVotesController < ApplicationController
    before_action :authenticate_owner!, only: [ :owner_decide ]
    before_action :set_admin_vote, only: [ :show, :vote, :results, :owner_decide ]

    # GET /admin_votes
    def index
      @admin_votes = AdminVote.all.order(created_at: :desc)
    end

    # GET /admin_votes/:id
    def show
    end

    # POST /admin_votes
    def create
      @admin_vote = AdminVote.new(admin_vote_params)
      @admin_vote.initiator = current_user
      @admin_vote.status = :pending
      @admin_vote.votes = {}
      if @admin_vote.save
        # Notify all admins except initiator
        User.admins.where.not(id: current_user.id).find_each do |admin|
          AdminVoteMailer.vote_called(@admin_vote, admin).deliver_later
        end
        redirect_to [ :admin, @admin_vote ], notice: "Vote initiated."
      else
        render :new
      end
    end

    # POST /admin_votes/:id/vote
    def vote
      @admin_vote.votes[current_user.id.to_s] = params[:vote]
      if @admin_vote.votes.keys.sort == User.admins.pluck(:id).map(&:to_s).sort
        @admin_vote.status = :completed
        @admin_vote.result = @admin_vote.votes.values.count("yes") > @admin_vote.votes.values.count("no")
        @admin_vote.completed_at = Time.current
        # Notify owner if result is true
        if @admin_vote.result
          User.owners.find_each do |owner|
            AdminVoteMailer.vote_completed(@admin_vote, owner).deliver_later
          end
        end
      end
      @admin_vote.save!
  redirect_to [ :admin, @admin_vote ], notice: "Your vote has been recorded."
    end

    # GET /admin_votes/:id/results
    def results
    end

    # PATCH /admin_votes/:id/owner_decide
    def owner_decide
      unless @admin_vote.status == "completed" && @admin_vote.result
  redirect_to [ :admin, @admin_vote ], alert: "Owner decision not allowed." and return
      end
      decision = params[:decision]
      if decision == "approve"
        @admin_vote.status = :owner_decided
        # Perform the final action, e.g., delete user
        if @admin_vote.vote_type == "delete_user" && @admin_vote.target_user_id
          user = User.find_by(id: @admin_vote.target_user_id)
          user&.destroy!
        end
        @admin_vote.save!
        redirect_to [ :admin, @admin_vote ], notice: "Owner approved and action executed."
      elsif decision == "reject"
  @admin_vote.status = :owner_decided
  @admin_vote.save!
  redirect_to [ :admin, @admin_vote ], notice: "Owner rejected the vote. No action taken."
      else
  redirect_to [ :admin, @admin_vote ], alert: "Invalid decision."
      end
    end

    private

    def set_admin_vote
      @admin_vote = AdminVote.find(params[:id])
    end

    def admin_vote_params
      params.require(:admin_vote).permit(:vote_type, :target_user_id, :reason)
    end

    def authenticate_admin!
      unless current_user&.admin?
        redirect_to root_path, alert: "Admins only."
      end
    end

    def authenticate_owner!
      unless current_user&.owner?
        redirect_to root_path, alert: "Owners only."
      end
    end
  end
end
